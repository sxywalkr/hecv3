import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'berita.dart';
import '../models/http_exception.dart';

class Beritas with ChangeNotifier {
  List<Berita> _items = [];

  final String authToken;
  final String userId;

  Beritas(this.authToken, this.userId, this._items);

  List<Berita> get items {
    return [..._items];
  }

  List<Berita> get itemsFav {
    return _items.where((element) => element.isFavorite).toList();
  }

  Berita findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetBeritas([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://fdev-hec.firebaseio.com/beritas.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print (extractedData);
      if (extractedData == null) {
        return;
      }
      url =
          'https://fdev-hec.firebaseio.com/userFavorites/$userId.json?auth=$authToken';

      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      // print(favoriteData);
      final List<Berita> loadedBeritas = [];
      extractedData.forEach((prodId, prodData) {
        loadedBeritas.add(Berita(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedBeritas;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addBerita(Berita berita) async {
    final url = 'https://fdev-hec.firebaseio.com/beritas.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': berita.title,
          'description': berita.description,
          'imageUrl': berita.imageUrl,
          'creatorId': userId,
        }),
      );
      final newBerita = Berita(
        title: berita.title,
        description: berita.description,
        imageUrl: berita.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newBerita);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateBerita(String id, Berita newBerita) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://fdev-hec.firebaseio.com/beritas/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'title': newBerita.title,
          'description': newBerita.description,
          'imageUrl': newBerita.imageUrl,
        }),
      );
      _items[prodIndex] = newBerita;
      notifyListeners();
    } else {
      print('..no data');
    }
  }

  Future<void> deleteBerita(String id) async {
    final url =
        'https://fdev-hec.firebaseio.com/beritas/$id.json?auth=$authToken';
    final existingBeritaIndex =
        _items.indexWhere((element) => element.id == id);
    var existingBerita = _items[existingBeritaIndex];
    _items.removeAt(existingBeritaIndex);
    notifyListeners();

    try {
      final response = await http.delete(url);
      existingBerita = null;
      print(json.decode(response.body));
    } catch (error) {
      print(error);
      _items.insert(existingBeritaIndex, existingBerita);
      notifyListeners();
      throw HttpException('Could not delete berita');
    }
  }
}
