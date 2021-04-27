import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

// 257) converted into stateless, as it will change its state?
// its because of the loading icon (during new creation i think?)
// [imp/] 258) at 258 it is converted to stateless widget (some design how to create a screen with a loader .
// (just for the loader maknig it a stateufl is not good , this way its better!))
class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _initialOrdersFetchFuture;

  // 258) here you take it only once, Instead of listening below constantly and then you pass 1 reference, not every single time!
  // kind of like a one time observable, while provider.of is a subject.
  Future _getAllOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    // 258) here in init its fetched and saved as var and passed below , so that it loads only once!
    _initialOrdersFetchFuture = _getAllOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Checking order');

    // 208-214) => here we listen for data Orders.
    // 258) this is deleted and but within the future listener (which is like an init state!)
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),

      // 208-214) => a drawer (side modal) with links , extracted into separate widget, for visibility.
      drawer: AppDrawer(),
      // 258) [imp/] and here the loading is done, while all of the products are loaded from the firebase.
      // important and elegant way to design your code.
      body: FutureBuilder(
        // [258] if nothing else is set, it will trigger infinite loop events (because of the provider listener in the build method!);
        // **** for single state management its good, but in case you have multiple places where this is loaded.
        // It is recommended to do the following: during initialization save the future initially and then  pass it to the listener below.
        //  That way you will take the first initial future and wait for its value, instead of listening constantly!
        //Provider.of<Orders>(context, listen: false).fetchAndSetOrders()

        future: this._initialOrdersFetchFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // error handling
              return Center(
                child: Text('Error occurred'),
              );
            } else {
              // 258) only here is the info listened for (instead of for the rest of the widgets,
              //  remember that from the future above you just listen for info (no changes))
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
