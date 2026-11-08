import 'models/task.dart';

class TaskRepository {
  TaskRepository([Iterable<Task> initial = const []]) : _tasks = [...initial] {
    for (final task in _tasks) {
      if (task.id >= _nextId) _nextId = task.id + 1;
    }
  }

  final List<Task> _tasks;
  int _nextId = 1;
  List<Task> get tasks => List.unmodifiable(_tasks);

  Task addTask(String title) {
    final task = Task(id: _nextId++, title: title.trim());
    _tasks.add(task);
    return task;
  }

  bool updateTask(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return false;
    _tasks[index] = task;
    return true;
  }

  bool deleteTask(int id) {
    final index = _tasks.indexWhere((item) => item.id == id);
    if (index == -1) return false;
    _tasks.removeAt(index);
    return true;
  }
}
