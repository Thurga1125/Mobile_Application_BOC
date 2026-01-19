import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boc_banking_app/main.dart';

void main() {
  testWidgets('BOC Banking app loads successfully', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MyApp());
    
    // Wait for any animations
    await tester.pumpAndSettle();

    // Just verify the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Verify welcome screen elements
    expect(find.text('BANK OF CEYLON'), findsOneWidget);
    expect(find.text('Bankers to the Nation'), findsOneWidget);
  });
}
