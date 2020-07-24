import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _token2;
  DateTime _expiryDate;
  String _userId;
  String _userRole;
  Timer _authTimer;

  bool get isAuth {
    // print(token);
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      // print('auth');
      return _token;
    }
    // print('no auth');
    return null;
  }

  String get userId {
    return _userId;
  }

  String get token2 {
    return _token2;
  }

  String get userRole {
    return _userRole;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAae_dFFc3lAE_kWE-qP25GtJAI1JuFTtE';
    // key fbHecc
    final url2 =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAKZ9QlpcCfWaSbttVXDTn8KMu31WSxIKE';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      // print(responseData);
      // print(responseData['error']);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      // get userRole for loginUser
      if (urlSegment == 'signInWithPassword') {
        final response3 = await http.get(
            'https://fdev-hec.firebaseio.com/appUsers/$_userId.json?auth=$_token');

        final extractedData3 =
            json.decode(response3.body) as Map<String, dynamic>;
        // print(extractedData3['appUserRole']);
        _userRole = extractedData3['appUserRole'];
      }
      // register new user to db and assign role
      if (urlSegment == 'signUp') {
        final url =
            'https://fdev-hec.firebaseio.com/appUsers/$_userId.json?auth=$_token';
        await http.put(
          url,
          body: json.encode({
            'nama': email,
            'email': email,
            'noRmHec': '-',
            'noKtp': '-',
            'noBpjs': '-',
            'noHape': '-',
            'gender': '-',
            'alamat': '-',
            'tanggalLahir': DateTime.now().toIso8601String(),
            'statusAppUser': 'BPJS',
            'flagActivity': 'idle',
            'appUserRole': 'Anom',
          }),
        );
        _userRole = 'Anom';
      }
      // print(_userRole);
      // fbHecc
      if (urlSegment == 'signInWithPassword') {
        final response2 = await http.post(
          url2,
          body: json.encode(
            {
              'email': 'oka@m.com',
              'password': 'qawsed',
              'returnSecureToken': true,
            },
          ),
        );
        final responseData2 = json.decode(response2.body);
        if (responseData2['error'] != null) {
          throw HttpException(responseData2['error']['message']);
        }
        _token2 = responseData2['idToken'];
      }

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'token2': _token2,
          'userId': _userId,
          'userRole': _userRole,
          'expiryDate': _expiryDate.toIso8601String()
        },
      );
      _autoLogout();
      prefs.setString('userData', userData);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _token2 = extractedUserData['token2'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _token2 = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    // prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeExpiry), logout);
  }
}
