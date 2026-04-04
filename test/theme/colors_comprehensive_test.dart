import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:notes_application/theme/colors.dart';

void main() {
  group('AppColors Tests', () {
    test('primary colors are defined correctly', () {
      expect(AppColors.primary, isA<Color>());
      expect(AppColors.primaryDark, isA<Color>());
      expect(AppColors.secondary, isA<Color>());
    });

    test('background and surface colors are defined correctly', () {
      expect(AppColors.background, isA<Color>());
      expect(AppColors.surface, Colors.white);
    });

    test('typography colors are defined correctly', () {
      expect(AppColors.textPrimary, Colors.black);
      expect(AppColors.textSecondary, Colors.black87);
      expect(AppColors.textTertiary, Colors.black54);
      expect(AppColors.textHint, Colors.black38);
      expect(AppColors.textInverse, Colors.white);
    });

    test('status and state colors are defined correctly', () {
      expect(AppColors.error, isA<Color>());
      expect(AppColors.errorLight, isA<Color>());
      expect(AppColors.success, isA<Color>());
      expect(AppColors.warning, isA<Color>());
      expect(AppColors.placeholder, isA<Color>());
    });

    test('category colors are defined correctly', () {
      expect(AppColors.workColor, AppColors.primary);
      expect(AppColors.personalColor, isA<Color>());
      expect(AppColors.peaceColor, isA<Color>());
      expect(AppColors.urgentColor, isA<Color>());
    });

    test('category background colors are defined correctly', () {
      expect(AppColors.workBg, isA<Color>());
      expect(AppColors.personalBg, isA<Color>());
      expect(AppColors.peaceBg, isA<Color>());
      expect(AppColors.urgentBg, isA<Color>());
    });

    test('category text colors are defined correctly', () {
      expect(AppColors.workText, AppColors.primary);
      expect(AppColors.personalText, Colors.grey);
      expect(AppColors.peaceText, Colors.green);
      expect(AppColors.urgentText, Colors.red);
    });

    test('UI element colors are defined correctly', () {
      expect(AppColors.borderDefault, isA<Color>());
      expect(AppColors.borderSelected, AppColors.primary);
      expect(AppColors.borderUnselected, isA<Color>());
    });

    test('misc colors are defined correctly', () {
      expect(AppColors.moodColor, isA<Color>());
    });

    test('color values are consistent', () {
      // Test that related colors have consistent relationships
      expect(AppColors.workColor, AppColors.primary);
      expect(AppColors.workBg, isA<Color>());
      expect(AppColors.workText, AppColors.primary);
      
      expect(AppColors.personalColor, AppColors.personalBg);
      expect(AppColors.personalText, Colors.grey);
      
      expect(AppColors.peaceColor, AppColors.peaceBg);
      expect(AppColors.peaceText, Colors.green);
      
      expect(AppColors.urgentColor, AppColors.urgentBg);
      expect(AppColors.urgentText, Colors.red);
    });

    test('all colors are non-transparent', () {
      expect(AppColors.primary.opacity, equals(1.0));
      expect(AppColors.background.opacity, equals(1.0));
      expect(AppColors.surface.opacity, equals(1.0));
      expect(AppColors.textPrimary.opacity, equals(1.0));
      expect(AppColors.error.opacity, equals(1.0));
    });

    test('color hex values are correct', () {
      expect(AppColors.primary.value, 0xFF2D5BE3);
      expect(AppColors.primaryDark.value, 0xFF1E3F9D);
      expect(AppColors.secondary.value, 0xFF82B1FF);
      expect(AppColors.background.value, 0xFFEEF0F3);
      expect(AppColors.error.value, 0xFFB71C1C);
      expect(AppColors.success.value, 0xFF2E7D32);
    });

    test('border colors follow expected pattern', () {
      expect(AppColors.borderSelected, AppColors.primary);
      expect(AppColors.borderUnselected, AppColors.borderDefault);
      expect(AppColors.borderDefault, AppColors.placeholder);
    });
  });
}
