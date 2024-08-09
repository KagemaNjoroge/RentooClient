import 'package:flutter/material.dart';

import '../../constants.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator.adaptive(
      backgroundColor: kPrimaryColor,
    );
  }
}
