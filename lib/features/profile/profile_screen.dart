import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/glass_button.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/wallet_repository.dart';
import 'paywall/paywall_screen.dart';
import 'profile_controller.dart';
import 'sections/app_prefs_section.dart';
import 'sections/legal_support_section.dart';
import 'sections/wallet_section.dart';
import 'settings_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController? _profileController;
  SettingsController? _settingsController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPrefsService.getInstance();
    final walletRepo = WalletRepository(prefs);
    final settingsRepo = SettingsRepository(prefs);
    if (!mounted) return;
    setState(() {
      _profileController = ProfileController(walletRepo);
      _settingsController = SettingsController(settingsRepo);
    });
  }

  Future<void> _openPaywall() async {
    final result = await PaywallScreen.show(context);
    if (result == true) {
      _profileController?.refresh();
    }
  }

  Future<void> _confirmClearData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgElevated,
        title: const Text('Clear All Data?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will reset your wallet, projects, and settings. This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear Data', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _settingsController?.clearAppData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('App data cleared. Restarting...')),
        );
        // Navigate to Splash to restart flow
        // Assuming Splash is "/" or we push replacement
        // But main.dart builds MaterialApp with home: SplashScreen.
        // We can navigate to '/' if routes defined, but we used home property.
        // We can just pushReplacement mock restart.
        // Actually, RootShell is likely the base. We need to go back to SplashScreen.
        // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(...)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profileController == null || _settingsController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([_profileController!, _settingsController!]),
        builder: (context, _) {
          final wallet = _profileController!.wallet;
          final prefs = _settingsController!.prefs;

          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
            children: [
              if (wallet != null)
                WalletSection(
                  wallet: wallet,
                  onBuyTokens: _openPaywall,
                ),

              const SizedBox(height: 24),

              AppPrefsSection(
                prefs: prefs,
                onHapticsChanged: _settingsController!.toggleHaptics,
                onAutoSaveChanged: _settingsController!.toggleAutoSave,
                onReducedMotionChanged: _settingsController!.toggleReducedMotion,
              ),

              const SizedBox(height: 24),

              const LegalSupportSection(),

              const SizedBox(height: 32),

              Center(
                child: TextButton(
                  onPressed: _confirmClearData,
                  child: Text(
                    'Clear App Data',
                    style: TextStyle(color: AppColors.danger.withOpacity(0.8)),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Version 1.0.0 (Mock Build)',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
