import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/models/note_model.dart';

void main() {
  group('Note Model Tests', () {
    test('creates note with all required fields', () {
      final now = DateTime.now();
      final note = Note(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: now,
        updatedAt: now,
        isPinned: false,
        isFavourite: false,
      );

      expect(note.id, 'test-id');
      expect(note.title, 'Test Title');
      expect(note.body, 'Test Body');
      expect(note.category, 'WORK');
      expect(note.colorHex, '#1A73E8');
      expect(note.createdAt, now);
      expect(note.updatedAt, now);
      expect(note.isPinned, false);
      expect(note.isFavourite, false);
    });

    test('copyWith creates new note with updated fields', () {
      final originalNote = Note(
        id: 'original-id',
        title: 'Original Title',
        body: 'Original Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isPinned: false,
        isFavourite: false,
      );

      final updatedNote = originalNote.copyWith(
        title: 'Updated Title',
        isPinned: true,
        category: 'PERSONAL',
      );

      expect(updatedNote.id, 'original-id'); // ID should remain unchanged
      expect(updatedNote.title, 'Updated Title'); // Title should be updated
      expect(updatedNote.body, 'Original Body'); // Body should remain unchanged
      expect(updatedNote.category, 'PERSONAL'); // Category should be updated
      expect(updatedNote.colorHex, '#1A73E8'); // Color should remain unchanged
      expect(updatedNote.createdAt, originalNote.createdAt); // Created date should remain unchanged
      expect(updatedNote.updatedAt, originalNote.updatedAt); // Updated date should remain unchanged
      expect(updatedNote.isPinned, true); // Pinned should be updated
      expect(updatedNote.isFavourite, false); // Favourite should remain unchanged
    });

    test('copyWith updates updatedAt when called', () {
      final originalNote = Note(
        id: 'original-id',
        title: 'Original Title',
        body: 'Original Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isPinned: false,
        isFavourite: false,
      );

      final updatedNote = originalNote.copyWith(
        title: 'Updated Title',
      );

      // updatedAt should be updated to current time
      expect(updatedNote.updatedAt.isAfter(originalNote.updatedAt), true);
    });

    test('fromJson creates note from valid Map', () {
      final json = {
        'id': 'test-id',
        'title': 'Test Title',
        'body': 'Test Body',
        'category': 'WORK',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
        'is_pinned': false,
        'is_favourite': true,
        'user_id': 'test-user-id',
      };

      final note = Note.fromJson(json);

      expect(note.id, 'test-id');
      expect(note.title, 'Test Title');
      expect(note.body, 'Test Body');
      expect(note.category, 'WORK');
      expect(note.isPinned, false);
      expect(note.isFavourite, true);
      expect(note.userId, 'test-user-id');
    });

    test('fromJson handles null values gracefully', () {
      final json = {
        'id': 'test-id',
        'title': null,
        'body': null,
        'category': 'WORK',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
        'is_pinned': null,
        'is_favourite': null,
        'user_id': 'test-user-id',
      };

      final note = Note.fromJson(json);

      expect(note.id, 'test-id');
      expect(note.title, ''); // Should default to empty string
      expect(note.body, ''); // Should default to empty string
      expect(note.category, 'WORK');
      expect(note.isPinned, false); // Should default to false
      expect(note.isFavourite, false); // Should default to false
      expect(note.userId, 'test-user-id');
    });

    test('toJson creates valid Map', () {
      final now = DateTime.now();
      final note = Note(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: now,
        updatedAt: now,
        isPinned: true,
        isFavourite: false,
        userId: 'test-user-id',
      );

      final json = note.toJson();

      expect(json['id'], 'test-id');
      expect(json['title'], 'Test Title');
      expect(json['body'], 'Test Body');
      expect(json['category'], 'WORK');
      expect(json['is_pinned'], true);
      expect(json['is_favourite'], false);
      expect(json['user_id'], 'test-user-id');
    });

    test('toSupabase creates valid Map for database', () {
      final now = DateTime.now();
      final note = Note(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: now,
        updatedAt: now,
        isPinned: true,
        isFavourite: false,
        userId: 'test-user-id',
      );

      final supabaseJson = note.toSupabase();

      expect(supabaseJson['id'], 'test-id');
      expect(supabaseJson['title'], 'Test Title');
      expect(supabaseJson['body'], 'Test Body');
      expect(supabaseJson['category'], 'WORK');
      expect(supabaseJson['is_pinned'], true);
      expect(supabaseJson['is_favourite'], false);
      expect(supabaseJson['user_id'], 'test-user-id');
      // Should not include colorHex for Supabase
      expect(supabaseJson.containsKey('colorHex'), false);
    });

    test('fromSupabase creates note from database response', () {
      final json = {
        'id': 'test-id',
        'title': 'Test Title',
        'body': 'Test Body',
        'category': 'WORK',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
        'is_pinned': false,
        'is_favourite': true,
        'user_id': 'test-user-id',
      };

      final note = Note.fromSupabase(json);

      expect(note.id, 'test-id');
      expect(note.title, 'Test Title');
      expect(note.body, 'Test Body');
      expect(note.category, 'WORK');
      expect(note.isPinned, false);
      expect(note.isFavourite, true);
      expect(note.userId, 'test-user-id');
    });

    test('fromSupabase handles null values gracefully', () {
      final json = {
        'id': 'test-id',
        'title': null,
        'body': null,
        'category': 'WORK',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
        'is_pinned': null,
        'is_favourite': null,
        'user_id': 'test-user-id',
      };

      final note = Note.fromSupabase(json);

      expect(note.id, 'test-id');
      expect(note.title, ''); // Should default to empty string
      expect(note.body, ''); // Should default to empty string
      expect(note.category, 'WORK');
      expect(note.isPinned, false); // Should default to false
      expect(note.isFavourite, false); // Should default to false
      expect(note.userId, 'test-user-id');
    });

    test('categoryColor returns correct Color', () {
      final workNote = Note(
        id: 'test-id',
        title: 'Test',
        body: 'Test',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      final color = workNote.categoryColor;
      expect(color.value, 0xFF1A73E8);
    });

    test('categoryColor handles unknown category', () {
      final unknownNote = Note(
        id: 'test-id',
        title: 'Test',
        body: 'Test',
        category: 'UNKNOWN_CATEGORY',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      final color = unknownNote.categoryColor;
      // Should return a default color for unknown categories
      expect(color.value, 0xFF000000);
    });

    test('equality works correctly', () {
      final note1 = Note(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      final note2 = Note(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      expect(note1 == note2, true);
      expect(note1.hashCode == note2.hashCode, true);
    });

    test('toString returns readable format', () {
      final note = Note(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPinned: false,
        isFavourite: false,
      );

      final stringRepresentation = note.toString();
      expect(stringRepresentation, contains('test-id'));
      expect(stringRepresentation, contains('Test Title'));
      expect(stringRepresentation, contains('WORK'));
    });
  });
}
