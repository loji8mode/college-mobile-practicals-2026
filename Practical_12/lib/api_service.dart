import 'dart:async';

import 'package:dio/dio.dart';

const catcherUrl = 'https://valentyn32ist-lab12-20261123.requestcatcher.com';

abstract class AuthApi {
  Future<void> login(String email, String password);
  Future<void> signup(String name, String email, String password);
  Future<void> resetPassword(String email);
}

class ApiService implements AuthApi {
  ApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: catcherUrl,
              connectTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          ) {
    _dio.interceptors.add(
      LogInterceptor(
        logPrint: (message) => Zone.current.print(message.toString()),
        requestBody: false,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );
  }
  final Dio _dio;

  Future<void> _post(String path, Map<String, String> data) async {
    await _dio.post<String>(
      path,
      data: data,
      options: Options(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
  }

  @override
  Future<void> login(String email, String password) =>
      _post('/login', {'email': email, 'password': password});

  @override
  Future<void> signup(String name, String email, String password) =>
      _post('/signup', {'name': name, 'email': email, 'password': password});

  @override
  Future<void> resetPassword(String email) => _post('/reset', {'email': email});
}
