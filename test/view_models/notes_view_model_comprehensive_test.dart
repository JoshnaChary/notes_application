import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/view_models/notes_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabase extends Mock implements SupabaseClient {}

void main() {
  group('NotesViewModel Comprehensive Tests', () {
    late NotesViewModel viewModel;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues(<String, Object>{});
      
      // Mock Supabase
      try {
        await Supabase.initialize(
          url: 'https://test.supabase.co',
          anonKey: 'test-key',
        );
      } catch (_) {
        // Ignore if already initialized
      }
    });

    setUp(() {
      viewModel = NotesViewModel();
    });

    tearDown(() async {
      // Clean up any test data
    });

    test('creates note with valid data', () async {
      final testNote = Note(
        id: 'test-id',
        title: 'Test Note',
        body: 'Test Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      // Mock successful creation
      await viewModel.createNote(testNote);

      expect(viewModel.notes.length, 1);
      expect(viewModel.notes.first.title, 'Test Note');
    });

    test('handles empty note title gracefully', () async {
      final testNote = Note(
        id: 'test-id',
        title: '',
        body: 'Test Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      await viewModel.createNote(testNote);

      expect(viewModel.notes.length, 1);
      expect(viewModel.notes.first.title, '');
    });

    test('updates existing note', () async {
      final testNote = Note(
        id: 'test-id',
        title: 'Original Title',
        body: 'Original Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      // First create the note
      await viewModel.createNote(testNote);
      
      // Update the note
      final updatedNote = testNote.copyWith(
        title: 'Updated Title',
        body: 'Updated Body',
      );
      
      await viewModel.updateNote(updatedNote);

      expect(viewModel.notes.length, 1);
      expect(viewModel.notes.first.title, 'Updated Title');
      expect(viewModel.notes.first.body, 'Updated Body');
    });

    test('deletes note successfully', () async {
      final testNote = Note(
        id: 'test-id',
        title: 'Test Note',
        body: 'Test Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      await viewModel.createNote(testNote);
      expect(viewModel.notes.length, 1);

      await viewModel.deleteNote(testNote.id);
      expect(viewModel.notes.length, 0);
    });

    test('toggles pin status correctly', () async {
      final testNote = Note(
        id: 'test-id',
        title: 'Test Note',
        body: 'Test Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      await viewModel.createNote(testNote);
      expect(viewModel.notes.first.isPinned, false);

      await viewModel.togglePinStatus(testNote.id);
      expect(viewModel.notes.first.isPinned, true);

      await viewModel.togglePinStatus(testNote.id);
      expect(viewModel.notes.first.isPinned, false);
    });

    test('toggles favourite status correctly', () async {
      final testNote = Note(
        id: 'test-id',
        title: 'Test Note',
        body: 'Test Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      await viewModel.createNote(testNote);
      expect(viewModel.notes.first.isFavourite, false);

      await viewModel.toggleFavouriteStatus(testNote.id);
      expect(viewModel.notes.first.isFavourite, true);

      await viewModel.toggleFavouriteStatus(testNote.id);
      expect(viewModel.notes.first.isFavourite, false);
    });

    test('filters by main category correctly', () async {
      final workNote = Note(
        id: 'work-id',
        title: 'Work Note',
        body: 'Work Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: true, // This is a favourite
      );

      final personalNote = Note(
        id: 'personal-id',
        title: 'Personal Note',
        body: 'Personal Body',
        category: 'PERSONAL',
        colorHex: '#FF6B6B',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: true, // This is pinned
        isFavourite: false,
      );

      await viewModel.createNote(workNote);
      await viewModel.createNote(personalNote);

      // Test filtering by favourites
      viewModel.filterByCategory(1); // Favourites category
      expect(viewModel.filteredNotes.length, 1);
      expect(viewModel.filteredNotes.first.id, 'work-id');

      // Test filtering by pinned
      viewModel.filterByCategory(2); // Pinned category
      expect(viewModel.filteredNotes.length, 1);
      expect(viewModel.filteredNotes.first.id, 'personal-id');

      // Reset to all
      viewModel.filterByCategory(0); // All category
      expect(viewModel.filteredNotes.length, 2);
    });

    test('filters by sub-category correctly', () async {
      final workNote = Note(
        id: 'work-id',
        title: 'Work Note',
        body: 'Work Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      final personalNote = Note(
        id: 'personal-id',
        title: 'Personal Note',
        body: 'Personal Body',
        category: 'PERSONAL',
        colorHex: '#FF6B6B',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      final urgentNote = Note(
        id: 'urgent-id',
        title: 'Urgent Note',
        body: 'Urgent Body',
        category: 'URGENT',
        colorHex: '#FF4444',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      await viewModel.createNote(workNote);
      await viewModel.createNote(personalNote);
      await viewModel.createNote(urgentNote);

      // Test filtering by WORK sub-category
      viewModel.filterBySubCategory(2); // WORK sub-category
      expect(viewModel.filteredNotes.length, 1);
      expect(viewModel.filteredNotes.first.id, 'work-id');

      // Test filtering by PERSONAL sub-category
      viewModel.filterBySubCategory(1); // PERSONAL sub-category
      expect(viewModel.filteredNotes.length, 1);
      expect(viewModel.filteredNotes.first.id, 'personal-id');

      // Test filtering by URGENT sub-category
      viewModel.filterBySubCategory(3); // URGENT sub-category
      expect(viewModel.filteredNotes.length, 1);
      expect(viewModel.filteredNotes.first.id, 'urgent-id');
    });

    test('search functionality works correctly', () async {
      final workNote = Note(
        id: 'work-id',
        title: 'Work Project',
        body: 'Complete the work project',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      final personalNote = Note(
        id: 'personal-id',
        title: 'Personal Meeting',
        body: 'Meeting with team',
        category: 'PERSONAL',
        colorHex: '#FF6B6B',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      await viewModel.createNote(workNote);
      await viewModel.createNote(personalNote);

      // Test search by title
      viewModel.setSearchQuery('work');
      expect(viewModel.filteredNotes.length, 1);
      expect(viewModel.filteredNotes.first.id, 'work-id');

      // Test search by body
      viewModel.setSearchQuery('meeting');
      expect(viewModel.filteredNotes.length, 1);
      expect(viewModel.filteredNotes.first.id, 'personal-id');

      // Test search case insensitive
      viewModel.setSearchQuery('WORK');
      expect(viewModel.filteredNotes.length, 1);
      expect(viewModel.filteredNotes.first.id, 'work-id');

      // Test search with no results
      viewModel.setSearchQuery('nonexistent');
      expect(viewModel.filteredNotes.length, 0);

      // Clear search
      viewModel.setSearchQuery('');
      expect(viewModel.filteredNotes.length, 2);
    });

    test('handles error states correctly', () async {
      // Test initial error state
      expect(viewModel.errorMessage, null);
      expect(viewModel.isLoading, false);

      // Test error setting
      viewModel._setError('Test error message');
      expect(viewModel.errorMessage, 'Test error message');

      // Test error clearing
      viewModel._clearError();
      expect(viewModel.errorMessage, null);
    });

    test('loading state management', () async {
      // Test initial loading state
      expect(viewModel.isLoading, false);

      // Test setting loading state
      viewModel._setLoading(true);
      expect(viewModel.isLoading, true);

      // Test clearing loading state
      viewModel._setLoading(false);
      expect(viewModel.isLoading, false);
    });

    test('combined filtering works correctly', () async {
      final workNote = Note(
        id: 'work-id',
        title: 'Work Project',
        body: 'Complete the work project',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: true, // This is a favourite
      );

      final personalNote = Note(
        id: 'personal-id',
        title: 'Personal Meeting',
        body: 'Meeting with team',
        category: 'PERSONAL',
        colorHex: '#FF6B6B',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: true, // This is pinned
        isFavourite: false,
      );

      await viewModel.createNote(workNote);
      await viewModel.createNote(personalNote);

      // Apply main category filter (favourites)
      viewModel.filterByCategory(1);
      expect(viewModel.filteredNotes.length, 1);

      // Apply sub-category filter (WORK)
      viewModel.filterBySubCategory(2);
      expect(viewModel.filteredNotes.length, 0); // Work note not in favourites

      // Apply search filter
      viewModel.setSearchQuery('meeting');
      expect(viewModel.filteredNotes.length, 0); // No favourites contain 'meeting'

      // Reset filters
      viewModel.filterByCategory(0);
      viewModel.filterBySubCategory(0);
      viewModel.setSearchQuery('');
      expect(viewModel.filteredNotes.length, 2);
    });
  });
}
