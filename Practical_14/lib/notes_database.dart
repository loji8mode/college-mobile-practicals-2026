import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'note.dart';

abstract class NotesStore {
  Future<void> add(String text);
  Future<List<Note>> all({String query = '', bool oldestFirst = false});
  Future<void> update(int id, String text);
  Future<void> delete(int id);
}

class NotesDatabase implements NotesStore {
  NotesDatabase({DatabaseFactory? factory, this.file, DateTime Function()? now})
    : _factory = factory ?? databaseFactory,
      _now = now ?? DateTime.now;
  final DatabaseFactory _factory;
  final String? file;
  final DateTime Function() _now;
  Future<Database>? _opening;
  Future<Database> get database => _opening ??= _open();
  Future<Database> _open() async => _factory.openDatabase(
    file ?? join(await _factory.getDatabasesPath(), 'notes.db'),
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT NOT NULL CHECK(length(trim(text)) > 0), created_at INTEGER NOT NULL)',
      ),
    ),
  );
  @override
  Future<void> add(String text) async {
    if (noteValidator(text) != null) throw ArgumentError('Empty note');
    final db = await database;
    await db.insert(
      'notes',
      Note(text: text.trim(), createdAt: _now()).toMap(),
    );
  }

  @override
  Future<List<Note>> all({String query = '', bool oldestFirst = false}) async {
    final db = await database;
    final escaped = query
        .replaceAll('@', '@@')
        .replaceAll('%', '@%')
        .replaceAll('_', '@_');
    final rows = await db.query(
      'notes',
      where: query.isEmpty ? null : "text LIKE ? ESCAPE '@'",
      whereArgs: query.isEmpty ? null : ['%$escaped%'],
      orderBy: oldestFirst
          ? 'created_at ASC, id ASC'
          : 'created_at DESC, id DESC',
    );
    return rows.map(Note.fromMap).toList();
  }

  @override
  Future<void> update(int id, String text) async {
    if (noteValidator(text) != null) throw ArgumentError('Empty note');
    final db = await database;
    await db.update(
      'notes',
      {'text': text.trim()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final opening = _opening;
    if (opening != null) {
      await (await opening).close();
      _opening = null;
    }
  }
}
