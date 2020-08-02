import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../screens/user_beritas_screen.dart';
import '../screens/app_users_manage_screen.dart';
import '../screens/app_users_overview_list_screen.dart';
import '../screens/hec_layanan_manage_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<Auth>(context).userRole;
    final userName = Provider.of<Auth>(context).userName;

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('$userName'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          userRole == 'App Admin' || userRole == 'Resepsionis'
              ? Divider()
              : SizedBox(height: 1),
          userRole == 'App Admin' || userRole == 'Resepsionis'
              ? ListTile(
                  leading: Icon(Icons.person_pin),
                  title: Text('Overview App User'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                        AppUsersOverviewListScreen.routeName);
                  },
                )
              : SizedBox(height: 1),
          userRole == 'App Admin' ? Divider() : SizedBox(height: 1),
          userRole == 'App Admin'
              ? ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Manage App User'),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppUsersManageScreen.routeName);
                  },
                )
              : SizedBox(height: 1),
          userRole == 'App Admin' ? Divider() : SizedBox(height: 1),
          userRole == 'App Admin'
              ? ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Manage Berita'),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(UserBeritasScreen.routeName);
                  },
                )
              : SizedBox(height: 1),
          userRole == 'App Admin' ? Divider() : SizedBox(height: 1),
          userRole == 'App Admin'
              ? ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Manage Layanan'),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(HecLayananManageScreen.routeName);
                  },
                )
              : SizedBox(height: 1),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
