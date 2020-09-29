import 'package:MyShop/Providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static final routeName = 'product_detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Color appBarColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context).findById(productId);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            onStretchTrigger: () {
              if (appBarColor == Colors.white) {
                setState(() {
                  appBarColor = Theme.of(context).primaryColor;
                });
              } else {
                setState(() {
                  appBarColor = Colors.white;
                });
              }
              return;
            },
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                product.title,
              ),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "\$${product.price}",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 30,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "${product.description}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ),
              SizedBox(
                height: 800,
                child: Container(
                  height: 900,
                  color: Colors.amber,
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
