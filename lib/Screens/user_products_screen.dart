import 'package:MyShop/Providers/products_provider.dart';
import 'package:MyShop/Screens/edit_product_screen.dart';
import 'package:MyShop/Widgets/app_drawer.dart';
import 'package:MyShop/Widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static final routeName = "user-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetData(filterUser: true);
  }

  @override
  Widget build(BuildContext context) {
    //var products = Provider.of<Products>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("My products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Products>(
                    builder: (context, products, child) => RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (context, index) => UserProductItem(
                            products.items[index].id,
                            products.items[index].title,
                            products.items[index].imageUrl,
                          ),
                          itemCount: products.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
