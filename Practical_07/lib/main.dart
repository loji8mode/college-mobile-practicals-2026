import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() => runApp(const AccountApp());

class AccountApp extends StatelessWidget {
  const AccountApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Навчальні екрани',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: const LoginScreen(),
  );
}
