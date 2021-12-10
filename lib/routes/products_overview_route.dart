import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'cart_route.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverview extends StatefulWidget {
  static const routeName = '/';

  const ProductsOverview({Key? key}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (FilterOptions value) => setState(
              () => _showOnlyFavorites = value == FilterOptions.favorites,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.favorites,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, __) {
              return Badge(
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    CartRoute.routeName,
                  ),
                ),
                value: cart.itemQuantityCount.toString(),
              );
            },
            // child:
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(
        showOnlyFavorites: _showOnlyFavorites,
      ),
    );
  }
}
