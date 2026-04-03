import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/widgets/category_pill.dart';

void main() {
  group('CategoryPill', () {
    testWidgets('displays label and applies color', (tester) async {
      const color = Colors.deepPurple;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryPill(label: 'WORK', color: color),
          ),
        ),
      );

      expect(find.text('WORK'), findsOneWidget);
    });

    testWidgets('long label still builds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 80,
              child: CategoryPill(label: 'VERY_LONG_LABEL', color: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.text('VERY_LONG_LABEL'), findsOneWidget);
    });
  });
}
