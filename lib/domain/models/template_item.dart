import '../enums/template_category.dart';
import 'generation_settings.dart';

class TemplateItem {
  final String id;
  final String name;
  final String subtitle;
  final TemplateCategory category;
  final String previewAsset;
  final bool isPremium;
  final GenerationSettings defaultSettings;

  TemplateItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.previewAsset,
    required this.isPremium,
    required this.defaultSettings,
  });

  // Likely read-only from mock data, but json support is good.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'category': category.index,
      'previewAsset': previewAsset,
      'isPremium': isPremium,
      'defaultSettings': defaultSettings.toJson(),
    };
  }

  factory TemplateItem.fromJson(Map<String, dynamic> json) {
    return TemplateItem(
      id: json['id'],
      name: json['name'],
      subtitle: json['subtitle'],
      category: TemplateCategory.values[json['category'] ?? 0],
      previewAsset: json['previewAsset'],
      isPremium: json['isPremium'] ?? false,
      defaultSettings: GenerationSettings.fromJson(json['defaultSettings']),
    );
  }
}
