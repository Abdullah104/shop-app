import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../routes/product_details_route.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = context.read<Product>();
    final cart = context.read<Cart>();
    final messenger = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          ProductDetailsRoute.routeName,
          arguments: product,
        ),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (_, product, __) {
                final auth = context.read<Auth>();

                return IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  color: theme.colorScheme.secondary,
                  onPressed: () => product
                      .toggleFavoriteStatus(auth.token!, auth.userId!)
                      .catchError(
                    (error) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    },
                  ),
                );
              },
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: theme.colorScheme.secondary,
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                messenger.hideCurrentSnackBar();

                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('Added item to cart'),
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () => cart.removeSingleItem(product.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
