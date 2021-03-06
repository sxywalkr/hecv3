import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/beritas_overview_screen.dart';
import './screens/user_beritas_screen.dart';
import './screens/edit_berita_screen.dart';
import './screens/edit_app_user_screen.dart';
import './screens/app_users_manage_screen.dart';
import './screens/app_users_overview_screen.dart';
import './screens/app_users_overview_list_screen.dart';
import './screens/app_user_detail_screen.dart';
import './screens/hec_layanan_manage_screen.dart';
import './screens/edit_hec_layanan1_screen.dart';
import './screens/edit_hec_layanan2_screen.dart';
import './screens/edit_hec_layanan3_screen.dart';
import './screens/edit_hec_layanan4_screen.dart';
import './screens/edit_hec_layanan5_screen.dart';
import './screens/rekam_medik_screen.dart';

import './providers/auth.dart';
import './providers/beritas.dart';
import './providers/antrian.dart';
import './providers/antrians.dart';
import './providers/app_users.dart';
import './providers/hec_layanan1s.dart';
import './providers/hec_layanan2s.dart';
import './providers/hec_layanan3s.dart';
import './providers/hec_layanan4s.dart';
import './providers/hec_layanan5s.dart';
import './providers/rekam_medik.dart';
import './providers/rekam_mediks.dart';

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
        ChangeNotifierProxyProvider<Auth, Antrians>(
          // create: (_) => Products(null, null),
          update: (ctx, auth, prevAppUsers) => Antrians(
            auth.token,
            auth.userId,
            auth.token2,
            prevAppUsers == null ? [] : prevAppUsers.antriansItem,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Antrian>(
          // create: (_) => Products(null, null),
          update: (ctx, auth, prevAppUsers) => Antrian(
            auth.token,
            auth.userId,
            prevAppUsers == null ? [] : prevAppUsers.item,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, HecLayanan1s>(
          // create: (_) => Products(null, null),
          update: (ctx, auth, prevDatas) => HecLayanan1s(
            auth.token,
            auth.userId,
            prevDatas == null ? [] : prevDatas.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, HecLayanan2s>(
          // create: (_) => Products(null, null),
          update: (ctx, auth, prevDatas) => HecLayanan2s(
            auth.token,
            auth.userId,
            prevDatas == null ? [] : prevDatas.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, HecLayanan3s>(
          // create: (_) => Products(null, null),
          update: (ctx, auth, prevDatas) => HecLayanan3s(
            auth.token,
            auth.userId,
            prevDatas == null ? [] : prevDatas.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, HecLayanan4s>(
          // create: (_) => Products(null, null),
          update: (ctx, auth, prevDatas) => HecLayanan4s(
            auth.token,
            auth.userId,
            prevDatas == null ? [] : prevDatas.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, HecLayanan5s>(
          // create: (_) => Products(null, null),
          update: (ctx, auth, prevDatas) => HecLayanan5s(
            auth.token,
            auth.userId,
            prevDatas == null ? [] : prevDatas.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, RekamMediks>(
          // create: (_) => Products(null, null),
          update: (ctx, auth, prevDatas) => RekamMediks(
            auth.token,
            auth.userId,
            prevDatas == null ? [] : prevDatas.rmItems,
          ),
        ),
        ChangeNotifierProvider.value(
          value: RekamMedik(),
        ),
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
          debugShowCheckedModeBanner: false,
          routes: {
            UserBeritasScreen.routeName: (ctx) => UserBeritasScreen(),
            EditBeritaScreen.routeName: (ctx) => EditBeritaScreen(),
            AppUsersManageScreen.routeName: (ctx) => AppUsersManageScreen(),
            EditAppUserScreen.routeName: (ctx) => EditAppUserScreen(),
            AppUsersOverviewScreen.routeName: (ctx) => AppUsersOverviewScreen(),
            AppUsersOverviewListScreen.routeName: (ctx) =>
                AppUsersOverviewListScreen(),
            AppUserDetailScreen.routeName: (ctx) => AppUserDetailScreen(),
            HecLayananManageScreen.routeName: (ctx) => HecLayananManageScreen(),
            EditHecLayanan1Screen.routeName: (ctx) => EditHecLayanan1Screen(),
            EditHecLayanan2Screen.routeName: (ctx) => EditHecLayanan2Screen(),
            EditHecLayanan3Screen.routeName: (ctx) => EditHecLayanan3Screen(),
            EditHecLayanan4Screen.routeName: (ctx) => EditHecLayanan4Screen(),
            EditHecLayanan5Screen.routeName: (ctx) => EditHecLayanan5Screen(),
            RekamMedikScreen.routeName: (ctx) => RekamMedikScreen(),
          },
        ),
      ),
    );
  }
}
