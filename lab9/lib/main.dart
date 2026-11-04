import 'package:flutter/material.dart';

import 'screens/asset_screen.dart';
import 'screens/storage_screen.dart';
import 'services/json_storage_service.dart';

void main() {
  runApp(const LocalJsonApp());
}

class LocalJsonApp extends StatelessWidget {
  const LocalJsonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - Local JSON Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const JsonHomeScreen(),
    );
  }
}

class JsonHomeScreen extends StatefulWidget {
  const JsonHomeScreen({super.key});

  @override
  State<JsonHomeScreen> createState() => _JsonHomeScreenState();
}

class _JsonHomeScreenState extends State<JsonHomeScreen> {
  final _savedStorage = JsonStorageService(fileName: 'saved_movies.json');
  final _databaseStorage = JsonStorageService(
    fileName: 'movie_database.json',
    seedFromAssets: true,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: fileStorageSupported ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LAB9 - Local JSON Storage'),
          bottom: TabBar(
            tabs: [
              const Tab(text: '9.1 Assets'),
              if (fileStorageSupported) const Tab(text: '9.2 Save/Load'),
              const Tab(text: '9.3 CRUD'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              const AssetScreen(),
              if (fileStorageSupported)
                StorageScreen(storage: _savedStorage, autoSave: false),
              StorageScreen(storage: _databaseStorage, autoSave: true),
            ],
          ),
        ),
      ),
    );
  }
}
