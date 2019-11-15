import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  String _email;
  DateTime _expireDate;
  Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get email {
    return _email;
  }

  Future<void> _authenticate(
      {String email, String password, String urlSegment}) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyD0VjDj5u2398_oYXMovru8KQGg_2Yhmt8';

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

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      _email = email;
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      //print(_token);
      _autoLogout();

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expireDate': _expireDate.toIso8601String(),
          'email': _email,
        },
      );

      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: 'signupNewUser',
    );
  }

  Future<void> login(String email, String password) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: 'verifyPassword',
    );
  }

  
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      //print('no user data');
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expireDate = DateTime.parse(extractedUserData['expireDate']);

    if (expireDate.isBefore(DateTime.now())) {
      //print('token expired');

      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireDate = expireDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
     prefs.remove('userData');
    //prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }


}
