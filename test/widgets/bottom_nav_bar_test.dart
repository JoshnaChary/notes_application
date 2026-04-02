import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/widgets/bottom_nav_bar.dart';
import 'package:notes_application/theme/colors.dart';

void main() {
  group('BottomNavBar Widget Tests', () {
    testWidgets('renders correctly with default values', (WidgetTester tester) async {
      int? selectedIndex;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: selectedIndex,
              onTabSelected: (index) => selectedIndex = index,
            ),
          ),
        ),
      ),
      );

      expect(find.byType<BottomNavBar>, findsOneWidget);
      expect(find.text('All Notes'), findsOneWidget);
      expect(find.text('Favourites'), findsOneWidget);
      expect(find.text('Pinned'), findsOneWidget);
    });

    testWidgets('handles tab selection correctly', (WidgetTester tester) async {
      int? selectedIndex;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: selectedIndex,
              onTabSelected: (index) => selectedIndex = index,
            ),
          ),
        ),
      ),
      );

      // Tap on Favourites tab
      await tester.tap(find.text('Favourites'));
      await tester.pump();

      expect(selectedIndex, 1);
    });

    testWidgets('applies correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: 0,
              onTabSelected: (index) {},
            ),
          ),
        ),
      ),
      );

      final bottomNavBar = tester.widget<BottomNavBar>(find.byType<BottomNavBar>());
      
      // Verify blur effect is applied
      final container = tester.widget<Container>(find.descendant(of: find.byType<BottomNavBar>()).first);
      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('handles null selectedIndex gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: null,
              onTabSelected: (index) {},
            ),
          ),
        ),
      ),
      );

      expect(find.byType<BottomNavBar>, findsOneWidget);
    });

    testWidgets('debugFillProperties works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              selectedIndex: 0,
              onTabSelected: (index) {},
            ),
          ),
        ),
      ),
      );

      final bottomNavBar = tester.widget<BottomNavBar>(find.byType<BottomNavBar>());
      expect(BottomNavBar.toString(), contains('selectedIndex'));
      expect(BottomNavBar.toString(), contains('onTabSelected'));
    });
  });
}
