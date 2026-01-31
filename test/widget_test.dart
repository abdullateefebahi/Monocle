import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monocle_app/main.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MonocleApp());

    // Verify that the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
