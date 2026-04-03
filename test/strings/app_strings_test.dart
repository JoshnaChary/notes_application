import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/strings/app_strings.dart';

void main() {
  group('AppStrings', () {
    test('core UI strings are defined', () {
      expect(AppStrings.appName.isNotEmpty, true);
      expect(AppStrings.allNotes.isNotEmpty, true);
      expect(AppStrings.favourites.isNotEmpty, true);
      expect(AppStrings.save.isNotEmpty, true);
      expect(AppStrings.deleteConfirmation.isNotEmpty, true);
    });

    test('category labels match expected tokens', () {
      expect(AppStrings.all, 'ALL');
      expect(AppStrings.work, 'WORK');
      expect(AppStrings.personal, 'PERSONAL');
      expect(AppStrings.peace, 'PEACE');
      expect(AppStrings.urgent, 'URGENT');
    });

    test('months list has twelve entries', () {
      expect(AppStrings.months.length, 12);
      expect(AppStrings.months.first, 'JANUARY');
      expect(AppStrings.months.last, 'DECEMBER');
    });

    test('shortMonths list has twelve entries', () {
      expect(AppStrings.shortMonths.length, 12);
      expect(AppStrings.shortMonths[0], 'Jan');
      expect(AppStrings.shortMonths[11], 'Dec');
    });
  });
}
