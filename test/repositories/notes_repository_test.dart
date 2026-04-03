import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/repositories/notes_repository.dart';
import '../support/notes_rest_stub_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('NotesRepository', () {
    late SupabaseClient supabase;
    late NotesRepository repo;

    final t0 = DateTime.utc(2024, 6, 1, 12);
    final t1 = DateTime.utc(2024, 6, 2, 12);

    Map<String, dynamic> sampleRow() {
      return {
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'title': 'Hello',
        'body': 'World',
        'category': 'WORK',
        'color_hex': '#FF0000',
        'created_at': t0.toIso8601String(),
        'updated_at': t1.toIso8601String(),
        'is_pinned': false,
        'is_favourite': false,
        'image_url': null,
      };
    }

    Note sampleNote() {
      final m = sampleRow();
      return Note(
        id: m['id'] as String,
        title: m['title'] as String,
        body: m['body'] as String,
        category: m['category'] as String,
        colorHex: m['color_hex'] as String,
        createdAt: DateTime.parse(m['created_at'] as String).toLocal(),
        updatedAt: DateTime.parse(m['updated_at'] as String).toLocal(),
        isPinned: m['is_pinned'] as bool,
        isFavourite: m['is_favourite'] as bool,
        imageUrl: m['image_url'] as String?,
      );
    }

    setUp(() {
      supabase = SupabaseClient(
        'https://test.local',
        'test-anon-key',
        httpClient: NotesRestStubClient(),
      );
      repo = NotesRepository(client: supabase);
    });

    test('createNote inserts user_id and returns Note from response', () async {
      final note = sampleNote();
      note.id = '';

      final created = await repo.createNote(note);

      expect(created.id, sampleRow()['id']);
      expect(created.title, 'Hello');
    });

    test('getAllNotes returns list mapped to Note', () async {
      final list = await repo.getAllNotes();
      expect(list, hasLength(1));
      expect(list.first.category, 'WORK');
    });

    test('getPinnedNotes calls filters and maps rows', () async {
      final list = await repo.getPinnedNotes();
      expect(list, hasLength(1));
    });

    test('getFavouriteNotes calls filters and maps rows', () async {
      final list = await repo.getFavouriteNotes();
      expect(list, hasLength(1));
    });

    test('getNotesByCategory passes category to query', () async {
      final list = await repo.getNotesByCategory('WORK');
      expect(list, hasLength(1));
    });

    test('searchNotes builds query and maps rows', () async {
      final list = await repo.searchNotes('hello');
      expect(list, hasLength(1));
    });

    test('updateNote sends patch and returns Note', () async {
      final note = sampleNote();
      final updated = await repo.updateNote(note);
      expect(updated.id, note.id);
    });

    test('togglePin updates row and returns Note', () async {
      final n = await repo.togglePin(sampleRow()['id'] as String, true);
      expect(n.id, sampleRow()['id']);
    });

    test('toggleFavourite updates row and returns Note', () async {
      final n = await repo.toggleFavourite(sampleRow()['id'] as String, true);
      expect(n.id, sampleRow()['id']);
    });

    test('deleteNote completes without error', () async {
      await expectLater(
        repo.deleteNote(sampleRow()['id'] as String),
        completes,
      );
    });
  });
}
