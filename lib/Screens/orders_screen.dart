import 'package:MyShop/Providers/orders.dart';
import 'package:MyShop/Widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/orderItem.dart' as wid;

class OrdersScreens extends StatelessWidget {
  static final routeName = "orders_screen";
  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Center(child: Text("An error accured"));
            }
            return Consumer<Orders>(
              builder: (context, orderData, child) => ListView.builder(
                itemBuilder: (context, index) =>
                    wid.OrderItem(orderData.orders[index]),
                itemCount: orderData.orders.length,
              ),
            );
          }
        },
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
      ),
    );
  }
}
