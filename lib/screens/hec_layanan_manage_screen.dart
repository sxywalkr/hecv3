import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_hec_layanan1_screen.dart';
import '../providers/hec_layanan1s.dart';
import '../widgets/app_drawer.dart';
import '../widgets/hec_layanan1_manage_item.dart';

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
                    },
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: Text('Tindakan Non Operasi'),
                          value: FilterOptions.Layanan1),
                      PopupMenuItem(
                          child: Text('Diagnosa'),
                          value: FilterOptions.Layanan2),
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
            Icon(Icons.directions_transit),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
