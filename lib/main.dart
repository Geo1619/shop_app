import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';

import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './providers/cart.dart';
import './providers/product_data.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import 'providers/order_data.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        // ProxyProvider used to pass auth token of our requests on update to screens
        ChangeNotifierProxyProvider<Auth, ProductData>(
          create: (ctx) => ProductData(null, null, []),
          update: (ctx, auth, previousProductData) => ProductData(
              auth.token,
              auth.userId,
              previousProductData == null ? [] : previousProductData.products),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderData>(
          create: (ctx) => OrderData(null, null, []),
          update: (ctx, auth, previousOrderData) => OrderData(
              auth.token,
              auth.userId,
              previousOrderData == null ? [] : previousOrderData.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.purple,
              secondary: Colors.deepOrange,
            ),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: ((context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : const AuthScreen())),
          routes: {
            ProductDetailsScreen.routeName: (context) =>
                const ProductDetailsScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) =>
                const UserProductsScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
