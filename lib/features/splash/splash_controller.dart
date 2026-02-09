import 'package:flutter/material.dart';
import '../../data/local/shared_prefs_service.dart';
import '../onboarding/onboarding_screen.dart';
import '../shell/root_shell.dart';
import '../../app/constants/app_constants.dart';

class SplashController extends ChangeNotifier {
  final SharedPrefsService _prefs;

  SplashController(this._prefs);

  Future<void> init(BuildContext context) async {
    // Artificial delay for branding (1.2 - 1.8s)
    await Future.delayed(const Duration(milliseconds: AppConstants.animSplash));

    if (!context.mounted) return;

    final bool onboardingDone = _prefs.onboardingDone;

    if (onboardingDone) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const RootShell(),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }
}
