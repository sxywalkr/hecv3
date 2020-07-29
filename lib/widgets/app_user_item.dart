import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/app_user.dart';
import '../providers/antrian.dart';
// import '../providers/cart.dart';
import '../screens/app_user_detail_screen.dart';

class AppUserItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context, listen: false);
    Provider.of<Antrian>(context, listen: false)
        .fetchAntrian(appUser.appUserId);
    // final cart = Provider.of<Cart>(context, listen: false);
    final userRole = Provider.of<Auth>(context, listen: false).userRole;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppUserDetailScreen.routeName,
                arguments: appUser.appUserId);
          },
          child: Image.asset(
            'assets/images/men.png',
            // appUser.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: userRole == 'Resepsionis'
            ? GridTileBar(
                backgroundColor: Colors.black26,
                title: Consumer<Antrian>(
                    builder: (ctx, antrianData, child) => Text(
                        antrianData.item == null || antrianData.item.isEmpty
                            ? '-'
                            : '${antrianData.item[0].tanggalAntri}')),
              )
            : SizedBox(height: 1),
        footer: GridTileBar(
          backgroundColor: Colors.black12,
          leading: Consumer<Antrian>(
              builder: (ctx, antrianData, child) => Text(
                  antrianData.item == null || antrianData.item.isEmpty
                      ? '-'
                      : '${antrianData.item[0].nomorAntri}')),
          title: Column(
            children: [
              Text(
                '${appUser.nama} - ${appUser.statusAppUser}',
                textAlign: TextAlign.center,
              ),
              Text(
                'Nomor Rekam Medik : ${appUser.noRmHec}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // trailing: IconButton(
          //   icon: Icon(Icons.shopping_cart),
          //   onPressed: () {
          //     // cart.addItem(appUser.id, appUser.price, appUser.title);
          //     // Scaffold.of(context).hideCurrentSnackBar();
          //     // Scaffold.of(context).showSnackBar(
          //     //   SnackBar(
          //     //     content: Text('Add item to the cart'),
          //     //     duration: Duration(seconds: 7),
          //     //     action: SnackBarAction(
          //     //         label: 'UNDO',
          //     //         onPressed: () {
          //     //           cart.removeSingleItem(appUser.id);
          //     //         }),
          //     //   ),
          //     // );
          //   },
          //   color: Theme.of(context).accentColor,
          // ),
        ),
      ),
    );
  }
}
