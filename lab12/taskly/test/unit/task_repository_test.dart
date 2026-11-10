import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/task_repository.dart';

void main() {
  test('Add assigns unique IDs and trims the title', () {
    final repository = TaskRepository();
    final first = repository.addTask('  Study  ');
    final second = repository.addTask('Review');
    expect(first.title, 'Study');
    expect(first.id, isNot(second.id));
    expect(repository.tasks, [first, second]);
  });

  test('Delete removes only the matching ID', () {
    final repository = TaskRepository();
    final first = repository.addTask('Study');
    final second = repository.addTask('Review');
    expect(repository.deleteTask(first.id), isTrue);
    expect(repository.deleteTask(first.id), isFalse);
    expect(repository.tasks, [second]);
  });

  test('Update replaces the existing task with the same ID', () {
    final repository = TaskRepository();
    final task = repository.addTask('Study');
    final updated = task.rename('Read chapter 11').toggle();
    expect(repository.updateTask(updated), isTrue);
    expect(repository.tasks.single, updated);
  });
}
