import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../utils/number_utils.dart';

class TokenBadge extends StatelessWidget {
  final int balance;
  final VoidCallback? onTap;

  const TokenBadge({
    super.key,
    required this.balance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.glassTintMed,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.token, size: 16, color: AppColors.warning),
            const SizedBox(width: 6),
            Text(
              NumberUtils.formatToken(balance),
              style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
