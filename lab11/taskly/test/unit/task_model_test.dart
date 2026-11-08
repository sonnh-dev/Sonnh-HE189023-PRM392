import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/models/task.dart';

void main() {
  test('New task is incomplete', () {
    const task = Task(id: 1, title: 'Study');
    expect(task.completed, isFalse);
  });

  test('Toggle switches both ways and preserves the original task', () {
    const task = Task(id: 1, title: 'Study');
    final completed = task.toggle();
    expect(completed.completed, isTrue);
    expect(completed.toggle().completed, isFalse);
    expect(task.completed, isFalse);
    expect(completed.title, task.title);
  });
}
