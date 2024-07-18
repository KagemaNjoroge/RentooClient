import 'package:flutter/material.dart';

import '../utils/notifications.dart';

class NotificationsModal extends StatefulWidget {
  const NotificationsModal({super.key});

  @override
  State<NotificationsModal> createState() => _NotificationsModalState();
}

class _NotificationsModalState extends State<NotificationsModal> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchNotifications(),
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
          List notifications = snapshot.data!['notifications'];
          List<Widget> notifs = [];

          for (var x in notifications) {
            notifs.add(ListTile(
              title: Text(
                x.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(x.message),
                  behavior: SnackBarBehavior.floating,
                  width: 300,
                ));
              },
            ));
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: notifs,
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.dangerous), Text("No notifications")]);
        }
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ],
        );
      },
    );
  }
}
