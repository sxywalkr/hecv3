import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_berita_item.dart';
import '../providers/beritas.dart';
import 'edit_berita_screen.dart';

class UserBeritasScreen extends StatelessWidget {
  static const routeName = '/user-beritas';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Beritas>(context, listen: false).fetchAndSetBeritas(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditBeritaScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Beritas>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, index) {
                            return Column(
                              children: [
                                UserBeritaItem(
                                  productsData.items[index].id,
                                  productsData.items[index].title,
                                  productsData.items[index].imageUrl,
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
    );
  }
}
