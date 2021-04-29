import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  // 250) reload of the products , used once listViewWidget starts listening to the scroll changes.
  Future<void> _refreshProducts(BuildContext context) async {
    // [BUG/] lol, the return... was... holy moly.. so bad...
    //  I wonder why the compiler... did not pick this up though!?
    await Provider.of<Products>(context, listen: false)
        // 273) here the products will be refreshed and filtered, accoridng to the user
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // 219-220) subscription for products for context
    //  you could isolate it with consumer to just the appDrawer
    // 273) this needs to be commented, futreBUild will be used instead for initial state reload!
    // final productsData = Provider.of<Products>(context);
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

      // 273) future builder is also used to initialize the values properly
      // but you need to comment above the prvoider within the builder, otherwise
      // it would cause infinite loop of re-building.
      body: FutureBuilder(
        // 273) forgot to attach the listener for the intiial creation!
        future: _refreshProducts(context),
        // 273) also, depending on the state it will display reload icon.
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            // 273) consumer is used, to isolate the re-building on data change.
            : Consumer<Products>(
                builder: (ctx, productsData, _) =>
                    // 250) widget, which is kind of like inkwell and listens for rebuilt changes
                    // and each time a scroll is triggered it triggers the listening func
                    RefreshIndicator(
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
                ),
              ),
      ),
    );
  }
}
