import 'package:flutter/material.dart';

import 'bootstrap.dart';

Future<void> main() async {
  await initializeAppForRun();
  runApp(createNotesAppTree());
}
