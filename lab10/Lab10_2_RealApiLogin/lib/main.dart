import 'package:flutter/material.dart';

import 'auth_app.dart';
import 'rest_auth.dart';

void main() {
  runApp(
    AuthApp(
      title: 'Lab 10.2 · REST Login',
      description: 'Authenticate using the public DummyJSON API.',
      demoIdentity: 'emilys',
      demoPassword: 'emilyspass',
      onPasswordLogin: (username, password) async =>
          (await loginWithDummyJson(username, password)).profile,
    ),
  );
}
