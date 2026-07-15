import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/main.dart';

void main() {
  testWidgets('App boots to the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CoachApp());
    await tester.pumpAndSettle();

    expect(find.text('Accedi'), findsWidgets);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
