import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order.dart';

class OrderItemTile extends StatefulWidget {
  const OrderItemTile({Key? key, required this.orderItem}) : super(key: key);

  final Order orderItem;

  @override
  State<OrderItemTile> createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
              iconSize: 40,
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              height:
                  min(widget.orderItem.products.length * 20.0 + 20.0, 120.0),
              child: ListView(
                children: widget.orderItem.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
