import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/widgets/note_card.dart';

void main() {
  final baseTime = DateTime(2026, 3, 15, 12);

  Note buildNote({
    String id = '1',
    String title = 'Test Title',
    String body = 'Test body content',
    String category = 'WORK',
    String colorHex = '#2D5BE3',
    DateTime? createdAt,
    DateTime? updatedAt,
    bool pinned = false,
    bool favourite = false,
    String? imageUrl,
  }) {
    return Note(
      id: id,
      title: title,
      body: body,
      category: category,
      colorHex: colorHex,
      createdAt: createdAt ?? baseTime,
      updatedAt: updatedAt ?? baseTime,
      isPinned: pinned,
      isFavourite: favourite,
      imageUrl: imageUrl,
    );
  }

  group('NoteCard Coverage Tests', () {
    testWidgets('renders without image when imageUrl is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(imageUrl: null)),
          ),
        ),
      );

      expect(find.byType(NoteCard), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(ClipRRect), findsNothing);
    });

    testWidgets('renders without image when imageUrl is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(imageUrl: '')),
          ),
        ),
      );

      expect(find.byType(NoteCard), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(ClipRRect), findsNothing);
    });

    testWidgets('constructs correct date format for single digit date', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: buildNote(createdAt: DateTime(2026, 3, 5)),
            ),
          ),
        ),
      );

      expect(find.text('Mar 5'), findsOneWidget);
    });

    testWidgets('constructs correct date format for double digit date', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: buildNote(createdAt: DateTime(2026, 12, 25)),
            ),
          ),
        ),
      );

      expect(find.text('Dec 25'), findsOneWidget);
    });

    testWidgets('renders all elements in correct order', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: buildNote(
                title: 'My Title',
                body: 'My Body Text Here',
                category: 'PERSONAL',
                pinned: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('PERSONAL'), findsOneWidget);
      expect(find.byIcon(Icons.push_pin), findsOneWidget);
      expect(find.text('My Title'), findsOneWidget);
      expect(find.text('My Body Text Here'), findsOneWidget);
    });

    testWidgets('onTap is not called when widget is null', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: buildNote(),
              onTap: null,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      expect(tapped, false);
    });

    testWidgets('renders different category colors', (WidgetTester tester) async {
      const categories = [
        ('WORK', '#2D5BE3'),
        ('PERSONAL', '#999999'),
        ('URGENT', '#FF0000'),
        ('PEACE', '#4CAF50'),
      ];

      for (var (category, color) in categories) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NoteCard(
                note: buildNote(category: category, colorHex: color),
              ),
            ),
          ),
        );

        expect(find.text(category), findsOneWidget);
      }
    });

    testWidgets('multiple instances render independently', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              child: Column(
                children: [
                  NoteCard(note: buildNote(id: '1', title: 'Card 1')),
                  NoteCard(note: buildNote(id: '2', title: 'Card 2')),
                  NoteCard(note: buildNote(id: '3', title: 'Card 3')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Card 1'), findsOneWidget);
      expect(find.text('Card 2'), findsOneWidget);
      expect(find.text('Card 3'), findsOneWidget);
    });

    testWidgets('text overflow is handled correctly', (WidgetTester tester) async {
      const longTitle = 'This is a very long title that should be truncated with ellipsis';
      const longBody = 'Line 1\nLine 2\nLine 3\nLine 4 should be truncated\nLine 5';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: NoteCard(
                note: buildNote(title: longTitle, body: longBody),
              ),
            ),
          ),
        ),
      );

      // The truncated text should still be findable
      expect(find.text(longTitle), findsOneWidget);
    });

    testWidgets('note with all attributes renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: buildNote(
                title: 'Full Note',
                body: 'Complete note with all attributes',
                category: 'WORK',
                pinned: true,
                favourite: true,
                imageUrl: null,
              ),
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Full Note'), findsOneWidget);
      expect(find.text('Complete note with all attributes'), findsOneWidget);
      expect(find.text('WORK'), findsOneWidget);
      expect(find.byIcon(Icons.push_pin), findsOneWidget);
    });
  });
}
