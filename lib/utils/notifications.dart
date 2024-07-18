import 'package:dio/dio.dart';

import '../models/notification.dart';

const notificationsUrl = "http://localhost:8000/notifications/";

final dio = Dio();

Future<Map<String, dynamic>> fetchNotifications() async {
  final response = await dio.get(notificationsUrl, options: Options());

  if (response.statusCode == 200) {
    var notifications = [];
    for (var prop in response.data) {
      notifications.add(Notifications.fromJson(prop));
    }

    return {
      "status": "success",
      "notifications": notifications,
    };
  } else {
    throw "An error occured";
  }
}
