class GenerationProgress {
  final String stage;
  final double percent;
  final bool isCompleted;
  final bool isFailed;
  final String? resultPath;
  final String? failureMessage;

  GenerationProgress({
    required this.stage,
    required this.percent,
    this.isCompleted = false,
    this.isFailed = false,
    this.resultPath,
    this.failureMessage,
  });
}
