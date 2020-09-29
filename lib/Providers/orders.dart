import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'cart_items_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.products, this.dateTime);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String _authToken;
  final String _userId;

  Orders(this._authToken, this._userId);

  List<OrderItem> get orders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    final url =
        "https://flutter-update-a6327.firebaseio.com/orders/$_userId.json?auth=$_authToken";
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    _orders.clear();
    if (extractedData == null) return;
    extractedData.forEach((key, value) {
      _orders.add(OrderItem(
        key,
        value['total'],
        (value['cartProducts'] as List<dynamic>)
            .map((e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                  imageUrl: e['imageUrl'],
                ))
            .toList(),
        DateTime.parse(value['dateTime']),
      ));
    });
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://flutter-update-a6327.firebaseio.com/orders/$_userId.json?auth=$_authToken";
    final response = await http.post(
      url,
      body: json.encode(
        {
          'total': total,
          'cartProducts': cartProducts
              .map(
                (e) => {
                  'title': e.title,
                  'imageUrl': e.imageUrl,
                  'price': e.price,
                  'quantity': e.quantity,
                },
              )
              .toList(),
          'dateTime': DateTime.now().toIso8601String(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
        json.decode(response.body)['id'],
        total,
        cartProducts,
        json.decode(response.body)['dateTime'],
      ),
    );
    notifyListeners();
  }
}
