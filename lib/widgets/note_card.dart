import 'package:flutter/material.dart';
import '../models/note_model.dart';
import 'category_pill.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../strings/app_strings.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;
  const NoteCard({super.key, required this.note, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: note.categoryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: CategoryPill(
                              label: note.category,
                              color: note.categoryColor,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            _formatDate(note.createdAt),
                            style: AppTypography.caption,
                          ),
                          const Spacer(),
                          if (note.isPinned)
                            const Icon(Icons.push_pin, color: AppColors.primary, size: 20),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        note.title,
                        style: AppTypography.h2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        note.body,
                        style: AppTypography.body2,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (note.imageUrl != null && note.imageUrl!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            note.imageUrl!,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${AppStrings.shortMonths[date.month - 1]} ${date.day}';
  }
}
