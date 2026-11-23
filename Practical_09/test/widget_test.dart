import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical09/main.dart';

void main() {
  Finder field(String key) => find.byKey(ValueKey(key));
  Future<void> press(WidgetTester t, String text) async {
    await t.ensureVisible(find.text(text));
    await t.tap(find.text(text));
    await t.pumpAndSettle();
  }

  Future<void> start(WidgetTester t) async {
    t.view.physicalSize = const Size(360, 640);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(const AccountApp());
    await t.pumpAndSettle();
  }

  testWidgets('Login validates and toggles the password', (
    t,
  ) async {
    await start(t);
    expect(
      t.widget<Form>(find.byType(Form)).autovalidateMode,
      AutovalidateMode.onUserInteraction,
    );
    await press(t, 'Login');
    expect(find.text('Обов’язкове поле'), findsNWidgets(2));
    expect(find.byType(AlertDialog), findsNothing);
    await t.enterText(field('email'), 'bad-email');
    await t.enterText(field('password'), 'abcdef');
    await press(t, 'Login');
    expect(find.text('Некоректний email'), findsOneWidget);
    expect(find.text('Мінімум 7 символів'), findsOneWidget);
    final passwordText = find.descendant(
      of: field('password'),
      matching: find.byType(TextField),
    );
    expect(t.widget<TextField>(passwordText).obscureText, isTrue);
    await t.tap(find.byTooltip('Показати пароль'));
    await t.pump();
    expect(t.widget<TextField>(passwordText).obscureText, isFalse);
    await t.enterText(field('email'), 'demo@example.org');
    await t.enterText(field('password'), 'abcdefg');
    await press(t, 'Login');
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(t.takeException(), isNull);
  });
  testWidgets('Signup requires all fields and matching passwords', (
    t,
  ) async {
    await start(t);
    await press(t, 'Sign up');
    await press(t, 'Register');
    expect(find.text('Обов’язкове поле'), findsNWidgets(4));
    expect(find.byType(AlertDialog), findsNothing);
    await t.enterText(field('name'), 'Demo');
    await t.enterText(field('email'), 'signup@example.org');
    await t.enterText(field('password'), 'abcdefg');
    await t.enterText(field('confirmation'), 'abcdefh');
    await press(t, 'Register');
    expect(find.text('Паролі не збігаються'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    await t.enterText(field('confirmation'), 'abcdefg');
    await press(t, 'Register');
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(t.takeException(), isNull);
  });
  testWidgets(
    'Reset rejects invalid email and allows a valid form',
    (t) async {
      await start(t);
      await press(t, 'Reset Password');
      await press(t, 'Reset');
      expect(find.text('Обов’язкове поле'), findsOneWidget);
      await t.enterText(field('email'), 'wrong');
      await press(t, 'Reset');
      expect(find.text('Некоректний email'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
      await t.enterText(field('email'), 'reset@example.org');
      await press(t, 'Reset');
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );
}
