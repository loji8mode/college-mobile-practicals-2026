import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../post.dart';
import '../network_message.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key, this.load});
  final Future<List<Post>> Function()? load;
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<Post>> _posts;
  @override
  void initState() {
    super.initState();
    _posts = (widget.load ?? PostsApi().fetch)();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Дописи JSONPlaceholder')),
    body: FutureBuilder<List<Post>>(
      future: _posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    snapshot.error is DioException
                        ? networkMessage(snapshot.error! as DioException)
                        : 'Не вдалося прочитати дані.',
                  ),
                ),
                FilledButton(
                  onPressed: () => setState(() {
                    _posts = (widget.load ?? PostsApi().fetch)();
                  }),
                  child: const Text('Повторити'),
                ),
              ],
            ),
          );
        }
        final posts = snapshot.data ?? [];
        if (posts.isEmpty) return const Center(child: Text('Дописів немає'));
        return ListView.separated(
          itemCount: posts.length,
          separatorBuilder: (_, index) => const Divider(),
          itemBuilder: (_, index) {
            final post = posts[index];
            return ListTile(
              leading: Text(post.id.toString()),
              title: Text(post.title),
              subtitle: Text(post.body),
            );
          },
        );
      },
    ),
  );
}
