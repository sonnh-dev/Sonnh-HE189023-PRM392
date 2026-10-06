import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 1 – Core Widgets: Text, Image, Icon, Card, ListTile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Icon
            const Icon(Icons.movie, size: 80, color: Colors.indigo),
            const SizedBox(height: 16),

            // Image
            Image.network(
              'https://static.vecteezy.com/system/resources/thumbnails/083/933/835/small/beautiful-and-inspiring-picture-detailing-a-bright-hot-air-balloon-over-river-pure-cozy-perfect-for-creatives-moods-stock-image-free-photo.jpeg',
              height: 200,
            ),
            const SizedBox(height: 16),

            // Card
            const Card(
              child: ListTile(
                leading: Icon(Icons.star,),
                title: Text('Movie item'),
                subtitle: Text('This is a sample ListTile inside a Card'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
