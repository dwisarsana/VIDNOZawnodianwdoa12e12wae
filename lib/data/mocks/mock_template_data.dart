import '../../domain/models/template_item.dart';
import '../../domain/enums/template_category.dart';
import '../../domain/models/generation_settings.dart';
import '../../domain/enums/generation_quality.dart';

class MockTemplateData {
  static final List<TemplateItem> templates = [
    TemplateItem(
      id: 't1',
      name: 'Eternal Romance',
      subtitle: 'Soft lighting, dreamy atmosphere',
      category: TemplateCategory.romantic,
      previewAsset: 'assets/mock/templates/romantic_1.jpg',
      isPremium: false,
      defaultSettings: const GenerationSettings(
        durationSeconds: 5,
        quality: GenerationQuality.standard,
        moodIntensity: 0.7,
      ),
    ),
    TemplateItem(
      id: 't2',
      name: 'Cyberpunk City',
      subtitle: 'Neon lights, futuristic vibes',
      category: TemplateCategory.modern,
      previewAsset: 'assets/mock/templates/cyber_1.jpg',
      isPremium: true,
      defaultSettings: const GenerationSettings(
        durationSeconds: 8,
        quality: GenerationQuality.high,
        cinematicMotion: true,
      ),
    ),
    TemplateItem(
      id: 't3',
      name: 'Vintage Film',
      subtitle: 'Grain, scratches, sepia tones',
      category: TemplateCategory.vintage,
      previewAsset: 'assets/mock/templates/vintage_1.jpg',
      isPremium: false,
      defaultSettings: const GenerationSettings(
        durationSeconds: 5,
        quality: GenerationQuality.standard,
        decorationLevel: 0.8,
      ),
    ),
    TemplateItem(
      id: 't4',
      name: 'Cinematic Epic',
      subtitle: 'Wide shots, dramatic lighting',
      category: TemplateCategory.cinematic,
      previewAsset: 'assets/mock/templates/cine_1.jpg',
      isPremium: true,
      defaultSettings: const GenerationSettings(
        durationSeconds: 12,
        quality: GenerationQuality.ultra,
        stabilization: true,
      ),
    ),
    TemplateItem(
      id: 't5',
      name: 'Documentary',
      subtitle: 'Clean cuts, natural colors',
      category: TemplateCategory.documentary,
      previewAsset: 'assets/mock/templates/doc_1.jpg',
      isPremium: false,
      defaultSettings: const GenerationSettings(
        durationSeconds: 8,
        quality: GenerationQuality.standard,
      ),
    ),
  ];
}
