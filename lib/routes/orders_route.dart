import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdesRoute extends StatelessWidget {
  static const routeName = '/orders';

  const OrdesRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<Orders>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orders.orderItems.length,
        itemBuilder: (_, index) => OrderItem(
          orderItem: orders.orderItems[index],
        ),
      ),
    );
  }
}
