import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'rekam_medik.dart';
import '../models/http_exception.dart';

class RekamMediksItem {
  final String id;
  final double total;
  final List<RekamMedikItem> layanans;
  final DateTime dateTime;

  RekamMediksItem({
    @required this.id,
    @required this.total,
    @required this.layanans,
    @required this.dateTime,
  });
}

class RekamMediks with ChangeNotifier {
  List<RekamMediksItem> _rmItems = [];
  final String authToken;
  final String userId;

  RekamMediks(this.authToken, this.userId, this._rmItems);

  List<RekamMediksItem> get rmItems {
    return [..._rmItems];
  }

  Future<void> fetchAndSetRekamMediks() async {
    final url =
        'https://fdev-hec.firebaseio.com/rekamMediks/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<RekamMediksItem> loadedRekamMediks = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // print (extractedData);
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedRekamMediks.add(
        RekamMediksItem(
          id: orderId,
          total: orderData['total'],
          dateTime: DateTime.parse(orderData['dateTime']),
          layanans: (orderData['products'] as List<dynamic>)
              .map(
                (item) => RekamMedikItem(
                  id: item['id'],
                  nama: item['nama'],
                  jumlah: item['jumlah'],
                  harga1: item['harga1'],
                  harga2: item['harga2'],
                ),
              )
              .toList(),
        ),
      );
    });
    _rmItems = loadedRekamMediks.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
      List<RekamMedikItem> cartRekamMedikItem, double total) async {
    final url =
        'https://fdev-hec.firebaseio.com/RekamMediks/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    // try {
    final response = await http.post(url,
        body: json.encode({
          'total': total,
          'dateTime': timestamp.toIso8601String(),
          'layanans': cartRekamMedikItem
              .map((cp) => {
                    'id': cp.id,
                    'nama': cp.nama,
                    'jumlah': cp.jumlah,
                    'harga1': cp.harga1,
                    'harga2': cp.harga2,
                  })
              .toList(),
        }));
    // print(json.decode(response.body)['name']);
    _rmItems.insert(
      0,
      RekamMediksItem(
        id: json.decode(response.body)['name'],
        // id: timestamp.toString(),
        total: total,
        layanans: cartRekamMedikItem,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
    // } catch (error) {
    //   print(error);
    // }
  }
}
