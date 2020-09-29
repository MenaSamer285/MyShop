import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem _order;

  const OrderItem(this._order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget._order.amount.toStringAsFixed(2)}"),
            subtitle: Text(
              DateFormat("dd/MM/yyy hh:mm").format(widget._order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: (Duration(milliseconds: 300)),
            width: double.infinity,
            height: _expanded
                ? min((widget._order.products.length * 20.0 + 100.0), 180.0)
                : 0,
            child: ListView(
              children: widget._order.products
                  .map((e) => Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${e.title}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${e.quantity}X${e.price}",
                              style: TextStyle(
                                fontSize: 17.5,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
