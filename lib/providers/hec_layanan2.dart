import 'package:flutter/material.dart';

//Layanan1 = Diagnosa
class HecLayanan2 with ChangeNotifier {
  final String idHecLayanan2;
  final String namaHecLayanan2;
  final String kodeIcdHecLayanan2;
  final int harga1HecLayanan2;
  final int harga2HecLayanan2;
  final int jumlahHecLayanan2;
  final String kodeBpjsHecLayanan2;
  final DateTime tglBeliHecLayanan2;

  HecLayanan2({
    @required this.idHecLayanan2,
    @required this.namaHecLayanan2,
    @required this.kodeIcdHecLayanan2,
    @required this.harga1HecLayanan2,
    @required this.harga2HecLayanan2,
    @required this.jumlahHecLayanan2,
    @required this.kodeBpjsHecLayanan2,
    @required this.tglBeliHecLayanan2,
  });
}
