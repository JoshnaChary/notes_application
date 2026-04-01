import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_config.dart';
import 'view_models/notes_view_model.dart';
import 'screens/notes_screen.dart';
import 'screens/edit_note_screen.dart';
import 'models/note_model.dart';
import 'theme/theme.dart';
import 'strings/app_strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final viewModel = NotesViewModel();
        // Initialize and load notes on app start
        viewModel.initialize();
        return viewModel;
      },
      child: const NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      routes: {
        '/': (_) => const NotesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          final note = settings.arguments as Note?;
          return MaterialPageRoute(
            builder: (_) => EditNoteScreen(note: note),
          );
        }
        return null;
      },
    );
  }
}
