import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_typography.dart';
import '../utils/haptics.dart';

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isPrimary;
  final bool isFullWidth;
  final double? width;
  final double? height;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isPrimary = false,
    this.isFullWidth = false,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;
    final borderRadius = BorderRadius.circular(AppRadii.pill);

    // Background
    final Color backgroundColor = isPrimary
        ? (isDisabled ? AppColors.primary.withOpacity(0.3) : AppColors.primary.withOpacity(0.8))
        : (isDisabled ? AppColors.glassTintLow.withOpacity(0.5) : AppColors.glassTintMed);

    // Gradient (for primary)
    final Gradient? gradient = isPrimary && !isDisabled
        ? const LinearGradient(
            colors: [Color(0xFF7C8CFF), Color(0xFF9B8CFF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
        : null;

    final Color contentColor = isDisabled
        ? AppColors.textMuted
        : (isPrimary ? Colors.white : AppColors.textPrimary);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          IconTheme(
            data: IconThemeData(color: contentColor, size: 20),
            child: icon!,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: AppTypography.button.copyWith(color: contentColor),
        ),
      ],
    );

    Widget container = Container(
      width: isFullWidth ? double.infinity : width,
      height: height,
      padding: (width == null && !isFullWidth) ? const EdgeInsets.symmetric(horizontal: 24) : null,
      decoration: BoxDecoration(
        color: gradient == null ? backgroundColor : null,
        gradient: gradient,
        borderRadius: borderRadius,
        border: (isPrimary || isDisabled) ? null : Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: Center(child: content),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : () {
          AppHaptics.buttonPress();
          onPressed!();
        },
        borderRadius: borderRadius,
        child: container,
      ),
    );
  }
}
