import 'package:flutter/material.dart';

//Layanan5 = Kacamata
class HecLayanan5 with ChangeNotifier {
  final String idHecLayanan5;
  final String namaHecLayanan5;
  final String kodeIcdHecLayanan5;
  final int harga1HecLayanan5;
  final int harga2HecLayanan5;
  final int jumlahHecLayanan5;
  final String kodeBpjsHecLayanan5;
  final DateTime tglBeliHecLayanan5;

  HecLayanan5({
    @required this.idHecLayanan5,
    @required this.namaHecLayanan5,
    @required this.kodeIcdHecLayanan5,
    @required this.harga1HecLayanan5,
    @required this.harga2HecLayanan5,
    @required this.jumlahHecLayanan5,
    @required this.kodeBpjsHecLayanan5,
    @required this.tglBeliHecLayanan5,
  });
}
