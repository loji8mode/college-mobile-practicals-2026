import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical14/main.dart';
import 'package:practical14/note.dart';
import 'package:practical14/notes_database.dart';
import 'package:practical14/sort_settings.dart';

class MemoryStore implements NotesStore {
  final notes = <Note>[];
  int next = 0;
  @override
  Future<List<Note>> all({String query = '', bool oldestFirst = false}) async {
    final found = notes.where((n) => n.text.contains(query)).toList();
    return oldestFirst ? found : found.reversed.toList();
  }

  @override
  Future<void> add(String text) async {
    notes.add(
      Note(
        id: ++next,
        text: text.trim(),
        createdAt: DateTime(2026, 11, 25, 10, 5),
      ),
    );
  }

  @override
  Future<void> update(int id, String text) async {
    final i = notes.indexWhere((n) => n.id == id);
    notes[i] = Note(id: id, text: text, createdAt: notes[i].createdAt);
  }

  @override
  Future<void> delete(int id) async {
    notes.removeWhere((n) => n.id == id);
  }
}

class MemorySettings implements SortSettings {
  bool value = false;
  @override
  Future<bool> load() async => value;
  @override
  Future<void> save(bool oldestFirst) async {
    value = oldestFirst;
  }
}

void main() {
  test('Friendly local date format', () {
    expect(displayDate(DateTime(2026, 11, 25, 10, 5)), '25.11.2026 10:05');
  });
  testWidgets('Empty form and empty database state', (tester) async {
    final store = MemoryStore();
    await tester.pumpWidget(NotesApp(store: store, settings: MemorySettings()));
    await tester.pumpAndSettle();
    expect(find.text('Нотаток ще немає'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('note')), '   ');
    await tester.tap(find.text('Додати'));
    await tester.pumpAndSettle();
    expect(find.text('Введіть текст нотатки'), findsOneWidget);
    expect(store.notes, isEmpty);
  });
  testWidgets('Add search edit validation and confirmed delete', (
    tester,
  ) async {
    final store = MemoryStore();
    await store.add('Old');
    await tester.pumpWidget(NotesApp(store: store, settings: MemorySettings()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('note')), 'New');
    await tester.tap(find.text('Додати'));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('New')).dy,
      lessThan(tester.getTopLeft(find.text('Old')).dy),
    );
    expect(find.text('25.11.2026 10:05'), findsNWidgets(2));
    await tester.enterText(find.byKey(const ValueKey('search')), 'New');
    await tester.pumpAndSettle();
    expect(find.text('Old'), findsNothing);
    await tester.enterText(find.byKey(const ValueKey('search')), '');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('edit_2')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('edit_text')), '   ');
    await tester.tap(find.text('Зберегти'));
    await tester.pumpAndSettle();
    expect(find.text('Введіть текст нотатки'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('edit_text')), 'Changed');
    await tester.tap(find.text('Зберегти'));
    await tester.pumpAndSettle();
    expect(find.text('Changed'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('delete_2')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Скасувати'));
    await tester.pumpAndSettle();
    expect(store.notes.length, 2);
    await tester.tap(find.byKey(const ValueKey('delete_2')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Видалити'));
    await tester.pumpAndSettle();
    expect(find.text('Changed'), findsNothing);
    expect(store.notes.single.text, 'Old');
  });
  testWidgets('Sort setting is saved and reloaded', (tester) async {
    final store = MemoryStore();
    final settings = MemorySettings();
    await store.add('First');
    await store.add('Second');
    await tester.pumpWidget(NotesApp(store: store, settings: settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Змінити порядок'));
    await tester.pumpAndSettle();
    expect(settings.value, isTrue);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(NotesApp(store: store, settings: settings));
    await tester.pumpAndSettle();
    expect(find.text('Спочатку давніші'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('First')).dy,
      lessThan(tester.getTopLeft(find.text('Second')).dy),
    );
  });
  testWidgets('Small viewport with keyboard does not overflow', (tester) async {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2;
    tester.view.viewInsets = const FakeViewPadding(bottom: 600);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(
      NotesApp(store: MemoryStore(), settings: MemorySettings()),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
