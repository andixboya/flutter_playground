import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

// 200-203) this widget is turned into stateful, rather than stateless + provider
class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // 185-193) initial context.
  // final List<Product> loadedProducts = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];
  
  
  var _showOnlyFavorites = false;
  // 248-249) both props are used for spinner display, while waiting for data to be fetched.
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // 248-249) didChange method will be used to initialize the collection data.
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

// 248-249) used for initialization of the products, instead of in-memory dependency.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        // 200-203 actions were added :
        // one for drop_down menu
        // another for re-direction to cart, which will be done later on.
        actions: <Widget>[
          // 200-203) [imp/] dropdown !
          PopupMenuButton(
            // 200-203) with this you change the icon to selected favourite or not
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: const Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          // 200-203) here it listens for changes in the object, and rebuilds the count, in case some are added.
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                // 204-207) a redirect to cartScreen is added.
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      // 248-249) loader widget is used while waiting for data fetch.
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          // 204-207) favorites are added here for filter.
          : ProductsGrid(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }
}
