import 'package:flutter/material.dart';
import 'package:hec/providers/app_users.dart';
import 'package:hec/screens/beritas_overview_screen.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
// import './screens/app_home_screen.dart';
import './screens/user_beritas_screen.dart';
import './screens/edit_berita_screen.dart';
import './screens/app_users_overview_screen.dart';
import './screens/edit_app_user_screen.dart';
// import './screens/products_overview_screen.dart';
// import './screens/product_detail_screen.dart';
// import './screens/cart_screen.dart';
// import './screens/orders_screen.dart';
// import './screens/user_products_screen.dart';
// import './screens/edit_product_screen.dart';

import './providers/auth.dart';
import './providers/beritas.dart';
// import './providers/products.dart';
// import './providers/orders.dart';
// import './providers/cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Beritas>(
          // create: (_) => Products(null, null),
          update: (ctx, auth, prevBeritas) => Beritas(
            auth.token,
            auth.userId,
            prevBeritas == null ? [] : prevBeritas.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, AppUsers>(
          // create: (_) => Products(null, null),
          update: (ctx, auth, prevAppUsers) => AppUsers(
            auth.token,
            auth.userId,
            prevAppUsers == null ? [] : prevAppUsers.items,
          ),
        ),
        // ChangeNotifierProxyProvider<Auth, Products>(
        //   // create: (_) => Products(null, null),
        //   update: (ctx, auth, prevProducts) => Products(
        //     auth.token,
        //     auth.userId,
        //     prevProducts == null ? [] : prevProducts.items,
        //   ),
        // ),
        // ChangeNotifierProvider.value(
        //   value: Cart(),
        // ),
        // ChangeNotifierProxyProvider<Auth, Orders>(
        //   // create: (_) => Products(null, null),
        //   update: (ctx, auth, prevOrders) => Orders(
        //     auth.token,
        //     auth.userId,
        //     prevOrders == null ? [] : prevOrders.orders,
        //   ),
        // ),
        // ChangeNotifierProvider.value(
        //   value: Orders(),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? BeritasOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            UserBeritasScreen.routeName: (ctx) => UserBeritasScreen(),
            EditBeritaScreen.routeName: (ctx) => EditBeritaScreen(),
            AppUsersOverviewScreen.routeName: (ctx) => AppUsersOverviewScreen(),
            EditAppUserScreen.routeName: (ctx) => EditAppUserScreen(),
            // ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            // CartScreen.routeName: (ctx) => CartScreen(),
            // OrdersScreen.routeName: (ctx) => OrdersScreen(),
            // UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            // EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
