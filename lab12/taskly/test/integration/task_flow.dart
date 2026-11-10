import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/main.dart';

Future<void> verifyTaskFlow(WidgetTester tester) async {
  await tester.pumpWidget(const TasklyApp());
  await tester.enterText(find.byType(TextField), 'Original title');
  await tester.tap(find.text('Add'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Original title'));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const ValueKey('detailTitleField')),
    'Updated title',
  );
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
  expect(find.text('Updated title'), findsOneWidget);
  expect(find.text('Original title'), findsNothing);
}
