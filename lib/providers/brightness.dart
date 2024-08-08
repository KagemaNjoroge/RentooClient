import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrightnessProvider with ChangeNotifier {
  bool isDark = false;
  String value = "isDark";

  BrightnessProvider() {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool(value) ?? false;
    notifyListeners();
  }

  void saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(value, isDark);
  }

  Future<void> removeThemeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(value);
  }

  void swithTheme() {
    isDark = !isDark;
    saveTheme();
    notifyListeners();
  }
}
