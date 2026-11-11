
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';
import 'add_post_screen.dart';
import 'todos_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<PostProvider>().loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),

        actions: [
          IconButton(
            tooltip: 'View Todos',
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TodosScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.posts.isEmpty) {
            return const Center(
              child: Text('No posts found'),
            );
          }

          return ListView.builder(
            itemCount: provider.posts.length,
            itemBuilder: (context, index) {
              final post = provider.posts[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${post.id}'),
                  ),

                  title: Text(
                    post.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(post.body),

                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPostScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
