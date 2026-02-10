import 'dart:async';
import 'dart:math';
import '../../domain/models/generation_settings.dart';
import '../../domain/models/generation_progress.dart';
import '../../app/constants/mock_constants.dart';

class MockGenerationService {
  final Random _random = Random();

  Stream<GenerationProgress> startGeneration(GenerationSettings settings) async* {
    final int duration = MockConstants.useMockDelay
        ? _random.nextInt(MockConstants.mockGenerationMaxTime - MockConstants.mockGenerationMinTime) + MockConstants.mockGenerationMinTime
        : 1000;

    // Controlled failure
    if (_random.nextDouble() < MockConstants.failureRate) {
      yield GenerationProgress(stage: 'Initializing...', percent: 0.1);
      await Future.delayed(const Duration(milliseconds: 1500));
      yield GenerationProgress(
        stage: 'Error',
        percent: 0.2,
        isFailed: true,
        failureMessage: 'Simulation failed. Please try again.',
      );
      return;
    }

    final int steps = 20;
    final int stepDuration = duration ~/ steps;

    for (int i = 0; i <= steps; i++) {
      await Future.delayed(Duration(milliseconds: stepDuration));

      final double percent = i / steps;
      String stage = 'Preparing assets...';
      if (percent > 0.2) stage = 'Composing cinematic plan...';
      if (percent > 0.5) stage = 'Rendering keyframes...';
      if (percent > 0.9) stage = 'Finalizing output...';

      yield GenerationProgress(
        stage: stage,
        percent: percent,
      );
    }

    yield GenerationProgress(
      stage: 'Complete',
      percent: 1.0,
      isCompleted: true,
      resultPath: MockConstants.placeholderVideoUrl,
    );
  }
}
