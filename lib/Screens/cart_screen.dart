import 'package:MyShop/Providers/cart_items_provider.dart';
import 'package:MyShop/Providers/orders.dart';
import 'package:MyShop/Widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static final routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Total", style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_left_sharp),
                Text("Swap left to remove item"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(15),
              itemBuilder: (context, index) => CartItemWidget(
                cart.items.values.toList()[index].id,
                cart.items.values.toList()[index].title,
                cart.items.values.toList()[index].quantity,
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].imageUrl,
              ),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class OrderButton extends StatefulWidget {
  OrderButton({
    @required this.cart,
  });

  bool _isLoaded = false;
  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget._isLoaded || widget.cart.totalAmount <= 0)
          ? null
          : () async {
              setState(() {
                widget._isLoaded = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              setState(() {
                widget._isLoaded = false;
              });
              widget.cart.clear();
            },
      child: widget._isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text("ORDER NOW"),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
