import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrightnessProvider with ChangeNotifier {
  bool isDark = false;

  BrightnessProvider() {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  void saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
  }

  void swithTheme() {
    isDark = !isDark;
    saveTheme();
    notifyListeners();
  }
}
