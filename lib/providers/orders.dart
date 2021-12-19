import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/cart_item.dart';
import '../models/order_item.dart' as models;

class Orders with ChangeNotifier {
  var _orderItems = <models.OrderItem>[];
  final String? token;
  final String? userId;

  late final _uri = Uri.parse(
    'https://shop-app-e0796-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$token',
  );

  Orders({
    this.token,
    this.userId,
    List<models.OrderItem>? orderItems,
  }) : _orderItems = orderItems ?? [];

  List<models.OrderItem> get orderItems => [..._orderItems];

  Future<void> fetchAndSetOrders() async {
    final response = await get(_uri);

    final body = json.decode(response.body) as Map<String, dynamic>?;
    final tmp = <models.OrderItem>[];

    if (body != null) {
      body.forEach((key, value) {
        final cartItems = (value['products'] as List)
            .map(
              (product) => CartItem(
                id: product['id'],
                title: product['title'],
                quantity: product['quantity'],
                price: product['price'],
              ),
            )
            .toList();

        tmp.add(
          models.OrderItem(
            id: key,
            time: DateTime.parse(value['date']),
            cartItems: cartItems,
            amount: value['amount'],
          ),
        );
      });
    }

    _orderItems = tmp.reversed.toList();

    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final timestamp = DateTime.now();

    final response = await post(
      _uri,
      body: json.encode({
        'amount': total,
        'date': timestamp.toIso8601String(),
        'products': cartItems
            .map((cartItem) => {
                  'id': cartItem.id,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );

    _orderItems.insert(
      0,
      models.OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        cartItems: cartItems,
        time: timestamp,
      ),
    );

    notifyListeners();
  }
}
