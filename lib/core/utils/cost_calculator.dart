import '../../domain/models/generation_settings.dart';
import '../../domain/enums/generation_quality.dart';
import '../../domain/models/template_item.dart';

class CostCalculator {
  static int calculate({
    required int durationSeconds,
    required GenerationSettings settings,
    TemplateItem? selectedTemplate,
  }) {
    // 1. Base Cost
    int base = 0;
    switch (durationSeconds) {
      case 3: base = 6; break;
      case 5: base = 10; break;
      case 8: base = 16; break;
      case 12: base = 24; break;
      default: base = 10; // default 5s
    }

    // 2. Quality Multiplier
    double multiplier = 1.0;
    switch (settings.quality) {
      case GenerationQuality.standard: multiplier = 1.0; break;
      case GenerationQuality.high: multiplier = 1.25; break;
      case GenerationQuality.ultra: multiplier = 1.5; break;
    }

    // 3. Add-ons
    int addOns = 0;
    if (settings.cinematicMotion) addOns += 2; // smoothMotion
    if (settings.includeTransitions) addOns += 2;
    // Assuming faceDetail or stabilization logic from prompt "faceDetail => +3"
    // Prompt says: smoothMotion => +2, transitions => +2, faceDetail => +3
    // My GenerationSettings has: includeTransitions, stabilization, cinematicMotion, decorationLevel, moodIntensity.
    // Let's map prompt requirements to available settings or add missing ones if needed.
    // The prompt listed "stabilization" but cost formula said "faceDetail".
    // I'll assume stabilization maps to faceDetail or just use stabilization as +3 for now to match logic.
    if (settings.stabilization) addOns += 3;

    // 4. Premium Template
    int premiumAdd = 0;
    if (selectedTemplate != null && selectedTemplate.isPremium) {
      premiumAdd = 4;
    }

    // Formula: roundUp(base * multiplier + addOns + premiumAdd)
    // Actually prompt says: roundUp(base * multiplier + addOns + premiumAdd)
    // Wait, let's check precedence. "base * multiplier + addOns + premiumAdd"
    // Usually multiplier applies to base rendering cost.

    double total = (base * multiplier) + addOns + premiumAdd;
    return total.ceil();
  }
}
