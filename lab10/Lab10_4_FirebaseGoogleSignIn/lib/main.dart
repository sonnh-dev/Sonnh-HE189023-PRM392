import 'package:flutter/material.dart';

import 'auth_app.dart';
import 'google_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final google = GoogleAuth();
  runApp(
    AuthApp(
      title: 'Lab 10.4 · Google Sign-In',
      description: 'Use your Google account to sign in with Firebase.',
      onGoogleLogin: google.isConfigured ? google.signIn : null,
      googlePreview: !google.isConfigured,
      restore: google.restore,
      signOut: (_) => google.signOut(),
    ),
  );
}
