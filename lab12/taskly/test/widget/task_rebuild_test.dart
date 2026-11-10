import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/main.dart';
import 'package:taskly/task_list_screen.dart';
import 'package:taskly/task_repository.dart';

void main() {
  testWidgets('Toggle builds only the task row that changed', (tester) async {
    final repository = TaskRepository();
    for (final title in ['Review', 'Build', 'Measure', 'Ship']) {
      repository.addTask(title);
    }
    await tester.pumpWidget(TasklyApp(repository: repository));
    var screenBuilds = 0;
    var rowBuilds = 0;
    debugOnRebuildDirtyWidget = (element, _) {
      if (element.widget is TaskListScreen) screenBuilds++;
      if (element.widget is ListTile) rowBuilds++;
    };
    addTearDown(() => debugOnRebuildDirtyWidget = null);
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(repository.tasks.first.completed, isTrue);
    expect(repository.tasks.skip(1).every((task) => !task.completed), isTrue);
    debugPrint('TASKLY_REBUILDS screen=$screenBuilds rows=$rowBuilds');
    const baseline = bool.fromEnvironment('TASKLY_EXPECT_BASELINE');
    expect(screenBuilds, baseline ? 1 : 0);
    expect(rowBuilds, baseline ? 4 : 1);
  });
}
