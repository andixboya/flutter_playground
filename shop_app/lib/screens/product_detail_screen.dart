import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// dependecy is necessary for Provider!
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  // through constructor you WOULD change the widget (and re-initialize) it but instead you subscribe for the changes.
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);

  @override
  Widget build(BuildContext context) {
    // 185-193) here we take the args from context`s state.
    // it is taken from routing, not from context!
    final productId = ModalRoute.of(context).settings.arguments as String;

    // 193-196) => this is how providr passes context and of differnt type (the generic class is responsible for recognizing it)
    // ***/ 193-196) inside we tell the widget to listen for different state changes! By default its set to true!
    //  so... this practically... just gets the info, without actually rebuilding anything. (at least up until 199)
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    final previousScrollViewWithSingleChild = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            // 286) linking the 2 images from details and overview so that the transition is a popup effect.
            child: Hero(
              tag: loadedProduct.id,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '\$${loadedProduct.price}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              loadedProduct.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          )
        ],
      ),
    );

    return Scaffold(
        // 287) in case of sliverList appbar is rendudant as it will be taken
        // from the sliverList (it is linked to it)
        // appBar: AppBar(
        //   title: Text(loadedProduct.title),
        // ),
        body: CustomScrollView(
      slivers: <Widget>[
        // 287) this replaces the appbar. and links this bar with the sliverList
        //
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(loadedProduct.title),
            background: Hero(
              tag: loadedProduct.id,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // 287) here the rest of the elements are dispalyed on top of the sliver
        // that is the effect and if you scroll down even further below
        // you will see the rest of the items
        // [imp/] basically linking the Icon and making it background + appbar
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(height: 10),
          Text(
            '\$${loadedProduct.price}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              loadedProduct.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          // 287) this is necessary so that the scrollbar part can be visible
          SizedBox(
            height: 800,
          ),
        ]))
      ],
    ));
  }
}
