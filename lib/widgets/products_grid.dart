import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/product_item.dart';

import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Want to update every time a product gets added
    final loadedProducts = Provider.of<Products>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        // this is the nearest product provided to product initialized beneath
        create: ((context) => loadedProducts[i]),
        child: const ProductItem(
            // loadedProducts[i].id,
            // loadedProducts[i].title,
            // loadedProducts[i].imageUrl,
            ),
      ),
    );
  }
}
