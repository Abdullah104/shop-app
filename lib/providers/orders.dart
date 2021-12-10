import 'package:flutter/foundation.dart';
import 'package:shop_app/models/order_item.dart' as models;
import 'package:shop_app/models/cart_item.dart';

class Orders with ChangeNotifier {
  final List<models.OrderItem> _orderItems = [];

  List<models.OrderItem> get orderItems => [..._orderItems];

  void addOrder(List<CartItem> cartItems, double total) {
    _orderItems.insert(
      0,
      models.OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        cartItems: cartItems,
        time: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
