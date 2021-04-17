import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    
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
              arguments: id,
            );
          },
          
          child: Image.network(
            imageUrl,
            // 185-193)=> important as it resizes the image to fit the whole container.
            fit: BoxFit.cover,
          ),
        ),
        //185-193) => also nice feature of the GridTile component!
        
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          //185-193) => actionBar (or action) on the left side 
          leading: IconButton(
            icon: Icon(Icons.favorite),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
          //185-193) => text in the middle of the action.
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          //185-193) => actionBar (or action) on the right side 
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {},
          //185-193) => theme consumtion of the action.
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
