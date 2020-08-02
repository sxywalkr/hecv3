import 'package:flutter/material.dart';
import 'package:hec/providers/app_user.dart';
// import '../screens/products_overview_screen.dart';

// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/antrian.dart';
import '../providers/antrians.dart';
import '../providers/app_users.dart';

enum FilterOptions {
  DaftarAntrian,
  DaftarKamarOperasi,
}

class AppUserDetailScreen extends StatelessWidget {
  static const routeName = '/app-user-detail';

  Future<void> _presentDatePicker(ctx, a, b) async {
    showDatePicker(
            context: ctx,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(Duration(days: 7)))
        .then((e) async {
      if (e == null) {
        return;
      }
      try {
        if (b == 'antri') {
          await Provider.of<Antrians>(ctx, listen: false)
              .fetchAndSetAntrians(e, a);
        } else if (b == 'ko') {
          await Provider.of<Antrians>(ctx, listen: false).setKamarOperasi(e, a);
        }
      } catch (error) {
        await showDialog(
          context: ctx,
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
  }

  @override
  Widget build(BuildContext context) {
    // final scaffold = Scaffold.of(context);
    final itemId = ModalRoute.of(context).settings.arguments as String;
    final loadedItem = Provider.of<AppUsers>(
      context,
      listen: false,
    ).findById(itemId);
    Provider.of<Antrian>(context).fetchAntrian(itemId);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loadedItem.nama),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.perm_contact_calendar)),
              Tab(icon: Icon(Icons.directions_transit)),
            ],
          ),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                // setState(() {
                if (selectedValue == FilterOptions.DaftarAntrian) {
                  _presentDatePicker(context, loadedItem, 'antri');
                } else if (selectedValue == FilterOptions.DaftarKamarOperasi) {
                  _presentDatePicker(context, loadedItem, 'ko');
                }
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
        body: TabBarView(
          children: [
            UserProfile(loadedItem: loadedItem),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key key,
    @required this.loadedItem,
  }) : super(key: key);

  final AppUser loadedItem;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
