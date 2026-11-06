import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_full/auth_app.dart';
import 'package:lab10_full/auth_models.dart';

const profile = AuthProfile(
  name: 'Test user',
  email: 'test@example.com',
  provider: 'DummyJSON REST API',
);

void main() {
  testWidgets(
    'Restoring a saved session skips login and sends no notification',
    (tester) async {
      var notifications = 0;
      var signedOut = false;
      await tester.pumpWidget(
        AuthApp(
          title: 'Lab 10',
          description: 'Sign in',
          restore: () async => profile,
          signOut: (_) async {
            signedOut = true;
          },
          afterLogin: (_) async {
            notifications++;
            return true;
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Session restored'), findsOneWidget);
      expect(notifications, 0);

      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      expect(signedOut, isTrue);
      expect(find.text('Session restored'), findsNothing);
    },
  );

  testWidgets('Successful credentials invoke the login notification once', (
    tester,
  ) async {
    var notifications = 0;
    await tester.pumpWidget(
      AuthApp(
        title: 'Lab 10',
        description: 'Sign in using your account.',
        onPasswordLogin: (username, password) async {
          if (username != 'demo' || password != 'test') {
            throw const AuthFailure('Incorrect username or password.');
          }
          return profile;
        },
        afterLogin: (_) async {
          notifications++;
          return true;
        },
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'demo');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Incorrect username or password.'), findsOneWidget);
    expect(notifications, 0);

    await tester.enterText(find.byType(TextFormField).at(1), 'test');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Test user'), findsOneWidget);
    expect(find.text('Login notification sent.'), findsOneWidget);
    expect(notifications, 1);
  });

  testWidgets(
    'Google profile demo returns to sign-in without creating a session',
    (tester) async {
      var notifications = 0;
      await tester.pumpWidget(
        AuthApp(
          title: 'Lab 10',
          description: 'Sign in',
          googlePreview: true,
          afterLogin: (_) async {
            notifications++;
            return true;
          },
        ),
      );
      await tester.tap(find.text('Preview demo profile'));
      await tester.pumpAndSettle();
      expect(find.text('Sample profile'), findsOneWidget);
      expect(find.text('Signed in'), findsNothing);
      await tester.tap(find.text('Back to sign-in'));
      await tester.pumpAndSettle();
      expect(find.text('Preview demo profile'), findsOneWidget);
      expect(notifications, 0);
    },
  );
}
