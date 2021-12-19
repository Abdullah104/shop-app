import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartRoute extends StatelessWidget {
  static const routeName = '/cart';

  const CartRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<Cart>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 8,
                  ),
                  Chip(
                    label: Text(
                      '${cart.totalAmount.toStringAsFixed(2)} SAR',
                      style: TextStyle(
                        color: theme.primaryTextTheme.headline6?.color,
                      ),
                    ),
                    backgroundColor: theme.primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (_, index) => CartItem(
                cartItem: cart.items.values.toList()[index],
                productId: cart.items.keys.toList()[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cart.totalAmount <= 0 || _loading ? null : order,
      child: _loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : const Text('ORDER NOW'),
    );
  }

  Future<void> order() async {
    setState(() {
      _loading = true;
    });

    await context
        .read<Orders>()
        .addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);

    setState(() {
      _loading = false;
    });

    widget.cart.clearCart();
  }
}
