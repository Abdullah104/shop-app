import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'routes/cart_route.dart';
import 'routes/edit_product_route.dart';
import 'routes/orders_route.dart';
import 'routes/product_details_route.dart';
import 'routes/products_overview_route.dart';
import 'routes/user_products_route.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final theme = ThemeData(
    primarySwatch: Colors.indigo,
    fontFamily: 'Lato',
  );

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: Colors.red,
          ),
        ),
        routes: {
          ProductsOverview.routeName: (_) => const ProductsOverview(),
          ProductDetailsRoute.routeName: (_) => const ProductDetailsRoute(),
          CartRoute.routeName: (_) => const CartRoute(),
          OrdesRoute.routeName: (_) => const OrdesRoute(),
          UserProductsRoute.routeName: (_) => const UserProductsRoute(),
          EditProductRoute.routeName: (_) => const EditProductRoute(),
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
