// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RekamMedikItem {
  final String id;
  final String nama;
  final int jumlah;
  final double harga1;
  final double harga2;

  RekamMedikItem({
    @required this.id,
    @required this.nama,
    @required this.jumlah,
    @required this.harga1,
    @required this.harga2,
  });
}

class RekamMedik with ChangeNotifier {
  Map<String, RekamMedikItem> _items = {};

  Map<String, RekamMedikItem> get items {
    return {..._items};
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.harga2 * value.jumlah;
    });
    return total;
  }

  void addItem(String itemId, String nama, double harga1, double harga2) {
    if (_items.containsKey(itemId)) {
      _items.update(
          itemId,
          (oldData) => RekamMedikItem(
                id: oldData.id,
                nama: oldData.nama,
                jumlah: oldData.jumlah + 1,
                harga1: oldData.harga1,
                harga2: oldData.harga2,
              ));
    } else {
      _items.putIfAbsent(
          itemId,
          () => RekamMedikItem(
                id: DateTime.now().toString(),
                nama: nama,
                jumlah: 1,
                harga1: harga1,
                harga2: harga2,
              ));
    }
    // print('nama >>> $nama');
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.remove(itemId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  removeSingleItem(String itemId) {
    if (!_items.containsKey(itemId)) {
      return;
    }
    if (_items[itemId].jumlah > 1) {
      _items.update(
        itemId,
        (xCart) => RekamMedikItem(
          id: xCart.id,
          nama: xCart.nama,
          jumlah: xCart.jumlah - 1,
          harga1: xCart.harga1,
          harga2: xCart.harga2,
        ),
      );
    } else {
      _items.remove(itemId);
    }
    notifyListeners();
  }
}
