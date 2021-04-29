import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

// 266) notifier which should be included on top most level.
class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  // 269) token validation, once its taken.
  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

// 267) sign in url => https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]

// 266) signup func
  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  // 267) login func
  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

// 267) abstraction is extracted for readability
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBSaZoD22qHqAcpCDMUEPh_n7oeZl0vBTM');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      // 268) error handling here.
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      // 269) here the token info is distributed form a successful login. Check docs what each prop from the token is.
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      // 269) once the data is loaded successfully , the widgets are signaled to refresh
      // (with consumer on materialApp() main widget)
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
