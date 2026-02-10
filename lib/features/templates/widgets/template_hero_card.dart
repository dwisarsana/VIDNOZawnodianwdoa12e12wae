import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../domain/models/template_item.dart';

class TemplateHeroCard extends StatelessWidget {
  final TemplateItem template;
  final VoidCallback onUseTemplate;

  const TemplateHeroCard({
    super.key,
    required this.template,
    required this.onUseTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        color: AppColors.bgElevated,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.asset(
              template.previewAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.primary.withOpacity(0.1)),
            ),

            // Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                    child: Text(
                      'FEATURED',
                      style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    template.name,
                    style: AppTypography.h2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template.subtitle,
                    style: AppTypography.body.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  GlassButton(
                    text: 'Use Template',
                    isPrimary: true,
                    height: 44,
                    // width: 140, // Removed to allow auto-sizing
                    onPressed: onUseTemplate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
