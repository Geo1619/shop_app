import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/product_item_list_tile.dart';

import '../providers/product_data.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductData>(context, listen: false)
        .fetchAndSetProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<ProductData>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        drawer: const AppDrawer(),
        // this widget: drug top to refresh
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<ProductData>(
                    builder: (context, productData, child) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemBuilder: ((_, i) => Column(
                              children: [
                                ProductItemListTile(
                                    id: productData.products[i].id,
                                    title: productData.products[i].title,
                                    imageUrl: productData.products[i].imageUrl),
                                const Divider(),
                              ],
                            )),
                        itemCount: productData.products.length,
                      ),
                    ),
                  ),
                ),
        ));
  }
}
