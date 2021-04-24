import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

import 'package:http/http.dart' as http;

// 193-196) this is like the state providr class, whic need ChangeNotifier
// in order to notify the selected widgets.
// this can by absolutely anything and then you access it
// the type of provider, depends on this mixin!
class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // 193-196) here a collection is passed as a new item, otherwise it will pass the reference and change it directly
  List<Product> get items {
    return [..._items];
  }

// 193-196) the logic is to pass as much logic to the provider as possible and keep the widgets lean and clean.
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

// 204-207) favorites are added here for filter.
  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  // not sure why we left this commented?
  //  as of 240-245) it will be done with query to firbase (not in-memory)
  // void addProduct(Product product) {
  //   final newProduct = Product(
  //     title: product.title,
  //     description: product.description,
  //     price: product.price,
  //     imageUrl: product.imageUrl,
  //     id: DateTime.now().toString(),
  //   );
  //   _items.add(newProduct);
  //   // _items.insert(0, newProduct); // at the start of the list
  //   notifyListeners();
  // }

  Future<void> addProduct(Product product) async {
    // 240-245) here , instead of string, it is necessary to insert a uri object!
    // const url = 'https://flutter-update.firebaseio.com/products.json';
    // [imp/] first arg is the base, second is the url, add json always, its fire base specific!
    final url = Uri.https(
        'flutter-shop-app-6b626-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.post(url,
          // 240-245) data.convert library is used to convert the object into string format and vise versa!
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      // 240-245) => here the in-memory is still used, probably the db will be used for load of products as well!
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (err) {
      // 246) throwing erors and handling them (in case sth. goes wrong with the http call.)
      // 247) in 246 it was with catchError, but this is WAAAY more readible!

      print(err);
      throw err;
    }
  }

  // 232-233) update of products logic (here in state)
  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

// 233) delete of products logic (here in state)
  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
