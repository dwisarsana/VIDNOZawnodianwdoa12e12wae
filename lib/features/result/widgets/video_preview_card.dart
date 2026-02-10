import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_shadows.dart'; // Import shadows
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class VideoPreviewCard extends StatelessWidget {
  final String? path;

  const VideoPreviewCard({super.key, this.path});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background / Thumbnail
          Container(
            color: Colors.black,
            child: path != null
                ? const Center(child: Icon(Icons.videocam, size: 64, color: Colors.white24)) // Placeholder
                : null,
          ),

          // Play Button Overlay
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: AppShadows.primaryGlow,
              ),
              child: const Icon(Icons.play_arrow, size: 32, color: Colors.white),
            ),
          ),

          // Debug Path
          if (path != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Text(
                'Result: $path',
                style: AppTypography.caption.copyWith(color: Colors.white54),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
