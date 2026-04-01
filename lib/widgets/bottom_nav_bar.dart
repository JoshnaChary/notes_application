import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../strings/app_strings.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;
  const BottomNavBar({super.key, required this.selectedIndex, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.6),
            border: Border(
              top: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.05)),
            ),
          ),
          padding: EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.sm,
            bottom: AppSpacing.sm + MediaQuery.of(context).padding.bottom,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTab(
                context,
                icon: Icons.description,
                label: AppStrings.notesTab,
                selected: selectedIndex == 0,
                onTap: () => onTabSelected?.call(0),
              ),
              _buildTab(
                context,
                icon: Icons.push_pin,
                label: AppStrings.pinnedTab,
                selected: selectedIndex == 1,
                onTap: () => onTabSelected?.call(1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, {required IconData icon, required String label, required bool selected, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: AppSpacing.sm),
        decoration: selected
            ? BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
              )
            : null,
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.textInverse : AppColors.textHint, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: selected ? AppColors.textInverse : AppColors.textTertiary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
