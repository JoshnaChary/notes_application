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
  });
}
