import 'package:MyShop/Providers/product.dart';
import 'package:MyShop/Providers/products_provider.dart';
import 'package:MyShop/Widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFavouritesOnly;

  ProductsGrid(this._showFavouritesOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    List<Product> _products;
    if (_showFavouritesOnly)
      _products = productsData.favouriteItems;
    else
      _products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: _products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: _products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 20 / 21,
        mainAxisSpacing: 10,
      ),
    );
  }
}
