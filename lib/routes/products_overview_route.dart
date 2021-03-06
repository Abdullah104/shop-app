import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

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
  static const routeName = '/products-overview';

  const ProductsOverview({Key? key}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavorites = false;
  var _init = false;
  var _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_init) {
      setState(() {
        _loading = true;
      });

      context
          .read<Products>()
          .fetchAndSetProducts()
          .then((_) => setState(() => _loading = false));

      _init = true;
    }
  }

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
      body: _loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ProductsGrid(
              showOnlyFavorites: _showOnlyFavorites,
            ),
    );
  }
}
