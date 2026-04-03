import 'package:flutter_test/flutter_test.dart';
import 'package:notes_application/theme/spacing.dart';

void main() {
  group('AppSpacing', () {
    test('scale increases monotonically', () {
      expect(AppSpacing.xs < AppSpacing.sm, true);
      expect(AppSpacing.sm < AppSpacing.md, true);
      expect(AppSpacing.md < AppSpacing.lg, true);
      expect(AppSpacing.lg < AppSpacing.xl, true);
    });

    test('padding insets use spacing values', () {
      expect(AppSpacing.paddingXs.top, AppSpacing.xs);
      expect(AppSpacing.paddingMd.left, AppSpacing.md);
      expect(AppSpacing.horizontalLg.left, AppSpacing.lg);
    });
  });
}
