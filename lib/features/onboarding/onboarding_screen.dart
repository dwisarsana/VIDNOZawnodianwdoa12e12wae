import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/glass_button.dart';
import '../../data/local/shared_prefs_service.dart';
import 'onboarding_controller.dart';
import 'onboarding_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  OnboardingController? _controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPrefsService.getInstance();
    if (!mounted) return;
    setState(() {
      _controller = OnboardingController(prefs);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AppScaffold(
      child: Stack(
        children: [
          // Content
          PageView(
            controller: _controller!.pageController,
            onPageChanged: (index) {
              setState(() {
                _controller!.onPageChanged(index);
              });
            },
            children: const [
              // Screen A
              OnboardingPageWidget(
                title: 'Create cinematic AI videos from your photos',
                visual: Icon(Icons.movie_creation_outlined, size: 120, color: AppColors.primary),
                subtitle: 'Turn your memories into professional videos instantly.',
              ),
              // Screen B
              OnboardingPageWidget(
                title: 'Control style, mood, and duration with precision',
                visual: Icon(Icons.tune, size: 120, color: AppColors.secondary),
                bullets: [
                  'Choose from 5+ premium styles',
                  'Adjust duration & intensity',
                  'Mock rendering simulation',
                ],
                showBullets: true,
              ),
              // Screen C
              OnboardingPageWidget(
                title: 'Your projects, drafts, and tokens in one place',
                visual: Icon(Icons.folder_open, size: 120, color: AppColors.accent),
                subtitle: 'Manage your creative portfolio and credits easily.',
              ),
            ],
          ),

          // Top Right Skip
          Positioned(
            top: 16,
            right: 16,
            child: _controller!.isLastPage
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: () => _controller!.skip(context),
                    child: Text(
                      'Skip',
                      style: AppTypography.button.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PageIndicator(
                  count: 3,
                  currentIndex: _controller!.currentPage,
                ),
                const SizedBox(height: 32),
                GlassButton(
                  text: _controller!.isLastPage ? 'Start Creating' : 'Next',
                  isPrimary: _controller!.isLastPage,
                  onPressed: () => _controller!.next(context),
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
