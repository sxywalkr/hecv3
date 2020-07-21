// import 'dart:convert';
import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;

class AppUser with ChangeNotifier {
  final String appUserId;
  final String nama;
  final String email;
  final String noRmHec;
  final String noKtp;
  final String noBpjs;
  final String noHape;
  final String gender;
  final String alamat;
  final DateTime tanggalLahir;
  final String statusAppUser; //BPJS atau UMUM
  final String flagActivity; //status activity appUser
  final String appUserRole;

  AppUser({
    @required this.appUserId,
    @required this.nama,
    @required this.email,
    @required this.noRmHec,
    @required this.noKtp,
    @required this.noBpjs,
    @required this.noHape,
    @required this.gender,
    @required this.alamat,
    @required this.tanggalLahir,
    @required this.statusAppUser,
    @required this.flagActivity,
    @required this.appUserRole,
  });
}
