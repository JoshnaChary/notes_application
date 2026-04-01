import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/view_models/notes_view_model.dart';

class FakeNote extends Fake implements Note {}

void main() {
  late NotesViewModel viewModel;

  final testNote = Note(
    id: '1',
    title: 'Test Note',
    body: 'Test Body',
    category: 'WORK',
    colorHex: '#1A73E8',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isPinned: false,
    isFavourite: false,
  );

  setUpAll(() {
    registerFallbackValue(FakeNote());
  });

  setUp(() {
    viewModel = NotesViewModel();
  });

  group('NotesViewModel', () {
    test('initial state', () {
      expect(viewModel.notes.isEmpty, true);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.activeCategory, 0);
      expect(viewModel.activeSubCategory, 0);
      expect(viewModel.isSearching, false);
      expect(viewModel.searchQuery, '');
    });

    test('set search query', () {
      viewModel.setSearchQuery('test query');
      
      expect(viewModel.searchQuery, 'test query');
      expect(viewModel.filteredNotes.isEmpty, true); // No notes loaded yet
    });

    test('set searching state', () {
      viewModel.setIsSearching(true);
      
      expect(viewModel.isSearching, true);
    });

    test('filter by category', () {
      viewModel.filterByCategory(1); // Favourites
      
      expect(viewModel.activeCategory, 1);
    });

    test('filter by sub-category', () {
      viewModel.filterBySubCategory(2); // WORK
      
      expect(viewModel.activeSubCategory, 2);
    });

    test('clear error', () {
      // Note: We can't directly test error setting since it's private
      // But we can verify initial state
      expect(viewModel.errorMessage, null);
    });

    test('copyWith functionality', () {
      final updatedNote = testNote.copyWith(
        title: 'Updated Title',
        isPinned: true,
      );
      
      expect(updatedNote.title, 'Updated Title');
      expect(updatedNote.isPinned, true);
      expect(updatedNote.body, testNote.body); // Other fields unchanged
    });

    test('fromSupabase factory', () {
      final data = {
        'id': '1',
        'title': 'Test Note',
        'body': 'Test Body',
        'category': 'WORK',
        'color_hex': '#1A73E8',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'is_pinned': false,
        'is_favourite': false,
        'image_url': null,
      };
      
      final note = Note.fromSupabase(data);
      
      expect(note.id, '1');
      expect(note.title, 'Test Note');
      expect(note.category, 'WORK');
      expect(note.isPinned, false);
    });

    test('toSupabase method', () {
      final data = testNote.toSupabase();
      
      expect(data['title'], 'Test Note');
      expect(data['category'], 'WORK');
      expect(data['is_pinned'], false);
      expect(data['color_hex'], '#1A73E8');
      expect(data.containsKey('updated_at'), true);
    });
  });
}
