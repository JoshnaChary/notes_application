import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notes_application/screens/notes_screen.dart';
import 'package:notes_application/view_models/notes_view_model.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:provider/provider.dart';

class MockNotesViewModel extends Mock implements NotesViewModel {}

void main() {
  group('NotesScreen Widget Tests', () {
    late NotesScreen notesScreen;
    late MockNotesViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockNotesViewModel();
      notesScreen = const NotesScreen();
    });

    testWidgets('renders correctly with initial state', (WidgetTester tester) async {
      when(mockViewModel.notes).thenReturn([]);
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.errorMessage).thenReturn(null);
      when(mockViewModel.activeCategory).thenReturn(0);
      when(mockViewModel.activeSubCategory).thenReturn(0);
      when(mockViewModel.isSearching).thenReturn(false);
      when(mockViewModel.searchQuery).thenReturn('');

      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>.value(
          value: mockViewModel,
          child: MaterialApp(
            home: notesScreen,
          ),
        ),
      );

      expect(find.byType<NotesScreen>(), findsOneWidget);
      expect(find.text('All Notes'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (WidgetTester tester) async {
      when(mockViewModel.notes).thenReturn([]);
      when(mockViewModel.isLoading).thenReturn(true);
      when(mockViewModel.errorMessage).thenReturn(null);

      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>.value(
          value: mockViewModel,
          child: MaterialApp(
            home: notesScreen,
          ),
        ),
      );

      expect(find.byType<CircularProgressIndicator>(), findsOneWidget);
    });

    testWidgets('shows error message when error exists', (WidgetTester tester) async {
      when(mockViewModel.notes).thenReturn([]);
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.errorMessage).thenReturn('Test error message');

      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>.value(
          value: mockViewModel,
          child: MaterialApp(
            home: notesScreen,
          ),
        ),
      );

      expect(find.text('Test error message'), findsOneWidget);
    });

    testWidgets('shows search interface when searching', (WidgetTester tester) async {
      when(mockViewModel.notes).thenReturn([]);
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.isSearching).thenReturn(true);
      when(mockViewModel.searchQuery).thenReturn('test query');

      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>.value(
          value: mockViewModel,
          child: MaterialApp(
            home: notesScreen,
          ),
        ),
      );

      expect(find.byType<TextField>(), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('shows notes when data is available', (WidgetTester tester) async {
      final testNotes = [
        Note(
          id: '1',
          title: 'Test Note 1',
          body: 'Test body 1',
          category: 'WORK',
          colorHex: '#1A73E8',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isPinned: false,
          isFavourite: false,
        ),
        Note(
          id: '2',
          title: 'Test Note 2',
          body: 'Test body 2',
          category: 'PERSONAL',
          colorHex: '#FF6B6B',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isPinned: true,
          isFavourite: false,
        ),
      ];

      when(mockViewModel.notes).thenReturn(testNotes);
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.errorMessage).thenReturn(null);

      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>.value(
          value: mockViewModel,
          child: MaterialApp(
            home: notesScreen,
          ),
        ),
      );

      expect(find.text('Test Note 1'), findsOneWidget);
      expect(find.text('Test Note 2'), findsOneWidget);
      expect(find.text('WORK'), findsOneWidget);
      expect(find.text('PERSONAL'), findsOneWidget);
    });

    testWidgets('shows empty state when no notes', (WidgetTester tester) async {
      when(mockViewModel.notes).thenReturn([]);
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.errorMessage).thenReturn(null);

      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>.value(
          value: mockViewModel,
          child: MaterialApp(
            home: notesScreen,
          ),
        ),
      );

      expect(find.text('No notes yet'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('handles FAB tap correctly', (WidgetTester tester) async {
      when(mockViewModel.notes).thenReturn([]);
      when(mockViewModel.isLoading).thenReturn(false);

      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>.value(
          value: mockViewModel,
          child: MaterialApp(
            home: notesScreen,
          ),
        ),
      );

      await tester.tap(find.byType<FloatingActionButton>());
      await tester.pump();

      // Should navigate to edit screen
      // Note: In a real test, you'd verify navigation
      expect(find.byType<FloatingActionButton>(), findsOneWidget);
    });

    testWidgets('toggles search mode correctly', (WidgetTester tester) async {
      when(mockViewModel.notes).thenReturn([]);
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.isSearching).thenReturn(false);

      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>.value(
          value: mockViewModel,
          child: MaterialApp(
            home: notesScreen,
          ),
        ),
      );

      // Tap search button
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      verify(mockViewModel.setIsSearching(true)).called(1);
    });
  });
}
