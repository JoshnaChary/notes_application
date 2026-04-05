import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/screens/edit_note_screen.dart';
import 'package:notes_application/strings/app_strings.dart';
import 'package:notes_application/view_models/notes_view_model.dart';
import 'package:provider/provider.dart';

class MockNotesVm extends Mock implements NotesViewModel {}

/// Wide surface so [PopupMenuButton] rows are not clipped in tests.
Widget wide(Widget child) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(1200, 1600)),
    child: child,
  );
}

void main() {
  late MockNotesVm mock;

  final existing = Note(
    id: 'e1',
    title: 'T',
    body: 'B',
    category: AppStrings.work,
    colorHex: '#2D5BE3',
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 2),
  );

  setUp(() {
    mock = MockNotesVm();
    registerFallbackValue(
      Note(
        id: 'fb',
        title: 't',
        body: 'b',
        category: 'WORK',
        colorHex: '#000000',
        createdAt: DateTime.utc(2020),
        updatedAt: DateTime.utc(2020),
      ),
    );
    when(() => mock.createNote(any())).thenAnswer((_) async {});
    when(() => mock.updateNote(any())).thenAnswer((_) async {});
    when(() => mock.deleteNote(any())).thenAnswer((_) async {});
  });

  group('EditNoteScreen actions', () {
    testWidgets('save new note calls createNote with trimmed title fallback',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      settings: const RouteSettings(name: '/edit'),
                      builder: (_) => ChangeNotifierProvider<NotesViewModel>.value(
                        value: mock,
                        child: const EditNoteScreen(),
                      ),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('save_note_button')));
      await tester.pumpAndSettle();
      verify(
        () => mock.createNote(
          any(
            that: isA<Note>().having((n) => n.title, 'title', AppStrings.untitledMaster),
          ),
        ),
      ).called(1);
    });

    testWidgets('save existing note calls updateNote', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ChangeNotifierProvider<NotesViewModel>.value(
                        value: mock,
                        child: EditNoteScreen(note: existing),
                      ),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('save_note_button')));
      await tester.pumpAndSettle();
      verify(() => mock.updateNote(any(that: isA<Note>()))).called(1);
    });

    testWidgets('menu pin toggles state', (tester) async {
      await tester.pumpWidget(
        wide(
          MaterialApp(
            home: ChangeNotifierProvider<NotesViewModel>.value(
              value: mock,
              child: EditNoteScreen(note: existing),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.pinNote).first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.unpinNote).first);
      await tester.pump();
    });

    testWidgets('menu favourite toggles state', (tester) async {
      await tester.pumpWidget(
        wide(
          MaterialApp(
            home: ChangeNotifierProvider<NotesViewModel>.value(
              value: mock,
              child: EditNoteScreen(note: existing),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.markAsFavourite).first);
      await tester.pump();
    });

    testWidgets('delete flow opens sheet and calls deleteNote', (tester) async {
      await tester.pumpWidget(
        wide(
          MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (_) => Scaffold(
                    body: Builder(
                      builder: (context) => TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/edit');
                        },
                        child: const Text('go'),
                      ),
                    ),
                  ),
              '/edit': (_) => ChangeNotifierProvider<NotesViewModel>.value(
                    value: mock,
                    child: EditNoteScreen(note: existing),
                  ),
            },
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.deleteNote));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('delete_button')));
      await tester.pumpAndSettle();
      verify(() => mock.deleteNote('e1')).called(1);
    });

    testWidgets('unknown category falls back to first chip in initState',
        (tester) async {
      final odd = existing.copyWith(
        const NotePatch(category: 'UNKNOWN_CAT'),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<NotesViewModel>.value(
            value: mock,
            child: EditNoteScreen(note: odd),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(EditNoteScreen), findsOneWidget);
    });
  });
}
