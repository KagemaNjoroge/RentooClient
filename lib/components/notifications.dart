import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/notification.dart';
import '../sdk/notifications.dart';
import '../utils/snack.dart';
import 'common/progress_indicator.dart';

class NotificationsModal extends StatefulWidget {
  const NotificationsModal({super.key});

  @override
  State<NotificationsModal> createState() => _NotificationsModalState();
}

class _NotificationsModalState extends State<NotificationsModal> {
  final NotificationsAPI _notificationsAPI = NotificationsAPI();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _notificationsAPI.get(notificationsUrl),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.dangerous),
              Text("An error occurred"),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<Notifications> notifications = snapshot.data!['notifications'];
          List<Widget> notifs = [];

          if (notifications.isEmpty) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text("You are all caught up!"),
                ),
              ],
            );
          }

          for (var x in notifications) {
            notifs.add(ListTile(
              title: Text(
                x.title ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                showSnackBar(context, Colors.green, x.message ?? '', 400);
              },
            ));
          }
          return SingleChildScrollView(
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: notifs,
              ),
            ),
          );
        }
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: CustomProgressIndicator(),
            ),
          ],
        );
      },
    );
  }
}
