import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/strings/app_strings.dart';
import 'package:notes_application/widgets/delete_confirmation_dialog.dart';

void main() {
  group('DeleteConfirmationDialog', () {
    testWidgets('shows title and buttons', (tester) async {
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

      expect(find.text(AppStrings.deleteThisNote), findsOneWidget);
      expect(find.text(AppStrings.deleteConfirmation), findsOneWidget);
      expect(find.byKey(const Key('delete_button')), findsOneWidget);
      expect(find.byKey(const Key('confirm_delete_button')), findsOneWidget);
    });

    testWidgets('cancel triggers onCancel', (tester) async {
      var cancelled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeleteConfirmationDialog(
              onDelete: () {},
              onCancel: () => cancelled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('confirm_delete_button')));
      expect(cancelled, true);
    });
  });
}
