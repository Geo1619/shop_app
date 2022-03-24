import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/product_data.dart';
import '../screens/product_details_screen.dart';

class ProductItemGridTile extends StatelessWidget {
  const ProductItemGridTile({Key? key}) : super(key: key);

  // const ProductItem(this.id, this.title, this.imageUrl, {Key? key})
  //     : super(key: key);
  // final String id;
  // final String title;
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    // will look for the nearest product provided at initialization
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<ProductData>(
            builder: (context, productData, child) {
              return IconButton(
                icon: child!,
                onPressed: () async {
                  try {
                    await productData.toggleFavoriteStatus(product.id);
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
              );
            },
            child: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              scaffoldMessenger.hideCurrentSnackBar();
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: const Text('Added Item to cart!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () => cart.reduceItemQuantity(product.id),
                  ),
                ),
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
