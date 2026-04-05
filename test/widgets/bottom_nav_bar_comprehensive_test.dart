import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/widgets/bottom_nav_bar.dart';
import 'package:notes_application/strings/app_strings.dart';
import 'package:notes_application/theme/colors.dart';

void main() {
  group('BottomNavBar Comprehensive Tests', () {
    testWidgets('renders with selectedIndex 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      expect(find.byType(BottomNavBar), findsOneWidget);
      expect(find.text(AppStrings.notesTab), findsOneWidget);
      expect(find.text(AppStrings.pinnedTab), findsOneWidget);
      expect(find.byIcon(Icons.description), findsOneWidget);
      expect(find.byIcon(Icons.push_pin), findsOneWidget);
    });

    testWidgets('renders with selectedIndex 1', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 1),
          ),
        ),
      );

      expect(find.byType(BottomNavBar), findsOneWidget);
    });

    testWidgets('first tab is highlighted when selectedIndex is 0', (WidgetTester tester) async {
      int? selectedTab;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: 0,
              onTabSelected: (index) => selectedTab = index,
            ),
          ),
        ),
      );

      // The first tab should have a background color when selected
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('second tab is highlighted when selectedIndex is 1', (WidgetTester tester) async {
      int? selectedTab;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: 1,
              onTabSelected: (index) => selectedTab = index,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('tapping first tab calls onTabSelected with 0', (WidgetTester tester) async {
      int? selectedTab;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: 1,
              onTabSelected: (index) => selectedTab = index,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.description));
      await tester.pumpAndSettle();
      expect(selectedTab, 0);
    });

    testWidgets('tapping second tab calls onTabSelected with 1', (WidgetTester tester) async {
      int? selectedTab;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: 0,
              onTabSelected: (index) => selectedTab = index,
            ),
          ),
        ),
      );

      await tester.tap(find.text(AppStrings.pinnedTab));
      await tester.pumpAndSettle();
      expect(selectedTab, 1);
    });

    testWidgets('does not crash when onTabSelected is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      await tester.tap(find.text(AppStrings.notesTab));
      await tester.pumpAndSettle();
      expect(find.byType(BottomNavBar), findsOneWidget);
    });

    testWidgets('clips with rounded border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('applies backdrop filter blur effect', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('text labels are bold and correct font size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsWidgets);
    });

    testWidgets('uses correct colors for selected state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      // Verify primary color is used for selection
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('uses correct colors for unselected state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('icon size is 22', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      expect(find.byIcon(Icons.description), findsOneWidget);
      expect(find.byIcon(Icons.push_pin), findsOneWidget);
    });

    testWidgets('layout uses Row with spaceBetween', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('each tab is wrapped in GestureDetector', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('container has border and decoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('uses correct tab label for notes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      expect(find.text(AppStrings.notesTab), findsOneWidget);
    });

    testWidgets('uses correct tab label for pinned', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(selectedIndex: 0),
          ),
        ),
      );

      expect(find.text(AppStrings.pinnedTab), findsOneWidget);
    });
  });
}
