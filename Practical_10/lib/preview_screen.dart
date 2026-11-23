import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({
    super.key,
    required this.text,
    required this.size,
    required this.color,
  });
  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Попередній перегляд')),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Text(
                  text,
                  key: const ValueKey('preview-text'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: size, color: color),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Ok'),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
