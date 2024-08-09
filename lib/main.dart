import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/common/progress_indicator.dart';
import 'constants.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'providers/auth_provider.dart';
import 'providers/brightness.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
// inject credentials provider
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      // inject brightness provider for toggling between light and dark modes
      builder: (_, child) => ChangeNotifierProvider<BrightnessProvider>(
        create: (_) => BrightnessProvider(),
        builder: (context, child) {
          return FutureBuilder(
            future: Provider.of<AuthProvider>(context, listen: false)
                .getCredentials(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return MaterialApp(
                  home: const LoginPage(),
                  theme: ThemeData(
                    colorSchemeSeed: kPrimaryColor,
                    useMaterial3: true,
                    brightness: Provider.of<BrightnessProvider>(context).isDark
                        ? Brightness.dark
                        : Brightness.light,
                  ),
                  debugShowCheckedModeBanner: false,
                  title: applicationName,
                );
              }
              if (!snapshot.hasError &&
                  snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                AuthCredentials? credentials = snapshot.data;
                if (credentials != null && credentials.token != null) {
                  return MaterialApp(
                    theme: ThemeData(
                      colorSchemeSeed: kPrimaryColor,
                      useMaterial3: true,
                      brightness:
                          Provider.of<BrightnessProvider>(context).isDark
                              ? Brightness.dark
                              : Brightness.light,
                    ),
                    debugShowCheckedModeBanner: false,
                    title: applicationName,
                    home: const Home(),
                  );
                } else {
                  return MaterialApp(
                    home: const LoginPage(),
                    theme: ThemeData(
                      colorSchemeSeed: kPrimaryColor,
                      useMaterial3: true,
                      brightness:
                          Provider.of<BrightnessProvider>(context).isDark
                              ? Brightness.dark
                              : Brightness.light,
                    ),
                    debugShowCheckedModeBanner: false,
                    title: applicationName,
                  );
                }
              }
              return const Center(child: CustomProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
