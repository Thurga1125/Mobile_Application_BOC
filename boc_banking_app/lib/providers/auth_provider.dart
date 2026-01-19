import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  String get userName => _userName ?? 'User';

  void login(String name) {
    _isAuthenticated = true;
    _userName = name;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _userName = null;
    notifyListeners();
  }
}
