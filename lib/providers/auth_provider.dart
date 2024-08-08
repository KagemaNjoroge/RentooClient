import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCredentials {
  String? username;
  String? password;
  String? token;
  AuthCredentials({this.password, this.token, this.username});

  AuthCredentials.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() =>
      {"username": username, "password": password, "token": token};
}

class AuthProvider with ChangeNotifier {
  AuthCredentials credentials = AuthCredentials();
  String value = "user";

  Future<AuthCredentials> getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString(value) ?? "");
    return AuthCredentials.fromJson(data);
  }

  Future<bool> removeCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(value);
  }

  Future<void> setCredentials(AuthCredentials credentials) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      value,
      jsonEncode({
        'username': credentials.username,
        'token': credentials.token,
      }),
    );
  }
}
