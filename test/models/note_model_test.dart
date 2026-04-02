import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/models/note_model.dart';

void main() {
  group('Note', () {
    test('creates note with valid data', () {
      final now = DateTime(2026, 1, 1, 12);
      final note = Note(
        id: '1',
        title: 'Title',
        body: 'Body',
        category: 'WORK',
        colorHex: '#FF0000',
        createdAt: now,
        updatedAt: now,
        isPinned: true,
        isFavourite: false,
        imageUrl: null,
      );

      expect(note.id, '1');
      expect(note.title, 'Title');
      expect(note.body, 'Body');
      expect(note.category, 'WORK');
      expect(note.colorHex, '#FF0000');
      expect(note.createdAt, now);
      expect(note.updatedAt, now);
      expect(note.isPinned, true);
      expect(note.isFavourite, false);
      expect(note.imageUrl, isNull);
    });

    test('allows empty title/body (no validation at model level)', () {
      final now = DateTime(2026, 1, 1, 12);
      final note = Note(
        id: '1',
        title: '',
        body: '',
        category: 'WORK',
        colorHex: '#000000',
        createdAt: now,
        updatedAt: now,
      );

      expect(note.title, isEmpty);
      expect(note.body, isEmpty);
    });

    test('categoryColor parses ARGB hex string', () {
      final now = DateTime(2026, 1, 1, 12);
      final note = Note(
        id: '1',
        title: 't',
        body: 'b',
        category: 'WORK',
        colorHex: '#1A73E8',
        createdAt: now,
        updatedAt: now,
      );

      expect(note.categoryColor, const Color(0xFF1A73E8));
    });

    test('copyWith updates only specified fields', () {
      final now = DateTime(2026, 1, 1, 12);
      final note = Note(
        id: '1',
        title: 'Title',
        body: 'Body',
        category: 'WORK',
        colorHex: '#FF0000',
        createdAt: now,
        updatedAt: now,
        isPinned: false,
        isFavourite: false,
      );

      final updated = note.copyWith(
        title: 'New Title',
        isPinned: true,
      );

      expect(updated.id, '1');
      expect(updated.title, 'New Title');
      expect(updated.body, 'Body');
      expect(updated.isPinned, true);
      expect(updated.isFavourite, false);
    });

    test('toJson includes id when not empty', () {
      final now = DateTime(2026, 1, 1, 12);
      final note = Note(
        id: '123',
        title: 'Title',
        body: 'Body',
        category: 'WORK',
        colorHex: '#FF0000',
        createdAt: now,
        updatedAt: now,
        isPinned: true,
        isFavourite: true,
        imageUrl: 'https://example.com/a.png',
      );

      final json = note.toJson();
      expect(json['id'], '123');
      expect(json['title'], 'Title');
      expect(json['body'], 'Body');
      expect(json['category'], 'WORK');
      expect(json['color_hex'], '#FF0000');
      expect(json['is_pinned'], true);
      expect(json['is_favourite'], true);
      expect(json['image_url'], 'https://example.com/a.png');
    });

    test('toJson omits id when empty', () {
      final now = DateTime(2026, 1, 1, 12);
      final note = Note(
        id: '',
        title: 'Title',
        body: 'Body',
        category: 'WORK',
        colorHex: '#FF0000',
        createdAt: now,
        updatedAt: now,
      );

      final json = note.toJson();
      expect(json.containsKey('id'), false);
    });

    test('fromJson defaults isPinned/isFavourite when missing', () {
      final json = <String, dynamic>{
        'id': '1',
        'title': 'Title',
        'body': 'Body',
        'category': 'WORK',
        'color_hex': '#FF0000',
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-02T00:00:00Z',
        'image_url': null,
      };

      final note = Note.fromJson(json);
      expect(note.isPinned, false);
      expect(note.isFavourite, false);
      expect(note.id, '1');
      expect(note.title, 'Title');
    });

    test('toSupabase emits updated_at in UTC', () {
      final updatedAtLocal = DateTime(2026, 1, 2, 10, 30); // local
      final note = Note(
        id: '1',
        title: 'Title',
        body: 'Body',
        category: 'WORK',
        colorHex: '#FF0000',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: updatedAtLocal,
      );

      final supa = note.toSupabase();
      expect(supa['updated_at'], updatedAtLocal.toUtc().toIso8601String());
      expect(supa.containsKey('id'), false);
      expect(supa['title'], 'Title');
    });

    test('fromSupabase matches expected field mapping', () {
      final data = <String, dynamic>{
        'id': '1',
        'title': 'Title',
        'body': 'Body',
        'category': 'WORK',
        'color_hex': '#FF0000',
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-02T00:00:00Z',
        'is_pinned': true,
        'is_favourite': true,
        'image_url': 'https://example.com/img.png',
      };

      final note = Note.fromSupabase(data);
      expect(note.id, '1');
      expect(note.isPinned, true);
      expect(note.isFavourite, true);
      expect(note.imageUrl, 'https://example.com/img.png');
    });
  });
}

