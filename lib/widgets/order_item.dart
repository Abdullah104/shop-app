import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_item.dart' as models;

class OrderItem extends StatefulWidget {
  final models.OrderItem orderItem;

  const OrderItem({
    Key? key,
    required this.orderItem,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text('${widget.orderItem.amount}'),
            subtitle:
                Text(DateFormat('dd MM yyyy').format(widget.orderItem.time)),
            trailing: IconButton(
              icon: const Icon(Icons.expand_more),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: min(widget.orderItem.cartItems.length * 20.0 + 10, 100),
              child: ListView.builder(
                  itemCount: widget.orderItem.cartItems.length,
                  itemBuilder: (_, index) {
                    final item = widget.orderItem.cartItems[index];

                    return FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${item.quantity} X ${item.price} SAR',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            )
        ],
      ),
    );
  }
}
