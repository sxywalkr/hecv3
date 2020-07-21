import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AntrianItem {
  final String appUserId;
  final String tanggalAntri;
  final int nomorAntri;

  AntrianItem({
    @required this.appUserId,
    @required this.tanggalAntri,
    @required this.nomorAntri,
  });
}

class Antrian with ChangeNotifier {
  List<AntrianItem> _item = [];
  final String authToken;
  final String userId;

  Antrian(this.authToken, this.userId, this._item);

  List<AntrianItem> get item {
    return [..._item];
  }

  // List<AntrianItem> get getItem {
  //   return [..._item];
  // }

  // AntrianItem findById(String id) {
  //   print(_item);
  //   // fetchAntrian(id);
  //   // print(_item);
  //   return _item.first;
  // }

  Future<void> fetchAntrian(String appUserId) async {
    final filterString = 'orderBy="appUserId"&equalTo="$appUserId"';
    var url =
        'https://fdev-hec.firebaseio.com/hecAntrian/hecAntrianDetail.json?auth=$authToken&$filterString';
    // print(url);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<AntrianItem> loadedAntrian = [];
      extractedData.forEach((key, value) {
        loadedAntrian.add(AntrianItem(
          appUserId: value['appUserId'],
          tanggalAntri: value['tanggalAntri'],
          nomorAntri: value['nomorAntri'],
        ));
      });
      _item = loadedAntrian;

      // print(_item);
      notifyListeners();
      // return _item;
    } catch (error) {
      print('fetchAntrian, $error');
      throw (error);
    }
  }

  // Future<void> fetchAntrianOk1(DateTime tanggalAntri) async {
  //   final filterString = 'orderBy="tanggal"&equalTo="$tanggalAntri"';
  //   var url =
  //       'https://fdev-hec.firebaseio.com/hecAntrian.json?auth=$authToken&$filterString';
  //   try {
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null) {
  //       // tambah antrian
  //     }
  //     final List<AntrianItem> loadedAntrian = [];
  //     extractedData.forEach((key, value) {
  //       loadedAntrian.add(AntrianItem(
  //         appUserId: value['appUserId'],
  //         tanggalAntri: value['tanggalAntri'],
  //         nomorAntri: value['nomorAntri'],
  //       ));
  //     });
  //     _item = loadedAntrian;
  //     notifyListeners();
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  // Future<void> addAntrian(AntrianItem newAntrian) async {
  //   final url =
  //       'https://fdev-hec.firebaseio.com/hecAntrian.json?auth=$authToken';
  //   try {
  //     await http.post(
  //       url,
  //       body: json.encode({
  //         'hecAntrianUserid': newAntrian.appUserId,
  //         'tanggalAntri': newAntrian.tanggalAntri.toIso8601String(),
  //         'hecAntrianNomorAntrian': newAntrian.nomorAntri,
  //       }),
  //     );

  //     _item.add(newAntrian);
  //     notifyListeners();
  //   } catch (error) {
  //     throw (error);
  //   }
  // }
}
