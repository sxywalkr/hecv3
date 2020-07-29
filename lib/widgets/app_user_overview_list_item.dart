import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_user.dart';
// import '../providers/antrian.dart';
// import '../screens/edit_app_user_screen.dart';
import '../screens/app_user_detail_screen.dart';

class AppUserOverviewListItem extends StatelessWidget {
  final String id;
  final String nama;
  final String imageUrl;

  AppUserOverviewListItem(this.id, this.nama, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context, listen: false);
    // final xx = Provider.of<Antrian>(context).fetchAntrian(id);
    // print('build ${appUser.antrian['nomorAntri']}');

    return ListTile(
      title: Text(appUser.nomorAntri != null
          ? '$nama - ${appUser.tanggalAntri} - ${appUser.nomorAntri}'
          : '$nama'),
      subtitle: Text('${appUser.noRmHec} - ${appUser.statusAppUser}'),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 50,
        child: Row(children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed(AppUserDetailScreen.routeName,
                  arguments: appUser.appUserId);
            },
          ),
        ]),
      ),
    );
  }
}
