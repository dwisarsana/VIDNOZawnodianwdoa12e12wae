import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class ProjectEmptyState extends StatelessWidget {
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  const ProjectEmptyState({
    super.key,
    required this.message,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.movie_filter_outlined, size: 64, color: AppColors.glassBorder),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (onAction != null) ...[
            const SizedBox(height: 24),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel ?? 'Action'),
            ),
          ],
        ],
      ),
    );
  }
}
