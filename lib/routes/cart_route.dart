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
                  TextButton(
                    onPressed: () {
                      context.read<Orders>().addOrder(
                          cart.items.values.toList(), cart.totalAmount);

                      cart.clearCart();
                    },
                    child: const Text('ORDER NOW'),
                  )
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
