import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab8/models/post.dart';
import 'package:lab8/services/api_service.dart';

const postJson = {'userId': 1, 'id': 7, 'title': 'Hello', 'body': 'Content'};

void main() {
  test('Post.fromJson reads all fields and rejects incorrect types', () {
    final post = Post.fromJson(postJson);
    expect(
      [post.userId, post.id, post.title, post.body],
      [1, 7, 'Hello', 'Content'],
    );
    expect(
      () => Post.fromJson({...postJson, 'id': '7'}),
      throwsFormatException,
    );
    expect(() => Post.fromJson({'id': 7}), throwsFormatException);
  });

  test('GET uses the required endpoint and returns typed posts', () async {
    final service = ApiService(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(
          request.url.toString(),
          'https://jsonplaceholder.typicode.com/posts',
        );
        return http.Response(json.encode([postJson]), 200);
      }),
    );
    addTearDown(service.dispose);
    final posts = await service.fetchPosts();
    expect(posts, isA<List<Post>>());
    expect(posts.single.id, 7);
  });

  for (final body in ['not JSON', '{}', '[1]', '[{"id":1}]']) {
    test('GET rejects malformed or unexpected data: $body', () async {
      final service = ApiService(
        client: MockClient((_) async => http.Response(body, 200)),
      );
      addTearDown(service.dispose);
      await expectLater(service.fetchPosts(), throwsA(isA<ApiException>()));
    });
  }

  test('GET reports HTTP errors', () async {
    final service = ApiService(
      client: MockClient((_) async => http.Response('Error', 500)),
    );
    addTearDown(service.dispose);
    await expectLater(
      service.fetchPosts(),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          contains('HTTP 500'),
        ),
      ),
    );
  });

  test('GET reports connectivity failures', () async {
    final service = ApiService(
      client: MockClient((_) async => throw http.ClientException('Offline')),
    );
    addTearDown(service.dispose);
    await expectLater(
      service.fetchPosts(),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          contains('internet connection'),
        ),
      ),
    );
  });

  test('GET times out instead of loading forever', () async {
    final service = ApiService(
      client: MockClient((_) => Completer<http.Response>().future),
      timeout: const Duration(milliseconds: 10),
    );
    addTearDown(service.dispose);
    await expectLater(
      service.fetchPosts(),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          contains('timed out'),
        ),
      ),
    );
  });

  test('POST sends JSON and parses the created post', () async {
    final service = ApiService(
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.headers['content-type'], contains('application/json'));
        expect(json.decode(request.body), {
          'userId': 1,
          'title': 'Hello',
          'body': 'Content',
        });
        return http.Response(json.encode({...postJson, 'id': 101}), 201);
      }),
    );
    addTearDown(service.dispose);
    final post = await service.createPost(title: ' Hello ', body: ' Content ');
    expect(post.id, 101);
    expect(post.title, 'Hello');
  });

  test('POST reports HTTP failures and invalid responses', () async {
    for (final response in [
      http.Response('Error', 500),
      http.Response('[]', 201),
    ]) {
      final service = ApiService(client: MockClient((_) async => response));
      addTearDown(service.dispose);
      await expectLater(
        service.createPost(title: 'Hello', body: 'Content'),
        throwsA(isA<ApiException>()),
      );
    }
  });
}
