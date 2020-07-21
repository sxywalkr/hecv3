import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/antrian.dart';
import '../providers/antrians.dart';
import '../providers/app_users.dart';

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
    // print(ModalRoute.of(context).settings.arguments as String);
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

  void _presentDatePicker(a) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(Duration(days: 7)))
        .then((e) {
      if (e == null) {
        return;
      }
      Provider.of<Antrians>(context, listen: false).fetchAndSetAntrians(e, a);
      setState(() {
        _selectAntriDate = e;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context).settings.arguments as String;
    final loadedItem = Provider.of<AppUsers>(
      context,
      listen: false,
    ).findById(itemId);
    // final loadedAntrian = Provider.of<Antrian>(context, listen: false).item;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedItem.nama,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => _presentDatePicker(loadedItem),
          ),
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
              'Nomor KTP : ${loadedItem.noKtp}',
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
            Text(
              _selectAntriDate == null
                  ? 'Tanggal Antri Poli : -'
                  : 'Tanggal Antri Poli : ${DateFormat.yMMMd().format(_selectAntriDate)}',
              style: TextStyle(
                // color: Colors.grey,
                fontSize: 14,
              ),
            ),
            // SizedBox(height: 10),
            // Text('Nomor Antri: ${loadedAntrian[0].nomorAntri}'),
            // Consumer<Antrian>(
            //   builder: (context, antrian, child) => Text(
            //       'Nomor Antri : ${antrian.item.map((e) => e.nomorAntri)}'),
            // ),
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
