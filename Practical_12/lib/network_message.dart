import 'package:dio/dio.dart';

String networkMessage(DioException e) => switch (e.type) {
  DioExceptionType.connectionTimeout ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout => 'Час очікування минув. Спробуйте ще раз.',
  DioExceptionType.badResponse =>
    'Сервер повернув помилку HTTP ${e.response?.statusCode?.toString() ?? 'невідомо'}.',
  DioExceptionType.cancel => 'Запит скасовано.',
  _ => 'Помилка мережі. Перевірте з’єднання та спробуйте знову.',
};
