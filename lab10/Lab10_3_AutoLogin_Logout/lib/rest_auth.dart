import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_models.dart';

class RestSession {
  const RestSession(this.profile, this.token, this.expiresAt);
  final AuthProfile profile;
  final String token;
  final DateTime expiresAt;
}

Future<RestSession> loginWithDummyJson(String username, String password) async {
  final http.Response response;
  try {
    response = await http
        .post(
          Uri.https('dummyjson.com', '/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username,
            'password': password,
            'expiresInMins': 60,
          }),
        )
        .timeout(const Duration(seconds: 15));
  } on TimeoutException {
    throw const AuthFailure('The request timed out. Try again.');
  } on http.ClientException {
    throw const AuthFailure(
      'Could not reach DummyJSON. Check your connection.',
    );
  }

  if (response.statusCode == 400 || response.statusCode == 401) {
    throw const AuthFailure('Incorrect username or password.');
  }
  if (response.statusCode != 200) {
    throw const AuthFailure('The sign-in service is unavailable. Try again.');
  }

  try {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final token = data['accessToken'] as String;
    final segments = token.split('.');
    if (segments.length != 3) throw const FormatException('Invalid token.');
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(segments[1]))),
    ) as Map<String, dynamic>;
    final expiry = DateTime.fromMillisecondsSinceEpoch(
      (payload['exp'] as int) * 1000,
      isUtc: true,
    );
    if (!expiry.isAfter(DateTime.now())) {
      throw const FormatException('Expired token.');
    }
    final name = [
      data['firstName'] as String,
      data['lastName'] as String,
    ].join(' ').trim();
    return RestSession(
      AuthProfile(
        name: name,
        username: data['username'] as String,
        email: data['email'] as String,
        provider: 'DummyJSON REST API',
      ),
      token,
      expiry,
    );
  } on FormatException {
    throw const AuthFailure('DummyJSON returned an invalid session.');
  } on TypeError {
    throw const AuthFailure('DummyJSON returned an invalid session.');
  }
}
