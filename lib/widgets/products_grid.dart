import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;

  const ProductsGrid({
    Key? key,
    required this.showOnlyFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Products>();

    final productsItems =
        showOnlyFavorites ? products.favoriteItems : products.items;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: productsItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, index) => ChangeNotifierProvider.value(
      key: ValueKey(productsItems[index].id),
        value: productsItems[index],
        child: const ProductItem(),
      ),
    );
  }
}
