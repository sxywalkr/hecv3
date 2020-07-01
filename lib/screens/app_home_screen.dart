import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class AppHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Home'),
      ),
      drawer: AppDrawer(),
    );
  }
}
