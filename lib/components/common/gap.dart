import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20);
  }
}

class HorizontalGap extends StatelessWidget {
  const HorizontalGap({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 10,
    );
  }
}
