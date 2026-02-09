import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'glass_button.dart';

class BottomActionBar extends StatelessWidget {
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const BottomActionBar({
    super.key,
    this.primaryAction,
    this.secondaryAction,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.glassTintMed,
            border: Border(top: BorderSide(color: AppColors.glassBorder)),
          ),
          padding: padding.add(EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 16),
              ],
              if (secondaryAction != null) ...[
                Expanded(child: secondaryAction!),
                const SizedBox(width: 16),
              ],
              if (primaryAction != null) Expanded(flex: 2, child: primaryAction!),
              if (trailing != null) ...[
                const SizedBox(width: 16),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
