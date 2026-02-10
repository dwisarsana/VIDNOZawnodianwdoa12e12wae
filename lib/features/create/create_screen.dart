import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/bottom_action_bar.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../data/repositories/draft_repository.dart';
import '../../data/repositories/template_repository.dart';
import '../../data/repositories/wallet_repository.dart';
import '../profile/paywall/paywall_screen.dart';
import 'create_controller.dart';
import 'widgets/step_header.dart';
import 'steps/upload_step.dart';
import 'steps/style_step.dart';
import 'steps/duration_step.dart';
import 'steps/review_step.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  CreateController? _controller;
  final TemplateRepository _templateRepo = TemplateRepository();
  late final DraftRepository _draftRepo;
  late final WalletRepository _walletRepo;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPrefsService.getInstance();
    _draftRepo = DraftRepository(prefs);
    _walletRepo = WalletRepository(prefs);

    if (!mounted) return;

    setState(() {
      _controller = CreateController(prefs, _templateRepo, _draftRepo, _walletRepo);
    });

    _controller!.addListener(_checkDraft);
  }

  void _checkDraft() {
    if (!mounted) return;
    if (_controller!.state.hasDraftDetected) {
      _controller!.removeListener(_checkDraft);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.bgElevated,
          title: const Text('Resume Draft?', style: TextStyle(color: Colors.white)),
          content: const Text(
            'You have an unsaved project draft. Would you like to resume it?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _controller!.discardDraft();
              },
              child: const Text('Discard', style: TextStyle(color: AppColors.danger)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _controller!.resumeDraft();
              },
              child: const Text('Resume', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _handleNext() async {
    final isLast = _controller!.state.currentStep == 3;
    if (isLast) {
      // Generate flow -> Check wallet
      final success = await _controller!.attemptGenerate();
      if (!success) {
        // Show Paywall
        if (mounted) {
          final bought = await PaywallScreen.show(context);
          if (bought == true) {
            // Retry automatically or just let user tap Generate again?
            // User can tap again.
          }
        }
      } else {
        // Proceed to Phase 8 logic (Success mock)
        // For now just pop or show success message as placeholder
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Generation Started! (Mock)')),
          );
        }
      }
    } else {
      _controller!.nextStep();
    }
  }

  Future<bool> _onWillPop() async {
    if (_controller == null) return true;
    if (_controller!.state.currentStep > 0) {
      _controller!.previousStep();
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _controller?.removeListener(_checkDraft);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: AppScaffold(
        appBar: AppBar(
          title: const Text('New Project'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // TODO: Logic for close/reset
            },
          ),
        ),
        child: Column(
          children: [
            // Header
            AnimatedBuilder(
              animation: _controller!,
              builder: (context, _) => StepHeader(
                currentStep: _controller!.state.currentStep,
                totalSteps: 4,
              ),
            ),

            // Content
            Expanded(
              child: AnimatedBuilder(
                animation: _controller!,
                builder: (context, _) {
                  return IndexedStack(
                    index: _controller!.state.currentStep,
                    children: [
                      UploadStep(controller: _controller!),
                      StyleStep(controller: _controller!),
                      DurationStep(controller: _controller!),
                      ReviewStep(controller: _controller!),
                    ],
                  );
                },
              ),
            ),

            // Bottom Bar
            AnimatedBuilder(
              animation: _controller!,
              builder: (context, _) {
                final step = _controller!.state.currentStep;
                final isFirst = step == 0;
                final isLast = step == 3;
                final canProceed = _controller!.canProceed();

                return BottomActionBar(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  secondaryAction: isFirst
                      ? null
                      : SecondaryButton(
                          text: 'Back',
                          onPressed: () => _controller!.previousStep(),
                        ),
                  primaryAction: GlassButton(
                    text: isLast ? 'Generate' : 'Next',
                    isPrimary: true,
                    onPressed: canProceed
                        ? _handleNext
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
