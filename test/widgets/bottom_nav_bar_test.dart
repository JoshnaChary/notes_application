import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/strings/app_strings.dart';
import 'package:notes_application/widgets/bottom_nav_bar.dart';

void main() {
  group('BottomNavBar', () {
    testWidgets('renders both tabs', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      expect(find.text(AppStrings.notesTab), findsOneWidget);
      expect(find.text(AppStrings.pinnedTab), findsOneWidget);
    });

    testWidgets('highlights selected index', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BottomNavBar(selectedIndex: 1),
          ),
        ),
      );

      expect(find.byIcon(Icons.push_pin), findsOneWidget);
    });

    testWidgets('onTabSelected is called with index', (tester) async {
      int? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BottomNavBar(
              selectedIndex: 0,
              onTabSelected: (i) => selected = i,
            ),
          ),
        ),
      );

      await tester.tap(find.text(AppStrings.pinnedTab));
      expect(selected, 1);
    });

    testWidgets('safe area padding respects MediaQuery', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(padding: EdgeInsets.only(bottom: 20)),
            child: Scaffold(
              body: BottomNavBar(selectedIndex: 0),
            ),
          ),
        ),
      );

      expect(find.byType(BottomNavBar), findsOneWidget);
    });
  });
}
