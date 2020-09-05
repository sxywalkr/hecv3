import 'dart:html';

import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
// import 'package:hec/providers/rekam_mediks.dart';

import 'package:provider/provider.dart';

import '../providers/hec_layanan1s.dart';
import '../providers/hec_layanan2s.dart';
import '../providers/rekam_medik.dart';
import '../providers/rekam_mediks.dart';

class RekamMedikScreen extends StatefulWidget {
  static const routeName = '/rekam-medik';

  @override
  _RekamMedikScreenState createState() => _RekamMedikScreenState();
}

class _RekamMedikScreenState extends State<RekamMedikScreen> {
  void displayBottomSheet(BuildContext context, int selected) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(ctx).size.height * 0.8,
            child: widgetConsumer(context, selected),
          );
        });
  }

  Widget widgetConsumer(BuildContext context, a) {
    final cartRekamMedik = Provider.of<RekamMedik>(context, listen: false);
    if (a == 1) {
      return Consumer<HecLayanan1s>(
        builder: (ctx, data, _) => ListView.builder(
          itemCount: data.items.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.items[index].namaHecLayanan1,
                  ),
                  IconButton(
                      icon: Icon(Icons.check_circle),
                      onPressed: () {
                        cartRekamMedik.addItem(
                          data.items[index].namaHecLayanan1,
                          data.items[index].namaHecLayanan1,
                          data.items[index].harga1HecLayanan1,
                          data.items[index].harga2HecLayanan1,
                        );
                      })
                ],
              ),
            );
          },
        ),
      );
    }
    return Text('No Data');
  }

  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context).settings.arguments as String;
    print('itemId > $itemId');

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Data Rekam Medik'),
      ),
      body: Center(
        child: Consumer<RekamMedik>(
          builder: (ctx, data, child) => ListView.builder(
              itemCount: data.items.length,
              itemBuilder: (ctx, i) => ListTile(
                    title: Text('${data.items.values.toList()[i].nama}'),
                    subtitle: Text('${data.items.values.toList()[i].jumlah}'),
                  )),
        ),
      ),
      floatingActionButton: FabCircularMenu(
        ringColor: Colors.purpleAccent,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.accessibility),
              onPressed: () async {
                await Provider.of<HecLayanan1s>(context, listen: false)
                    .fetchAndSetHecLayanan1s();
                displayBottomSheet(context, 1);
              }),
          IconButton(
              icon: Icon(Icons.account_balance_wallet),
              onPressed: () async {
                await Provider.of<HecLayanan2s>(context, listen: false)
                    .fetchAndSetHecLayanan2s();
                displayBottomSheet(context, 2);
              }),
          // IconButton(
          //     icon: Icon(Icons.add_box),
          //     onPressed: () {
          //       displayBottomSheet(context, 3, layanan1);
          //     }),
          // IconButton(
          //     icon: Icon(Icons.add_to_queue),
          //     onPressed: () {
          //       displayBottomSheet(context, 4, layanan1);
          //     }),
          // IconButton(
          //     icon: Icon(Icons.devices_other),
          //     onPressed: () {
          //       displayBottomSheet(context, 5, layanan1);
          //     })
        ],
      ),
    );
  }
}
