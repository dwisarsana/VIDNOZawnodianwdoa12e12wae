import '../enums/generation_quality.dart';

class WizardDraft {
  final List<String> selectedImages;
  final String? templateId;
  final String? styleId;
  final int durationSeconds;
  final GenerationQuality quality;
  final bool enhancementFlags; // simplified for now or match usage
  final double decorationLevel;
  final bool cameraMotion;
  final double moodIntensity;
  final int estimatedCost;
  final DateTime updatedAt;

  WizardDraft({
    this.selectedImages = const [],
    this.templateId,
    this.styleId,
    this.durationSeconds = 5,
    this.quality = GenerationQuality.standard,
    this.enhancementFlags = false,
    this.decorationLevel = 0.5,
    this.cameraMotion = true,
    this.moodIntensity = 0.5,
    this.estimatedCost = 0,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'selectedImages': selectedImages,
      'templateId': templateId,
      'styleId': styleId,
      'durationSeconds': durationSeconds,
      'quality': quality.index,
      'enhancementFlags': enhancementFlags,
      'decorationLevel': decorationLevel,
      'cameraMotion': cameraMotion,
      'moodIntensity': moodIntensity,
      'estimatedCost': estimatedCost,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory WizardDraft.fromJson(Map<String, dynamic> json) {
    return WizardDraft(
      selectedImages: List<String>.from(json['selectedImages'] ?? []),
      templateId: json['templateId'],
      styleId: json['styleId'],
      durationSeconds: json['durationSeconds'] ?? 5,
      quality: GenerationQuality.values[json['quality'] ?? 0],
      enhancementFlags: json['enhancementFlags'] ?? false,
      decorationLevel: (json['decorationLevel'] as num?)?.toDouble() ?? 0.5,
      cameraMotion: json['cameraMotion'] ?? true,
      moodIntensity: (json['moodIntensity'] as num?)?.toDouble() ?? 0.5,
      estimatedCost: json['estimatedCost'] ?? 0,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
