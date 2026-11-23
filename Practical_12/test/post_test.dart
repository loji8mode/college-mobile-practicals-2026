import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical12/post.dart';
import 'package:practical12/network_message.dart';
import 'package:practical12/screens/posts_screen.dart';

void main() {
  test('Model preserves all typed fields and rejects malformed JSON', () {
    final post = Post.fromJson({
      'id': 2,
      'userId': 1,
      'title': 'Title',
      'body': 'Body',
    });
    expect(
      [post.id, post.userId, post.title, post.body],
      [2, 1, 'Title', 'Body'],
    );
    expect(() => Post.fromJson({'id': 'wrong'}), throwsA(isA<TypeError>()));
  });
  test('Errors distinguish timeout HTTP and connectivity', () {
    final request = RequestOptions(path: '/');
    expect(
      networkMessage(
        DioException(
          requestOptions: request,
          type: DioExceptionType.receiveTimeout,
        ),
      ),
      contains('Час очікування'),
    );
    expect(
      networkMessage(
        DioException(
          requestOptions: request,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: request, statusCode: 503),
        ),
      ),
      contains('503'),
    );
    expect(
      networkMessage(
        DioException(
          requestOptions: request,
          type: DioExceptionType.connectionError,
        ),
      ),
      contains('Перевірте'),
    );
  });
  testWidgets('List loads models after progress', (tester) async {
    final complete = Completer<List<Post>>();
    await tester.pumpWidget(
      MaterialApp(home: PostsScreen(load: () => complete.future)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    complete.complete([
      const Post(id: 1, userId: 2, title: 'First post', body: 'Body'),
    ]);
    await tester.pumpAndSettle();
    expect(find.text('First post'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
  testWidgets('Failed list retries successfully', (tester) async {
    var calls = 0;
    Future<List<Post>> load() async {
      if (++calls == 1) {
        throw DioException(requestOptions: RequestOptions(path: '/'));
      }
      return [];
    }

    await tester.pumpWidget(MaterialApp(home: PostsScreen(load: load)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Повторити'));
    await tester.pumpAndSettle();
    expect(find.text('Дописів немає'), findsOneWidget);
    expect(calls, 2);
  });
}
