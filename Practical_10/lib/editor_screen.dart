import 'package:flutter/material.dart';

import 'preview_screen.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _text = TextEditingController(text: 'Вітаю, Flutter!');
  double _fontSize = 24;
  Color _color = Colors.indigo;
  static final _colors = {
    Colors.indigo: 'Синій',
    Colors.red: 'Червоний',
    Colors.teal: 'Зелений',
  };

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _showPreview() async {
    FocusScope.of(context).unfocus();
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewScreen(
          text: _text.text,
          size: _fontSize,
          color: _color,
        ),
      ),
    );
    if (!mounted) return;
    final message = switch (result) {
      true => 'Cool!',
      false => 'Let’s try something else',
      null => "Don't know what to say",
    };
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Редактор тексту')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const ValueKey('text-input'),
              controller: _text,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Текст для перегляду',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Text('Розмір: $_fontSize'),
            Slider(
              key: const ValueKey('font-size'),
              value: _fontSize,
              min: 12,
              max: 60,
              divisions: 48,
              label: _fontSize.toStringAsFixed(0),
              onChanged: (v) => setState(() => _fontSize = v),
            ),
            const Text('Колір тексту'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colors.entries
                  .map(
                    (entry) => ChoiceChip(
                      label: Text(entry.value),
                      avatar: Icon(Icons.circle, color: entry.key),
                      selected: _color == entry.key,
                      onSelected: (_) =>
                          setState(() => _color = entry.key),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showPreview,
              child: const Text('Переглянути'),
            ),
          ],
        ),
      ),
    ),
  );
}
