import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/main.dart';

void main() {
  testWidgets('App boots to the registration screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CoachApp());
    await tester.pumpAndSettle();

    expect(find.text('Crea il tuo account'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
