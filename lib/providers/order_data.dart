// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';
import 'order.dart';

class OrderData with ChangeNotifier {
  OrderData(this.authToken, this.authUserId, this._orders);
  List<Order> _orders = [];
  String? authToken;
  String? authUserId;

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final _url = Uri.https(
      'flutter-shop-app-335dd-default-rtdb.europe-west1.firebasedatabase.app',
      '/orders/$authUserId.json',
      {'auth': authToken},
    );
    try {
      final response = await http.get(_url);
      print(json.decode(response.body));

      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      List<Order> loadedOrders = [];

      if (extractedData == null) return;

      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(Order(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((cp) => CartItem(
                    id: cp['id'],
                    title: cp['title'],
                    quantity: cp['quantity'],
                    price: cp['price'],
                  ))
              .toList(),
        ));
        _orders = loadedOrders;

        // with this the UI updates in all places
        notifyListeners();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
      'flutter-shop-app-335dd-default-rtdb.europe-west1.firebasedatabase.app',
      '/orders/$authUserId.json',
      {'auth': authToken},
    );
    final timeStamp = DateTime.now();
    try {
      var response = await http.post(url,
          body: jsonEncode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'price': cp.price,
                      'quantity': cp.quantity,
                    })
                .toList(),
          }));

      _orders.insert(
        0,
        Order(
          id: jsonDecode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
