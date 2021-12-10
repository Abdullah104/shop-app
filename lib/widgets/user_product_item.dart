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
              onPressed: () =>
                  context.read<Products>().removeProduct(product.id),
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
