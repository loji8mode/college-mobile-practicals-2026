import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical07/main.dart';

void main() {
  testWidgets(
    'All screens accept text, show dialogs and navigate',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const AccountApp());
      await tester.pumpAndSettle();
      final email = find.byKey(const ValueKey('email'));
      final password = find.byKey(const ValueKey('password'));
      expect(find.byType(Image), findsOneWidget);
      expect(
        tester.widget<TextField>(password).obscureText,
        isTrue,
      );
      await tester.enterText(email, 'demo@example.org');
      await tester.enterText(password, 'DemoPass123');
      await tester.ensureVisible(find.text('Login'));
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining('demo@example.org'), findsWidgets);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.textContaining('DemoPass123'),
        ),
        findsNothing,
      );
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sign up'));
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      expect(find.text('Реєстрація'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3));
      await tester.enterText(
        find.byKey(const ValueKey('name')),
        'Demo',
      );
      await tester.enterText(email, 'signup@example.org');
      await tester.enterText(password, 'SignPass123');
      await tester.ensureVisible(find.text('Register'));
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Ім’я: Demo'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Back'));
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(email).controller!.text,
        'demo@example.org',
      );
      await tester.ensureVisible(find.text('Reset Password'));
      await tester.tap(find.text('Reset Password'));
      await tester.pumpAndSettle();
      expect(find.text('Відновлення пароля'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      await tester.enterText(email, 'reset@example.org');
      await tester.ensureVisible(find.text('Reset'));
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('reset@example.org'),
        findsWidgets,
      );
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Back'));
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Вхід'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
