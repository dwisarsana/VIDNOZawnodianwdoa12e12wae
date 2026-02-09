import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class UploadGrid extends StatelessWidget {
  final List<String> images;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  const UploadGrid({
    super.key,
    required this.images,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: images.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _AddPhotoCard(onTap: onAdd);
        }
        final imagePath = images[index - 1];
        return _PhotoCard(
          path: imagePath,
          onRemove: () => onRemove(imagePath),
        );
      },
    );
  }
}

class _AddPhotoCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPhotoCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.glassTintLow,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(
            color: AppColors.glassBorder.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.glassTintMed,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_a_photo, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              'Add Photos',
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;

  const _PhotoCard({required this.path, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Container for Image
        // Use a simple Container with color if path is invalid for now, mock logic handles path
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          child: Container(
            color: AppColors.bgElevated,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image, size: 40, color: AppColors.textMuted),
                  const SizedBox(height: 8),
                  Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8),
                     child: Text(
                       path.split('/').last,
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                       style: AppTypography.caption,
                     ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Remove Button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
