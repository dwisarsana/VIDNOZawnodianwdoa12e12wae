import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../domain/models/project_item.dart';
import '../../../../domain/enums/project_status.dart';
import '../../../../core/utils/date_utils.dart';

class ProjectListItem extends StatelessWidget {
  final ProjectItem project;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onShare;

  const ProjectListItem({
    super.key,
    required this.project,
    required this.onTap,
    required this.onFavorite,
    required this.onDelete,
    required this.onDuplicate,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        onTap: onTap,
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.md),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.black26, // Placeholder color
                child: project.thumbnailPath.isNotEmpty
                    ? Image.asset(
                        project.thumbnailPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.movie, color: Colors.white24),
                        ),
                      )
                    : const Center(child: Icon(Icons.movie, color: Colors.white24)),
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          project.title,
                          style: AppTypography.h3.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (project.favorite)
                        const Icon(Icons.favorite, size: 16, color: AppColors.danger),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${project.styleName} • ${project.durationSeconds}s',
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatusBadge(status: project.status),
                      Flexible(
                        child: Text(
                          AppDateUtils.formatDate(project.createdAt),
                          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Menu
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
              color: AppColors.bgElevated,
              onSelected: (value) {
                switch (value) {
                  case 'favorite': onFavorite(); break;
                  case 'duplicate': onDuplicate(); break;
                  case 'delete': onDelete(); break;
                  case 'share': onShare(); break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'favorite',
                  child: Row(
                    children: [
                      Icon(
                        project.favorite ? Icons.favorite : Icons.favorite_border,
                        color: project.favorite ? AppColors.danger : AppColors.textPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(project.favorite ? 'Unfavorite' : 'Favorite'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Row(
                    children: [
                      Icon(Icons.copy, color: AppColors.textPrimary, size: 20),
                      const SizedBox(width: 12),
                      Text('Duplicate'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, color: AppColors.textPrimary, size: 20),
                      const SizedBox(width: 12),
                      Text('Share'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: AppColors.danger, size: 20),
                      const SizedBox(width: 12),
                      Text('Delete', style: TextStyle(color: AppColors.danger)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProjectStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case ProjectStatus.success:
        color = AppColors.success;
        text = 'Ready';
        break;
      case ProjectStatus.generating:
      case ProjectStatus.queued:
        color = AppColors.warning;
        text = 'Processing';
        break;
      case ProjectStatus.failed:
        color = AppColors.danger;
        text = 'Failed';
        break;
      case ProjectStatus.draft:
        color = AppColors.textMuted;
        text = 'Draft';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
