import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/bottom_action_bar.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../data/repositories/draft_repository.dart';
import '../../data/repositories/template_repository.dart';
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

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPrefsService.getInstance();
    _draftRepo = DraftRepository(prefs);
    if (!mounted) return;

    setState(() {
      _controller = CreateController(prefs, _templateRepo, _draftRepo);
    });

    // Listen for draft detection
    _controller!.addListener(_checkDraft);
  }

  void _checkDraft() {
    if (!mounted) return;
    if (_controller!.state.hasDraftDetected) {
      // Show Dialog
      // Need to avoid showing multiple times or if already handling
      // Controller keeps hasDraftDetected=true until handled.
      // We should show it once.
      // But we are in a listener.
      // Use a post-frame callback or check if dialog is open?
      // Better: Reset flag immediately in controller when taking action,
      // but here we just want to trigger UI.
      // Let's show it.

      // Prevent re-entry if needed, but for simple mock flow:
      _controller!.removeListener(_checkDraft); // Remove listener to avoid loop/re-trigger

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
                        ? () => _controller!.nextStep()
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
