import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/core/config/app_config.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/screens/notes_screen.dart';
import 'package:notes_application/strings/app_strings.dart';
import 'package:notes_application/view_models/notes_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );
    } catch (_) {}
  });

  Note sampleNote({
    required String id,
    required String title,
    String body = 'Body',
    bool favourite = false,
    bool pinned = false,
  }) {
    final t = DateTime.utc(2026, 1, 1);
    return Note(
      id: id,
      title: title,
      body: body,
      category: AppStrings.work,
      colorHex: '#2D5BE3',
      createdAt: t,
      updatedAt: t,
      isFavourite: favourite,
      isPinned: pinned,
    );
  }

  group('notes_screen helpers', () {
    test('chipKeyForTab default branch', () {
      expect(chipKeyForTab('MOOD'), 'chip_mood');
    });

    test('semanticKeyForNoteTitle favourite and pinned', () {
      expect(
        semanticKeyForNoteTitle('My Favourite thing')!.toString(),
        contains('favourite_test_note'),
      );
      expect(
        semanticKeyForNoteTitle('Pinned item')!.toString(),
        contains('pinned_test_note'),
      );
      expect(semanticKeyForNoteTitle('Other'), isNull);
    });
  });

  group('NotesScreen interactions', () {
    testWidgets('error banner shows test error', (tester) async {
      final vm = NotesViewModel();
      vm.setErrorMessageForTest('Test error banner');
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );
      await tester.pump();
      expect(find.text('Test error banner'), findsOneWidget);
    });

    testWidgets('drawer category tap updates filter', (tester) async {
      final vm = NotesViewModel();
      vm.replaceNotesForTest([
        sampleNote(id: '1', title: 'A'),
      ]);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );
      await tester.pumpAndSettle();
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.favourites));
      await tester.pumpAndSettle();
      expect(vm.activeCategory, 1);
    });

    testWidgets('FAB navigates to edit route', (tester) async {
      final vm = NotesViewModel();
      vm.replaceNotesForTest([sampleNote(id: '1', title: 'T')]);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: MaterialApp(
            routes: {
              '/': (_) => const NotesScreen(),
              '/edit': (_) => const Scaffold(body: Text('edit-placeholder')),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Create Note'));
      await tester.pumpAndSettle();
      expect(find.text('edit-placeholder'), findsOneWidget);
    });

    testWidgets('note row opens edit with arguments', (tester) async {
      final vm = NotesViewModel();
      vm.replaceNotesForTest([sampleNote(id: '1', title: 'List title')]);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: MaterialApp(
            routes: {
              '/': (_) => const NotesScreen(),
              '/edit': (_) => const Scaffold(body: Text('opened-edit')),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('List title'));
      await tester.pumpAndSettle();
      expect(find.text('opened-edit'), findsOneWidget);
    });

    testWidgets('favourite and pin buttons invoke view model', (tester) async {
      final vm = NotesViewModel();
      vm.replaceNotesForTest([
        sampleNote(id: '1', title: 'X', favourite: true, pinned: true),
      ]);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('favourite_button')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('pin_button')));
      await tester.pump();
    });

    testWidgets('subcategory filter changes active tab', (tester) async {
      final vm = NotesViewModel();
      vm.replaceNotesForTest([sampleNote(id: '1', title: 'T')]);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );
      await tester.pumpAndSettle();
      vm.filterBySubCategory(2);
      await tester.pump();
      expect(vm.activeSubCategory, 2);
    });

    testWidgets('tab chip tap invokes filterBySubCategory', (tester) async {
      final vm = NotesViewModel();
      vm.replaceNotesForTest([sampleNote(id: '1', title: 'T')]);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('chip_work')));
      await tester.pumpAndSettle();
      expect(vm.activeSubCategory, 2);
    });

    testWidgets('closing search clears query', (tester) async {
      final vm = NotesViewModel();
      vm.replaceNotesForTest([sampleNote(id: '1', title: 'T')]);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('search_button')));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'q');
      await tester.pump();
      expect(vm.searchQuery, contains('q'));
      await tester.tap(find.byKey(const Key('search_button')));
      await tester.pumpAndSettle();
      expect(vm.isSearching, false);
      expect(vm.searchQuery, '');
    });

    testWidgets('list shows semantic keys for special titles', (tester) async {
      final vm = NotesViewModel();
      vm.replaceNotesForTest([
        sampleNote(id: 'a', title: 'My Favourite note'),
        sampleNote(id: 'b', title: 'Pinned note'),
      ]);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('favourite_test_note')), findsOneWidget);
      expect(find.byKey(const Key('pinned_test_note')), findsOneWidget);
    });
  });
}
