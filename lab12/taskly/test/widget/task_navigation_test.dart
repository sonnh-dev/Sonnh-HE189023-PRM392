import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/main.dart';
import 'package:taskly/task_repository.dart';

void main() {
  testWidgets('Tapping a task opens its detail title field', (tester) async {
    final repository = TaskRepository()..addTask('Seeded task');
    await tester.pumpWidget(TasklyApp(repository: repository));
    await tester.tap(find.text('Seeded task'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Task Detail'), findsOneWidget);
    expect(find.byKey(const ValueKey('detailTitleField')), findsOneWidget);
  });
}
