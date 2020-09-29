import 'package:MyShop/Providers/auth.dart';
import 'package:MyShop/Screens/orders_screen.dart';
import 'package:MyShop/Screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(15),
            color: Theme.of(context).primaryColor,
            child: Text(
              "Welcome to my shop",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop", style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("My Orders", style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreens.routeName);
              // Navigator.of(context).pushReplacement(
              //     CustomRoute(widgetBuilder: (ctx) => OrdersScreens()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.ad_units),
            title: Text("My Products", style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Log out", style: TextStyle(fontSize: 20)),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logOut();
            },
          )
        ],
      ),
    );
  }
}
