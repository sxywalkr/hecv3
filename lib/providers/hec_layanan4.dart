import 'package:flutter/material.dart';

//Layanan1 = Medikamentosa
class HecLayanan4 with ChangeNotifier {
  final String idHecLayanan4;
  final String namaHecLayanan4;
  final String kodeIcdHecLayanan4;
  final int harga1HecLayanan4;
  final int harga2HecLayanan4;
  final int jumlahHecLayanan4;
  final String kodeBpjsHecLayanan4;
  final DateTime tglBeliHecLayanan4;

  HecLayanan4({
    @required this.idHecLayanan4,
    @required this.namaHecLayanan4,
    @required this.kodeIcdHecLayanan4,
    @required this.harga1HecLayanan4,
    @required this.harga2HecLayanan4,
    @required this.jumlahHecLayanan4,
    @required this.kodeBpjsHecLayanan4,
    @required this.tglBeliHecLayanan4,
  });
}
