import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'hec_layanan3.dart';
import '../models/http_exception.dart';

class HecLayanan3s with ChangeNotifier {
  List<HecLayanan3> _items = [];

  final String authToken;
  final String userId;

  HecLayanan3s(this.authToken, this.userId, this._items);

  List<HecLayanan3> get items {
    return [..._items];
  }

  HecLayanan3 findById(String id) {
    return _items.firstWhere((element) => element.idHecLayanan3 == id);
  }

  Future<void> fetchAndSetHecLayanan3s([bool filterById = false]) async {
    if (authToken == null) {
      return;
    }
    final filterString =
        filterById ? 'orderBy="idHecLayanan3"&equalTo="$filterById"' : '';
    var url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan3s.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<HecLayanan3> loadedItems = [];
      extractedData.forEach((itemId, itemData) {
        try {
          loadedItems.add(HecLayanan3(
            idHecLayanan3: itemId,
            namaHecLayanan3: itemData['namaHecLayanan3'],
            kodeIcdHecLayanan3: itemData['kodeIcdHecLayanan3'],
            harga1HecLayanan3: itemData['harga1HecLayanan3'],
            harga2HecLayanan3: itemData['harga2HecLayanan3'],
            jumlahHecLayanan3: itemData['jumlahHecLayanan3'],
            kodeBpjsHecLayanan3: itemData['kodeBpjsHecLayanan3'],
            tglBeliHecLayanan3: DateTime.parse(itemData['tglBeliHecLayanan3']),
          ));
        } catch (error) {
          print('extractedData > $error');
        }
      });
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addHecLayanan3(HecLayanan3 item) async {
    // print(item.tglBeliHecLayanan3);
    final url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan3s.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          // 'idHecLayanan3': item.idHecLayanan3,
          'namaHecLayanan3': item.namaHecLayanan3,
          'kodeIcdHecLayanan3': item.kodeIcdHecLayanan3,
          'harga1HecLayanan3': item.harga1HecLayanan3,
          'harga2HecLayanan3': item.harga2HecLayanan3,
          'jumlahHecLayanan3': item.jumlahHecLayanan3,
          'kodeBpjsHecLayanan3': item.kodeBpjsHecLayanan3,
          'tglBeliHecLayanan3': item.tglBeliHecLayanan3.toIso8601String(),
        }),
      );
      final newItem = HecLayanan3(
        idHecLayanan3: json.decode(response.body)['name'],
        namaHecLayanan3: item.namaHecLayanan3,
        kodeIcdHecLayanan3: item.kodeIcdHecLayanan3,
        harga1HecLayanan3: item.harga1HecLayanan3,
        harga2HecLayanan3: item.harga2HecLayanan3,
        jumlahHecLayanan3: item.jumlahHecLayanan3,
        kodeBpjsHecLayanan3: item.kodeBpjsHecLayanan3,
        tglBeliHecLayanan3: item.tglBeliHecLayanan3,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateHecLayanan3(String id, HecLayanan3 newItem) async {
    final prodIndex =
        _items.indexWhere((element) => element.idHecLayanan3 == id);
    if (prodIndex >= 0) {
      final url =
          'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan3s/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'namaHecLayanan3': newItem.namaHecLayanan3,
          'kodeIcdHecLayanan3': newItem.kodeIcdHecLayanan3,
          'harga1HecLayanan3': newItem.harga1HecLayanan3,
          'harga2HecLayanan3': newItem.harga2HecLayanan3,
          'jumlahHecLayanan3': newItem.jumlahHecLayanan3,
          'kodeBpjsHecLayanan3': newItem.kodeBpjsHecLayanan3,
          'tglBeliHecLayanan3': newItem.tglBeliHecLayanan3.toIso8601String(),
        }),
      );
      _items[prodIndex] = newItem;
      notifyListeners();
    } else {
      print('..no data');
    }
  }

  Future<void> deleteHecLayanan3(String id) async {
    final url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan3s/$id.json?auth=$authToken';
    final existingItemIndex =
        _items.indexWhere((element) => element.idHecLayanan3 == id);
    var existingItem = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    notifyListeners();

    try {
      final response = await http.delete(url);
      existingItem = null;
      print(json.decode(response.body));
    } catch (error) {
      print(error);
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw HttpException('Could not delete item');
    }
  }
}
