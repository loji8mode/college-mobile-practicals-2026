import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical10/main.dart';

void main() {
  const cases = {
    'Ok': 'Cool!',
    'Cancel': 'Let’s try something else',
    'AppBar': "Don't know what to say",
    'SystemBack': "Don't know what to say",
  };
  for (final entry in cases.entries) {
    testWidgets('Data transfer and return via ${entry.key}', (
      t,
    ) async {
      await t.pumpWidget(const NavigationApp());
      await t.enterText(
        find.byKey(const ValueKey('text-input')),
        'Навігація 32-ІСТ',
      );
      t
          .widget<Slider>(find.byKey(const ValueKey('font-size')))
          .onChanged!(36);
      await t.pump();
      await t.tap(find.text('Червоний'));
      await t.pump();
      await t.tap(find.text('Переглянути'));
      await t.pumpAndSettle();
      final text = t.widget<Text>(
        find.byKey(const ValueKey('preview-text')),
      );
      expect(text.data, 'Навігація 32-ІСТ');
      expect(text.style!.fontSize, 36);
      expect(text.style!.color, Colors.red);
      if (entry.key == 'AppBar') {
        await t.pageBack();
      } else if (entry.key == 'SystemBack') {
        await t.binding.handlePopRoute();
      } else {
        await t.tap(find.text(entry.key));
      }
      await t.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(entry.value), findsOneWidget);
      expect(find.text('Редактор тексту'), findsOneWidget);
      await t.tap(find.text('OK'));
      await t.pumpAndSettle();
      expect(
        t
            .widget<TextField>(
              find.byKey(const ValueKey('text-input')),
            )
            .controller!
            .text,
        'Навігація 32-ІСТ',
      );
      expect(t.takeException(), isNull);
    });
  }
}
