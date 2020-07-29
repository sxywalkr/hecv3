import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_users.dart';
import 'app_user_item.dart';

class AppUsersGrid extends StatelessWidget {
  final bool isFav;

  AppUsersGrid(this.isFav);

  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<AppUsers>(context);
    final items = itemsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: items.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: items[index],
        child: AppUserItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
