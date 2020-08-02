import 'package:flutter/material.dart';

//Layanan1 = Medikamentosa
class HecLayanan3 with ChangeNotifier {
  final String idHecLayanan3;
  final String namaHecLayanan3;
  final String kodeIcdHecLayanan3;
  final int harga1HecLayanan3;
  final int harga2HecLayanan3;
  final int jumlahHecLayanan3;
  final String kodeBpjsHecLayanan3;
  final DateTime tglBeliHecLayanan3;

  HecLayanan3({
    @required this.idHecLayanan3,
    @required this.namaHecLayanan3,
    @required this.kodeIcdHecLayanan3,
    @required this.harga1HecLayanan3,
    @required this.harga2HecLayanan3,
    @required this.jumlahHecLayanan3,
    @required this.kodeBpjsHecLayanan3,
    @required this.tglBeliHecLayanan3,
  });
}
