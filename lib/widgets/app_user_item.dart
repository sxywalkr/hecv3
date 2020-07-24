import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/app_user.dart';
// import '../providers/cart.dart';
import '../screens/app_user_detail_screen.dart';

class AppUserItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context, listen: false);
    // final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
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
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // leading: Consumer<AppUser>(
          //   builder: (ctx, appUser, child) => IconButton(
          //     icon: Icon(Icons.favorite_border),
          //     onPressed: () {
          //       // appUser.toggleFavoriteStatus(
          //       //   authData.token,
          //       //   authData.userId,
          //       // );
          //     },
          //     color: Theme.of(context).accentColor,
          //   ),
          // ),
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
