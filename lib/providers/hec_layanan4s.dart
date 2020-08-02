import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'hec_layanan4.dart';
import '../models/http_exception.dart';

class HecLayanan4s with ChangeNotifier {
  List<HecLayanan4> _items = [];

  final String authToken;
  final String userId;

  HecLayanan4s(this.authToken, this.userId, this._items);

  List<HecLayanan4> get items {
    return [..._items];
  }

  HecLayanan4 findById(String id) {
    return _items.firstWhere((element) => element.idHecLayanan4 == id);
  }

  Future<void> fetchAndSetHecLayanan4s([bool filterById = false]) async {
    if (authToken == null) {
      return;
    }
    final filterString =
        filterById ? 'orderBy="idHecLayanan4"&equalTo="$filterById"' : '';
    var url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan4s.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<HecLayanan4> loadedItems = [];
      extractedData.forEach((itemId, itemData) {
        try {
          loadedItems.add(HecLayanan4(
            idHecLayanan4: itemId,
            namaHecLayanan4: itemData['namaHecLayanan4'],
            kodeIcdHecLayanan4: itemData['kodeIcdHecLayanan4'],
            harga1HecLayanan4: itemData['harga1HecLayanan4'],
            harga2HecLayanan4: itemData['harga2HecLayanan4'],
            jumlahHecLayanan4: itemData['jumlahHecLayanan4'],
            kodeBpjsHecLayanan4: itemData['kodeBpjsHecLayanan4'],
            tglBeliHecLayanan4: DateTime.parse(itemData['tglBeliHecLayanan4']),
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

  Future<void> addHecLayanan4(HecLayanan4 item) async {
    // print(item.tglBeliHecLayanan4);
    final url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan4s.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          // 'idHecLayanan4': item.idHecLayanan4,
          'namaHecLayanan4': item.namaHecLayanan4,
          'kodeIcdHecLayanan4': item.kodeIcdHecLayanan4,
          'harga1HecLayanan4': item.harga1HecLayanan4,
          'harga2HecLayanan4': item.harga2HecLayanan4,
          'jumlahHecLayanan4': item.jumlahHecLayanan4,
          'kodeBpjsHecLayanan4': item.kodeBpjsHecLayanan4,
          'tglBeliHecLayanan4': item.tglBeliHecLayanan4.toIso8601String(),
        }),
      );
      final newItem = HecLayanan4(
        idHecLayanan4: json.decode(response.body)['name'],
        namaHecLayanan4: item.namaHecLayanan4,
        kodeIcdHecLayanan4: item.kodeIcdHecLayanan4,
        harga1HecLayanan4: item.harga1HecLayanan4,
        harga2HecLayanan4: item.harga2HecLayanan4,
        jumlahHecLayanan4: item.jumlahHecLayanan4,
        kodeBpjsHecLayanan4: item.kodeBpjsHecLayanan4,
        tglBeliHecLayanan4: item.tglBeliHecLayanan4,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateHecLayanan4(String id, HecLayanan4 newItem) async {
    final prodIndex =
        _items.indexWhere((element) => element.idHecLayanan4 == id);
    if (prodIndex >= 0) {
      final url =
          'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan4s/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'namaHecLayanan4': newItem.namaHecLayanan4,
          'kodeIcdHecLayanan4': newItem.kodeIcdHecLayanan4,
          'harga1HecLayanan4': newItem.harga1HecLayanan4,
          'harga2HecLayanan4': newItem.harga2HecLayanan4,
          'jumlahHecLayanan4': newItem.jumlahHecLayanan4,
          'kodeBpjsHecLayanan4': newItem.kodeBpjsHecLayanan4,
          'tglBeliHecLayanan4': newItem.tglBeliHecLayanan4.toIso8601String(),
        }),
      );
      _items[prodIndex] = newItem;
      notifyListeners();
    } else {
      print('..no data');
    }
  }

  Future<void> deleteHecLayanan4(String id) async {
    final url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan4s/$id.json?auth=$authToken';
    final existingItemIndex =
        _items.indexWhere((element) => element.idHecLayanan4 == id);
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
