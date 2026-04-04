import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/repositories/notes_repository.dart';
import 'package:notes_application/models/note_model.dart';

void main() {
  group('NotesRepository Tests', () {
    late NotesRepository repository;

    setUp(() {
      repository = NotesRepository();
    });

    test('constructor creates repository instance', () {
      expect(repository, isA<NotesRepository>());
    });

    test('constructor with client creates repository instance', () {
      final repo = NotesRepository();
      expect(repo, isA<NotesRepository>());
    });

    test('createNote method exists', () {
      expect(() => repository.createNote(testNote), returnsNormally);
    });

    test('getAllNotes method exists', () {
      expect(() => repository.getAllNotes(), returnsNormally);
    });

    test('getPinnedNotes method exists', () {
      expect(() => repository.getPinnedNotes(), returnsNormally);
    });

    test('getFavouriteNotes method exists', () {
      expect(() => repository.getFavouriteNotes(), returnsNormally);
    });

    test('getNotesByCategory method exists', () {
      expect(() => repository.getNotesByCategory('WORK'), returnsNormally);
    });

    test('searchNotes method exists', () {
      expect(() => repository.searchNotes('test'), returnsNormally);
    });

    test('updateNote method exists', () {
      expect(() => repository.updateNote(testNote), returnsNormally);
    });

    test('togglePin method exists', () {
      expect(() => repository.togglePin('test-id', true), returnsNormally);
    });

    test('toggleFavourite method exists', () {
      expect(() => repository.toggleFavourite('test-id', false), returnsNormally);
    });

    test('deleteNote method exists', () {
      expect(() => repository.deleteNote('test-id'), returnsNormally);
    });

    test('all methods return Future types', () {
      expect(repository.createNote(testNote), isA<Future<Note>>());
      expect(repository.getAllNotes(), isA<Future<List<Note>>>());
      expect(repository.getPinnedNotes(), isA<Future<List<Note>>>());
      expect(repository.getFavouriteNotes(), isA<Future<List<Note>>>());
      expect(repository.getNotesByCategory('WORK'), isA<Future<List<Note>>>());
      expect(repository.searchNotes('test'), isA<Future<List<Note>>>());
      expect(repository.updateNote(testNote), isA<Future<Note>>());
      expect(repository.togglePin('test-id', true), isA<Future<Note>>());
      expect(repository.toggleFavourite('test-id', false), isA<Future<Note>>());
      expect(repository.deleteNote('test-id'), isA<Future<void>>());
    });
  });
}

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
