import 'package:flutter/material.dart';

import '../models/company.dart';

class CompanyProvider with ChangeNotifier {
  Company company =
      Company(email: "", id: 1, logo: "", name: "", phone: "", website: "");

  void setCompany(Company comp) {
    company = comp;
    notifyListeners();
  }
}
