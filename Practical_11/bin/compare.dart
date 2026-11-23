import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:practical11/api_service.dart';

Future<void> main() async {
  final url = Uri.parse('$catcherUrl/compare');
  final data = {
    'course': 'mobile',
    'practical': 12,
    'sample': 'same JSON body',
  };
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  try {
    final first = await dio.post<String>(
      url.toString(),
      data: data,
      options: Options(
        responseType: ResponseType.plain,
        headers: {'X-Client': 'dio'},
      ),
    );
    final second = await http
        .post(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'X-Client': 'http',
          },
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 10));
    stdout.writeln('dio: HTTP ${first.statusCode}');
    stdout.writeln('http: HTTP ${second.statusCode}');
    stdout.writeln('dio response: ${first.data}');
    stdout.writeln('http response: ${second.body}');
    if (first.statusCode != 200 || second.statusCode != 200) {
      throw StateError('Expected HTTP 200 from both clients');
    }
  } finally {
    dio.close(force: true);
  }
}
