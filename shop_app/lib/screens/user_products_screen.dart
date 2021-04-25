import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    // 219-220) subscription for products for context
    //  you could isolate it with consumer to just the appDrawer
    final productsData = Provider.of<Products>(context);

// 250) reload of the products , used once listViewWidget starts listening to the scroll changes.
    Future<void> _refreshProducts(BuildContext context) async {
      // [BUG/] lol, the return... was... holy moly.. so bad...
      //  I wonder why the compiler... did not pick this up though!?
       await Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),

          // 219-220) option for addition, which will be later filled.
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // 221-223) => added so it can be re-routed to edit ( edit will be both add/edit, because our item is simple)
                // yup.
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
          ],
        ),
        // 219-220) appDrawer is included so navigation to other options is available.
        drawer: AppDrawer(),
        // 250) widget, which is kind of like inkwell and listens for rebuilt changes
        // and each time a scroll is triggered it triggers the listening func
        body: RefreshIndicator(
          // 250)  must return a Future!
          onRefresh: () => _refreshProducts(context),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  // 219-220) and each userProduct is a listTile row
                  UserProductItem(
                    // 232-233) => id is added to the model filling.
                    productsData.items[i].id,
                    productsData.items[i].title,
                    productsData.items[i].imageUrl,
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ));
  }
}
