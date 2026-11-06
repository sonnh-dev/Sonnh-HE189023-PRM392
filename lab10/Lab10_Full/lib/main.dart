import 'package:flutter/material.dart';

import 'auth_app.dart';
import 'google_auth.dart';
import 'notification_service.dart';
import 'rest_auth.dart';
import 'session_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final sessions = SessionStore();
  final google = GoogleAuth();
  final notifications = NotificationService();
  runApp(
    AuthApp(
      title: 'Lab 10 · Authentication',
      description:
          'Sign in to your account and keep your session on this device.',
      demoIdentity: 'emilys',
      demoPassword: 'emilyspass',
      onPasswordLogin: (username, password) async {
        final session = await loginWithDummyJson(username, password);
        await sessions.save(session);
        return session.profile;
      },
      onGoogleLogin: google.isConfigured ? google.signIn : null,
      googlePreview: !google.isConfigured,
      restore: () async => await sessions.restore() ?? await google.restore(),
      signOut: (profile) => profile.provider == GoogleAuth.provider
          ? google.signOut()
          : sessions.clear(),
      afterLogin: (profile) =>
          notifications.show('Sign-in successful', 'Welcome, ${profile.name}.'),
    ),
  );
}
