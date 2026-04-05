import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'notes_app.dart';
import 'view_models/notes_view_model.dart';

/// Initializes bindings and Supabase before [runApp]. Kept separate from [main] for testability.
Future<void> initializeAppForRun() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
}

/// Root widget tree: [ChangeNotifierProvider] + [NotesApp].
Widget createNotesAppTree() {
  return ChangeNotifierProvider(
    create: (context) {
      final viewModel = NotesViewModel();
      viewModel.initialize();
      return viewModel;
    },
    child: const NotesApp(),
  );
}
