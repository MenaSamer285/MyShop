import 'package:MyShop/Providers/cart_items_provider.dart';
import 'package:MyShop/Providers/products_provider.dart';
import 'package:MyShop/Widgets/app_drawer.dart';
import 'package:MyShop/Widgets/badge.dart';
import 'package:MyShop/Widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  static String routeName = "products_screen";
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _showFavouritesOnly = false;
  bool isInite = false;
  bool _isLoaded = false;

  @override
  void initState() {
    isInite = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInite) {
      setState(() {
        _isLoaded = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetData(filterUser: false)
          .then((value) {
        setState(() {
          _isLoaded = false;
        });

        isInite = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Shop"),
          actions: [
            Consumer<Cart>(
              builder: (context, cart, child) => Badge(
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
                value: "${cart.itemsCount}",
              ),
            ),
            PopupMenuButton(
              onSelected: (res) {
                if (res == 1) {
                  setState(() {
                    _showFavouritesOnly = true;
                  });
                }
                if (res == 2) {
                  setState(() {
                    _showFavouritesOnly = false;
                  });
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Show favourites"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("All"),
                ),
              ],
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoaded
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showFavouritesOnly));
  }
}
