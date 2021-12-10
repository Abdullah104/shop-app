import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../providers/product.dart';
import '../routes/edit_product_route.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: FittedBox(
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pushNamed(
                context,
                EditProductRoute.routeName,
                arguments: {
                  'product': product,
                  'purpose': RoutePurpose.editExistingProduct,
                },
              ),
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () => deleteProduct(
                product.id,
                context,
                scaffoldMessenger,
              ),
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteProduct(
    String id,
    BuildContext context,
    ScaffoldMessengerState messenger,
  ) async {
    try {
      await context.read<Products>().removeProduct(product.id);
    } on Exception catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
