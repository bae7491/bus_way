import 'package:flutter/material.dart';

class MainPageViewModel with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void resetIndex() {
    _index = 0;
    notifyListeners();
  }

  updateCurrentPage(int index) {
    _index = index;
    notifyListeners();
  }
}
