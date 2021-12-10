import 'package:shop_app/models/cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime time;

  OrderItem({
    required this.id,
    required this.amount,
    required this.cartItems,
    required this.time,
  });
}
