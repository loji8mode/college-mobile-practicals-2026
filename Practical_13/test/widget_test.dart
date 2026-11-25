import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical13/main.dart';
import 'package:practical13/note.dart';
import 'package:practical13/notes_database.dart';

class MemoryStore implements NotesStore {
  final notes = <Note>[];
  @override
  Future<List<Note>> all() async => notes.reversed.toList();
  @override
  Future<void> add(String text) async {
    notes.add(
      Note(
        id: notes.length + 1,
        text: text.trim(),
        createdAt: DateTime.utc(2026, 11, 24),
      ),
    );
  }
}

void main() {
  testWidgets('Empty and whitespace submissions are not inserted', (
    tester,
  ) async {
    final store = MemoryStore();
    await tester.pumpWidget(NotesApp(store: store));
    await tester.pumpAndSettle();
    expect(find.text('Нотаток ще немає'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '   ');
    await tester.tap(find.text('Додати'));
    await tester.pumpAndSettle();
    expect(find.text('Введіть текст нотатки'), findsOneWidget);
    expect(store.notes, isEmpty);
  });
  testWidgets('Startup load and addition refresh text and date in LIFO', (
    tester,
  ) async {
    final store = MemoryStore();
    await store.add('Old');
    await tester.pumpWidget(NotesApp(store: store));
    await tester.pumpAndSettle();
    expect(find.text('Old'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'New');
    await tester.tap(find.text('Додати'));
    await tester.pumpAndSettle();
    expect(find.text('New'), findsOneWidget);
    expect(
      find.text(DateTime.utc(2026, 11, 24).toLocal().toIso8601String()),
      findsNWidgets(2),
    );
    expect(
      tester.getTopLeft(find.text('New')).dy,
      lessThan(tester.getTopLeft(find.text('Old')).dy),
    );
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller!.text,
      isEmpty,
    );
  });
}
