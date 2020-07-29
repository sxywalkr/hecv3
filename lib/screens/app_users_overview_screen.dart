import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_users_grid.dart';
// import '../widgets/badge.dart';
// import './cart_screen.dart';
// import '../providers/cart.dart';
import '../providers/app_users.dart';
import '../providers/auth.dart';

enum UserFilterOptions {
  AntrianPoli,
  KamarOperasi,
  All,
}

class AppUsersOverviewScreen extends StatefulWidget {
  static const routeName = '/app-user-overview';

  @override
  _AppUsersOverviewScreenState createState() => _AppUsersOverviewScreenState();
}

class _AppUsersOverviewScreenState extends State<AppUsersOverviewScreen> {
  var _showOnlyFav = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      var userRole = Provider.of<Auth>(context).userRole;
      if (userRole == 'Anom') {
        Provider.of<AppUsers>(context)
            .fetchAndSetAppUsers()
            .then((_) => setState(() {
                  _isLoading = false;
                }));
      } else if (userRole == 'App Admin' || userRole == 'Resepsionis') {
        Provider.of<AppUsers>(context)
            .fetchAndSetAppUsers('antri poli')
            .then((_) => setState(() {
                  _isLoading = false;
                }));
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overview App User'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (UserFilterOptions selectedValue) {
              setState(() {
                if (selectedValue == UserFilterOptions.AntrianPoli) {
                  Provider.of<AppUsers>(context, listen: false)
                      .fetchAndSetAppUsers('antri poli');
                } else if (selectedValue == UserFilterOptions.KamarOperasi) {
                  Provider.of<AppUsers>(context, listen: false)
                      .fetchAndSetAppUsers('antri kamar operasi');
                } else {
                  Provider.of<AppUsers>(context, listen: false)
                      .fetchAndSetAppUsers();
                }
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : AppUsersGrid(_showOnlyFav),
    );
  }
}
