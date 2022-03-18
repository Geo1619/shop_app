import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.purple,
              secondary: Colors.deepOrange,
            ),
            fontFamily: 'Lato',
          ),
          home: const ProductsOverviewScreen(),
          routes: {
            ProductDetailsScreen.routeName: (context) =>
                const ProductDetailsScreen(),
          }),
    );
  }
}
