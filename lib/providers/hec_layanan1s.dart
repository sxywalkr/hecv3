import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'hec_layanan1.dart';
import '../models/http_exception.dart';

class HecLayanan1s with ChangeNotifier {
  List<HecLayanan1> _items = [];

  final String authToken;
  final String userId;

  HecLayanan1s(this.authToken, this.userId, this._items);

  List<HecLayanan1> get items {
    return [..._items];
  }

  // List<HecLayanan1> get itemsFav {
  //   return _items.where((element) => element.isFavorite).toList();
  // }

  HecLayanan1 findById(String id) {
    return _items.firstWhere((element) => element.idHecLayanan1 == id);
  }

  Future<void> fetchAndSetHecLayanan1s([bool filterById = false]) async {
    if (authToken == null) {
      return;
    }
    final filterString =
        filterById ? 'orderBy="idHecLayanan1"&equalTo="$filterById"' : '';
    var url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan1s.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      final List<HecLayanan1> loadedItems = [];
      extractedData.forEach((itemId, itemData) {
        try {
          loadedItems.add(HecLayanan1(
            idHecLayanan1: itemId,
            namaHecLayanan1: itemData['namaHecLayanan1'],
            kodeIcdHecLayanan1: itemData['kodeIcdHecLayanan1'],
            harga1HecLayanan1: itemData['harga1HecLayanan1'],
            harga2HecLayanan1: itemData['harga2HecLayanan1'],
            jumlahHecLayanan1: itemData['jumlahHecLayanan1'],
            kodeBpjsHecLayanan1: itemData['kodeBpjsHecLayanan1'],
            tglBeliHecLayanan1: DateTime.parse(itemData['tglBeliHecLayanan1']),
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

  Future<void> addHecLayanan1(HecLayanan1 item) async {
    // print(item.tglBeliHecLayanan1);
    final url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan1s.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          // 'idHecLayanan1': item.idHecLayanan1,
          'namaHecLayanan1': item.namaHecLayanan1,
          'kodeIcdHecLayanan1': item.kodeIcdHecLayanan1,
          'harga1HecLayanan1': item.harga1HecLayanan1,
          'harga2HecLayanan1': item.harga2HecLayanan1,
          'jumlahHecLayanan1': item.jumlahHecLayanan1,
          'kodeBpjsHecLayanan1': item.kodeBpjsHecLayanan1,
          'tglBeliHecLayanan1': item.tglBeliHecLayanan1.toIso8601String(),
        }),
      );
      final newItem = HecLayanan1(
        idHecLayanan1: json.decode(response.body)['name'],
        namaHecLayanan1: item.namaHecLayanan1,
        kodeIcdHecLayanan1: item.kodeIcdHecLayanan1,
        harga1HecLayanan1: item.harga1HecLayanan1,
        harga2HecLayanan1: item.harga2HecLayanan1,
        jumlahHecLayanan1: item.jumlahHecLayanan1,
        kodeBpjsHecLayanan1: item.kodeBpjsHecLayanan1,
        tglBeliHecLayanan1: item.tglBeliHecLayanan1,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateHecLayanan1(String id, HecLayanan1 newItem) async {
    final prodIndex =
        _items.indexWhere((element) => element.idHecLayanan1 == id);
    if (prodIndex >= 0) {
      final url =
          'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan1s/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'namaHecLayanan1': newItem.namaHecLayanan1,
          'kodeIcdHecLayanan1': newItem.kodeIcdHecLayanan1,
          'harga1HecLayanan1': newItem.harga1HecLayanan1,
          'harga2HecLayanan1': newItem.harga2HecLayanan1,
          'jumlahHecLayanan1': newItem.jumlahHecLayanan1,
          'kodeBpjsHecLayanan1': newItem.kodeBpjsHecLayanan1,
          'tglBeliHecLayanan1': newItem.tglBeliHecLayanan1.toIso8601String(),
        }),
      );
      _items[prodIndex] = newItem;
      notifyListeners();
    } else {
      print('..no data');
    }
  }

  Future<void> deleteHecLayanan1(String id) async {
    final url =
        'https://fdev-hec.firebaseio.com/hecLayanan/hecLayanan1s/$id.json?auth=$authToken';
    final existingItemIndex =
        _items.indexWhere((element) => element.idHecLayanan1 == id);
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
