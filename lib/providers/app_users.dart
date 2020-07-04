import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_user.dart';
import '../models/http_exception.dart';

class AppUsers with ChangeNotifier {
  List<AppUser> _items = [];

  final String authToken;
  final String userId;

  AppUsers(this.authToken, this.userId, this._items);

  List<AppUser> get items {
    return [..._items];
  }

  AppUser findById(String id) {
    return _items.firstWhere((element) => element.appUserId == id);
  }

  Future<void> fetchAndSetAppUsers([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://fdev-hec.firebaseio.com/appUsers.json?auth=$authToken&$filterString';
    // print(url);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      // print(json.decode(response.body));
      final List<AppUser> loadedAppUsers = [];
      extractedData.forEach((id, data) {
        loadedAppUsers.add(AppUser(
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
          appUserRole: data['appUserRole'],
        ));
      });
      _items = loadedAppUsers;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addAppUser(AppUser appUser) async {
    // print(json.decode(appUser));
    final url = 'https://fdev-hec.firebaseio.com/appUsers.json?auth=$authToken';
    try {
      final response = await http.post(
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
        appUserRole: appUser.appUserRole,
        appUserId: json.decode(response.body)['name'],
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