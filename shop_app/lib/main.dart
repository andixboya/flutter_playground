import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import 'providers/orders.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // [imp/] 193-196) **** here it is important to add the StateListener
    // ( position it on top level, so it has access to the children that you need!)
    // the new syntax is used with create, since the provider is v.5
    return
        // 197) the below is an alternative syntax
        // ChangeNotifierProvider.value(value: Products, child: null,})
        // [IMP/] USE BUILDER FOR INSTANCES!!
        MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // 208-214) => and we provide possibility for listening of context related to orders.
        ChangeNotifierProvider.value(
          value: Orders(),
        )
      ],
      child: MaterialApp(
          title: 'MyShop',
          // 185-193) => check the theme stuff again.
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            // 205-207) the route is added for cart.
            CartScreen.routeName: (ctx) => CartScreen(),
            // 208-214) =>  route for orderScreen
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            // 219-220) => inclusion route for ... UserProductScrren 
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),

            //221-223) => route added when we click add new product ( it will pop it)
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          }),
    );
  }
}
