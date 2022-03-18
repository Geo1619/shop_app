import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    // don't want to update if another product gets added
    var loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).getById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
