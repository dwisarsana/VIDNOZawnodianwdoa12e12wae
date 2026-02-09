import '../enums/generation_quality.dart';

class GenerationSettings {
  final int durationSeconds;
  final GenerationQuality quality;
  final bool includeTransitions;
  final bool stabilization;
  final bool cinematicMotion;
  final double decorationLevel;
  final double moodIntensity;

  const GenerationSettings({
    this.durationSeconds = 5,
    this.quality = GenerationQuality.standard,
    this.includeTransitions = true,
    this.stabilization = false,
    this.cinematicMotion = true,
    this.decorationLevel = 0.5,
    this.moodIntensity = 0.5,
  });

  Map<String, dynamic> toJson() {
    return {
      'durationSeconds': durationSeconds,
      'quality': quality.index,
      'includeTransitions': includeTransitions,
      'stabilization': stabilization,
      'cinematicMotion': cinematicMotion,
      'decorationLevel': decorationLevel,
      'moodIntensity': moodIntensity,
    };
  }

  factory GenerationSettings.fromJson(Map<String, dynamic> json) {
    return GenerationSettings(
      durationSeconds: json['durationSeconds'] ?? 5,
      quality: GenerationQuality.values[json['quality'] ?? 0],
      includeTransitions: json['includeTransitions'] ?? true,
      stabilization: json['stabilization'] ?? false,
      cinematicMotion: json['cinematicMotion'] ?? true,
      decorationLevel: (json['decorationLevel'] as num?)?.toDouble() ?? 0.5,
      moodIntensity: (json['moodIntensity'] as num?)?.toDouble() ?? 0.5,
    );
  }

  GenerationSettings copyWith({
    int? durationSeconds,
    GenerationQuality? quality,
    bool? includeTransitions,
    bool? stabilization,
    bool? cinematicMotion,
    double? decorationLevel,
    double? moodIntensity,
  }) {
    return GenerationSettings(
      durationSeconds: durationSeconds ?? this.durationSeconds,
      quality: quality ?? this.quality,
      includeTransitions: includeTransitions ?? this.includeTransitions,
      stabilization: stabilization ?? this.stabilization,
      cinematicMotion: cinematicMotion ?? this.cinematicMotion,
      decorationLevel: decorationLevel ?? this.decorationLevel,
      moodIntensity: moodIntensity ?? this.moodIntensity,
    );
  }
}
