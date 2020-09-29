import 'package:MyShop/Providers/auth.dart';
import 'package:MyShop/Providers/cart_items_provider.dart';
import 'package:MyShop/Providers/orders.dart';
import 'package:MyShop/Providers/products_provider.dart';
import 'package:MyShop/Screens/auth_screen.dart';
import 'package:MyShop/Screens/cart_screen.dart';
import 'package:MyShop/Screens/edit_product_screen.dart';
import 'package:MyShop/Screens/products_screen.dart';
import 'package:MyShop/Screens/splash_screen.dart';
import 'package:MyShop/helpers/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/orders_screen.dart';
import 'Screens/product_detail_screen.dart';
import 'Screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) =>
              Products(Provider.of<Auth>(context, listen: false)),
          update: (_, auth, products) => products,
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(
            Provider.of<Auth>(context, listen: false).token,
            Provider.of<Auth>(context, listen: false).userId,
          ),
          update: (_, auth, orders) => orders,
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomTransitionPage(),
                TargetPlatform.iOS: CustomTransitionPage(),
              },
            ),
          ),
          home: auth.isAuthenticated
              ? ProductScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SplashScreen();
                    }
                    if (auth.isAuthenticated) return ProductScreen();
                    return AuthScreen();
                  },
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            ProductScreen.routeName: (ctx) => ProductScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreens.routeName: (ctx) => OrdersScreens(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
