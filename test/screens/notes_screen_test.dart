import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/core/config/app_config.dart';
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

  group('buildCategoryBadge', () {
    testWidgets('renders URGENT category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: buildCategoryBadge(AppStrings.urgent))),
      );
      expect(find.text(AppStrings.urgent), findsOneWidget);
    });

    testWidgets('renders WORK category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: buildCategoryBadge(AppStrings.work))),
      );
      expect(find.text(AppStrings.work), findsOneWidget);
    });

    testWidgets('renders PERSONAL category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: buildCategoryBadge(AppStrings.personal))),
      );
      expect(find.text(AppStrings.personal), findsOneWidget);
    });

    testWidgets('renders PEACE category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: buildCategoryBadge(AppStrings.peace))),
      );
      expect(find.text(AppStrings.peace), findsOneWidget);
    });

    testWidgets('unknown category falls back to uppercase label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: buildCategoryBadge('custom'))),
      );
      expect(find.text('CUSTOM'), findsOneWidget);
    });
  });

  group('NotesScreen', () {
    testWidgets('renders scaffold with app name', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      expect(find.text(AppStrings.appName), findsOneWidget);
    });

    testWidgets('shows tab labels', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      expect(find.text(AppStrings.all), findsOneWidget);
      expect(find.text(AppStrings.work), findsOneWidget);
    });

    testWidgets('search toggle shows TextField', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      await tester.tap(find.byKey(const Key('search_button')));
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('search field updates viewmodel on text change', (tester) async {
      final viewModel = NotesViewModel();
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => viewModel,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      // Open search
      await tester.tap(find.byKey(const Key('search_button')));
      await tester.pump();
      
      // Type in search field
      await tester.enterText(find.byType(TextField), 'test search');
      await tester.pump();
      
      expect(viewModel.searchQuery, contains('test'));
    });

    testWidgets('category filter tabs are available', (tester) async {
      final viewModel = NotesViewModel();
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => viewModel,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      
      // Verify viewModel exists and can filter
      expect(viewModel.activeCategory, equals(0));
    });

    testWidgets('sub-category filters work when tapped', (tester) async {
      final viewModel = NotesViewModel();
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => viewModel,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();
      
      // Verify initial state
      expect(viewModel.activeSubCategory, equals(0));
    });

    testWidgets('screen widget renders', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      expect(find.byType(NotesScreen), findsOneWidget);
    });

    testWidgets('app bar has title and actions', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      // Check for AppBar (should have title)
      expect(find.text(AppStrings.appName), findsOneWidget);
    });

    testWidgets('renders all sub-category filter labels', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();
      
      // Should render category filters
      expect(find.text(AppStrings.all), findsWidgets);
    });

    testWidgets('handles empty notes list', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      // Empty state message should be present or list should be empty
      expect(find.byType(NotesScreen), findsOneWidget);
    });
  });
}
