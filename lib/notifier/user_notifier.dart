import 'package:flutter/cupertino.dart';
import 'package:hackathon_app/models/user.dart';

class UserNotifier with ChangeNotifier {
  CustomUser _user;

  CustomUser get user => _user;

  setUser(CustomUser user) {
    _user = user;
    notifyListeners();
  }
}
