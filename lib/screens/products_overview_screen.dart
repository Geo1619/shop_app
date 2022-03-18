import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

// Grid of products
class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

// Screen (or page or route) widgets should return a Scaffold widget to provide a full UI layout
// with appBar, body etc.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Shop'),
      ),
      body: const ProductsGrid(),
    );
  }
}
