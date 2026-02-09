import 'package:flutter/material.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../app/constants/app_constants.dart';
import '../shell/root_shell.dart';

class OnboardingController extends ChangeNotifier {
  final SharedPrefsService _prefs;
  final PageController pageController = PageController();
  int _currentPage = 0;

  OnboardingController(this._prefs);

  int get currentPage => _currentPage;

  bool get isLastPage => _currentPage == 2;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  Future<void> skip(BuildContext context) async {
    await _completeOnboarding(context);
  }

  Future<void> next(BuildContext context) async {
    if (_currentPage < 2) {
      await pageController.nextPage(
        duration: const Duration(milliseconds: AppConstants.animStandard),
        curve: Curves.easeInOut,
      );
    } else {
      await _completeOnboarding(context);
    }
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    await _prefs.setOnboardingDone(true);
    if (!context.mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const RootShell(),
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
