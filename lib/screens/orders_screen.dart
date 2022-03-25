// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item_tile.dart';

import '../providers/order_data.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const routeName = '/order';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
// Isolate future initialisation from FutureBuilder

  late Future _ordersFetchFuture;

  Future _runOrdersFetchFuture() {
    return Provider.of<OrderData>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFetchFuture = _runOrdersFetchFuture();
    super.initState();
  }

  // // All this logic of fetching the orders and showing loading screen can be
  // // gracefully handled by Futurebuilder with Consumer

  // var _isLoading = false;

  // @override
  // void initState() {

  //     _isLoading = true;

  //   Provider.of<OrderData>(context, listen: false)
  //       .fetchAndSetOrders()
  //       .then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // // if this is left here along with FutureBuilder it will cause an endless loop
    // // of listening to .fetchAndSetOrders and rebuilding so we use a Consumer inside FutureBuilder
    // final orderData = Provider.of<OrderData>(context);
    print('Building orders');
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      drawer: const AppDrawer(),
      // FutureBuilder will accept a future and bind its current
      // data state to the widgets of its builder
      // The future obtained should be executed outside of Widget build()
      // to avoid being run on every rebuild
      body: FutureBuilder(
        future: _ordersFetchFuture,
        builder: (context, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (dataSnapShot.hasError) {
            return Center(
              child: Text(
                'An error occured!',
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            );
          } else {
            return Consumer<OrderData>(
              builder: (ctx, orderData, child) {
                return ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItemTile(
                    orderItem: orderData.orders[i],
                  ),
                );
              },
            );
          }
        },
      ),
      //  _isLoading
      //   ? const Center(
      //       child: CircularProgressIndicator(),
      //     )
      //   : ListView.builder(
      //       itemCount: orderData.orders.length,
      //       itemBuilder: (ctx, i) => OrderItemTile(
      //         orderItem: orderData.orders[i],
      //       ),
      //     ),
    );
  }
}
