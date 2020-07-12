import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_users.dart';
import 'app_user_item.dart';

class AppUsersGrid extends StatelessWidget {
  final bool isFav;

  AppUsersGrid(this.isFav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<AppUsers>(context);
    final products = productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: AppUserItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
