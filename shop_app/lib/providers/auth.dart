import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

// 266) notifier which should be included on top most level.
class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  // 276) timer is something like setTimeout, it will be used for auto logout!
  Timer _authTimer;

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
      // 276) timer needs to start ticking out here!
      _autoLogout();
      // 269) once the data is loaded successfully , the widgets are signaled to refresh
      // (with consumer on materialApp() main widget)

    //278) here the data needs to be written, silly!
    final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);


      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

// 275) logout func: simply delete the token from the service.
  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    // 267)it should be cancelled on logout
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  // 276) autLogout execution, once you logiin, it should start ticking
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    // it works!
    // like setTimeOut, it just removes/deletes the cookies and that`s it.
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

// 277) auto_login implementation (with the help of device storage)
  Future<bool> tryAutoLogin() async {
    // 277) its accessed from shared preferences and is future , so you should await it
    // otherwise it would not be executed.
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    // 277) here in case its expired it should not be extracted.
    // should it not be nullified?
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    // 277) if all cases are successful, then they will be loaded within the memory of the app.
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
}
