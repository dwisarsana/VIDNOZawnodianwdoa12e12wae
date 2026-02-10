import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/utils/number_utils.dart';
import '../../../../domain/models/token_wallet.dart';

class WalletSection extends StatelessWidget {
  final TokenWallet wallet;
  final VoidCallback onBuyTokens;

  const WalletSection({
    super.key,
    required this.wallet,
    required this.onBuyTokens,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Wallet', style: AppTypography.h3),
              const Icon(Icons.account_balance_wallet, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.token, color: AppColors.warning, size: 32),
              ),
              const SizedBox(width: 8),
              Text(
                NumberUtils.formatToken(wallet.balance),
                style: AppTypography.display.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    'tokens available',
                    style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GlassButton(
            text: 'Get More Tokens',
            isPrimary: true,
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: onBuyTokens,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
