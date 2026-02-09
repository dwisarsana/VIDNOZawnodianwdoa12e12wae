import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../create_controller.dart';
import '../widgets/upload_grid.dart';

class UploadStep extends StatelessWidget {
  final CreateController controller;

  const UploadStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final images = controller.state.selectedImages;

    return Column(
      children: [
        // Optional Quality Tips Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: GlassCard(
            blur: 10,
            tintColor: AppColors.glassTintLow,
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'For best results, use clear photos with good lighting.',
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Upload Grid
        Expanded(
          child: UploadGrid(
            images: images,
            onAdd: controller.pickImages,
            onRemove: controller.removeImage,
          ),
        ),
      ],
    );
  }
}
