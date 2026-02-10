import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../domain/models/generation_progress.dart';

class GenerateProgressSheet extends StatelessWidget {
  final Stream<GenerationProgress> progressStream;
  final VoidCallback onCancel;
  final Function(String resultPath) onSuccess;
  final VoidCallback onRetry;

  const GenerateProgressSheet({
    super.key,
    required this.progressStream,
    required this.onCancel,
    required this.onSuccess,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // This widget needs to be stateful or use StreamBuilder
    return StreamBuilder<GenerationProgress>(
      stream: progressStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
           return _ErrorState(
             message: 'An unexpected error occurred.',
             onRetry: onRetry,
             onCancel: onCancel,
           );
        }

        if (!snapshot.hasData) {
          return const _LoadingState(
            stage: 'Initializing...',
            percent: 0.0,
          );
        }

        final data = snapshot.data!;

        // Handle Completion Side Effect?
        // StreamBuilder build method is not ideal for navigation.
        // Usually controller handles listening and navigation.
        // But prompt says "Generate Progress Sheet (Modal)".
        // If we use showModalBottomSheet, we can't easily push route from inside build.
        // Best practice: The parent (CreateScreen) listens to stream and closes sheet when done.
        // OR: This widget triggers a callback when done.

        if (data.isCompleted && data.resultPath != null) {
          // Trigger success callback after this frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onSuccess(data.resultPath!);
          });
        }

        if (data.isFailed) {
          return _ErrorState(
            message: data.failureMessage ?? 'Generation failed.',
            onRetry: onRetry,
            onCancel: onCancel,
          );
        }

        return _LoadingState(
          stage: data.stage,
          percent: data.percent,
          onCancel: onCancel,
        );
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  final String stage;
  final double percent;
  final VoidCallback? onCancel;

  const _LoadingState({
    required this.stage,
    required this.percent,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular or Linear Progress
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 6,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  backgroundColor: AppColors.glassTintLow,
                ),
                Center(
                  child: Text(
                    '${(percent * 100).toInt()}%',
                    style: AppTypography.h3.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            stage,
            style: AppTypography.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Hold tight, we are crafting your video...',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (onCancel != null)
            TextButton(
              onPressed: onCancel,
              child: Text(
                'Cancel Generation',
                style: AppTypography.button.copyWith(color: AppColors.textMuted),
              ),
            ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onCancel;

  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 64),
          const SizedBox(height: 24),
          Text(
            'Generation Failed',
            style: AppTypography.h2,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: GlassButton(
                  text: 'Cancel',
                  onPressed: onCancel,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GlassButton(
                  text: 'Retry',
                  isPrimary: true,
                  onPressed: onRetry,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
