import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical11/api_service.dart';
import 'package:practical11/main.dart';

class FakeApi implements AuthApi {
  final calls = <Map<String, String>>[];
  Completer<void>? pending;
  DioException? failure;
  Future<void> _send(Map<String, String> data) async {
    calls.add(data);
    if (pending != null) await pending!.future;
    if (failure != null) throw failure!;
  }

  @override
  Future<void> login(String email, String password) => _send({
    'path': '/login',
    'email': email,
    'password': password,
  });
  @override
  Future<void> signup(String name, String email, String password) =>
      _send({
        'path': '/signup',
        'name': name,
        'email': email,
        'password': password,
      });
  @override
  Future<void> resetPassword(String email) =>
      _send({'path': '/reset', 'email': email});
}

void main() {
  Finder field(String key) => find.byKey(ValueKey(key));
  Future<void> press(WidgetTester t, String text) async {
    await t.ensureVisible(find.text(text));
    await t.tap(find.text(text));
    await t.pumpAndSettle();
  }

  Future<void> start(WidgetTester t, FakeApi api) async {
    t.view.physicalSize = const Size(360, 640);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(AccountApp(api: api));
    await t.pumpAndSettle();
  }

  Future<void> loginValues(WidgetTester t) async {
    await t.enterText(field('email'), ' demo@example.org ');
    await t.enterText(field('password'), 'StudyPass123');
  }

  const actions = {
    'Login': '/login',
    'Register': '/signup',
    'Reset': '/reset',
  };
  for (final entry in actions.entries) {
    testWidgets('Validate and send ${entry.key}', (t) async {
      final api = FakeApi();
      await start(t, api);
      if (entry.key == 'Register') await press(t, 'Sign up');
      if (entry.key == 'Reset') await press(t, 'Reset Password');
      await press(t, entry.key);
      expect(api.calls, isEmpty);
      if (entry.key == 'Register') {
        await t.enterText(field('name'), ' Demo ');
        await t.enterText(field('confirmation'), 'StudyPass123');
      }
      await t.enterText(field('email'), ' demo@example.org ');
      if (entry.key != 'Reset') {
        await t.enterText(field('password'), 'StudyPass123');
      }
      await press(t, entry.key);
      final expected = {
        'path': entry.value,
        'email': 'demo@example.org',
        if (entry.key == 'Register') 'name': 'Demo',
        if (entry.key != 'Reset') 'password': 'StudyPass123',
      };
      expect(api.calls, [expected]);
      expect(find.text('Дані надіслано'), findsOneWidget);
      expect(t.takeException(), isNull);
    });
  }
  testWidgets(
    'Pending request disables the button and prevents duplicates',
    (t) async {
      final api = FakeApi()..pending = Completer<void>();
      await start(t, api);
      await loginValues(t);
      await t.ensureVisible(find.text('Login'));
      await t.tap(find.text('Login'));
      await t.tap(find.text('Login'));
      await t.pump();
      expect(api.calls.length, 1);
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
      expect(
        t
            .widget<ElevatedButton>(find.byType(ElevatedButton))
            .onPressed,
        isNull,
      );
      api.pending!.complete();
      await t.pumpAndSettle();
      expect(find.text('Дані надіслано'), findsOneWidget);
    },
  );
  testWidgets(
    'Connection error is visible and restores the button',
    (t) async {
      final api = FakeApi()
        ..failure = DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.connectionError,
        );
      await start(t, api);
      await loginValues(t);
      await press(t, 'Login');
      expect(
        find.textContaining('Помилка мережі.'),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        t
            .widget<ElevatedButton>(find.byType(ElevatedButton))
            .onPressed,
        isNotNull,
      );
      expect(t.takeException(), isNull);
    },
  );
}
