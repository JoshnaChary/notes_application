import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/bootstrap.dart';
import 'package:notes_application/core/config/app_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:notes_application/view_models/notes_view_model.dart';

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

  group('createNotesAppTree', () {
    test('returns a ChangeNotifierProvider wrapping NotesApp', () {
      final w = createNotesAppTree();
      expect(w, isA<ChangeNotifierProvider<NotesViewModel>>());
    });
  });
}
