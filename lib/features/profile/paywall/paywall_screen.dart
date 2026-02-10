import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/utils/number_utils.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../data/local/shared_prefs_service.dart';
import '../../../../data/repositories/wallet_repository.dart';
import 'paywall_controller.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PaywallScreen(),
    );
  }

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  PaywallController? _controller;
  int _currentBalance = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPrefsService.getInstance();
    final repo = WalletRepository(prefs);
    setState(() {
      _controller = PaywallController(repo);
      _currentBalance = repo.getWallet().balance;
    });
  }

  Future<void> _buyPack(int amount, String label) async {
    if (_controller == null) return;

    final success = await _controller!.purchasePack(amount);
    if (success && mounted) {
      AppHaptics.success();
      Navigator.of(context).pop(true); // Return true indicating purchase made

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully added $amount tokens!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const SizedBox(height: 400, child: Center(child: CircularProgressIndicator()));
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.bgBase,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.glassBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                Text('Get More Tokens', style: AppTypography.h2),
                const SizedBox(height: 8),
                Text(
                  'Choose a pack to continue creating amazing videos.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // Balance
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.token, color: AppColors.warning, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Current Balance: ${NumberUtils.formatToken(_currentBalance)}',
                  style: AppTypography.h3,
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.glassBorder),

          // Packs
          Expanded(
            child: AnimatedBuilder(
              animation: _controller!,
              builder: (context, _) {
                if (_controller!.isLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _PackCard(
                      title: 'Starter Pack',
                      amount: 20,
                      price: 'Demo',
                      onTap: () => _buyPack(20, 'Starter'),
                    ),
                    const SizedBox(height: 16),
                    _PackCard(
                      title: 'Creator Pack',
                      amount: 60,
                      price: 'Demo',
                      isPopular: true,
                      onTap: () => _buyPack(60, 'Creator'),
                    ),
                    const SizedBox(height: 16),
                    _PackCard(
                      title: 'Studio Pack',
                      amount: 140,
                      price: 'Demo',
                      onTap: () => _buyPack(140, 'Studio'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PackCard extends StatelessWidget {
  final String title;
  final int amount;
  final String price;
  final bool isPopular;
  final VoidCallback onTap;

  const _PackCard({
    required this.title,
    required this.amount,
    required this.price,
    this.isPopular = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.glassTintMed,
              borderRadius: BorderRadius.circular(AppRadii.lg),
              border: isPopular
                  ? Border.all(color: AppColors.primary, width: 2)
                  : Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.glassTintHigh,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.token, color: AppColors.warning, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.h3),
                      Text(
                        '+$amount Tokens',
                        style: AppTypography.body.copyWith(color: AppColors.warning),
                      ),
                    ],
                  ),
                ),
                GlassButton(
                  text: price,
                  height: 40,
                  isPrimary: isPopular,
                  onPressed: onTap,
                ),
              ],
            ),
          ),

          if (isPopular)
            Positioned(
              top: -12,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                child: Text(
                  'MOST POPULAR',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
