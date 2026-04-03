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
  });
}
