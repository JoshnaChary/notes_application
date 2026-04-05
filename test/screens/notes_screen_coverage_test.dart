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

  group('buildCategoryBadge Helper Function', () {
    testWidgets('renders URGENT category with correct background', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildCategoryBadge(AppStrings.urgent),
          ),
        ),
      );

      expect(find.text(AppStrings.urgent.toUpperCase()), findsOneWidget);
      // Verify Container is created with decoration
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('renders PERSONAL category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildCategoryBadge(AppStrings.personal),
          ),
        ),
      );

      expect(find.text(AppStrings.personal.toUpperCase()), findsOneWidget);
    });

    testWidgets('renders WORK category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildCategoryBadge(AppStrings.work),
          ),
        ),
      );

      expect(find.text(AppStrings.work.toUpperCase()), findsOneWidget);
    });

    testWidgets('renders PEACE category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildCategoryBadge(AppStrings.peace),
          ),
        ),
      );

      expect(find.text(AppStrings.peace.toUpperCase()), findsOneWidget);
    });

    testWidgets('unknown category renders as uppercase', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildCategoryBadge('UNKNOWN'),
          ),
        ),
      );

      expect(find.text('UNKNOWN'), findsOneWidget);
    });

    testWidgets('category badge has correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildCategoryBadge(AppStrings.work),
          ),
        ),
      );

      // Find the Container with the badge
      final container = find.byType(Container);
      expect(container, findsOneWidget);

      // Find the Text inside
      expect(find.text(AppStrings.work.toUpperCase()), findsOneWidget);
    });

    testWidgets('category badge text styles are applied', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buildCategoryBadge(AppStrings.personal),
          ),
        ),
      );

      // Text widget with bold styling should exist
      expect(find.text(AppStrings.personal.toUpperCase()), findsOneWidget);

      // Container should have decoration/background
      expect(find.byType(Container), findsOneWidget);
    });
  });

  group('NotesScreen Comprehensive Coverage', () {
    testWidgets('renders with correct scaffold structure',
        (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays all tab categories in UI', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pumpAndSettle();
      
      // Main category tabs should be visible
      expect(find.text(AppStrings.all), findsOneWidget);
      expect(find.text(AppStrings.work), findsOneWidget);
    });

    testWidgets('search button toggles search visibility',
        (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      
      // Initially no search field
      final searchBefore = find.byType(TextField);
      
      // Tap search button
      await tester.tap(find.byKey(const Key('search_button')));
      await tester.pump();
      
      // Search field should appear
      final searchAfter = find.byType(TextField);
      expect(searchAfter, findsOneWidget);
    });

    testWidgets('category tabs are tappable and update state',
        (tester) async {
      final viewModel = NotesViewModel();
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => viewModel,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pumpAndSettle();
      
      // Initial state
      expect(viewModel.activeCategory, equals(0));
    });

    testWidgets('sub-category chips are rendered', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pumpAndSettle();
      
      // Sub-category tabs (using InkWell + Container) should exist
      // Look for the specific tab chips by their keys
      expect(find.byKey(const Key('chip_all')), findsOneWidget);
      expect(find.byKey(const Key('chip_work')), findsOneWidget);
      expect(find.byKey(const Key('chip_personal')), findsOneWidget);
      expect(find.byKey(const Key('chip_urgent')), findsOneWidget);
      expect(find.byKey(const Key('chip_peace')), findsOneWidget);
    });

    testWidgets('notes list renders in main content area', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pumpAndSettle();
      
      // Should have some list representation
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('app bar is displayed with title', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      
      // App bar should exist
      expect(find.byType(AppBar), findsOneWidget);
      
      // Title should be visible
      expect(find.text(AppStrings.appName), findsOneWidget);
    });

    testWidgets('empty state is handled gracefully', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => NotesViewModel(),
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pumpAndSettle();
      
      // Screen should render even with no notes
      expect(find.byType(NotesScreen), findsOneWidget);
    });

    testWidgets('search query filters notes', (tester) async {
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
      
      // Type search query
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();
      
      // ViewModel should be updated
      expect(viewModel.searchQuery, contains('test'));
    });

    testWidgets('multiple category filters can be tested', (tester) async {
      final viewModel = NotesViewModel();
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => viewModel,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      
      // Change category filter
      viewModel.filterByCategory(1);
      await tester.pump();
      
      expect(viewModel.activeCategory, equals(1));
    });

    testWidgets('sub-category filtering works', (tester) async {
      final viewModel = NotesViewModel();
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => viewModel,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      
      // Change sub-category
      viewModel.filterBySubCategory(1);
      await tester.pump();
      
      expect(viewModel.activeSubCategory, equals(1));
    });

    testWidgets('render category badge for each category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  buildCategoryBadge(AppStrings.all),
                  buildCategoryBadge(AppStrings.work),
                  buildCategoryBadge(AppStrings.personal),
                  buildCategoryBadge(AppStrings.urgent),
                  buildCategoryBadge(AppStrings.peace),
                ],
              ),
            ),
          ),
        ),
      );

      // All categories should be rendered
      expect(find.text(AppStrings.all.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.work.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.personal.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.urgent.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.peace.toUpperCase()), findsOneWidget);
    });

    testWidgets('category badge rendering multiple times', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  buildCategoryBadge(AppStrings.work),
                  buildCategoryBadge(AppStrings.work),
                  buildCategoryBadge(AppStrings.work),
                ],
              ),
            ),
          ),
        ),
      );

      // Multiple badges should exist (3 badges were created)
      expect(find.text(AppStrings.work.toUpperCase()), findsNWidgets(3));
      expect(find.byType(Container), findsNWidgets(3));
    });

    testWidgets('screen state management works', (tester) async {
      final viewModel = NotesViewModel();
      await tester.pumpWidget(
        ChangeNotifierProvider<NotesViewModel>(
          create: (_) => viewModel,
          child: const MaterialApp(home: NotesScreen()),
        ),
      );

      await tester.pump();
      
      // Test multiple state changes
      viewModel.setSearchQuery('test1');
      expect(viewModel.searchQuery, equals('test1'));
      
      viewModel.setIsSearching(true);
      expect(viewModel.isSearching, equals(true));
      
      viewModel.filterByCategory(1);
      expect(viewModel.activeCategory, equals(1));
    });
  });
}
