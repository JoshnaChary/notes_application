import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/widgets/note_card.dart';

void main() {
  final baseTime = DateTime(2026, 3, 15, 12);

  Note buildNote({
    String title = 'Title',
    String body = 'Body text',
    bool pinned = false,
    String? imageUrl,
  }) {
    return Note(
      id: '1',
      title: title,
      body: body,
      category: 'WORK',
      colorHex: '#2D5BE3',
      createdAt: baseTime,
      updatedAt: baseTime,
      isPinned: pinned,
      isFavourite: false,
      imageUrl: imageUrl,
    );
  }

  group('NoteCard', () {
    testWidgets('renders title body and category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote()),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Body text'), findsOneWidget);
      expect(find.text('WORK'), findsOneWidget);
    });

    testWidgets('shows pin icon when note is pinned', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(pinned: true)),
          ),
        ),
      );

      expect(find.byIcon(Icons.push_pin), findsOneWidget);
    });

    testWidgets('invokes onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: buildNote(),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NoteCard));
      expect(tapped, true);
    });

    testWidgets('omits image section when imageUrl is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(imageUrl: null)),
          ),
        ),
      );

      expect(find.byType(Image), findsNothing);
    });

    testWidgets('omits image section when imageUrl is empty string', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(imageUrl: '')),
          ),
        ),
      );

      expect(find.byType(Image), findsNothing);
    });
  });
}
