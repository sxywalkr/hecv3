import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_users.dart';
import '../screens/edit_app_user_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_user_item.dart';

class AppUsersOverviewScreen extends StatelessWidget {
  static const routeName = '/app-users-overview';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<AppUsers>(context, listen: false).fetchAndSetAppUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application User'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditAppUserScreen.routeName);
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
                    child: Consumer<AppUsers>(
                      builder: (ctx, data, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: data.items.length,
                          itemBuilder: (_, index) {
                            return Column(
                              children: [
                                AppUserItem(
                                    data.items[index].appUserId,
                                    data.items[index].nama,
                                    data.items[index].noRmHec),
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
