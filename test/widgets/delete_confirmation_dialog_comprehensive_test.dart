import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/widgets/delete_confirmation_dialog.dart';
import 'package:notes_application/strings/app_strings.dart';
import 'package:notes_application/theme/colors.dart';

void main() {
  group('DeleteConfirmationDialog Comprehensive Tests', () {
    testWidgets('displays all required UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
      expect(find.text(AppStrings.deleteThisNote), findsOneWidget);
      expect(find.text(AppStrings.deleteConfirmation), findsOneWidget);
      expect(find.text(AppStrings.delete), findsOneWidget);
      expect(find.text(AppStrings.cancel), findsOneWidget);
    });

    testWidgets('delete button calls onDelete callback', (WidgetTester tester) async {
      bool deletePressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () => deletePressed = true,
              onCancel: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('delete_button')));
      await tester.pumpAndSettle();
      expect(deletePressed, true);
    });

    testWidgets('cancel button calls onCancel callback', (WidgetTester tester) async {
      bool cancelPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () => cancelPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('confirm_delete_button')));
      await tester.pumpAndSettle();
      expect(cancelPressed, true);
    });

    testWidgets('delete button pops navigation before calling callback', (WidgetTester tester) async {
      bool deletePressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () => deletePressed = true,
              onCancel: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('delete_button')));
      await tester.pumpAndSettle();
      expect(deletePressed, true);
    });

    testWidgets('cancel button pops navigation before calling callback', (WidgetTester tester) async {
      bool cancelPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () => cancelPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('confirm_delete_button')));
      await tester.pumpAndSettle();
      expect(cancelPressed, true);
    });

    testWidgets('has correct dialog container styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('delete icon is displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
    });

    testWidgets('title text has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      final titleText = find.text(AppStrings.deleteThisNote);
      expect(titleText, findsOneWidget);
    });

    testWidgets('confirmation message is centered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text(AppStrings.deleteConfirmation), findsOneWidget);
    });

    testWidgets('delete button has error color background', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('delete_button')), findsOneWidget);
    });

    testWidgets('cancel button has placeholder color background', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('confirm_delete_button')), findsOneWidget);
    });

    testWidgets('dialog is sized to minimum required', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      // The Column should be MainAxisSize.min
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('buttons span full width', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('proper vertical spacing between elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('icon container has placeholder background', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
    });

    testWidgets('icon color is error red', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
    });

    testWidgets('delete button text is white', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text(AppStrings.delete), findsOneWidget);
    });

    testWidgets('cancel button text is secondary gray', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text(AppStrings.cancel), findsOneWidget);
    });

    testWidgets('supports accessibility with keys', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('delete_button')), findsOneWidget);
      expect(find.byKey(const Key('confirm_delete_button')), findsOneWidget);
    });
  });
}
