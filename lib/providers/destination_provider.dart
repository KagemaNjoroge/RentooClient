import 'package:flutter/material.dart';

class DestinationProvider with ChangeNotifier {
  int destination = 0;
  dynamic data_ = 0;
  void changeDestination(int dest) {
    destination = dest;
    notifyListeners();
  }

  void setData(dynamic data) {
    data_ = data;
    notifyListeners();
  }
}
