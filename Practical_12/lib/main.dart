import 'package:flutter/material.dart';

import 'api_service.dart';
import 'screens/login_screen.dart';

void main() => runApp(const AccountApp());

class AccountApp extends StatelessWidget {
  const AccountApp({super.key, this.api});
  final AuthApi? api;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Форми й сервер',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: LoginScreen(api: api ?? ApiService()),
  );
}
