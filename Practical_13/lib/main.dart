import 'package:flutter/material.dart';

import 'note.dart';
import 'notes_database.dart';

void main() => runApp(const NotesApp());

class NotesApp extends StatelessWidget {
  const NotesApp({super.key, this.store});
  final NotesStore? store;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    home: NotesPage(store: store ?? NotesDatabase()),
  );
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key, required this.store});
  final NotesStore store;
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _form = GlobalKey<FormState>();
  final _text = TextEditingController();
  List<Note>? _notes;
  bool _busy = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final notes = await widget.store.all();
      if (mounted) {
        setState(() {
          _notes = notes;
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Не вдалося прочитати нотатки');
    }
  }

  Future<void> _add() async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    try {
      await widget.store.add(_text.text);
      _text.clear();
      await _load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не вдалося зберегти нотатку')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Нотатки SQLite')),
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: const ValueKey('note'),
                    controller: _text,
                    enabled: !_busy,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Текст нотатки',
                      border: OutlineInputBorder(),
                    ),
                    validator: noteValidator,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _busy ? null : _add,
                    child: _busy
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Додати'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!),
                        TextButton(
                          onPressed: _load,
                          child: const Text('Повторити'),
                        ),
                      ],
                    ),
                  )
                : _notes == null
                ? const Center(child: CircularProgressIndicator())
                : _notes!.isEmpty
                ? const Center(child: Text('Нотаток ще немає'))
                : ListView.separated(
                    itemCount: _notes!.length,
                    separatorBuilder: (_, index) => const Divider(),
                    itemBuilder: (_, index) {
                      final note = _notes![index];
                      return ListTile(
                        title: Text(note.text),
                        subtitle: Text(
                          note.createdAt.toLocal().toIso8601String(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
  );
}
