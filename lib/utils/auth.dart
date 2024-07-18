import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String username;
  String? password;

  // will be set after login, returned by the server
  String? accessToken;

  User({
    required this.username,
    this.password,
    this.accessToken,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      accessToken: json['access_token'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'access_token': accessToken,
    };
  }
}

// Utility class for handling storage and access of the user data from shared preferences

class UserPreferences {
  static const myUser = 'user';
  static Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(
        myUser,
        jsonEncode({
          'username': user.username,
          'access_token': user.accessToken,
        }));
  }

  static Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return User.fromJson(jsonDecode(prefs.getString(myUser)!));
  }

  static Future<bool> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(myUser);
  }
}
