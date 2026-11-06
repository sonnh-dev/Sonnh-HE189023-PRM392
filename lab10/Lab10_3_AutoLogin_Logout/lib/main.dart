import 'package:flutter/material.dart';

import 'auth_app.dart';
import 'rest_auth.dart';
import 'session_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final sessions = SessionStore();
  runApp(
    AuthApp(
      title: 'Lab 10.3 · Saved Session',
      description: 'Sign in once to keep your session on this device.',
      demoIdentity: 'emilys',
      demoPassword: 'emilyspass',
      onPasswordLogin: (username, password) async {
        final session = await loginWithDummyJson(username, password);
        await sessions.save(session);
        return session.profile;
      },
      restore: sessions.restore,
      signOut: (_) => sessions.clear(),
    ),
  );
}
