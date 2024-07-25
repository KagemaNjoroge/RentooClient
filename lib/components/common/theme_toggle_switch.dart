import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/brightness.dart';

class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: Provider.of<BrightnessProvider>(context).isDark,
      onChanged: (val) {
        Provider.of<BrightnessProvider>(context, listen: false).swithTheme();
      },
      title: const Text("Switch theme"),
    );
  }
}
