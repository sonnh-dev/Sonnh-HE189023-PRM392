import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab8/screens/post_list_screen.dart';
import 'package:lab8/services/api_service.dart';

const postJson = {
  'userId': 1,
  'id': 1,
  'title': 'First post',
  'body': 'Post body',
};

void main() {
  testWidgets('Shows loading, then API posts and post details', (tester) async {
    final response = Completer<http.Response>();
    var requests = 0;
    final service = ApiService(
      client: MockClient((_) {
        requests++;
        return response.future;
      }),
    );
    addTearDown(service.dispose);
    await tester.pumpWidget(
      MaterialApp(home: PostListScreen(apiService: service)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading posts...'), findsOneWidget);

    response.complete(http.Response(json.encode([postJson]), 200));
    await tester.pumpAndSettle();
    expect(find.text('First post'), findsOneWidget);
    expect(find.text('1 posts - JSONPlaceholder'), findsOneWidget);
    await tester.tap(find.text('First post'));
    await tester.pumpAndSettle();
    expect(find.text('Post #1'), findsOneWidget);
    expect(find.text('Post body'), findsOneWidget);
    expect(requests, 1);
  });

  testWidgets('Retry recovers from an error and refresh makes a new request', (
    tester,
  ) async {
    var requests = 0;
    final service = ApiService(
      client: MockClient((_) async {
        requests++;
        return requests == 1
            ? http.Response('Unavailable', 503)
            : http.Response(json.encode([postJson]), 200);
      }),
    );
    addTearDown(service.dispose);
    await tester.pumpWidget(
      MaterialApp(home: PostListScreen(apiService: service)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Something went wrong'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('First post'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, 400));
    await tester.pumpAndSettle();
    expect(requests, 3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Empty API list has a useful state', (tester) async {
    final service = ApiService(
      client: MockClient((_) async => http.Response('[]', 200)),
    );
    addTearDown(service.dispose);
    await tester.pumpWidget(
      MaterialApp(home: PostListScreen(apiService: service)),
    );
    await tester.pumpAndSettle();
    expect(find.text('No posts yet. Pull down to try again.'), findsOneWidget);
  });

  testWidgets(
    'POST validates, prevents duplicate sends and adds returned post',
    (tester) async {
      final response = Completer<http.Response>();
      var sends = 0;
      final service = ApiService(
        client: MockClient((request) async {
          if (request.method == 'GET') {
            return http.Response(json.encode([postJson]), 200);
          }
          sends++;
          return response.future;
        }),
      );
      addTearDown(service.dispose);
      await tester.pumpWidget(
        MaterialApp(home: PostListScreen(apiService: service)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('New post'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create post'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter a title.'), findsOneWidget);
      expect(find.text('Please enter the post body.'), findsOneWidget);
      expect(sends, 0);
      await tester.enterText(find.byType(TextFormField).at(0), 'My new post');
      await tester.enterText(find.byType(TextFormField).at(1), 'My new body');
      await tester.ensureVisible(find.text('Create post'));
      await tester.tap(find.text('Create post'));
      await tester.pump();
      expect(find.text('Sending...'), findsOneWidget);
      await tester.tap(find.text('Sending...'));
      expect(sends, 1);
      response.complete(
        http.Response(
          json.encode({
            'userId': 1,
            'id': 101,
            'title': 'My new post',
            'body': 'My new body',
          }),
          201,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('My new post'), findsOneWidget);
      expect(find.text('2 posts - JSONPlaceholder'), findsOneWidget);
      expect(find.text('Post #101 created for this session.'), findsOneWidget);
    },
  );
}
