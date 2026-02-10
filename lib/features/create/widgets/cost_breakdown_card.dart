import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/utils/number_utils.dart';
import '../../../domain/models/generation_settings.dart';
import '../../../domain/models/template_item.dart';
import '../../../domain/enums/generation_quality.dart';

class CostBreakdownCard extends StatelessWidget {
  final int durationSeconds;
  final GenerationSettings settings;
  final TemplateItem? template;
  final int totalCost;

  const CostBreakdownCard({
    super.key,
    required this.durationSeconds,
    required this.settings,
    this.template,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      tintColor: AppColors.glassTintMed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Token Cost Breakdown',
            style: AppTypography.h3.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),

          _RowItem(
            label: 'Base Cost (${durationSeconds}s)',
            value: _baseCost(durationSeconds).toString(),
          ),

          _RowItem(
            label: 'Quality Multiplier',
            value: 'x${_qualityMultiplier(settings.quality)}',
            isDetail: true,
          ),

          if (settings.cinematicMotion)
             const _RowItem(label: 'Cinematic Motion', value: '+2'),

          if (settings.includeTransitions)
             const _RowItem(label: 'Transitions', value: '+2'),

          if (settings.stabilization)
             const _RowItem(label: 'Enhancements', value: '+3'),

          if (template != null && template!.isPremium)
             const _RowItem(label: 'Premium Template', value: '+4'),

          const Divider(color: AppColors.glassBorder, height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Estimated',
                style: AppTypography.h3,
              ),
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

  int _baseCost(int seconds) {
    switch (seconds) {
      case 3: return 6;
      case 5: return 10;
      case 8: return 16;
      case 12: return 24;
      default: return 10;
    }
  }

  String _qualityMultiplier(GenerationQuality q) {
    switch (q) {
      case GenerationQuality.standard: return '1.0';
      case GenerationQuality.high: return '1.25';
      case GenerationQuality.ultra: return '1.5';
    }
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDetail;

  const _RowItem({
    required this.label,
    required this.value,
    this.isDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isDetail
                ? AppTypography.caption.copyWith(color: AppColors.textMuted)
                : AppTypography.body,
          ),
          Text(
            value,
            style: isDetail
                ? AppTypography.caption.copyWith(color: AppColors.textMuted)
                : AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
