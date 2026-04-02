import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/widgets/delete_confirmation_dialog.dart';
import 'package:notes_application/strings/app_strings.dart';

void main() {
  group('DeleteConfirmationDialog Widget Tests', () {
    testWidgets('renders correctly with title and buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DeleteConfirmationDialog.show(
                      context: context,
                      onConfirm: () {},
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.deleteNote), findsOneWidget);
      expect(find.text(AppStrings.deleteNoteConfirmation), findsOneWidget);
      expect(find.text(AppStrings.delete), findsOneWidget);
      expect(find.text(AppStrings.cancel), findsOneWidget);
    });

    testWidgets('calls onConfirm when delete button is tapped', (WidgetTester tester) async {
      bool confirmCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DeleteConfirmationDialog.show(
                      context: context,
                      onConfirm: () => confirmCalled = true,
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.delete));
      await tester.pumpAndSettle();

      expect(confirmCalled, true);
    });

    testWidgets('dismisses when cancel button is tapped', (WidgetTester tester) async {
      bool confirmCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DeleteConfirmationDialog.show(
                      context: context,
                      onConfirm: () => confirmCalled = true,
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.cancel));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.deleteNote), findsNothing);
      expect(confirmCalled, false);
    });

    testWidgets('applies correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DeleteConfirmationDialog.show(
                      context: context,
                      onConfirm: () {},
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(find.descendant(of: find.byType<DeleteConfirmationDialog>()).first);
      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('handles tap outside to dismiss', (WidgetTester tester) async {
      bool confirmCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DeleteConfirmationDialog.show(
                      context: context,
                      onConfirm: () => confirmCalled = true,
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();
      
      // Tap outside the dialog to dismiss
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.deleteNote), findsNothing);
      expect(confirmCalled, false);
    });

    testWidgets('debugFillProperties works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    DeleteConfirmationDialog.show(
                      context: context,
                      onConfirm: () {},
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      final dialog = tester.widget<DeleteConfirmationDialog>(find.byType<DeleteConfirmationDialog>());
      expect(dialog.toString(), contains('title'));
      expect(dialog.toString(), contains('onConfirm'));
    });
  });
}
