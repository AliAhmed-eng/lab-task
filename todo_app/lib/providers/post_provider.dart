
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _service = PostService();

  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  // GET Posts
  Future<void> loadPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _service.getPosts();
    } catch (e) {
      debugPrint('Error loading posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // POST New Post
  Future<void> addPost(String title, String body) async {
    final post = Post(
      userId: 1,
      id: 0,
      title: title,
      body: body,
    );

    final newPost = await _service.createPost(post);

    _posts = [newPost, ..._posts];

    notifyListeners();
  }
}
