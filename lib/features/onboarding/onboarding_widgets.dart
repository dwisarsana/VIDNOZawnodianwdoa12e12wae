import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_radii.dart';
import '../../core/widgets/glass_card.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget visual;
  final List<String>? bullets;
  final bool showBullets;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.visual,
    this.bullets,
    this.showBullets = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual (Glass Card placeholder)
          Expanded(
            flex: 3,
            child: Center(child: visual),
          ),
          const SizedBox(height: 32),
          // Content
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTypography.h1.copyWith(height: 1.2),
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    subtitle!,
                    style: AppTypography.body,
                    textAlign: TextAlign.center,
                  ),
                ],
                if (showBullets && bullets != null) ...[
                  const SizedBox(height: 24),
                  ...bullets!.map((bullet) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(bullet, style: AppTypography.body),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 24 : 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.glassBorder,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
