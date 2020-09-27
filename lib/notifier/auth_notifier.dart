import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthNotifier with ChangeNotifier {
  User _user;
  bool _isLoading = false;
  String _error = '';

  User get user => _user;

  bool get isLoading => _isLoading;

  String get error => _error;

  setUser(User user) {
    _user = user;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  setError(String errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }
}
