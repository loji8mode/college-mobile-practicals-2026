import 'package:flutter/material.dart';

import 'note.dart';
import 'notes_database.dart';
import 'sort_settings.dart';

void main() => runApp(const NotesApp());

class NotesApp extends StatelessWidget {
  const NotesApp({super.key, this.store, this.settings});
  final NotesStore? store;
  final SortSettings? settings;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    home: NotesPage(
      store: store ?? NotesDatabase(),
      settings: settings ?? PreferenceSortSettings(),
    ),
  );
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key, required this.store, required this.settings});
  final NotesStore store;
  final SortSettings settings;
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _form = GlobalKey<FormState>();
  final _text = TextEditingController(), _search = TextEditingController();
  List<Note>? _notes;
  bool _busy = false, _oldestFirst = false;
  String? _error;
  int _request = 0;
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final oldest = await widget.settings.load();
      if (!mounted) return;
      _oldestFirst = oldest;
    } catch (_) {
      if (mounted) _message('Не вдалося прочитати налаштування');
    }
    await _load();
  }

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  Future<void> _load() async {
    final request = ++_request;
    try {
      final notes = await widget.store.all(
        query: _search.text,
        oldestFirst: _oldestFirst,
      );
      if (mounted && request == _request) {
        setState(() {
          _notes = notes;
          _error = null;
        });
      }
    } catch (_) {
      if (mounted && request == _request) {
        setState(() => _error = 'Не вдалося прочитати нотатки');
      }
    }
  }

  Future<void> _mutate(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      await _load();
    } catch (_) {
      if (mounted) _message('Не вдалося зберегти зміни');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _add() async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await _mutate(() async {
      await widget.store.add(_text.text);
      if (mounted) _text.clear();
    });
  }

  Future<void> _edit(Note note) async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => NoteEditor(text: note.text),
    );
    if (text != null && mounted) {
      await _mutate(() => widget.store.update(note.id!, text));
    }
  }

  Future<void> _delete(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Видалити нотатку'),
        content: Text(note.text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Скасувати'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Видалити'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await _mutate(() => widget.store.delete(note.id!));
    }
  }

  Future<void> _sort() async {
    final next = !_oldestFirst;
    await _mutate(() async {
      await widget.settings.save(next);
      if (mounted) _oldestFirst = next;
    });
  }

  @override
  void dispose() {
    _text.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Нотатки SQLite'),
      actions: [
        IconButton(
          tooltip: 'Змінити порядок',
          onPressed: _busy ? null : _sort,
          icon: const Icon(Icons.sort),
        ),
      ],
    ),
    body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
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
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
                    TextField(
                      key: const ValueKey('search'),
                      controller: _search,
                      decoration: const InputDecoration(
                        labelText: 'Пошук нотаток',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _load(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _oldestFirst
                          ? 'Спочатку давніші'
                          : 'Спочатку новіші LIFO',
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_error != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: TextButton(
                  onPressed: _load,
                  child: Text('${_error!}. Повторити'),
                ),
              ),
            )
          else if (_notes == null)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_notes!.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  _search.text.isEmpty
                      ? 'Нотаток ще немає'
                      : 'Нічого не знайдено',
                ),
              ),
            )
          else
            SliverList.builder(
              itemCount: _notes!.length,
              itemBuilder: (_, index) {
                final note = _notes![index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(note.text),
                      subtitle: Text(displayDate(note.createdAt)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            key: ValueKey('edit_${note.id}'),
                            tooltip: 'Редагувати',
                            onPressed: _busy ? null : () => _edit(note),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            key: ValueKey('delete_${note.id}'),
                            tooltip: 'Видалити',
                            onPressed: _busy ? null : () => _delete(note),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
        ],
      ),
    ),
  );
}

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key, required this.text});
  final String text;
  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _text;
  @override
  void initState() {
    super.initState();
    _text = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Редагування нотатки'),
    content: Form(
      key: _form,
      child: TextFormField(
        key: const ValueKey('edit_text'),
        controller: _text,
        autofocus: true,
        minLines: 1,
        maxLines: 4,
        validator: noteValidator,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Скасувати'),
      ),
      FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(context, _text.text.trim());
          }
        },
        child: const Text('Зберегти'),
      ),
    ],
  );
}
