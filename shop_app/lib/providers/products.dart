import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';

// 193-196) this is like the state providr class, whic need ChangeNotifier 
// in order to notify the selected widgets.
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

  // not sure why we left this commented?
  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }
}
