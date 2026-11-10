import 'package:flutter/foundation.dart';

import 'models/task.dart';
import 'task_repository.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider(this.repository);
  final TaskRepository repository;
  List<Task> get tasks => repository.tasks;

  Task? find(int id) {
    for (final task in repository.tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  void add(String title) {
    if (title.trim().isEmpty) return;
    repository.addTask(title);
    notifyListeners();
  }

  void update(Task task) {
    if (repository.updateTask(task)) notifyListeners();
  }

  void delete(int id) {
    if (repository.deleteTask(id)) notifyListeners();
  }
}
