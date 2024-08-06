import 'package:dio/dio.dart';

Dio dio = Dio();

Future<Map<String, dynamic>> login(
    String url, String username, String password) async {
  try {
    var response =
        await dio.post(url, data: {"username": username, "password": password});
    if (response.statusCode == 200) {
      return {
        "username": response.data['username'],
        "token": response.data['token']
      };
    } else {
      return Future.error("Wrong credentials");
    }
  } catch (e) {
    return Future.error({"error": e.toString()});
  }
}
