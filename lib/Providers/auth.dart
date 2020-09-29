import 'dart:async';
import 'dart:convert';

import 'package:MyShop/Models/http-exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _timerLogout;

  bool get isAuthenticated {
    return _token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) return _token;
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBsidl6TPrf0iWrUlKO-FlYp7h0WooKBow";
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
      final extractedData = json.decode(response.body);
      if (extractedData['error'] != null) {
        throw HttpException(extractedData['error']['message']);
      }
      _token = extractedData['idToken'];
      _userId = extractedData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(extractedData['expiresIn']),
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expireDate': _expireDate.toIso8601String(),
        },
      );
      prefs.setString("userData", userData);
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email.trim(), password, "signUp");
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email.trim(), password, "signInWithPassword");
  }

  void logOut() async {
    _token = null;
    _expireDate = null;
    _userId = null;
    if (_timerLogout != null) {
      _timerLogout.cancel();
      _timerLogout = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    print(_expireDate.toIso8601String());
    if (_timerLogout != null) {
      _timerLogout.cancel();
    }
    final secontLogout = _expireDate.difference(DateTime.now()).inSeconds;
    _timerLogout = Timer(Duration(seconds: secontLogout), logOut);
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final userData = json.decode(prefs.get('userData')) as Map<String, Object>;
    final expireDate = DateTime.parse(userData['expireDate']);
    if (expireDate.isBefore(DateTime.now())) return false;
    _token = userData['token'];
    _expireDate = expireDate;
    _userId = userData['userId'];
    notifyListeners();
    _autoLogout();
    return true;
  }
}
