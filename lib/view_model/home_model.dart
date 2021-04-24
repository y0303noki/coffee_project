import 'package:flutter/material.dart';

class HomeModel extends ChangeNotifier {
  int bottomIndex = 0;
  void refresh() {
    notifyListeners();
  }
}
