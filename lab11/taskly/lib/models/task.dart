class Task {
  const Task({required this.id, required this.title, this.completed = false});
  final int id;
  final String title;
  final bool completed;

  Task toggle() => Task(id: id, title: title, completed: !completed);
  Task rename(String title) => Task(id: id, title: title, completed: completed);
}
