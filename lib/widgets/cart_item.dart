import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import '../models/cart_item.dart' as cart_item_model;
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final cart_item_model.CartItem cartItem;
  final String productId;

  const CartItem({
    Key? key,
    required this.cartItem,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.read<Cart>();

    return Dismissible(
      key: ValueKey(cartItem.id),
      confirmDismiss: (direction) {
        var dismiss = false;

        if (direction == DismissDirection.endToStart ||
            cartItem.quantity == 1) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Are you sure?'),
              content:
                  const Text('Do you want to remove the item from the cart?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    dismiss = true;

                    cart.removeItem(productId);

                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        } else {
          cart.removeSingleItem(productId);
        }

        return Future.value(dismiss);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(cartItem.price.toString()),
                ),
              ),
            ),
            title: Text(cartItem.title),
            subtitle: Text(
              (cartItem.price * cartItem.quantity).toStringAsFixed(2),
            ),
            trailing: Text(cartItem.quantity.toString()),
          ),
        ),
      ),
    );
  }
}
