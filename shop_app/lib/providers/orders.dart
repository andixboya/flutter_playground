import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// 208-214) => DTO class.
class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  // 271) adding the token through consumer from outside.
  Orders(this.authToken, this._orders);

  final String authToken;
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  // 208-214) => logic for order creation
  // as of 256) its stored in firebase.
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
        'flutter-shop-app-6b626-default-rtdb.firebaseio.com', '/orders.json',
        // 271) adding token
        {'auth': authToken});
    final timestamp = DateTime.now();

    // 256) creation of the model, too tired to think on that...
    // 256) could be done with Model.asjsoon()
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

// 257) orders will be fetched from firebase as well
  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
        'flutter-shop-app-6b626-default-rtdb.firebaseio.com', '/orders.json',
        // 271) adding token.
        {'auth': authToken});
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          // 257) again here, it could be loaded with json model map.
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
