import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_models.dart';
import 'rest_auth.dart';

class SessionStore {
  final _preferences = SharedPreferencesAsync();
  final _secureStorage = const FlutterSecureStorage();
  static const _activeKey = 'lab10.rest.active';
  static const _sessionKey = 'lab10.rest.session';

  Future<void> save(RestSession session) async {
    await _preferences.remove(_activeKey);
    await _secureStorage.write(
      key: _sessionKey,
      value: jsonEncode({
        'token': session.token,
        'name': session.profile.name,
        'email': session.profile.email,
        'username': session.profile.username,
        'expiresAt': session.expiresAt.toIso8601String(),
      }),
    );
    await _preferences.setBool(_activeKey, true);
  }

  Future<AuthProfile?> restore() async {
    if (await _preferences.getBool(_activeKey) != true) return null;
    final raw = await _secureStorage.read(key: _sessionKey);
    if (raw != null) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        final expiry = DateTime.parse(data['expiresAt'] as String);
        if ((data['token'] as String).isNotEmpty &&
            expiry.isAfter(DateTime.now())) {
          return AuthProfile(
            name: data['name'] as String,
            email: data['email'] as String,
            username: data['username'] as String,
            provider: 'DummyJSON REST API',
          );
        }
      } on FormatException {
        // Remove a malformed saved session.
      } on TypeError {
        // Remove a saved session whose fields have the wrong types.
      }
    }
    await clear();
    return null;
  }

  Future<void> clear() async {
    await _preferences.remove(_activeKey);
    await _secureStorage.delete(key: _sessionKey);
  }
}
