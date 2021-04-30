import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // 197) [IMP/] if you are using providers pattern, you won`t need ANY of these!!!! no constructors!
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    // 196-199) => here we can extract the info, and use CONSUMER to LOCALLY reload widgets which are on this level!
    //[imp/] and that way the need for properties from above is eliminated and is kept within the model itself, (it gets leaner!)
    final product = Provider.of<Product>(context, listen: false);
    // 271) adding listener to extractt info from auth, but no reload is necessary!
    final authData = Provider.of<Auth>(context, listen: false);

    // 200-203) here subscription for cart is added, because it is necessary to know
    final cart = Provider.of<Cart>(context, listen: false);
    // 185-193) => used to clip (round) the edges of the rectangular
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      // 185-193) => nice looking tile widget (like listViewTile), but specifically for girdView
      child: GridTile(
        // 185-193) => wrapper for eventListener!
        child: GestureDetector(
          onTap: () {
            // this should probably be replacedNamed but w.e.
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              // 192-193) => here we pass arguments , istead of adding them to constructor (as direct link.)
              arguments: product.id,
            );
          },

          // 285) placeholder is shown and then the actual photo is displayed with some smooth
          // fadeIn effect.
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),

          //  Image.network(
          //   product.imageUrl,
          //   // 185-193)=> important as it resizes the image to fit the whole container.
          //   fit: BoxFit.cover,
        ),
        //185-193) => also nice feature of the GridTile component!

        footer: GridTileBar(
          backgroundColor: Colors.black87,
          //185-193) => actionBar (or action) on the left side

          // 196-199) with consumer, you can isolate the rebuild to be applied for specific widgets that need the change notification.
          // ctx (not sure if we need, product is the new subscribed product change, while child is something you defined which WILL NOT BE REBUILT
          // and you can put it within consumer, to isolate change AGAIN optimization!)
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                // 204-207) here i`ve forgotten to add the actual action...
                // 255) interesting, but it does not need to be returned or anything..., actually it just needs to be executed i guess?
                product.toggleFavoriteStatus(authData.token, authData.userId);
              },
            ),
          ),
          //185-193) => text in the middle of the action.
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          //185-193) => actionBar (or action) on the right side
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            // 200-203) here the state is linked with that of the cart ,
            // otherwise we would have to drag all of the propreties through constructors and widgets and they all would have to rebuild.
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);

              // 216) both accessible from context,
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              // 216) creates a popup which can be used for manipulation/cancellation (just this example)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'Added item to cart!',
                ),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
            //185-193) => theme consumtion of the action.
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
