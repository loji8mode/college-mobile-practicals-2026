import 'package:flutter/material.dart';

import 'editor_screen.dart';

void main() => runApp(const NavigationApp());

class NavigationApp extends StatelessWidget {
  const NavigationApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    home: const EditorScreen(),
  );
}
