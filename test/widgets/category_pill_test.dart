import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/widgets/category_pill.dart';
import 'package:notes_application/theme/colors.dart';

void main() {
  group('CategoryPill Widget Tests', () {
    testWidgets('renders with default label and color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryPill(
              label: 'Test Category',
              color: AppColors.primary,
            ),
          ),
        ),
      );

      expect(find.byType<CategoryPill>(), findsOneWidget);
      expect(find.text('TEST CATEGORY'), findsOneWidget);
    });

    testWidgets('applies correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryPill(
              label: 'Test',
              color: AppColors.primary,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(of: find.byType<CategoryPill>()).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, AppColors.primary.withValues(alpha: 0.1));
      expect(decoration.borderRadius, BorderRadius.circular(16));
    });

    testWidgets('handles empty label gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryPill(
              label: '',
              color: AppColors.primary,
            ),
          ),
        ),
      );

      expect(find.byType<CategoryPill>(), findsOneWidget);
    });

    testWidgets('handles long label with ellipsis', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryPill(
              label: 'Very Long Category Name That Should Be Truncated',
              color: AppColors.primary,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.descendant(of: find.byType<CategoryPill>()).first);
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('debugFillProperties works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryPill(
              label: 'Test',
              color: AppColors.primary,
            ),
          ),
        ),
      );

      final categoryPill = tester.widget<CategoryPill>(find.byType<CategoryPill>());
      expect(categoryPill.toString(), contains('label'));
      expect(categoryPill.toString(), contains('color'));
    });
  });
}
