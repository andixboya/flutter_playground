import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
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
        // 266) added emitter
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // *** 270) [imp/] really vital part, how to mix providers states and then rebuilt them one by one!
        // its generic and you can point the 'provider provider' and  the receiving one,
        //  otherwise they would be left out dynamic and it would be treated as object
        ChangeNotifierProxyProvider<Auth, Products>(
          // in previous patches builder was used instead of update.
          builder: null,
          update: (ctx, auth, prevProducts) => Products(
              auth.token,
              auth.userId,
              // 270) also here the intial state is null, so a check is necessary!
              prevProducts == null ? [] : prevProducts.items),
          create: null,
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // 208-214) => and we provide possibility for listening of context related to orders.
        // 271) addition of auth dep. so orders get the token.
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: null,
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                // 275) userId is added for orders separation.
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders))
      ],
      // 269) listener is added here for the changes within auth. so that this app is guarded and rebuilt
      // because otherwise the resources would never be loaded and it would be stuck on reload screen.
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            // 185-193) => check the theme stuff again.
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              // 290) this is necessary for setting up the custom router ,
              //  instead of the built in one.
              // [imp/] also it is optional that you choose different
              // custom routers according to different platforms!
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }),
              fontFamily: 'Lato',
            ),
            // as if 264) home is switched to auth (which will grant authorization!)
            // [imp/] 269) here a check is added, if the user is auth. he will be redirected to normal screen, otherwise to login!

            // logic: if user is authenticated, go to starting page, otherwise make and attempt with futureBuilder (init state)
            // and check if there are any credentials to take from the device`s memory and if there is none, then just
            // load auth screen and use splashScreen while waiting/loading or checking for the info within the device`s storage!
            home: auth.isAuth
                ? ProductsOverviewScreen()
                // [imp/] 277) here it will make an attempt to login automatically with another futureBuilder check (init)
                // a second ternary operator (ugly buy does the trick).

                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
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
      ),
    );
  }
}
