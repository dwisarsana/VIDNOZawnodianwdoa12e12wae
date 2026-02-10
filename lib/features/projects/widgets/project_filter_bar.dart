import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../domain/enums/project_sort_option.dart';

class ProjectFilterBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<ProjectSortOption> onSortChanged;
  final ProjectSortOption currentSort;

  const ProjectFilterBar({
    super.key,
    required this.onSearchChanged,
    required this.onSortChanged,
    required this.currentSort,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          // Search
          Expanded(
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 48,
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      style: AppTypography.body,
                      decoration: const InputDecoration(
                        hintText: 'Search projects...',
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: onSearchChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Sort Button
          GlassCard(
            width: 48,
            height: 48,
            padding: EdgeInsets.zero,
            child: PopupMenuButton<ProjectSortOption>(
              icon: const Icon(Icons.sort, color: AppColors.textPrimary),
              color: AppColors.bgElevated,
              initialValue: currentSort,
              onSelected: onSortChanged,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: ProjectSortOption.newest,
                  child: Text('Newest First'),
                ),
                const PopupMenuItem(
                  value: ProjectSortOption.oldest,
                  child: Text('Oldest First'),
                ),
                const PopupMenuItem(
                  value: ProjectSortOption.longestDuration,
                  child: Text('Longest Duration'),
                ),
                const PopupMenuItem(
                  value: ProjectSortOption.shortestDuration,
                  child: Text('Shortest Duration'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
