import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:practical13/note.dart';
import 'package:practical13/notes_database.dart';

void main() {
  sqfliteFfiInit();
  test('Model round trip preserves UTC microseconds and text', () {
    final note = Note(
      id: 3,
      text: 'Нотатка',
      createdAt: DateTime.utc(2026, 11, 24, 1, 2, 3, 4, 5),
    );
    final copy = Note.fromMap(note.toMap());
    expect(copy.id, 3);
    expect(copy.text, note.text);
    expect(copy.createdAt, note.createdAt);
  });
  test('Validation rejects whitespace', () {
    expect(noteValidator('   '), isNotNull);
    expect(noteValidator(' текст '), isNull);
  });
  late Directory folder;
  late NotesDatabase repo;
  setUp(() async {
    folder = await Directory.systemTemp.createTemp('practical13-test-');
    repo = NotesDatabase(
      factory: databaseFactoryFfi,
      file: '${folder.path}/notes.db',
      now: () => DateTime.utc(2026, 11, 24),
    );
  });
  tearDown(() async {
    await repo.close();
    await folder.delete(recursive: true);
  });
  test('Actual SQLite inserts trimmed text and deterministic LIFO', () async {
    await repo.add(' first ');
    await repo.add("O'Brien");
    final notes = await repo.all();
    expect(notes.map((n) => n.text).toList(), ["O'Brien", 'first']);
    expect(notes.first.id, 2);
  });
  test('Repository rejects empty notes without insertion', () async {
    await expectLater(repo.add('   '), throwsArgumentError);
    expect(await repo.all(), isEmpty);
  });
  test('SQLite file survives close and reopen', () async {
    await repo.add('persistent');
    await repo.close();
    final again = NotesDatabase(
      factory: databaseFactoryFfi,
      file: '${folder.path}/notes.db',
    );
    try {
      expect((await again.all()).single.text, 'persistent');
    } finally {
      await again.close();
    }
  });
}
