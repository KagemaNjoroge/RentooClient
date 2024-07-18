import 'package:flutter/material.dart';

void showSnackBar(
    BuildContext context, Color color, String message, double width) {
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      width: width,
    ),
  );
}
