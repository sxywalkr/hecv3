import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_hec_layanan1_screen.dart';
import 'edit_hec_layanan2_screen.dart';
import 'edit_hec_layanan3_screen.dart';
import 'edit_hec_layanan4_screen.dart';
import 'edit_hec_layanan5_screen.dart';
import '../providers/hec_layanan1s.dart';
import '../providers/hec_layanan2s.dart';
import '../providers/hec_layanan3s.dart';
import '../providers/hec_layanan4s.dart';
import '../providers/hec_layanan5s.dart';
import '../widgets/app_drawer.dart';
import '../widgets/hec_layanan1_manage_item.dart';
import '../widgets/hec_layanan2_manage_item.dart';
import '../widgets/hec_layanan3_manage_item.dart';
import '../widgets/hec_layanan4_manage_item.dart';
import '../widgets/hec_layanan5_manage_item.dart';

enum FilterOptions {
  Layanan1,
  Layanan2,
  Layanan3,
  Layanan4,
  Layanan5,
}

class HecLayananManageScreen extends StatelessWidget {
  static const routeName = '/hec-layanan-manage';

  Future<void> _refreshItems(BuildContext context) async {
    await Provider.of<HecLayanan1s>(context, listen: false)
        .fetchAndSetHecLayanan1s();
    await Provider.of<HecLayanan2s>(context, listen: false)
        .fetchAndSetHecLayanan2s();
    await Provider.of<HecLayanan3s>(context, listen: false)
        .fetchAndSetHecLayanan3s();
    await Provider.of<HecLayanan4s>(context, listen: false)
        .fetchAndSetHecLayanan4s();
    await Provider.of<HecLayanan5s>(context, listen: false)
        .fetchAndSetHecLayanan5s();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('List Layanan'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontSize: 13.0),
            unselectedLabelStyle: TextStyle(fontSize: 9.0),
            tabs: [
              Tab(
                child: Text(
                  "Tindakan Non Operasi",
                  textAlign: TextAlign.center,
                ),
                // icon: Icon(Icons.perm_contact_calendar),
              ),
              Tab(
                child: Text(
                  "Diagnosa",
                  textAlign: TextAlign.center,
                ),
                // icon: Icon(Icons.perm_contact_calendar)
              ),
              Tab(
                child: Text(
                  "Medikamentosa",
                  textAlign: TextAlign.center,
                ),
                // icon: Icon(Icons.perm_contact_calendar),
              ),
              Tab(
                child: Text(
                  "Tindakan Operasi",
                  textAlign: TextAlign.center,
                ),
                // icon: Icon(Icons.perm_contact_calendar),
              ),
              Tab(
                child: Text(
                  "Kacamata",
                  textAlign: TextAlign.center,
                ),
                // icon: Icon(Icons.perm_contact_calendar),
              ),
            ],
          ),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.add),
            //   onPressed: () {
            //     Navigator.of(context)
            //         .pushNamed(EditHecLayanan1Screen.routeName);
            //   },
            // ),
            PopupMenuButton(
                onSelected: (FilterOptions value) => {
                      if (value == FilterOptions.Layanan1)
                        {
                          Navigator.of(context)
                              .pushNamed(EditHecLayanan1Screen.routeName)
                        }
                      else if (value == FilterOptions.Layanan2)
                        {
                          Navigator.of(context)
                              .pushNamed(EditHecLayanan2Screen.routeName)
                        }
                      else if (value == FilterOptions.Layanan3)
                        {
                          Navigator.of(context)
                              .pushNamed(EditHecLayanan3Screen.routeName)
                        }
                      else if (value == FilterOptions.Layanan4)
                        {
                          Navigator.of(context)
                              .pushNamed(EditHecLayanan4Screen.routeName)
                        }
                      else if (value == FilterOptions.Layanan5)
                        {
                          Navigator.of(context)
                              .pushNamed(EditHecLayanan5Screen.routeName)
                        }
                    },
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: Text('Tindakan Non Operasi'),
                          value: FilterOptions.Layanan1),
                      PopupMenuItem(
                          child: Text('Diagnosa'),
                          value: FilterOptions.Layanan2),
                      PopupMenuItem(
                          child: Text('Medikamentosa'),
                          value: FilterOptions.Layanan3),
                      PopupMenuItem(
                          child: Text('Tindakan Operasi'),
                          value: FilterOptions.Layanan4),
                      PopupMenuItem(
                          child: Text('Kacamata'),
                          value: FilterOptions.Layanan5),
                    ])
          ],
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: _refreshItems(context),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _refreshItems(context),
                          child: Consumer<HecLayanan1s>(
                            builder: (ctx, data, _) => Padding(
                              padding: EdgeInsets.all(8),
                              child: ListView.builder(
                                itemCount: data.items.length,
                                itemBuilder: (_, index) {
                                  return Column(
                                    children: [
                                      HecLayanan1ManageItem(
                                        data.items[index].idHecLayanan1,
                                        data.items[index].namaHecLayanan1,
                                        data.items[index].jumlahHecLayanan1,
                                      ),
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
            ),
            FutureBuilder(
              future: _refreshItems(context),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _refreshItems(context),
                          child: Consumer<HecLayanan2s>(
                            builder: (ctx, data, _) => Padding(
                              padding: EdgeInsets.all(8),
                              child: ListView.builder(
                                itemCount: data.items.length,
                                itemBuilder: (_, index) {
                                  return Column(
                                    children: [
                                      HecLayanan2ManageItem(
                                        data.items[index].idHecLayanan2,
                                        data.items[index].namaHecLayanan2,
                                        data.items[index].jumlahHecLayanan2,
                                      ),
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
            ),
            FutureBuilder(
              future: _refreshItems(context),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _refreshItems(context),
                          child: Consumer<HecLayanan3s>(
                            builder: (ctx, data, _) => Padding(
                              padding: EdgeInsets.all(8),
                              child: ListView.builder(
                                itemCount: data.items.length,
                                itemBuilder: (_, index) {
                                  return Column(
                                    children: [
                                      HecLayanan3ManageItem(
                                        data.items[index].idHecLayanan3,
                                        data.items[index].namaHecLayanan3,
                                        data.items[index].jumlahHecLayanan3,
                                      ),
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
            ),
            FutureBuilder(
              future: _refreshItems(context),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _refreshItems(context),
                          child: Consumer<HecLayanan4s>(
                            builder: (ctx, data, _) => Padding(
                              padding: EdgeInsets.all(8),
                              child: ListView.builder(
                                itemCount: data.items.length,
                                itemBuilder: (_, index) {
                                  return Column(
                                    children: [
                                      HecLayanan4ManageItem(
                                        data.items[index].idHecLayanan4,
                                        data.items[index].namaHecLayanan4,
                                        data.items[index].jumlahHecLayanan4,
                                      ),
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
            ),
            FutureBuilder(
              future: _refreshItems(context),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _refreshItems(context),
                          child: Consumer<HecLayanan5s>(
                            builder: (ctx, data, _) => Padding(
                              padding: EdgeInsets.all(8),
                              child: ListView.builder(
                                itemCount: data.items.length,
                                itemBuilder: (_, index) {
                                  return Column(
                                    children: [
                                      HecLayanan5ManageItem(
                                        data.items[index].idHecLayanan5,
                                        data.items[index].namaHecLayanan5,
                                        data.items[index].jumlahHecLayanan5,
                                      ),
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
