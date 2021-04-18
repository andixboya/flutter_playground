import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // [imp/] 193-196) this is how the provider is accessed! With the generic class, you access it as a <generic> type.
    // and it is the only one that gets rebuilt.
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,

      //[imp/] 200-203)  this though is now a bit unclear, where do we add these so that the rest can get notifications?
      //answer(but not sure) (they need to be above the children, who listen i think?)
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          //[imp/] 197) here you pass the nested PROVIDER MODEL!
          // with this, you spread the change for such models ( you emit the changes, so to speak)
          value: products[i],
          // 197) [IMP/] if you are using providers pattern, you won`t need ANY of these!!!! no constructors!
          child: ProductItem(
              // products[i].id,
              // products[i].title,
              // products[i].imageUrl,
              )),

      // 185-193)  important part of gridView with configs, which I need to read in the doc.
      //  How each element should be positioned, within the grid I think

      // [imp/] 196-199) because of providerOf for example, this widget will be rebuilt only, but the rest
      // will get rebuilt ONLY if you need (or at least that`s how I understood)
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
