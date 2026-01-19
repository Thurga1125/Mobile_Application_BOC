import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boc_banking_app/main.dart';

void main() {
  testWidgets('BOC Banking app loads welcome screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Wait for animations to complete
    await tester.pumpAndSettle();

    // Verify that welcome screen shows BOC text
    expect(find.text('BOC'),
        findsWidgets); // Changed to findsWidgets (allows multiple)
    expect(find.text('BANK OF CEYLON'), findsOneWidget);
    expect(find.text('Bankers to the Nation'), findsOneWidget);

    // Verify buttons exist
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('Login button navigates to login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Find and tap the login button
    final loginButton = find.widgetWithText(ElevatedButton, 'Log in');
    expect(loginButton, findsOneWidget);

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify we're on login screen
    expect(find.text('Welcome User'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
