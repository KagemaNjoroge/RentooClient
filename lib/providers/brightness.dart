import 'package:flutter/material.dart';

class BrightnessProvider with ChangeNotifier {
  bool isDark = false;

  void swithTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
