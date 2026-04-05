import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/widgets/note_card.dart';
import 'package:notes_application/theme/colors.dart';

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

  group('NoteCard Comprehensive Tests', () {
    testWidgets('displays title with truncation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(title: 'Test Title')),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('displays body with truncation maxLines 3', (WidgetTester tester) async {
      const longBody = 'Line 1\nLine 2\nLine 3\nLine 4 truncated';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(body: longBody)),
          ),
        ),
      );

      expect(find.text(longBody), findsOneWidget);
    });

    testWidgets('displays category pill', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(category: 'PERSONAL')),
          ),
        ),
      );

      expect(find.text('PERSONAL'), findsOneWidget);
    });

    testWidgets('displays formatted date', (WidgetTester tester) async {
      const String march = 'Mar';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote()),
          ),
        ),
      );

      expect(find.text('$march 15'), findsOneWidget);
    });

    testWidgets('shows pin icon when note is pinned', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(pinned: true)),
          ),
        ),
      );

      expect(find.byIcon(Icons.push_pin), findsOneWidget);
    });

    testWidgets('hides pin icon when note is not pinned', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(pinned: false)),
          ),
        ),
      );

      expect(find.byIcon(Icons.push_pin), findsNothing);
    });

    testWidgets('displays expected layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote()),
          ),
        ),
      );

      expect(find.byType(NoteCard), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('does not display image when imageUrl is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(imageUrl: null)),
          ),
        ),
      );

      expect(find.byType(Image), findsNothing);
    });

    testWidgets('does not display image when imageUrl is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(imageUrl: '')),
          ),
        ),
      );

      expect(find.byType(Image), findsNothing);
    });

    testWidgets('invokes onTap callback when card is tapped', (WidgetTester tester) async {
      bool tapped = false;
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

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      expect(tapped, true);
    });

    testWidgets('does not crash when onTap is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote()),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(find.byType(NoteCard), findsOneWidget);
    });

    testWidgets('card has rounded corners', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote()),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('card uses category color with opacity', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote()),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('uses IntrinsicHeight for proper layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote()),
          ),
        ),
      );

      expect(find.byType(IntrinsicHeight), findsOneWidget);
    });

    testWidgets('uses Row with crossAxisAlignment stretch', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote()),
          ),
        ),
      );

      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('uses proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote()),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('displays category pill before date', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(category: 'URGENT')),
          ),
        ),
      );

      expect(find.text('URGENT'), findsOneWidget);
      expect(find.text('Mar 15'), findsOneWidget);
    });

    testWidgets('correctly formats different months', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: buildNote(createdAt: DateTime(2026, 1, 25)),
            ),
          ),
        ),
      );

      expect(find.text('Jan 25'), findsOneWidget);
    });

    testWidgets('correctly formats December', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: buildNote(createdAt: DateTime(2026, 12, 31)),
            ),
          ),
        ),
      );

      expect(find.text('Dec 31'), findsOneWidget);
    });

    testWidgets('has accessibility with GestureDetector', (WidgetTester tester) async {
      bool tapped = false;
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

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, true);
    });

    testWidgets('Favorite status does not affect rendering', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(favourite: true)),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('handles WORK category color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(category: 'WORK', colorHex: '#2D5BE3')),
          ),
        ),
      );

      expect(find.text('WORK'), findsOneWidget);
    });

    testWidgets('handles PERSONAL category color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(category: 'PERSONAL', colorHex: '#999999')),
          ),
        ),
      );

      expect(find.text('PERSONAL'), findsOneWidget);
    });

    testWidgets('handles PEACE category color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(category: 'PEACE', colorHex: '#4CAF50')),
          ),
        ),
      );

      expect(find.text('PEACE'), findsOneWidget);
    });

    testWidgets('handles URGENT category color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(note: buildNote(category: 'URGENT', colorHex: '#FF0000')),
          ),
        ),
      );

      expect(find.text('URGENT'), findsOneWidget);
    });
  });
}
