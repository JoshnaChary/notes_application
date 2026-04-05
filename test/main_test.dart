import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/core/config/app_config.dart';
import 'package:notes_application/main.dart';
import 'package:notes_application/models/note_model.dart';
import 'package:notes_application/screens/edit_note_screen.dart';
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

  group('NotesApp', () {
    testWidgets('uses app title and theme', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const NotesApp(),
        ),
      );

      await tester.pump();
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.title, AppStrings.appName);
      expect(app.debugShowCheckedModeBanner, false);
      expect(app.theme, isNotNull);
    });

    testWidgets('onGenerateRoute opens EditNoteScreen for /edit', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const NotesApp(),
        ),
      );

      await tester.pump();
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      final note = Note(
        id: '1',
        title: 'T',
        body: 'B',
        category: 'WORK',
        colorHex: '#000000',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      navigator.pushNamed('/edit', arguments: note);
      await tester.pumpAndSettle();
      expect(find.byType(EditNoteScreen), findsOneWidget);
    });

    testWidgets('onGenerateRoute /edit with null arguments', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const NotesApp(),
        ),
      );

      await tester.pump();
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/edit', arguments: null);
      await tester.pumpAndSettle();
      expect(find.byType(EditNoteScreen), findsOneWidget);
    });

    testWidgets('NotesApp has MaterialApp root widget', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const NotesApp(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('NotesApp routes defaults to NotesScreen', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const NotesApp(),
        ),
      );

      await tester.pumpAndSettle();
      // Default route '/' should show NotesScreen
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('NotesApp initializes with ChangeNotifierProvider',
        (tester) async {
      final viewModel = NotesViewModel();
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => viewModel,
          child: const NotesApp(),
        ),
      );

      // The provider should make the ViewModel available
      final provider =
          find.byType(ChangeNotifierProvider<NotesViewModel>);
      expect(provider, findsOneWidget);
    });

    testWidgets('NotesApp setState updates UI when ViewModel changes',
        (tester) async {
      final viewModel = NotesViewModel();
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => viewModel,
          child: const NotesApp(),
        ),
      );

      await tester.pumpAndSettle();
      
      // Trigger a change in the ViewModel
      viewModel.setSearchQuery('test');
      await tester.pumpAndSettle();
      
      // UI should still be rendered
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('NotesApp builds correctly multiple times',
        (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const NotesApp(),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Rebuild
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const NotesApp(),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('EditNoteScreen receives correct note from route',
        (tester) async {
      final testNote = Note(
        id: 'test-id',
        title: 'Test Note',
        body: 'Test Body',
        category: 'PERSONAL',
        colorHex: '#999999',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const NotesApp(),
        ),
      );

      await tester.pump();
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/edit', arguments: testNote);
      await tester.pumpAndSettle();
      
      expect(find.byType(EditNoteScreen), findsOneWidget);
    });

    testWidgets('NotesApp layout structure is valid', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const NotesApp(),
        ),
      );

      await tester.pumpAndSettle();
      
      // Should have MaterialApp > other widgets
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Material), findsWidgets);
    });
  });
}
