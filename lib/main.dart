import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'pages/home.dart';
import 'providers/brightness.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BrightnessProvider>(
      create: (_) => BrightnessProvider(),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            colorSchemeSeed: kPrimaryColor,
            useMaterial3: true,
            brightness: Provider.of<BrightnessProvider>(context).isDark
                ? Brightness.dark
                : Brightness.light,
          ),
          debugShowCheckedModeBanner: false,
          home: const Home(),
        );
      },
    );
  }
}