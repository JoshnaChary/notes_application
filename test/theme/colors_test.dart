import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/theme/colors.dart';

void main() {
  group('AppColors', () {
    test('primary palette is defined', () {
      expect(AppColors.primary, isA<Color>());
      expect(AppColors.secondary, isA<Color>());
      expect(AppColors.background, isA<Color>());
      expect(AppColors.surface, isA<Color>());
    });

    test('category backgrounds are distinct colors', () {
      expect(AppColors.workBg, isA<Color>());
      expect(AppColors.personalBg, isA<Color>());
      expect(AppColors.peaceBg, isA<Color>());
      expect(AppColors.urgentBg, isA<Color>());
    });

    test('text colors are defined', () {
      expect(AppColors.textPrimary, isA<Color>());
      expect(AppColors.textInverse, isA<Color>());
      expect(AppColors.error, isA<Color>());
    });
  });
}
