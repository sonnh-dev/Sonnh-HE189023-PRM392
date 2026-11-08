import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/main.dart';

void main() {
  testWidgets('Shows the empty state', (tester) async {
    await tester.pumpWidget(const TasklyApp());
    expect(find.text('No tasks yet. Add one!'), findsOneWidget);
  });

  testWidgets('Adding a task updates the list', (tester) async {
    await tester.pumpWidget(const TasklyApp());
    await tester.enterText(find.byType(TextField), 'Read Flutter docs');
    await tester.tap(find.text('Add'));
    await tester.pump();
    expect(find.text('Read Flutter docs'), findsOneWidget);
    expect(find.text('No tasks yet. Add one!'), findsNothing);
  });

  testWidgets('Multiple tasks appear together', (tester) async {
    await tester.pumpWidget(const TasklyApp());
    for (final title in ['Read Flutter docs', 'Run unit tests']) {
      await tester.enterText(find.byType(TextField), title);
      await tester.tap(find.text('Add'));
      await tester.pump();
    }
    expect(find.text('Read Flutter docs'), findsOneWidget);
    expect(find.text('Run unit tests'), findsOneWidget);
  });
}
