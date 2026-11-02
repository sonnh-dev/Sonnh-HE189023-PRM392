import 'package:flutter/material.dart';

import 'screens/post_list_screen.dart';

void main() {
  runApp(const ApiListApp());
}

class ApiListApp extends StatelessWidget {
  const ApiListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8 - API-powered List Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PostListScreen(),
    );
  }
}
