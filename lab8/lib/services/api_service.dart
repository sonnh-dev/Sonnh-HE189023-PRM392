import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client _client;
  final Duration timeout;
  static final Uri _postsUrl = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts',
  );

  ApiService({http.Client? client, this.timeout = const Duration(seconds: 15)})
    : _client = client ?? http.Client();

  // Lab 8.1 + 8.2: GET, decode JSON, then convert to List<Post>.
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _client.get(_postsUrl).timeout(timeout);
      if (response.statusCode != 200) {
        throw ApiException(
          'Could not load posts (HTTP ${response.statusCode}). Please try again.',
        );
      }

      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data is! List) {
        throw const FormatException('Expected a list of posts.');
      }

      return data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Invalid post data.');
        }
        return Post.fromJson(item);
      }).toList();
    } on TimeoutException {
      throw const ApiException('The request timed out. Please try again.');
    } on http.ClientException {
      throw const ApiException(
        'Unable to connect. Check your internet connection and try again.',
      );
    } on FormatException {
      throw const ApiException('The server returned invalid post data.');
    }
  }

  // Bonus: JSONPlaceholder accepts POST but does not persist new posts.
  Future<Post> createPost({required String title, required String body}) async {
    try {
      final response = await _client
          .post(
            _postsUrl,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: json.encode({
              'userId': 1,
              'title': title.trim(),
              'body': body.trim(),
            }),
          )
          .timeout(timeout);
      if (response.statusCode != 201) {
        throw ApiException(
          'Could not create the post (HTTP ${response.statusCode}). Please try again.',
        );
      }

      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Expected a post.');
      }
      return Post.fromJson(data);
    } on TimeoutException {
      throw const ApiException('The request timed out. Please try again.');
    } on http.ClientException {
      throw const ApiException(
        'Unable to connect. Check your internet connection and try again.',
      );
    } on FormatException {
      throw const ApiException('The server returned invalid post data.');
    }
  }

  void dispose() => _client.close();
}
