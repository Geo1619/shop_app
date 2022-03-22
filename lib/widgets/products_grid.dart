import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/product_item_grid_tile.dart';

import '../providers/product_data.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid(
    this.showFavorites, {
    Key? key,
  }) : super(key: key);

  final bool showFavorites;

  @override
  Widget build(BuildContext context) {
    // Want to update every time a product gets added
    final productsData = Provider.of<ProductData>(context);
    final loadedProducts =
        showFavorites ? productsData.favoriteItems : productsData.products;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // this is the nearest product provided to product initialized beneath
        value: loadedProducts[i],
        child: const ProductItemGridTile(
            // loadedProducts[i].id,
            // loadedProducts[i].title,
            // loadedProducts[i].imageUrl,
            ),
      ),
    );
  }
}
