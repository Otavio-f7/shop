import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/products_page.dart';
import 'package:shop/utils/app_routes.dart';
import './models/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList('', []),
          update: (ctx, auth, previous){
            return ProductList(
              auth.token ?? '', 
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList('', []),
          update: (tx, auth, previous) {
            return OrderList(auth.token ?? '', previous?.items ?? []);
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ), 
          scaffoldBackgroundColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.primary,
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
            centerTitle: true
          ),
          fontFamily: 'Lato'
        ),
        // home: const ProductsOverviewPage(),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.AUTH_OR_HOME :(ctx) => const AuthOrHomePage(),
          AppRoutes.PRODUCT_DETAIL :(ctx) => const ProductDetailPage(),
          AppRoutes.CART :(ctx) => const CartPage(),
          AppRoutes.ORDERS :(ctx) => const OrdersPage(),
          AppRoutes.PRODUCTS :(ctx) => const ProductsPage(),
          AppRoutes.PRODUCT_FORM :(ctx) => const ProductFormPage(),
        },
      ),
    );
  }
}
