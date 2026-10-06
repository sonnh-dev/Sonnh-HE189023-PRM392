import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  static const movies = [
    ['Avatar', 'Sample description'],
    ['Inception', 'Sample description'],
    ['Interstellar', 'Sample description'],
    ['Joker', 'Sample description'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise 3 – Layout Basics: Column, Row, Padding, ListView',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Now Playing',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(movies[index][0][0])),
                    title: Text(movies[index][0]),
                    subtitle: Text(movies[index][1]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
