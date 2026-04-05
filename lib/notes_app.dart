import 'package:flutter/material.dart';

import 'models/note_model.dart';
import 'screens/edit_note_screen.dart';
import 'screens/notes_screen.dart';
import 'strings/app_strings.dart';
import 'theme/theme.dart';

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
