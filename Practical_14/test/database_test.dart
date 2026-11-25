import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:practical14/note.dart';
import 'package:practical14/notes_database.dart';

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
    folder = await Directory.systemTemp.createTemp('practical14-test-');
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
  test(
    'Update preserves id and creation time, delete selects one id',
    () async {
      await repo.add('first');
      await repo.add('second');
      final before = await repo.all();
      await repo.update(before.first.id!, "O'Brien edited");
      final updated = (await repo.all()).first;
      expect(updated.id, before.first.id);
      expect(updated.createdAt, before.first.createdAt);
      expect(updated.text, "O'Brien edited");
      await repo.delete(before.first.id!);
      expect((await repo.all()).single.text, 'first');
    },
  );
  test('LIKE treats quote wildcard and injection input as data', () async {
    await repo.add("O'Brien 100%_@");
    await repo.add('other');
    expect((await repo.all(query: "O'Brien")).length, 1);
    for (final query in ['%', '_', '@']) {
      expect((await repo.all(query: query)).length, 1);
    }
    expect(await repo.all(query: "' OR 1=1 --"), isEmpty);
    expect((await repo.all()).length, 2);
  });
  test('Sort flag changes order and blank update is rejected', () async {
    await repo.add('first');
    await repo.add('second');
    expect((await repo.all(oldestFirst: true)).map((n) => n.text), [
      'first',
      'second',
    ]);
    await expectLater(repo.update(1, '   '), throwsArgumentError);
    expect((await repo.all()).last.text, 'first');
  });
}
