import 'package:MyShop/Providers/auth.dart';
import 'package:MyShop/Providers/cart_items_provider.dart';
import 'package:MyShop/Providers/product.dart';
import 'package:MyShop/Providers/products_provider.dart';
import 'package:MyShop/Screens/product_detail_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final productsData = Provider.of<Products>(context);
    final myCart = Provider.of<Cart>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset.zero,
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: AutoSizeText(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
              minFontSize: 10,
              maxLines: 1,
            ),
            leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                onPressed: () async {
                  var auth = Provider.of<Auth>(context, listen: false);
                  await product.toggleFavourite(auth.token, auth.userId);
                  productsData.makeNotify();
                },
                color: Theme.of(context).accentColor,
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                myCart.addItem(
                  product.id,
                  product.title,
                  product.price,
                  product.imageUrl,
                );
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${product.title} added to card",
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false)
                            .removeProduct(product.id);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Container(
              color: Colors.white,
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      AssetImage("assests/images/product-placeholder.png"),
                  image: NetworkImage(
                    product.imageUrl,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
