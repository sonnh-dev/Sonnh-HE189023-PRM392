import 'package:flutter/material.dart';

import 'screens/signup_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Lab 7 - Signup Form with Validation & Good UX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SignupScreen(),
    ),
  );
}
