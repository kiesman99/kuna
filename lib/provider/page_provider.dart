import 'package:flutter/material.dart';

class PageProvider with ChangeNotifier {
  bool _gridView = true;

  bool get gridView => _gridView;

  void switchView() {
    _gridView = !gridView;
    notifyListeners();
  }
}
