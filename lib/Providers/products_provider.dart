import 'dart:convert';

import 'package:MyShop/Providers/auth.dart';

import '../Models/http-exception.dart';
import 'package:MyShop/Providers/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://3.imimg.com/data3/MB/XC/MY-19124053/stylish-trouser-500x500.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yello Scarf',
    //   description: 'warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/6103LNztB8L._AC_UL1200_.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://purepng.com/public/uploads/large/purepng.com-frying-panfrying-panfryingpan-1701528267147za99v.png',
    // )
  ];

  final Auth _auth;

  Products(this._auth);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  Future<void> fetchAndSetData({bool filterUser = false}) async {
    String filter =
        filterUser ? '&orderBy="creatorId"&equalTo="${_auth.userId}"' : '';
    final url =
        "https://flutter-update-a6327.firebaseio.com/products.json?auth=${_auth.token}$filter";
    final favUrl =
        "https://flutter-update-a6327.firebaseio.com/userFavourites/${_auth.userId}.json?auth=${_auth.token}";
    final response = await http.get(url);
    final responseFavData = await http.get(favUrl);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final extractedFavData =
        json.decode(responseFavData.body) as Map<String, dynamic>;
    _items.clear();
    if (extractedData == null) return;
    extractedData.forEach((key, value) {
      _items.add(Product(
        id: key,
        title: value['title'],
        description: value['description'],
        imageUrl: value['imageUrl'],
        price: value['price'],
        isFavourite:
            extractedFavData == null ? false : extractedFavData[key] ?? false,
      ));
    });
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://flutter-update-a6327.firebaseio.com/products.json?auth=${_auth.token}";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'creatorId': _auth.userId,
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          },
        ),
      );
      var newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final url =
        "https://flutter-update-a6327.firebaseio.com/products/${product.id}.json?auth=${_auth.token}";
    try {
      await http.patch(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          },
        ),
      );
      var productIndex =
          _items.indexWhere((element) => element.id == product.id);
      _items[productIndex] = product;
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> removeProduct(String productId) async {
    final url =
        "https://flutter-update-a6327.firebaseio.com/products/$productId.json?auth=${_auth.token}";
    final productIndex =
        _items.indexWhere((element) => element.id == productId);
    var product = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, product);
      notifyListeners();
      throw HttpException("There is error, may be internet conection");
    } else {
      product = null;
    }
  }

  void makeNotify() {
    notifyListeners();
  }
}
