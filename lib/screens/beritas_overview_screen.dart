import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/beritas_grid.dart';
// import '../widgets/badge.dart';
// import './cart_screen.dart';
// import '../providers/cart.dart';
import '../providers/beritas.dart';

enum FilterOptions {
  Favorites,
  All,
}

class BeritasOverviewScreen extends StatefulWidget {
  @override
  _BeritasOverviewScreenState createState() => _BeritasOverviewScreenState();
}

class _BeritasOverviewScreenState extends State<BeritasOverviewScreen> {
  var _showOnlyFav = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Beritas>(context)
          .fetchAndSetBeritas()
          .then((_) => setState(() {
                _isLoading = false;
              }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Klinik Mata Hasanuddin'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFav = true;
                } else {
                  _showOnlyFav = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              )
            ],
            icon: Icon(Icons.more_vert),
          ),
          // Consumer<Cart>(
          //   builder: (_a, carts, ch) => Badge(
          //     child: ch,
          //     value: carts.itemCount.toString(),
          //   ),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.shopping_cart,
          //     ),
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(CartScreen.routeName);
          //     },
          //   ),
          // ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : BeritasGrid(_showOnlyFav),
    );
  }
}
