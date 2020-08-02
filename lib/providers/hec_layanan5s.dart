import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'hec_layanan5.dart';
import '../models/http_exception.dart';

class HecLayanan5s with ChangeNotifier {
  List<HecLayanan5> _items = [];

  final String authToken;
  final String userId;

  HecLayanan5s(this.authToken, this.userId, this._items);

  List<HecLayanan5> get items {
    return [..._items];
  }

  HecLayanan5 findById(String id) {
    return _items.firstWhere((element) => element.idHecLayanan5 == id);
  }

  Future<void> fetchAndSetHecLayanan5s([bool filterById = false]) async {
    if (authToken == null) {
      return;
    }
    final filterString =
        filterById ? 'orderBy="idHecLayanan5"&equalTo="$filterById"' : '';
    var url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan5s.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<HecLayanan5> loadedItems = [];
      extractedData.forEach((itemId, itemData) {
        try {
          loadedItems.add(HecLayanan5(
            idHecLayanan5: itemId,
            namaHecLayanan5: itemData['namaHecLayanan5'],
            kodeIcdHecLayanan5: itemData['kodeIcdHecLayanan5'],
            harga1HecLayanan5: itemData['harga1HecLayanan5'],
            harga2HecLayanan5: itemData['harga2HecLayanan5'],
            jumlahHecLayanan5: itemData['jumlahHecLayanan5'],
            kodeBpjsHecLayanan5: itemData['kodeBpjsHecLayanan5'],
            tglBeliHecLayanan5: DateTime.parse(itemData['tglBeliHecLayanan5']),
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

  Future<void> addHecLayanan5(HecLayanan5 item) async {
    // print(item.tglBeliHecLayanan5);
    final url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan5s.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          // 'idHecLayanan5': item.idHecLayanan5,
          'namaHecLayanan5': item.namaHecLayanan5,
          'kodeIcdHecLayanan5': item.kodeIcdHecLayanan5,
          'harga1HecLayanan5': item.harga1HecLayanan5,
          'harga2HecLayanan5': item.harga2HecLayanan5,
          'jumlahHecLayanan5': item.jumlahHecLayanan5,
          'kodeBpjsHecLayanan5': item.kodeBpjsHecLayanan5,
          'tglBeliHecLayanan5': item.tglBeliHecLayanan5.toIso8601String(),
        }),
      );
      final newItem = HecLayanan5(
        idHecLayanan5: json.decode(response.body)['name'],
        namaHecLayanan5: item.namaHecLayanan5,
        kodeIcdHecLayanan5: item.kodeIcdHecLayanan5,
        harga1HecLayanan5: item.harga1HecLayanan5,
        harga2HecLayanan5: item.harga2HecLayanan5,
        jumlahHecLayanan5: item.jumlahHecLayanan5,
        kodeBpjsHecLayanan5: item.kodeBpjsHecLayanan5,
        tglBeliHecLayanan5: item.tglBeliHecLayanan5,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateHecLayanan5(String id, HecLayanan5 newItem) async {
    final prodIndex =
        _items.indexWhere((element) => element.idHecLayanan5 == id);
    if (prodIndex >= 0) {
      final url =
          'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan5s/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'namaHecLayanan5': newItem.namaHecLayanan5,
          'kodeIcdHecLayanan5': newItem.kodeIcdHecLayanan5,
          'harga1HecLayanan5': newItem.harga1HecLayanan5,
          'harga2HecLayanan5': newItem.harga2HecLayanan5,
          'jumlahHecLayanan5': newItem.jumlahHecLayanan5,
          'kodeBpjsHecLayanan5': newItem.kodeBpjsHecLayanan5,
          'tglBeliHecLayanan5': newItem.tglBeliHecLayanan5.toIso8601String(),
        }),
      );
      _items[prodIndex] = newItem;
      notifyListeners();
    } else {
      print('..no data');
    }
  }

  Future<void> deleteHecLayanan5(String id) async {
    final url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan5s/$id.json?auth=$authToken';
    final existingItemIndex =
        _items.indexWhere((element) => element.idHecLayanan5 == id);
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
