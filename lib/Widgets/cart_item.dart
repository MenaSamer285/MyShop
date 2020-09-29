import 'package:MyShop/Providers/cart_items_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final int quantity;
  final double price;

  CartItemWidget(
    this.id,
    this.title,
    this.quantity,
    this.price,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        child: Icon(
          Icons.delete,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd)
          return Future.value(false);
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text("Do you want to remove this item from the cart?"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text("no"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text("yes"),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => cart.removeItem(id),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 64,
                maxHeight: 64,
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            //  CircleAvatar(
            //   child: Padding(
            //     padding: const EdgeInsets.all(2),
            //     child: FittedBox(
            //       child: Text(
            //         "\$${price * quantity}",
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     ),
            //   ),
            //   backgroundColor: Theme.of(context).primaryColor,
            // ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text("total : ${price * quantity}"),
            trailing: Text(
              "${quantity}x",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
