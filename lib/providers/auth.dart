import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  static const _apiKey = 'AIzaSyD_tZGY36znbLhJo4DCBKFRAZGcUZbbN1A';
  late String _token;
  late DateTime _expiryDate;
  late String _useId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:$urlSegment',
      {'key': _apiKey},
    );

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      debugPrint(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    await _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    await _authenticate(email, password, 'signInWithPassword');
  }
}
