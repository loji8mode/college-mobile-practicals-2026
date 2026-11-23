import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical12/api_service.dart';

class RecordingAdapter implements HttpClientAdapter {
  final requests = <Map<String, Object?>>[];
  int status = 200;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final bytes = await requestStream!.expand((c) => c).toList();
    requests.add({
      'method': options.method,
      'path': options.uri.path,
      'contentType': options.contentType,
      'data': jsonDecode(utf8.decode(bytes)),
    });
    return ResponseBody.fromString(
      'request caught',
      status,
      headers: {
        Headers.contentTypeHeader: ['text/plain'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;
  late RecordingAdapter adapter;
  late ApiService api;
  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://unit.invalid'));
    adapter = RecordingAdapter();
    dio.httpClientAdapter = adapter;
    api = ApiService(dio: dio);
  });
  tearDown(() => dio.close(force: true));

  test('Three methods serialize the correct UTF-8 JSON POST bodies', () async {
    await api.login('login@example.org', 'StudyPass123');
    await api.signup('Тест', 'signup@example.org', 'StudyPass123');
    await api.resetPassword('reset@example.org');
    expect(adapter.requests, [
      {
        'method': 'POST',
        'path': '/login',
        'contentType': 'application/json',
        'data': {'email': 'login@example.org', 'password': 'StudyPass123'},
      },
      {
        'method': 'POST',
        'path': '/signup',
        'contentType': 'application/json',
        'data': {
          'name': 'Тест',
          'email': 'signup@example.org',
          'password': 'StudyPass123',
        },
      },
      {
        'method': 'POST',
        'path': '/reset',
        'contentType': 'application/json',
        'data': {'email': 'reset@example.org'},
      },
    ]);
  });
  test('HTTP 500 propagates a Dio badResponse exception', () async {
    adapter.status = 500;
    await expectLater(
      api.login('a@example.org', 'StudyPass123'),
      throwsA(
        isA<DioException>()
            .having((e) => e.type, 'type', DioExceptionType.badResponse)
            .having((e) => e.response!.statusCode, 'status', 500),
      ),
    );
  });
}
