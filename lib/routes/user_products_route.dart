import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import 'edit_product_route.dart';

class UserProductsRoute extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              EditProductRoute.routeName,
              arguments: {'purpose': RoutePurpose.addNewProduct},
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer<Products>(
          builder: (_, products, __) => ListView.builder(
            itemCount: products.items.length,
            itemBuilder: (_, index) => Column(
              children: [
                UserProductItem(
                  product: products.items[index],
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
