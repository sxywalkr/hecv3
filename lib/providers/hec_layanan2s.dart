import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'hec_layanan2.dart';
import '../models/http_exception.dart';

class HecLayanan2s with ChangeNotifier {
  List<HecLayanan2> _items = [];

  final String authToken;
  final String userId;

  HecLayanan2s(this.authToken, this.userId, this._items);

  List<HecLayanan2> get items {
    return [..._items];
  }

  HecLayanan2 findById(String id) {
    return _items.firstWhere((element) => element.idHecLayanan2 == id);
  }

  Future<void> fetchAndSetHecLayanan2s([bool filterById = false]) async {
    if (authToken == null) {
      return;
    }
    final filterString =
        filterById ? 'orderBy="idHecLayanan2"&equalTo="$filterById"' : '';
    var url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan2s.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<HecLayanan2> loadedItems = [];
      extractedData.forEach((itemId, itemData) {
        try {
          loadedItems.add(HecLayanan2(
            idHecLayanan2: itemId,
            namaHecLayanan2: itemData['namaHecLayanan2'],
            kodeIcdHecLayanan2: itemData['kodeIcdHecLayanan2'],
            harga1HecLayanan2: itemData['harga1HecLayanan2'],
            harga2HecLayanan2: itemData['harga2HecLayanan2'],
            jumlahHecLayanan2: itemData['jumlahHecLayanan2'],
            kodeBpjsHecLayanan2: itemData['kodeBpjsHecLayanan2'],
            tglBeliHecLayanan2: DateTime.parse(itemData['tglBeliHecLayanan2']),
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

  Future<void> addHecLayanan2(HecLayanan2 item) async {
    // print(item.tglBeliHecLayanan2);
    final url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan2s.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          // 'idHecLayanan2': item.idHecLayanan2,
          'namaHecLayanan2': item.namaHecLayanan2,
          'kodeIcdHecLayanan2': item.kodeIcdHecLayanan2,
          'harga1HecLayanan2': item.harga1HecLayanan2,
          'harga2HecLayanan2': item.harga2HecLayanan2,
          'jumlahHecLayanan2': item.jumlahHecLayanan2,
          'kodeBpjsHecLayanan2': item.kodeBpjsHecLayanan2,
          'tglBeliHecLayanan2': item.tglBeliHecLayanan2.toIso8601String(),
        }),
      );
      final newItem = HecLayanan2(
        idHecLayanan2: json.decode(response.body)['name'],
        namaHecLayanan2: item.namaHecLayanan2,
        kodeIcdHecLayanan2: item.kodeIcdHecLayanan2,
        harga1HecLayanan2: item.harga1HecLayanan2,
        harga2HecLayanan2: item.harga2HecLayanan2,
        jumlahHecLayanan2: item.jumlahHecLayanan2,
        kodeBpjsHecLayanan2: item.kodeBpjsHecLayanan2,
        tglBeliHecLayanan2: item.tglBeliHecLayanan2,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateHecLayanan2(String id, HecLayanan2 newItem) async {
    final prodIndex =
        _items.indexWhere((element) => element.idHecLayanan2 == id);
    if (prodIndex >= 0) {
      final url =
          'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan2s/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'namaHecLayanan2': newItem.namaHecLayanan2,
          'kodeIcdHecLayanan2': newItem.kodeIcdHecLayanan2,
          'harga1HecLayanan2': newItem.harga1HecLayanan2,
          'harga2HecLayanan2': newItem.harga2HecLayanan2,
          'jumlahHecLayanan2': newItem.jumlahHecLayanan2,
          'kodeBpjsHecLayanan2': newItem.kodeBpjsHecLayanan2,
          'tglBeliHecLayanan2': newItem.tglBeliHecLayanan2.toIso8601String(),
        }),
      );
      _items[prodIndex] = newItem;
      notifyListeners();
    } else {
      print('..no data');
    }
  }

  Future<void> deleteHecLayanan2(String id) async {
    final url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan2s/$id.json?auth=$authToken';
    final existingItemIndex =
        _items.indexWhere((element) => element.idHecLayanan2 == id);
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
