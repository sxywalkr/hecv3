import 'package:flutter/material.dart';

//Layanan1 = Tindakan Non Operasi
class HecLayanan1 with ChangeNotifier {
  final String idHecLayanan1;
  final String namaHecLayanan1;
  final String kodeIcdHecLayanan1;
  final double harga1HecLayanan1;
  final double harga2HecLayanan1;
  final int jumlahHecLayanan1;
  final String kodeBpjsHecLayanan1;
  final DateTime tglBeliHecLayanan1;

  HecLayanan1({
    @required this.idHecLayanan1,
    @required this.namaHecLayanan1,
    @required this.kodeIcdHecLayanan1,
    @required this.harga1HecLayanan1,
    @required this.harga2HecLayanan1,
    @required this.jumlahHecLayanan1,
    @required this.kodeBpjsHecLayanan1,
    @required this.tglBeliHecLayanan1,
  });
}
