import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../data/repositories/wallet_repository.dart';
import 'profile_controller.dart';
import 'sections/wallet_section.dart';
import 'paywall/paywall_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController? _controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPrefsService.getInstance();
    final repo = WalletRepository(prefs);
    if (!mounted) return;
    setState(() {
      _controller = ProfileController(repo);
    });
  }

  Future<void> _openPaywall() async {
    final result = await PaywallScreen.show(context);
    if (result == true) {
      _controller?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      child: AnimatedBuilder(
        animation: _controller!,
        builder: (context, _) {
          final wallet = _controller!.wallet;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (wallet != null)
                WalletSection(
                  wallet: wallet,
                  onBuyTokens: _openPaywall,
                ),

              const SizedBox(height: 24),

              // Placeholders
              const ListTile(
                leading: Icon(Icons.settings, color: AppColors.textSecondary),
                title: Text('Settings', style: TextStyle(color: AppColors.textPrimary)),
                trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ),
              const ListTile(
                leading: Icon(Icons.description, color: AppColors.textSecondary),
                title: Text('Terms & Privacy', style: TextStyle(color: AppColors.textPrimary)),
                trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ),
              const ListTile(
                leading: Icon(Icons.help, color: AppColors.textSecondary),
                title: Text('Support', style: TextStyle(color: AppColors.textPrimary)),
                trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ),
            ],
          );
        },
      ),
    );
  }
}
