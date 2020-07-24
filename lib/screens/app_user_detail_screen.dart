import 'package:flutter/material.dart';
// import '../screens/products_overview_screen.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/antrian.dart';
import '../providers/antrians.dart';
import '../providers/app_users.dart';

enum FilterOptions {
  DaftarAntrian,
  DaftarKamarOperasi,
}

class AppUserDetailScreen extends StatefulWidget {
  static const routeName = '/app-user-detail';

  @override
  _AppUserDetailScreenState createState() => _AppUserDetailScreenState();
}

class _AppUserDetailScreenState extends State<AppUserDetailScreen> {
  DateTime _selectAntriDate;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // print('init');
    // print('AppUserDetailScreen ${ModalRoute.of(context).settings.arguments}');
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Antrian>(context)
          .fetchAntrian(ModalRoute.of(context).settings.arguments as String)
          .then((_) => setState(() {
                _isLoading = false;
              }));
    }
    super.didChangeDependencies();
  }

  Future<void> _presentDatePicker(ctx, a, b) async {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(Duration(days: 7)))
        .then((e) async {
      if (e == null) {
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        if (b == 'antri') {
          await Provider.of<Antrians>(context, listen: false)
              .fetchAndSetAntrians(e, a);
          //     .then((_) {
          //   Scaffold.of(context).hideCurrentSnackBar();
          //   Scaffold.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text('Sukses menambah data kamar operasi'),
          //       duration: Duration(seconds: 5),
          //     ),
          //   );
          // });
        } else if (b == 'ko') {
          await Provider.of<Antrians>(context, listen: false)
              .setKamarOperasi(e, a);
          //     .then((_) {
          //   Scaffold.of(context).hideCurrentSnackBar();
          //   Scaffold.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text('Sukses menambah data kamar operasi'),
          //       duration: Duration(seconds: 5),
          //     ),
          //   );
          // });
        }
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error occurred'),
            content: Text('Something went wrong. $error'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    });
    setState(() {
      _isLoading = false;
    });
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // final scaffold = Scaffold.of(context);
    final itemId = ModalRoute.of(context).settings.arguments as String;
    final loadedItem = Provider.of<AppUsers>(
      context,
      listen: false,
    ).findById(itemId);
    // final loadedAntrian = Provider.of<Antrian>(context, listen: false).item;

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedItem.nama),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.date_range),
          //   onPressed: () => _presentDatePicker(loadedItem, 'antri'),
          // ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.DaftarAntrian) {
                  _presentDatePicker(context, loadedItem, 'antri');
                } else if (selectedValue == FilterOptions.DaftarKamarOperasi) {
                  _presentDatePicker(context, loadedItem, 'ko');
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Daftar Antrian'),
                value: FilterOptions.DaftarAntrian,
              ),
              PopupMenuItem(
                child: Text('Daftar Kamar Operasi'),
                value: FilterOptions.DaftarKamarOperasi,
              )
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: Image.asset(
                'assets/images/men.png',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '${loadedItem.flagActivity}',
              style: TextStyle(
                // color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Text(
              'App User Id : ${loadedItem.appUserId}',
              style: TextStyle(
                // color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Text(
              'Nomor KTP : ${loadedItem.noRmHec}',
              style: TextStyle(
                // color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Text(
              'Nomor BPJS : ${loadedItem.noBpjs}',
              style: TextStyle(
                // color: Colors.grey,
                fontSize: 14,
              ),
            ),
            // SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Alamat : ${loadedItem.alamat}',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(height: 10),
            Consumer<Antrian>(
              builder: (context, antrian, child) => Text(
                  antrian.item == null || antrian.item.isEmpty
                      ? ''
                      : 'Tanggal Antri : ${antrian.item[0].tanggalAntri}'),
            ),
            Consumer<Antrian>(
              builder: (context, antrian, child) => Text(
                  antrian.item == null || antrian.item.isEmpty
                      ? ''
                      : 'Nomor Antri : ${antrian.item[0].nomorAntri}'),
            )
          ],
        ),
      ),
    );
  }
}
