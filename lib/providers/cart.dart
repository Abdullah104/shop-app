import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  final _items = <String, CartItem>{};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  int get itemQuantityCount {
    int count = 0;

    for (var i = 0; i < _items.keys.length; i++) {
      final key = _items.keys.toList()[i];
      final item = _items[key];

      count += item!.quantity;
    }

    return count;
  }

  double get totalAmount => _items.values.fold(
        0.0,
        (previousValue, item) => previousValue + item.price * item.quantity,
      );

  void addItem(String productId, double price, String title) {
    _items.update(
      productId,
      (oldItem) => CartItem(
        id: oldItem.id,
        title: oldItem.title,
        quantity: oldItem.quantity + 1,
        price: oldItem.price,
      ),
      ifAbsent: () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        quantity: 1,
        price: price,
      ),
    );

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);

    notifyListeners();
  }

  void clearCart() {
    _items.clear();

    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items.update(
          productId,
          (product) => CartItem(
            id: product.id,
            title: product.title,
            quantity: product.quantity - 1,
            price: product.price,
          ),
        );
      } else {
        _items.remove(productId);
      }

      notifyListeners();
    }
  }
}
