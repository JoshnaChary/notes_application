import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('supabaseUrl is non-empty https URL', () {
      expect(AppConfig.supabaseUrl, startsWith('https://'));
      expect(AppConfig.supabaseUrl.isNotEmpty, true);
    });

    test('supabaseAnonKey is non-empty', () {
      expect(AppConfig.supabaseAnonKey.isNotEmpty, true);
    });

    test('hardcodedUserId looks like UUID', () {
      expect(AppConfig.hardcodedUserId.length, greaterThan(30));
      expect(AppConfig.hardcodedUserId.contains('-'), true);
    });

    test('table name constants', () {
      expect(AppConfig.notesTable, 'notes');
      expect(AppConfig.categoriesTable, 'categories');
      expect(AppConfig.usersTable, 'users');
    });

    test('getWorkingSupabaseUrl returns supabaseUrl', () {
      expect(AppConfig.getWorkingSupabaseUrl(), AppConfig.supabaseUrl);
    });
  });
}
