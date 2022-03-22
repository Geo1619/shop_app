import 'package:flutter/material.dart';
import 'product.dart';

class ProductData with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
// // manage the favorite filter.
// // this is application wide filter approach.
// // filter logic should typically be managed in a widget locally
// // change ProductsOverviewScreen to Stateful Widget
// var showFavoritesOnly = false;

  List<Product> get products {
    // if (showFavoritesOnly) {
    //   return [..._items.where((element) => element.isFavorite)];
    // }
    return [..._products];
  }

  // filtering logic isolated in provider
  List<Product> get favoriteItems {
    return [..._products.where((p) => p.isFavorite)];
  }

  Product getById(String id) {
    return products.firstWhere((p) => p.id == id);
  }

  void addProduct(Product product) {
    product = product.copyWith(id: DateTime.now().toString());
    _products.add(product);
    // _items.insert(0, product); // at the start of the list
    notifyListeners();
  }

  void editProduct(Product product) {
    final productIndex = _products.indexWhere((p) => p.id == product.id);
    if (productIndex >= 0) {
      _products[productIndex] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}