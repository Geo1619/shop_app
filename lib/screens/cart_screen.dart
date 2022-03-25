import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_data.dart';

import '../providers/cart.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            ?.color),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                OrderButton(cart: cart),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (ctx, i) => CartItemTile(
              id: cart.items.values.toList()[i].id,
              productId: cart.items.keys.toList()[i],
              title: cart.items.values.toList()[i].title,
              quantity: cart.items.values.toList()[i].quantity,
              price: cart.items.values.toList()[i].price,
            ),
          ),
        )
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              // cart screen is not interested (aka. does not need to change) in
              // changes of our orders so set listen: false
              await Provider.of<OrderData>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              //  cart screen needs to listen to cart changes to empty the following ListView of
              // cartItems
              widget.cart.clear();
            },
      child: _isLoading
          ? const SizedBox(
              width: 80,
              child: Center(child: CircularProgressIndicator()),
            )
          : const Text('ORDER NOW'),
    );
  }
}
