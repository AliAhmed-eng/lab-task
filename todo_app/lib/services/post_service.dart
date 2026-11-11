
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  final String baseUrl =
      'https://jsonplaceholder.typicode.com';

  // GET Posts
  Future<List<Post>> getPosts() async {
    final url = Uri.parse('$baseUrl/posts');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data =
          jsonDecode(response.body);

      return data.map((json) {
        return Post.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // POST New Post
  Future<Post> createPost(Post post) async {
    final url = Uri.parse('$baseUrl/posts');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Failed to create post');
    }
  }
}
