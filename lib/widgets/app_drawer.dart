import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text('Hello friend!'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shop),
          title: const Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text('Orders'),
          onTap: () {
            // Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            Navigator.of(context).pushReplacement(CustomRoute(
              builder: (ctx) => const OrdersScreen(),
            ));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shopping_basket),
          title: const Text('Manage Products'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log out'),
          onTap: () {
            // This might not be needed anymore
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacementNamed('/'); // default route of home page

            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ]),
    );
  }
}
