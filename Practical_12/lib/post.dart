import 'package:dio/dio.dart';

class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });
  final int id, userId;
  final String title, body;
  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'] as int,
    userId: json['userId'] as int,
    title: json['title'] as String,
    body: json['body'] as String,
  );
}

class PostsApi {
  PostsApi({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );
  final Dio _dio;
  Future<List<Post>> fetch() async {
    final response = await _dio.get<List<dynamic>>(
      'https://jsonplaceholder.typicode.com/posts',
    );
    return (response.data ?? [])
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
