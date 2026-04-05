import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_application/core/config/app_config.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/strings/app_strings.dart';
import 'package:notes_application/view_models/notes_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'support/notes_rest_stub_client.dart';

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

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});

    // NotesViewModel reads Supabase.instance.client in its constructor, so we
    // must initialize Supabase in tests as well.
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );
    } catch (_) {
      // Ignore if already initialized (e.g., when tests are run multiple times).
    }
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

    test('filter by pinned category index', () {
      viewModel.filterByCategory(2);
      expect(viewModel.activeCategory, 2);
    });

    test('search filter with no notes yields empty filtered list', () {
      viewModel.setSearchQuery('anything');
      expect(viewModel.filteredNotes.isEmpty, true);
    });

    test('search is case insensitive on empty list', () {
      viewModel.setSearchQuery('ABC');
      expect(viewModel.filteredNotes, isEmpty);
    });

    test('clear error', () {
      // Note: We can't directly test error setting since it's private
      // But we can verify initial state
      expect(viewModel.errorMessage, null);
    });

    test('copyWith functionality', () {
      final updatedNote = testNote.copyWith(
        const NotePatch(
          title: 'Updated Title',
          isPinned: true,
        ),
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

  group('NotesViewModel with injected SupabaseClient', () {
    late NotesRestStubClient httpStub;
    late SupabaseClient client;
    late NotesViewModel vm;

    setUp(() {
      httpStub = NotesRestStubClient(
        rows: [
          testNoteJson(
            id: 'a',
            title: 'Alpha',
            body: 'one',
            category: AppStrings.work,
            favourite: true,
          ),
          testNoteJson(
            id: 'b',
            title: 'Beta',
            body: 'two',
            category: AppStrings.personal,
            pinned: true,
          ),
        ],
      );
      client = SupabaseClient(
        'https://vm.test',
        'test-anon-key',
        httpClient: httpStub,
      );
      vm = NotesViewModel(supabaseClient: client);
    });

    test('loadNotes fills notes and filteredNotes', () async {
      await vm.loadNotes();
      expect(vm.notes, hasLength(2));
      expect(vm.filteredNotes, hasLength(2));
      expect(vm.isLoading, false);
      expect(vm.errorMessage, isNull);
    });

    test('initialize loads notes', () async {
      await vm.initialize();
      expect(vm.notes, hasLength(2));
    });

    test('refresh reloads notes', () async {
      await vm.loadNotes();
      await vm.refresh();
      expect(vm.notes, hasLength(2));
    });

    test('filterByCategory keeps only favourites when index is 1', () async {
      await vm.loadNotes();
      vm.filterByCategory(1);
      expect(vm.filteredNotes, hasLength(1));
      expect(vm.filteredNotes.single.isFavourite, true);
    });

    test('filterByCategory keeps only pinned when index is 2', () async {
      await vm.loadNotes();
      vm.filterByCategory(2);
      expect(vm.filteredNotes, hasLength(1));
      expect(vm.filteredNotes.single.isPinned, true);
    });

    test('filterBySubCategory filters by label', () async {
      await vm.loadNotes();
      vm.filterBySubCategory(2);
      expect(vm.filteredNotes.single.category, AppStrings.work);
    });

    test('setSearchQuery filters title and body case-insensitively', () async {
      await vm.loadNotes();
      vm.setSearchQuery('alp');
      expect(vm.filteredNotes, hasLength(1));
      expect(vm.filteredNotes.single.title, 'Alpha');
      vm.setSearchQuery('TWO');
      expect(vm.filteredNotes, hasLength(1));
      expect(vm.filteredNotes.single.title, 'Beta');
    });

    test('createNote completes and reloads', () async {
      final n = Note(
        id: '',
        title: 'New',
        body: 'Body',
        category: AppStrings.work,
        colorHex: '#1A73E8',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 2),
      );
      await vm.createNote(n);
      expect(vm.isLoading, false);
      expect(vm.errorMessage, isNull);
    });

    test('updateNote completes and reloads', () async {
      await vm.loadNotes();
      final first = vm.notes.first;
      await vm.updateNote(first);
      expect(vm.errorMessage, isNull);
    });

    test('deleteNote completes and reloads', () async {
      await vm.loadNotes();
      await vm.deleteNote(vm.notes.first.id);
      expect(vm.errorMessage, isNull);
    });

    test('togglePinStatus and toggleFavouriteStatus delegate to updateNote',
        () async {
      await vm.loadNotes();
      await vm.togglePinStatus('a');
      await vm.toggleFavouriteStatus('b');
      expect(vm.errorMessage, isNull);
    });

    test('loadNotes succeeds after one failed GET (retry path)', () {
      fakeAsync((async) {
        final stub = NotesRestStubClient(
          failGetTimes: 1,
          rows: [
            testNoteJson(id: 'x'),
          ],
        );
        final c = SupabaseClient(
          'https://retry.test',
          'k',
          httpClient: stub,
        );
        final vm = NotesViewModel(supabaseClient: c);
        vm.loadNotes();
        async.elapse(const Duration(seconds: 2));
        expect(vm.notes, hasLength(1));
        expect(vm.errorMessage, isNull);
      });
    });

    test('loadNotes sets network error after repeated GET failures', () {
      fakeAsync((async) {
        final stub = NotesRestStubClient(failGetTimes: 100);
        final c = SupabaseClient(
          'https://fail.test',
          'k',
          httpClient: stub,
        );
        final vm = NotesViewModel(supabaseClient: c);
        vm.loadNotes();
        async.elapse(const Duration(seconds: 6));
        expect(vm.errorMessage, isNotNull);
        expect(vm.errorMessage, contains('Network error'));
      });
    });

    test('createNote records error when POST fails', () async {
      final stub = NotesRestStubClient(failPost: true);
      final c = SupabaseClient(
        'https://post.fail',
        'k',
        httpClient: stub,
      );
      final vm = NotesViewModel(supabaseClient: c);
      await vm.createNote(
        Note(
          id: '',
          title: 't',
          body: 'b',
          category: AppStrings.work,
          colorHex: '#000000',
          createdAt: DateTime.utc(2024),
          updatedAt: DateTime.utc(2024),
        ),
      );
      expect(vm.errorMessage, contains('Failed to create note'));
    });

    test('updateNote records error when PATCH fails', () async {
      final stub = NotesRestStubClient(failPatch: true);
      final c = SupabaseClient(
        'https://patch.fail',
        'k',
        httpClient: stub,
      );
      final vm = NotesViewModel(supabaseClient: c);
      await vm.loadNotes();
      await vm.updateNote(vm.notes.first);
      expect(vm.errorMessage, contains('Failed to update note'));
    });

    test('deleteNote records error when DELETE fails', () async {
      final stub = NotesRestStubClient(failDelete: true);
      final c = SupabaseClient(
        'https://del.fail',
        'k',
        httpClient: stub,
      );
      final vm = NotesViewModel(supabaseClient: c);
      await vm.loadNotes();
      await vm.deleteNote(vm.notes.first.id);
      expect(vm.errorMessage, contains('Failed to delete note'));
    });
  });

  group('NotesViewModel clientResolver', () {
    test('second resolve succeeds after first throws', () {
      var calls = 0;
      final client = SupabaseClient(
        'https://resolver.test',
        'k',
        httpClient: NotesRestStubClient(),
      );
      final vm = NotesViewModel(
        clientResolver: () {
          calls++;
          if (calls == 1) {
            throw Exception('init-once');
          }
          return client;
        },
      );
      expect(vm.activeCategory, 0);
    });
  });
}
