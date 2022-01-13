import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/routes/splash_screen.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'routes/authentication_route.dart';
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
    textTheme: const TextTheme(
      headline6: TextStyle(
        color: Colors.white,
      ),
    ),
  );

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (_, auth, previous) => Products(
            authenticationToken: auth.token,
            items: previous == null ? [] : previous.items,
            userId: auth.userId,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (_, auth, previous) => Orders(
            token: auth.token,
            orderItems: previous == null ? [] : previous.orderItems,
            userId: auth.userId,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (_, auth, __) {
          return MaterialApp(
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
              // AuthenticationRoute.routeName: (_) => const AuthenticationRoute(),
            },
            home: auth.isAuthenticated
                ? const ProductsOverview()
                : FutureBuilder<bool>(
                    future: auth.tryAutoLogin(),
                    builder: (_, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthenticationRoute(),
                  ),
            // : const AuthenticationRoute(),
          );
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
