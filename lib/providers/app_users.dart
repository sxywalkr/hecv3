import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_user.dart';
import '../models/http_exception.dart';
// import '../providers/antrian.dart';

class AppUsers with ChangeNotifier {
  List<AppUser> _items = [];
  // List<Antrian> _antrian = [];
  final String authToken;
  final String userId;

  AppUsers(
    this.authToken,
    this.userId,
    this._items,
    // this._antrian,
  );

  List<AppUser> get items {
    return [..._items..sort((a, b) => a.nama.compareTo(b.nama))];
  }

  AppUser findById(String id) {
    return _items.firstWhere((element) => element.appUserId == id);
  }

  Future<void> fetchAndSetAppUsers([String filterByUser = 'All']) async {
    final filterString = filterByUser == 'All'
        ? ''
        : 'orderBy="flagActivity"&equalTo="$filterByUser"';
    var url =
        'https://fdev-hec.firebaseio.com/appUsers.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      // print('extractedData > $filterByUser >>> ${extractedData.length}');
      final List<AppUser> loadedAppUsers = [];
      extractedData.forEach((id, data) async {
        AppUser aa;
        try {
          final responseAntrian = await http.get(
              'https://fdev-hec.firebaseio.com/hecAntrian/hecAntrianDetail.json?auth=$authToken&orderBy="appUserId"&equalTo="$id"');
          final extractedDataAntrian =
              json.decode(responseAntrian.body) as Map<String, dynamic>;
          if (extractedDataAntrian.isNotEmpty) {
            aa = AppUser(
              appUserId: id,
              nama: data['nama'],
              email: data['email'],
              noRmHec: data['noRmHec'],
              noKtp: data['noKtp'],
              noBpjs: data['noBpjs'],
              noHape: data['noHape'],
              gender: data['gender'],
              alamat: data['alamat'],
              tanggalLahir: DateTime.parse(data['tanggalLahir']),
              statusAppUser: data['statusAppUser'],
              flagActivity: data['flagActivity'],
              appUserRole: data['appUserRole'],
              tanggalAntri: extractedDataAntrian[id]['tanggalAntri'],
              nomorAntri: extractedDataAntrian[id]['nomorAntri'],
            );
          } else {
            aa = AppUser(
              appUserId: id,
              nama: data['nama'],
              email: data['email'],
              noRmHec: data['noRmHec'],
              noKtp: data['noKtp'],
              noBpjs: data['noBpjs'],
              noHape: data['noHape'],
              gender: data['gender'],
              alamat: data['alamat'],
              tanggalLahir: DateTime.parse(data['tanggalLahir']),
              statusAppUser: data['statusAppUser'],
              flagActivity: data['flagActivity'],
              appUserRole: data['appUserRole'],
            );
          }
          loadedAppUsers.add(aa);
          _items = loadedAppUsers;
          notifyListeners();
        } catch (error) {
          print('responseAntrian >>> $error');
          // throw (error);
        }
      });
    } catch (error) {
      print('fetchAndSetAppUsers >>> $error');
      throw (error);
    }
  }

  Future<void> addAppUser(AppUser appUser) async {
    String userId;
    final urlAuth =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAae_dFFc3lAE_kWE-qP25GtJAI1JuFTtE';
    try {
      final response = await http.post(
        urlAuth,
        body: json.encode(
          {
            'email': appUser.email,
            'password': '12345678',
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // print(responseData);
      userId = responseData['localId'];
    } catch (error) {
      throw error;
    }

    final url =
        'https://fdev-hec.firebaseio.com/appUsers/$userId.json?auth=$authToken';
    try {
      await http.put(
        url,
        body: json.encode({
          'nama': appUser.nama,
          'email': appUser.email,
          'noRmHec': appUser.noRmHec,
          'noKtp': appUser.noKtp,
          'noBpjs': appUser.noBpjs,
          'noHape': appUser.noHape,
          'gender': appUser.gender,
          'alamat': appUser.alamat,
          'tanggalLahir': appUser.tanggalLahir.toIso8601String(),
          'statusAppUser': appUser.statusAppUser,
          'flagActivity': appUser.flagActivity,
          'appUserRole': appUser.appUserRole,
        }),
      );
      final newAppUser = AppUser(
        nama: appUser.nama,
        email: appUser.email,
        noRmHec: appUser.noRmHec,
        noKtp: appUser.noKtp,
        noBpjs: appUser.noBpjs,
        noHape: appUser.noHape,
        gender: appUser.gender,
        alamat: appUser.alamat,
        tanggalLahir: appUser.tanggalLahir,
        statusAppUser: appUser.statusAppUser,
        flagActivity: appUser.flagActivity,
        appUserRole: appUser.appUserRole,
        // appUserId: json.decode(response.body)['name'],
        appUserId: userId,
      );
      _items.add(newAppUser);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateAppUser(String id, AppUser updData) async {
    final prodIndex = _items.indexWhere((element) => element.appUserId == id);
    if (prodIndex >= 0) {
      final url =
          'https://fdev-hec.firebaseio.com/appUsers/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'nama': updData.nama,
          'email': updData.email,
          'noRmHec': updData.noRmHec,
          'noKtp': updData.noKtp,
          'noBpjs': updData.noBpjs,
          'noHape': updData.noHape,
          'gender': updData.gender,
          'alamat': updData.alamat,
          'tanggalLahir': updData.tanggalLahir.toIso8601String(),
          // 'statusAppUser': 'BPJS',
          'appUserRole': updData.appUserRole,
        }),
      );
      _items[prodIndex] = updData;
      notifyListeners();
    } else {
      print('..no data');
    }
  }

  Future<void> deleteAppUser(String id) async {
    final url =
        'https://fdev-hec.firebaseio.com/appUsers/$id.json?auth=$authToken';
    final existingDataIndex =
        _items.indexWhere((element) => element.appUserId == id);
    var existingData = _items[existingDataIndex];
    _items.removeAt(existingDataIndex);
    notifyListeners();

    try {
      final response = await http.delete(url);
      existingData = null;
      print(json.decode(response.body));
    } catch (error) {
      print(error);
      _items.insert(existingDataIndex, existingData);
      notifyListeners();
      throw HttpException('Could not delete appUser $id');
    }
  }
}
