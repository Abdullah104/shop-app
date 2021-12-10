import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'product.dart';

class Products with ChangeNotifier {
  final _uri = Uri.parse(
    'https://shop-app-e0796-default-rtdb.europe-west1.firebasedatabase.app/products.json',
  );

  var _items = <Product>[];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((item) => item.isFavorite).toList();

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await get(_uri);
      final body = json.decode(response.body) as Map<String, dynamic>;
      final keys = body.keys.toList();
      final tmp = <Product>[];

      for (var i = 0; i < keys.length; i++) {
        final key = keys[i];
        final value = body[key];

        tmp.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['image_url'],
          ),
        );
      }

      _items = tmp;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await post(_uri, body: json.encode(product.toJson()));

      final id = (json.decode(response.body) as Map<String, dynamic>)['name']
          as String;

      final newProduct = Product(
        id: id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);

      notifyListeners();
    } on Exception catch (_) {}
  }

  Product findById(String id) => _items.firstWhere((item) => item.id == id);

  void updateProduct(String id, Product product) {
    final index = _items.indexWhere((item) => item.id == id);

    _items[index] = product;

    notifyListeners();
  }

  void removeProduct(String id) {
    _items.removeWhere((item) => item.id == id);

    notifyListeners();
  }
}
