// This is a basic Flutter widget test for the Hypnos App.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hypnos_app/main.dart';

void main() {
  testWidgets('Hypnos App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HypnosApp());

    // Verify that the app title is displayed
    expect(find.text('HYPNOS'), findsOneWidget);

    // Verify that the main UI elements are present
    expect(find.byIcon(Icons.mic), findsWidgets); // Voice button(s)
    expect(find.byIcon(Icons.camera_alt), findsOneWidget); // Camera button
    expect(find.byIcon(Icons.settings), findsOneWidget); // Settings button

    // Verify that the text input field is present
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the initial message is displayed
    expect(find.text('Tap the sphere to start talking'), findsOneWidget);
    expect(find.text('Or use text input'), findsOneWidget);
  });
}
