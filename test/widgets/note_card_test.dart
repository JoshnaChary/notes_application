import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/widgets/note_card.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/theme/colors.dart';

void main() {
  group('NoteCard Widget Tests', () {
    final testNote = Note(
      id: '1',
      title: 'Test Note Title',
      body: 'Test note body content that is reasonably long to test truncation behavior',
      category: 'WORK',
      colorHex: '#1A73E8',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPinned: false,
      isFavourite: true,
    );

    testWidgets('renders note information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: testNote,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType<NoteCard>(), findsOneWidget);
      expect(find.text('TEST NOTE TITLE'), findsOneWidget);
      expect(find.text('Test note body content that is reasonably long'), findsOneWidget);
      expect(find.text('WORK'), findsOneWidget);
    });

    testWidgets('shows favourite indicator when isFavourite is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: testNote,
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(of: find.byType<NoteCard>()).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.accent);
    });

    testWidgets('shows pin indicator when isPinned is true', (WidgetTester tester) async {
      final pinnedNote = testNote.copyWith(isPinned: true);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: pinnedNote,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.push_pin), findsOneWidget);
    });

    testWidgets('handles tap callback correctly', (WidgetTester tester) async {
      bool tapCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: testNote,
              onTap: () => tapCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType<NoteCard>());
      await tester.pump();

      expect(tapCalled, true);
    });

    testWidgets('applies correct background color from category', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: testNote,
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(of: find.byType<NoteCard>()).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, testNote.categoryColor.withValues(alpha: 0.1));
    });

    testWidgets('truncates long title correctly', (WidgetTester tester) async {
      final longTitleNote = testNote.copyWith(
        title: 'This is a very long note title that should definitely be truncated when displayed in the note card widget to test the maxLines and overflow properties',
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: longTitleNote,
              onTap: () {},
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.descendant(
        of: find.byType<NoteCard>(),
        matching: (widget) => widget.data is Text,
      ).first);
      expect(text.maxLines, 2);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('truncates long body correctly', (WidgetTester tester) async {
      final longBodyNote = testNote.copyWith(
        body: 'This is a very long note body that should definitely be truncated when displayed in the note card widget to test the maxLines and overflow properties for the body text field',
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: longBodyNote,
              onTap: () {},
            ),
          ),
        ),
      );

      // Find the body text (should be the second Text widget)
      final bodyText = tester.widget<Text>(find.descendant(
        of: find.byType<NoteCard>(),
        matching: (widget) => widget.data is Text,
      ).at(1));
      expect(bodyText.maxLines, 3);
      expect(bodyText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('handles null onTap gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: testNote,
              onTap: null,
            ),
          ),
        ),
      );

      expect(find.byType<NoteCard>(), findsOneWidget);
      
      // Should not crash when tapped
      await tester.tap(find.byType<NoteCard>());
      await tester.pump();
    });

    testWidgets('debugFillProperties works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCard(
              note: testNote,
              onTap: () {},
            ),
          ),
        ),
      );

      final noteCard = tester.widget<NoteCard>(find.byType<NoteCard>());
      expect(noteCard.toString(), contains('note'));
      expect(noteCard.toString(), contains('onTap'));
    });
  });
}
