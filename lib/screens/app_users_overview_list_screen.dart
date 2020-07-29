import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_users.dart';
// import 'edit_app_user_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_user_overview_list_item.dart';
import '../providers/auth.dart';

enum UserFilterOptions {
  AntrianPoli,
  KamarOperasi,
  All,
}

class AppUsersOverviewListScreen extends StatefulWidget {
  static const routeName = '/app-users-overview-list';

  @override
  _AppUsersOverviewListScreenState createState() =>
      _AppUsersOverviewListScreenState();
}

class _AppUsersOverviewListScreenState
    extends State<AppUsersOverviewListScreen> {
  var _isInit = true;
  // var _isLoading = false;
  var filter = UserFilterOptions.All;

  @override
  void didChangeDependencies() {
    print('didChangeDependencies filter >>> $filter || init >>> $_isInit');
    if (_isInit) {
      setState(() {
        // _isLoading = true;
        _isInit = false;
      });
      var userRole = Provider.of<Auth>(context).userRole;
      if (userRole == 'Anom') {
        setState(() {
          filter = UserFilterOptions.All;
          // _isInit = false;
          // _isLoading = false;
        });
        // _refreshProducts(context, filter);
        // setState(() {
        //   _isLoading = false;
        // });
      } else if (userRole == 'App Admin' || userRole == 'Resepsionis') {
        setState(() {
          filter = UserFilterOptions.AntrianPoli;
          // _isInit = false;
          // _isLoading = false;
        });
        // _refreshProducts(context, UserFilterOptions.AntrianPoli);
        // setState(() {
        //   _isLoading = false;
        // });
      }
    }
    // _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts(BuildContext context, filter) async {
    print('_refreshProducts >>> $filter');
    if (filter == UserFilterOptions.AntrianPoli) {
      print('_refreshProducts filter >>> $filter');
      await Provider.of<AppUsers>(context, listen: false)
          .fetchAndSetAppUsers('antri poli');
    } else if (filter == UserFilterOptions.KamarOperasi) {
      await Provider.of<AppUsers>(context, listen: false)
          .fetchAndSetAppUsers('antri kamar operasi');
    } else {
      print('_refreshProducts filter >>> $filter');
      await Provider.of<AppUsers>(context, listen: false).fetchAndSetAppUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AppUsers>(
            builder: (ctx, data, _) =>
                Text('List HEC User - ${data.items.length}')),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (UserFilterOptions selectedValue) {
              setState(() {
                filter = selectedValue;
                // _refreshProducts(context, filter);
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Show All'), value: UserFilterOptions.All),
              PopupMenuItem(
                child: Text('Antri Poli'),
                value: UserFilterOptions.AntrianPoli,
              ),
              PopupMenuItem(
                child: Text('Kamar Operasi'),
                value: UserFilterOptions.KamarOperasi,
              )
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context, filter),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(ctx, filter),
                    child: Consumer<AppUsers>(
                      builder: (ctx, data, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: data.items.length,
                          itemBuilder: (context, index) =>
                              ChangeNotifierProvider.value(
                            value: data.items[index],
                            child: AppUserOverviewListItem(
                              data.items[index].appUserId,
                              data.items[index].nama,
                              data.items[index].noRmHec,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
