import 'package:flutter/material.dart';

import '../strings/app_strings.dart';
import '../theme/colors.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const DeleteConfirmationDialog({
    super.key,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.placeholder,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: const Icon(Icons.delete_forever, color: AppColors.error, size: 32),
          ),
          const SizedBox(height: 24),
          const Text(
            AppStrings.deleteThisNote,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.deleteConfirmation,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key('delete_button'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              child: const Text(
                AppStrings.delete,
                style: TextStyle(color: AppColors.textInverse, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key('confirm_delete_button'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.placeholder,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context);
                onCancel();
              },
              child: const Text(
                AppStrings.cancel,
                style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
