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
    final future = context.read<Orders>().fetchAndSetOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<void>(
        future: future,
        builder: (_, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? Consumer<Orders>(
                  builder: (_, orders, __) => ListView.builder(
                    itemCount: orders.orderItems.length,
                    itemBuilder: (_, index) => OrderItem(
                      orderItem: orders.orderItems[index],
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
        },
      ),
    );
  }
}
