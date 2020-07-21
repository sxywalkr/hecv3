import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

import 'antrian.dart';

class AntriansItem {
  // final DateTime hecAntrianTanggal;
  final int hecAntrianTotal;
  // final int totalTerlayani;
  final List<AntrianItem> hecAntrianDetail;

  AntriansItem({
    // @required this.hecAntrianTanggal,
    @required this.hecAntrianTotal,
    // @required this.totalTerlayani,
    @required this.hecAntrianDetail,
  });
}

class Antrians with ChangeNotifier {
  List<AntriansItem> _antriansItem = [];
  final String authToken;
  final String userId;

  Antrians(this.authToken, this.userId, this._antriansItem);

  List<AntriansItem> get antriansItem {
    return [..._antriansItem];
  }

  Future<void> fetchAndSetAntrians(DateTime queryTanggalAntri, dataUser) async {
    final qDate = queryTanggalAntri.toIso8601String().substring(0, 10);
    final qAppUserId = dataUser.appUserId;
    // cek apakah sudah ada hecTanggalAntri di db
    var url =
        'https://fdev-hec.firebaseio.com/hecAntrian/hecAntrianSummary/$qDate.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print(extractedData);
      if (extractedData == null || extractedData.isEmpty) {
        // belum ada hecTanggalAntri, create dan tambahkan user ke list
        await http.put(
          'https://fdev-hec.firebaseio.com/hecAntrian/hecAntrianSummary.json?auth=$authToken',
          body: json.encode({
            qDate: {'hecAntrianTotal': 1}
          }),
        );
        await http.put(
          'https://fdev-hec.firebaseio.com/hecAntrian/hecAntrianDetail.json?auth=$authToken',
          body: json.encode({
            qAppUserId: {
              'appUserId': qAppUserId,
              'nomorAntri': 1,
              'tanggalAntri': qDate,
            }
          }),
        );
        // update flagActivity jadi antri poli
        await http.patch(
          'https://fdev-hec.firebaseio.com/appUsers/$qAppUserId.json?auth=$authToken',
          body: json.encode({'flagActivity': 'antri poli'}),
        );
        return;
      }
      // hecTanggalAntri sudah ada di db, cek apakah user sudah antri atau belum
      final response2 = await http.get(
          'https://fdev-hec.firebaseio.com/hecAntrian/hecAntrianDetail/$qAppUserId.json?auth=$authToken');
      final extractedData2 =
          json.decode(response2.body) as Map<String, dynamic>;
      if (extractedData2 != null) {
        print('user sudah antri');
        return;
      }
      // add new user to existing hecTanggalAntri
      await http.patch(
        'https://fdev-hec.firebaseio.com/hecAntrian/hecAntrianDetail.json?auth=$authToken',
        body: json.encode({
          qAppUserId: {
            'appUserId': qAppUserId,
            'nomorAntri': extractedData['hecAntrianTotal'] + 1,
            'tanggalAntri': qDate,
          }
        }),
      );
      // update totalAntri on hecAntrianSummary
      await http.patch(
          'https://fdev-hec.firebaseio.com/hecAntrian/hecAntrianSummary/$qDate.json?auth=$authToken',
          body: json.encode(
              {'hecAntrianTotal': extractedData['hecAntrianTotal'] + 1}));
      // update flagActivity jadi antri poli
      await http.patch(
          'https://fdev-hec.firebaseio.com/appUsers/$qAppUserId.json?auth=$authToken',
          body: json.encode({'flagActivity': 'antri poli'}));

      notifyListeners();
    } catch (error) {
      print('fetchAndSetAntrians, $error');
      throw (error);
    }
  }

//   Future<void> fetchAndSetAntriansOk1(
//       DateTime queryTanggalAntri, dataUser) async {
//     final qDate = queryTanggalAntri.toIso8601String().substring(0, 10);
//     final qAppUserId = dataUser.appUserId;
//     // cek apakah sudah ada hecTanggalAntri di db
//     var url =
//         'https://fdev-hec.firebaseio.com/hecAntrian/hecAntrian/$qDate.json?auth=$authToken';
//     try {
//       final response = await http.get(url);
//       final extractedData = json.decode(response.body) as Map<String, dynamic>;
//       // print(extractedData);
//       if (extractedData == null || extractedData.isEmpty) {
//         // belum ada hecTanggalAntri, create dan tambahkan user ke list
//         var url =
//             'https://fdev-hec.firebaseio.com/hecAntrian/hecAntrian.json?auth=$authToken';
//         await http.put(
//           url,
//           body: json.encode({
//             qDate: {
//               'hecAntrianTotal': 1,
//               'hecAntrianDetail': {
//                 dataUser.appUserId: {
//                   'appUserId': dataUser.appUserId,
//                   'hecAntrianTanggal': queryTanggalAntri.toIso8601String(),
//                   'nomorAntri': 1,
//                 }
//               }
//             }
//           }),
//         );
//         // update flagActivity jadi antri poli
//         await http.patch(
//             'https://fdev-hec.firebaseio.com/appUsers/$qAppUserId.json?auth=$authToken',
//             body: json.encode({'flagActivity': 'antri poli'}));
//         return;
//       }
//       // hecTanggalAntri sudah ada di db, cek apakah user sudah antri atau belum
//       // print('data found');
//       // print(extractedData);
//       // print(extractedData.keys);
//       // print(extractedData['hecAntrianTotal']);
//       // print(extractedData['hecAntrianDetail'][qAppUserId]['nomorAntri']);

//       if (extractedData['hecAntrianDetail'].containsKey(qAppUserId)) {
//         print('user sudah antri');
//         return;
//       }
//       // add new user to existing hecTanggalAntri
//       url =
//           'https://fdev-hec.firebaseio.com/hecAntrian/$qDate/hecAntrianDetail.json?auth=$authToken';
//       await http.patch(
//         url,
//         body: json.encode({
//           qAppUserId: {
//             'appUserId': qAppUserId,
//             'nomorAntri': extractedData['hecAntrianTotal'] + 1,
//           }
//         }),
//       );
//       await http.patch(
//           'https://fdev-hec.firebaseio.com/appUsers/$qAppUserId.json?auth=$authToken',
//           body: json.encode({'flagActivity': 'antri poli'}));

//       notifyListeners();
//     } catch (error) {
//       print(error);
//       throw (error);
//     }
//   }

//   Future<void> fetchAndSetAntriansOld(
//       DateTime queryTanggalAntri, dataUser) async {
//     final filterString =
//         'orderBy="hecAntrianTanggal"&equalTo="${queryTanggalAntri.toIso8601String()}"';
//     var url =
//         'https://fdev-hec.firebaseio.com/hecAntrian.json?auth=$authToken&$filterString';
//     final qDate = queryTanggalAntri.toIso8601String().substring(0, 10);
//     var url2 =
//         'https://fdev-hec.firebaseio.com/hecAntrian/$qDate/hecAntrianDetail/${dataUser.appUserId}.json?auth=$authToken';
//     print(url2);
// // var url =
// //         'https://fdev-hec.firebaseio.com/hecAntrian/$qDate/hecAntrianDetail/${qAppUserId}.json?auth=$authToken';

//     try {
//       final response = await http.get(url);
//       final extractedData = json.decode(response.body) as Map<String, dynamic>;
//       // print(extractedData);
//       if (extractedData == null || extractedData.isEmpty) {
//         print('no data found');
//         var url =
//             'https://fdev-hec.firebaseio.com/hecAntrian.json?auth=$authToken';
//         await http.put(
//           url,
//           body: json.encode({
//             queryTanggalAntri.toIso8601String().substring(0, 10): {
//               'hecAntrianTotal': 1,
//               'hecAntrianTanggal': queryTanggalAntri.toIso8601String(),
//               'hecAntrianDetail': {
//                 dataUser.appUserId: {
//                   'appUserId': dataUser.appUserId,
//                   'nomorAntri': 1,
//                 }
//               }
//             }
//           }),
//         );
//         // print(json.decode(response1.body)['name']);
//         return;
//       }
//       print('data found');
//       print(extractedData);
//       print(extractedData.keys);
//       print(extractedData['hecAntrianTotal']);
//       // var url =
//       //       'https://fdev-hec.firebaseio.com/hecAntrian.json?auth=$authToken';
//       //   await http.post(
//       //     url,
//       //     body: json.encode({
//       //       'hecAntrianTotal': extractedData,
//       //       'hecAntrianTanggal': queryTanggalAntri.toIso8601String(),
//       //       'hecAntrianDetail': {
//       //         dataUser.appUserId: {
//       //           'nomorAntri': 1,
//       //         }
//       //       }
//       //     }),
//       //   );
//       notifyListeners();
//     } catch (error) {
//       print(error);
//       throw (error);
//     }
//   }
}
