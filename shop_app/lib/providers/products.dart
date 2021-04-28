import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';

import 'package:http/http.dart' as http;

// 193-196) this is like the state providr class, whic need ChangeNotifier
// in order to notify the selected widgets.
// this can by absolutely anything and then you access it
// the type of provider, depends on this mixin!
class Products with ChangeNotifier {
  final String authToken;

  //270) from now on since every provdier/service will need the token to make proper requests,
  // they will be added/injected through the constructor and
  // they will be re-built every single time the auth is rebuilt.
  // remember to add the auth token (in our case to url) for each request, so that the api is accessible!
  // also the previous state must be kept, so the main state that is kept in this 'provider/service' must be re-initializezd.

  Products(this.authToken, this._items);

  // 248-249) from here onwards, the items will be loaded from fireBase with fetchAndSet method.
  List<Product> _items = [];
  //  [
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

  // 248-249) data fetching, I wonder if I change the model, will it map it , itself?)
  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        'flutter-shop-app-6b626-default-rtdb.firebaseio.com',
        //  270) here the token is added the access token is accessed through access_token not auth like in the vid.
        // finally done!
        '/products.json',
        {'auth': authToken});
    try {
      final response = await http.get(url);
      // 248-249) this should be tested, wether it works, or not? OKay, its not working...

      final extractedMap = json.decode(response.body);
      final List<Product> loadedProducts = [];
      extractedMap.forEach((prodId, prodData) {
        loadedProducts.add(
            // 248-249) this... should work , I think? , instead of the below, manual mapping?
            // Product.fromJson(prodData) (this causes some display error of pixels overflow, but... why!?)
            Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // 232-233) update of products logic (here in state)
  // 252) update product. is now done through http.
  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https(
          'flutter-shop-app-6b626-default-rtdb.firebaseio.com',
          '/products.json/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

// 233) delete of products logic (here in state)
  // void deleteProduct(String id) {
  //   _items.removeWhere((prod) => prod.id == id);
  //   notifyListeners();
  // }

  // 252) void deletet is async as well!
  Future<void> deleteProduct(String id) async {
    final url = Uri.https('flutter-shop-app-6b626-default-rtdb.firebaseio.com',
        '/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
