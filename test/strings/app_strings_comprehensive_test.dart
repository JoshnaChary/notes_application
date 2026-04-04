import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/strings/app_strings.dart';

void main() {
  group('AppStrings Tests', () {
    test('app strings are defined correctly', () {
      expect(AppStrings.appName, 'Notes App');
      expect(AppStrings.appName, isA<String>());
      expect(AppStrings.appName.isNotEmpty, true);
    });

    test('navigation strings are defined correctly', () {
      expect(AppStrings.notes, 'Notes');
      expect(AppStrings.allNotes, 'All notes');
      expect(AppStrings.favourites, 'Favourites');
      expect(AppStrings.pinned, 'Pinned');
      expect(AppStrings.notesTab, 'NOTES');
      expect(AppStrings.pinnedTab, 'PINNED');
    });

    test('category strings are defined correctly', () {
      expect(AppStrings.all, 'ALL');
      expect(AppStrings.work, 'WORK');
      expect(AppStrings.personal, 'PERSONAL');
      expect(AppStrings.peace, 'PEACE');
      expect(AppStrings.urgent, 'URGENT');
    });

    test('search strings are defined correctly', () {
      expect(AppStrings.searchNotes, 'Search notes...');
      expect(AppStrings.searchNotes, contains('Search'));
      expect(AppStrings.searchNotes, contains('...'));
    });

    test('empty state strings are defined correctly', () {
      expect(AppStrings.noMoreEntries, 'No more entries');
      expect(AppStrings.noNotesYet, 'No notes yet. Tap the + button to add your first note.');
      expect(AppStrings.noNotesYet, contains('first note'));
    });

    test('edit note screen strings are defined correctly', () {
      expect(AppStrings.title, 'Title');
      expect(AppStrings.startWriting, 'Start writing your thoughts...');
      expect(AppStrings.untitledMaster, 'Untitled Master...');
      expect(AppStrings.save, 'Save');
    });

    test('note action strings are defined correctly', () {
      expect(AppStrings.pinNote, 'Pin Note');
      expect(AppStrings.unpinNote, 'Unpin Note');
      expect(AppStrings.markAsFavourite, 'Mark as Favourite');
      expect(AppStrings.unfavourite, 'Unfavourite');
      expect(AppStrings.deleteNote, 'Delete Note');
    });

    test('delete confirmation strings are defined correctly', () {
      expect(AppStrings.deleteThisNote, 'Delete this note?');
      expect(AppStrings.deleteConfirmation, 'Are you sure you want to delete this note? This action cannot be undone and content will be permanently removed.');
      expect(AppStrings.cancel, 'Cancel');
      expect(AppStrings.delete, 'Delete Note');
      expect(AppStrings.deleteConfirmation, contains('cannot be undone'));
    });

    test('snackbar strings are defined correctly', () {
      expect(AppStrings.noteDeleted, 'Note deleted');
      expect(AppStrings.undo, 'Undo');
    });

    test('formatting toolbar strings are defined correctly', () {
      expect(AppStrings.bold, 'Bold');
      expect(AppStrings.italic, 'Italic');
      expect(AppStrings.bulletedList, 'Bulleted List');
      expect(AppStrings.checkbox, 'Checkbox');
      expect(AppStrings.attachImage, 'Attach Image');
      expect(AppStrings.insertLink, 'Insert Link');
    });

    test('months list contains all 12 months', () {
      expect(AppStrings.months.length, 12);
      expect(AppStrings.months, contains('JANUARY'));
      expect(AppStrings.months, contains('FEBRUARY'));
      expect(AppStrings.months, contains('MARCH'));
      expect(AppStrings.months, contains('APRIL'));
      expect(AppStrings.months, contains('MAY'));
      expect(AppStrings.months, contains('JUNE'));
      expect(AppStrings.months, contains('JULY'));
      expect(AppStrings.months, contains('AUGUST'));
      expect(AppStrings.months, contains('SEPTEMBER'));
      expect(AppStrings.months, contains('OCTOBER'));
      expect(AppStrings.months, contains('NOVEMBER'));
      expect(AppStrings.months, contains('DECEMBER'));
    });

    test('short months list contains all 12 months', () {
      expect(AppStrings.shortMonths.length, 12);
      expect(AppStrings.shortMonths, contains('Jan'));
      expect(AppStrings.shortMonths, contains('Feb'));
      expect(AppStrings.shortMonths, contains('Mar'));
      expect(AppStrings.shortMonths, contains('Apr'));
      expect(AppStrings.shortMonths, contains('May'));
      expect(AppStrings.shortMonths, contains('Jun'));
      expect(AppStrings.shortMonths, contains('Jul'));
      expect(AppStrings.shortMonths, contains('Aug'));
      expect(AppStrings.shortMonths, contains('Sep'));
      expect(AppStrings.shortMonths, contains('Oct'));
      expect(AppStrings.shortMonths, contains('Nov'));
      expect(AppStrings.shortMonths, contains('Dec'));
    });

    test('all strings are non-empty', () {
      expect(AppStrings.appName.isNotEmpty, true);
      expect(AppStrings.notes.isNotEmpty, true);
      expect(AppStrings.allNotes.isNotEmpty, true);
      expect(AppStrings.favourites.isNotEmpty, true);
      expect(AppStrings.pinned.isNotEmpty, true);
      expect(AppStrings.notesTab.isNotEmpty, true);
      expect(AppStrings.pinnedTab.isNotEmpty, true);
      expect(AppStrings.all.isNotEmpty, true);
      expect(AppStrings.work.isNotEmpty, true);
      expect(AppStrings.personal.isNotEmpty, true);
      expect(AppStrings.peace.isNotEmpty, true);
      expect(AppStrings.urgent.isNotEmpty, true);
      expect(AppStrings.searchNotes.isNotEmpty, true);
      expect(AppStrings.noMoreEntries.isNotEmpty, true);
      expect(AppStrings.noNotesYet.isNotEmpty, true);
      expect(AppStrings.title.isNotEmpty, true);
      expect(AppStrings.startWriting.isNotEmpty, true);
      expect(AppStrings.untitledMaster.isNotEmpty, true);
      expect(AppStrings.save.isNotEmpty, true);
      expect(AppStrings.pinNote.isNotEmpty, true);
      expect(AppStrings.unpinNote.isNotEmpty, true);
      expect(AppStrings.markAsFavourite.isNotEmpty, true);
      expect(AppStrings.unfavourite.isNotEmpty, true);
      expect(AppStrings.deleteNote.isNotEmpty, true);
      expect(AppStrings.deleteThisNote.isNotEmpty, true);
      expect(AppStrings.deleteConfirmation.isNotEmpty, true);
      expect(AppStrings.cancel.isNotEmpty, true);
      expect(AppStrings.delete.isNotEmpty, true);
      expect(AppStrings.noteDeleted.isNotEmpty, true);
      expect(AppStrings.undo.isNotEmpty, true);
      expect(AppStrings.bold.isNotEmpty, true);
      expect(AppStrings.italic.isNotEmpty, true);
      expect(AppStrings.bulletedList.isNotEmpty, true);
      expect(AppStrings.checkbox.isNotEmpty, true);
      expect(AppStrings.attachImage.isNotEmpty, true);
      expect(AppStrings.insertLink.isNotEmpty, true);
    });

    test('all strings are of type String', () {
      expect(AppStrings.appName, isA<String>());
      expect(AppStrings.notes, isA<String>());
      expect(AppStrings.allNotes, isA<String>());
      expect(AppStrings.favourites, isA<String>());
      expect(AppStrings.pinned, isA<String>());
      expect(AppStrings.notesTab, isA<String>());
      expect(AppStrings.pinnedTab, isA<String>());
      expect(AppStrings.all, isA<String>());
      expect(AppStrings.work, isA<String>());
      expect(AppStrings.personal, isA<String>());
      expect(AppStrings.peace, isA<String>());
      expect(AppStrings.urgent, isA<String>());
      expect(AppStrings.searchNotes, isA<String>());
      expect(AppStrings.noMoreEntries, isA<String>());
      expect(AppStrings.noNotesYet, isA<String>());
      expect(AppStrings.title, isA<String>());
      expect(AppStrings.startWriting, isA<String>());
      expect(AppStrings.untitledMaster, isA<String>());
      expect(AppStrings.save, isA<String>());
      expect(AppStrings.pinNote, isA<String>());
      expect(AppStrings.unpinNote, isA<String>());
      expect(AppStrings.markAsFavourite, isA<String>());
      expect(AppStrings.unfavourite, isA<String>());
      expect(AppStrings.deleteNote, isA<String>());
      expect(AppStrings.deleteThisNote, isA<String>());
      expect(AppStrings.deleteConfirmation, isA<String>());
      expect(AppStrings.cancel, isA<String>());
      expect(AppStrings.delete, isA<String>());
      expect(AppStrings.noteDeleted, isA<String>());
      expect(AppStrings.undo, isA<String>());
      expect(AppStrings.bold, isA<String>());
      expect(AppStrings.italic, isA<String>());
      expect(AppStrings.bulletedList, isA<String>());
      expect(AppStrings.checkbox, isA<String>());
      expect(AppStrings.attachImage, isA<String>());
      expect(AppStrings.insertLink, isA<String>());
    });

    test('category strings are uppercase', () {
      expect(AppStrings.all, AppStrings.all.toUpperCase());
      expect(AppStrings.work, AppStrings.work.toUpperCase());
      expect(AppStrings.personal, AppStrings.personal.toUpperCase());
      expect(AppStrings.peace, AppStrings.peace.toUpperCase());
      expect(AppStrings.urgent, AppStrings.urgent.toUpperCase());
    });

    test('tab strings are uppercase', () {
      expect(AppStrings.notesTab, AppStrings.notesTab.toUpperCase());
      expect(AppStrings.pinnedTab, AppStrings.pinnedTab.toUpperCase());
    });
  });
}
