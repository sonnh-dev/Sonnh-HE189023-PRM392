import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_list_screen.dart';
import 'task_provider.dart';
import 'task_repository.dart';

void main() {
  final repository = TaskRepository();
  if (const bool.fromEnvironment('TASKLY_DEMO')) {
    for (final title in [
      'Review widget tests',
      'Check the task detail screen',
      'Record a performance trace',
      'Package the release APK',
    ]) {
      repository.addTask(title);
    }
  }
  runApp(TasklyApp(repository: repository));
}

class TasklyApp extends StatelessWidget {
  const TasklyApp({super.key, this.repository});
  final TaskRepository? repository;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => TaskProvider(repository ?? TaskRepository()),
    child: MaterialApp(
      title: 'Taskly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: const TaskListScreen(),
    ),
  );
}
