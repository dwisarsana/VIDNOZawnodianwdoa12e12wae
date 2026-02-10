import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_radii.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/utils/number_utils.dart';
import '../../../domain/models/generation_settings.dart';
import '../../../domain/models/template_item.dart';

class ReviewSummaryCard extends StatelessWidget {
  final int photoCount;
  final TemplateItem? template;
  final GenerationSettings settings;
  final int totalCost;

  const ReviewSummaryCard({
    super.key,
    required this.photoCount,
    this.template,
    required this.settings,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Project Summary', style: AppTypography.h3),
          const SizedBox(height: 16),

          _ReviewRow(
            icon: Icons.photo_library,
            label: 'Photos',
            value: '$photoCount selected',
          ),
          const SizedBox(height: 12),

          _ReviewRow(
            icon: Icons.style,
            label: 'Style',
            value: template?.name ?? 'None',
          ),
          const SizedBox(height: 12),

          _ReviewRow(
            icon: Icons.timer,
            label: 'Duration',
            value: '${settings.durationSeconds} seconds',
          ),
          const SizedBox(height: 12),

          _ReviewRow(
            icon: Icons.hd,
            label: 'Quality',
            value: settings.quality.toString().split('.').last.toUpperCase(),
          ),

          const Divider(color: AppColors.glassBorder, height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Estimated Cost', style: AppTypography.body),
              Row(
                children: [
                  const Icon(Icons.token, color: AppColors.warning, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    NumberUtils.formatToken(totalCost),
                    style: AppTypography.h2.copyWith(color: AppColors.warning),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReviewRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Text(
          value,
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
