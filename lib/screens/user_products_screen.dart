import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/product_item_list_tile.dart';

import '../providers/product_data.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductData>(context);
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
                        id: products.products[i].id,
                        title: products.products[i].title,
                        imageUrl: products.products[i].imageUrl),
                    const Divider(),
                  ],
                )),
            itemCount: products.products.length,
          ),
        ));
  }
}
