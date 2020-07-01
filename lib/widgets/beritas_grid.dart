import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/beritas.dart';
import 'berita_item.dart';

class BeritasGrid extends StatelessWidget {
  final bool isFav;

  BeritasGrid(this.isFav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Beritas>(context);
    final products = isFav ? productsData.itemsFav : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: BeritaItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
