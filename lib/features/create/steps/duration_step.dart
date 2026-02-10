import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/enums/generation_quality.dart';
import '../create_controller.dart';
import '../widgets/duration_selector.dart';
import '../widgets/cost_breakdown_card.dart';

class DurationStep extends StatelessWidget {
  final CreateController? controller;

  const DurationStep({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    // Handling case where controller might be null for placeholder if not passed
    // But we updated CreateScreen to pass it.
    // If not passed, show placeholder or error.
    if (controller == null) {
      return const Center(child: Text('Controller not injected'));
    }

    final settings = controller!.state.settings;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Duration
          DurationSelector(
            selectedSeconds: settings.durationSeconds,
            onDurationChanged: controller!.setDuration,
          ),
          const SizedBox(height: 32),

          // Quality
          Text('Quality', style: AppTypography.h3),
          const SizedBox(height: 12),
          DropdownButton<GenerationQuality>(
            value: settings.quality,
            dropdownColor: AppColors.bgElevated,
            style: AppTypography.body,
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
            underline: Container(height: 1, color: AppColors.glassBorder),
            onChanged: (val) {
              if (val != null) controller!.setQuality(val);
            },
            items: GenerationQuality.values.map((q) {
              return DropdownMenuItem(
                value: q,
                child: Text(q.toString().split('.').last.toUpperCase()),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Enhancements
          Text('Enhancements', style: AppTypography.h3),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Cinematic Motion', style: AppTypography.body),
            subtitle: Text('Smooth camera movements (+2 tokens)', style: AppTypography.caption),
            value: settings.cinematicMotion,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) => controller!.toggleEnhancement('motion'),
          ),
          SwitchListTile(
            title: const Text('Include Transitions', style: AppTypography.body),
            subtitle: Text('Professional scene switching (+2 tokens)', style: AppTypography.caption),
            value: settings.includeTransitions,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) => controller!.toggleEnhancement('transitions'),
          ),
          SwitchListTile(
            title: const Text('Stabilization & Face Detail', style: AppTypography.body),
            subtitle: Text('Enhance subject clarity (+3 tokens)', style: AppTypography.caption),
            value: settings.stabilization,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) => controller!.toggleEnhancement('stabilization'),
          ),

          const SizedBox(height: 32),

          // Cost Breakdown
          CostBreakdownCard(
            durationSeconds: settings.durationSeconds,
            settings: settings,
            template: controller!.state.selectedTemplate,
            totalCost: controller!.state.estimatedCost,
          ),
          const SizedBox(height: 80), // Bottom padding for sticky bar
        ],
      ),
    );
  }
}
