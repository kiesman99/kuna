import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PageProvider with ChangeNotifier {
  ValueNotifier<bool> gridView = new ValueNotifier(true);

  void switchView() {
    gridView.value = !gridView.value;
    notifyListeners();
  }
}
