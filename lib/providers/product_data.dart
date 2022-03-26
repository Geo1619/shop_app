// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductData with ChangeNotifier {
  ProductData(this.authToken, this.authUserId, this._products);

  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
// // manage the favorite filter.
// // this is application wide filter approach.
// // filter logic should typically be managed in a widget locally
// // change ProductsOverviewScreen to Stateful Widget
// var showFavoritesOnly = false;

  // Obtain this by ChangeNotifierProxyProvider in main.dart
  String? authToken;
  String? authUserId;

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

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    Map<String, String> queryParameters = filterByUser
        ? {
            // https://firebase.google.com/docs/database/rest/retrieve-data#orderby=key
            'orderBy': jsonEncode('creatorId'),
            'equalTo': jsonEncode(authUserId),
          }
        : {};
    var url = Uri.https(
      'flutter-shop-app-335dd-default-rtdb.europe-west1.firebasedatabase.app',
      '/products.json',
      {
        'auth': authToken,
      }..addAll(queryParameters),
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) return;
      url = Uri.https(
        'flutter-shop-app-335dd-default-rtdb.europe-west1.firebasedatabase.app',
        '/userFavorites/$authUserId.json',
        {'auth': authToken},
      );
      final favoritesResponse = await http.get(url);
      final favoriteData =
          jsonDecode(favoritesResponse.body) as Map<String, dynamic>?;

      List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
        _products = loadedProducts.reversed.toList();
        notifyListeners();
      });
    } catch (e) {
      rethrow;
    }
  }

  // We return a future so that edit product screen waits for this method
  Future<void> addProduct(Product product) async {
    final url = Uri.https(
      'flutter-shop-app-335dd-default-rtdb.europe-west1.firebasedatabase.app',
      '/products.json',
      {'auth': authToken},
    );
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': authUserId,
            // favorite is no longer part of product rather connected to user product
            // 'isFavorite': product.isFavorite,
          }));
      print(json.decode(response.body));
      // post from Firebase returns an json object {name: <generated key>} in its body
      // json.decode(json obj)  => dart map e.g. {'name': <generated key>}
      final responseMap = json.decode(response.body);
      product = product.copyWith(id: responseMap['name']);

      _products.add(product);
      // _items.insert(0, product); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    final productIndex = _products.indexWhere((p) => p.id == product.id);
    if (productIndex >= 0) {
      final url = Uri.https(
        'flutter-shop-app-335dd-default-rtdb.europe-west1.firebasedatabase.app',
        '/products/${product.id}.json',
        {'auth': authToken},
      );
      // patch will override only the sent data in db leaving the rest of the record intact.
      http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
      _products[productIndex] = product;
      notifyListeners();
    }
  }

  // optimistic updating (rollback deletion if request fails)
  Future<void> deleteProduct(String id) async {
    final url = Uri.https(
      'flutter-shop-app-335dd-default-rtdb.europe-west1.firebasedatabase.app',
      '/products/$id.json',
      {'auth': authToken},
    );
    final existingProductIndex = _products.indexWhere((p) => p.id == id);
    var existingProduct = _products[existingProductIndex];

    _products.removeAt(existingProductIndex);
    notifyListeners();
    final res = await http.delete(url);

    if (res.statusCode >= 400) {
      _products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
  }

  Future<void> toggleFavoriteStatus(String id) async {
    final productIndex = _products.indexWhere((p) => p.id == id);
    var existingProduct = _products[productIndex];
    var isFavoriteValue = !_products[productIndex].isFavorite;
    if (productIndex >= 0) {
      _products[productIndex] =
          _products[productIndex].copyWith(isFavorite: isFavoriteValue);
      notifyListeners();
      final url = Uri.https(
        'flutter-shop-app-335dd-default-rtdb.europe-west1.firebasedatabase.app',
        '/userFavorites/$authUserId/$id.json',
        {'auth': authToken},
      );
      // patch will override only the sent data in db leaving the rest of the record intact.
      // put will replace data of .json of url.
      try {
        final res = await http.put(
          url,
          body: json.encode(
            isFavoriteValue,
          ),
        );
        if (res.statusCode >= 400) {
          _products[productIndex] = existingProduct;
          notifyListeners();
          throw HttpException('Something went wrong on our side.');
        }
      } catch (e) {
        print(e);
        rethrow;
      }
    }
  }
}
