import 'package:flutter/material.dart';

import 'auth_app.dart';
import 'auth_models.dart';

void main() {
  runApp(
    const AuthApp(
      title: 'Lab 10.1 · Mock Login',
      description: 'Sign in using the local test account.',
      emailLogin: true,
      demoIdentity: 'student@example.com',
      demoPassword: 'lab10demo',
      onPasswordLogin: _mockLogin,
    ),
  );
}

Future<AuthProfile> _mockLogin(String email, String password) async {
  await Future<void>.delayed(const Duration(milliseconds: 700));
  if (email.toLowerCase() != 'student@example.com' || password != 'lab10demo') {
    throw const AuthFailure('Incorrect email or password.');
  }
  const session = (
    token: 'lab10-mock-token',
    profile: AuthProfile(
      name: 'Student Demo',
      email: 'student@example.com',
      provider: 'Mock authentication',
    ),
  );
  return session.profile;
}
