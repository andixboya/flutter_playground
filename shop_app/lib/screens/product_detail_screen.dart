import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// dependecy is necessary for Provider!
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    // 185-193) here we take the args from context`s state.
    // it is taken from routing, not from context!
    final productId = ModalRoute.of(context).settings.arguments as String;

    // 193-196) => this is how providr passes context and of differnt type (the generic class is responsible for recognizing it)
    // ***/ 193-196) inside we tell the widget to listen for different state changes! By default its set to true!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
