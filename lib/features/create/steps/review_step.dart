import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../create_controller.dart';
import '../widgets/review_summary_card.dart';

class ReviewStep extends StatelessWidget {
  final CreateController? controller;

  const ReviewStep({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller == null) return const Center(child: Text('Controller Error'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Summary Card
          ReviewSummaryCard(
            photoCount: controller!.state.selectedImages.length,
            template: controller!.state.selectedTemplate,
            settings: controller!.state.settings,
            totalCost: controller!.state.estimatedCost,
          ),

          const SizedBox(height: 32),

          // Confirmation Checkbox
          GestureDetector(
            onTap: controller!.toggleReviewConfirmation,
            child: Row(
              children: [
                Checkbox(
                  value: controller!.state.isReviewConfirmed,
                  onChanged: (val) => controller!.toggleReviewConfirmation(),
                  activeColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.textSecondary),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'I confirm these settings and understand the token cost.',
                    style: AppTypography.body.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80), // Space for sticky bar
        ],
      ),
    );
  }
}
