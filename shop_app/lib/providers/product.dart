import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  // 255) the status is changed in firebase with http
  // void toggleFavoriteStatus() {
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  // }
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

// 255) the status is changed in firebase with http
  // 272) userId is added, so the fav. is kept in a separate collection for each user!
  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.https(
        'flutter-shop-app-6b626-default-rtdb.firebaseio.com',
        // 272) userId is added, so the fav. is kept in a separate collection for each user!
        '/userFavorites/$userId/$id.json',
        // 271) adding token
        {'auth': authToken});
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
