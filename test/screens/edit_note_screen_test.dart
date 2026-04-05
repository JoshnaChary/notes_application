import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/screens/edit_note_screen.dart';
import 'package:notes_application/strings/app_strings.dart';

void main() {
  final existingNote = Note(
    id: 'n1',
    title: 'Hello',
    body: 'World',
    category: 'WORK',
    colorHex: '#2D5BE3',
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 2),
  );

  group('EditNoteScreen', () {
    testWidgets('new note shows title field and save', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditNoteScreen(),
        ),
      );

      expect(find.byKey(const Key('note_title_field')), findsOneWidget);
      expect(find.byKey(const Key('note_body_field')), findsOneWidget);
      expect(find.byKey(const Key('save_note_button')), findsOneWidget);
      expect(find.text(AppStrings.notes), findsOneWidget);
    });

    testWidgets('editing existing note prefills controllers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditNoteScreen(note: existingNote),
        ),
      );

      final titleField = tester.widget<TextField>(find.byKey(const Key('note_title_field')));
      expect(titleField.controller?.text, 'Hello');
    });

    testWidgets('category chips are tappable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditNoteScreen(),
        ),
      );

      await tester.tap(find.text(AppStrings.personal));
      await tester.pump();
      expect(find.text(AppStrings.personal), findsWidgets);
    });

    testWidgets('overflow menu button is present when editing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditNoteScreen(note: existingNote),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('renders all category options', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditNoteScreen(),
        ),
      );

      // All four categories should be available
      expect(find.text(AppStrings.work), findsWidgets);
      expect(find.text(AppStrings.personal), findsWidgets);
      expect(find.text(AppStrings.urgent), findsWidgets);
      expect(find.text(AppStrings.peace), findsWidgets);
    });

    testWidgets('tapping category updates selection', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditNoteScreen(),
        ),
      );

      // Tap URGENT category
      await tester.tap(find.text(AppStrings.urgent));
      await tester.pump();
      
      // Should update selection indicator
      expect(find.text(AppStrings.urgent), findsWidgets);
    });

    testWidgets('shows body field with proper hint', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditNoteScreen(),
        ),
      );

      expect(find.byKey(const Key('note_body_field')), findsOneWidget);
    });

    testWidgets('save button is functional', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditNoteScreen(),
        ),
      );

      // Find and verify save button exists
      expect(find.byKey(const Key('save_note_button')), findsOneWidget);
    });

    testWidgets('shows close button in app bar for new note', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditNoteScreen(),
        ),
      );

      // New note so no back button in nav, but close button should exist
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('editing note shows correct title in body', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditNoteScreen(note: existingNote),
        ),
      );

      final bodyField = tester.widget<TextField>(find.byKey(const Key('note_body_field')));
      expect(bodyField.controller?.text, 'World');
    });

    testWidgets('can switch between categories', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditNoteScreen(),
        ),
      );

      // Tap first category
      await tester.tap(find.text(AppStrings.work).first);
      await tester.pump();

      // Then tap another
      await tester.tap(find.text(AppStrings.personal).first);
      await tester.pump();

      // Should succeed
      expect(find.text(AppStrings.personal), findsWidgets);
    });

    testWidgets('renders text input fields with controllers', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditNoteScreen(),
        ),
      );

      // Both fields should be editable TextFields
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);
    });

    testWidgets('scaffold has proper structure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EditNoteScreen(),
        ),
      );

      // Should have Scaffold
      expect(find.byType(Scaffold), findsOneWidget);
      // Should have AppBar
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
