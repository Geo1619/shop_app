import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/product_item_list_tile.dart';

import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('My Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: Icon(Icons.add)),
          ],
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: ((_, i) => Column(
                  children: [
                    ProductItemListTile(
                        title: products.items[i].title,
                        imageUrl: products.items[i].imageUrl),
                    const Divider(),
                  ],
                )),
            itemCount: products.items.length,
          ),
        ));
  }
}
