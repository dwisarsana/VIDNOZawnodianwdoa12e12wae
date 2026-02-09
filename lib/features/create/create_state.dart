import 'package:flutter/foundation.dart';
import '../../domain/models/generation_settings.dart';
import '../../domain/models/template_item.dart';

@immutable
class CreateState {
  final int currentStep;
  final List<String> selectedImages;
  final String? selectedTemplateId;
  final String? selectedStyleId;
  final GenerationSettings settings;
  final bool isLoading;
  final List<TemplateItem> templates;
  final bool isLoadingTemplates;

  const CreateState({
    this.currentStep = 0,
    this.selectedImages = const [],
    this.selectedTemplateId,
    this.selectedStyleId,
    this.settings = const GenerationSettings(),
    this.isLoading = false,
    this.templates = const [],
    this.isLoadingTemplates = false,
  });

  CreateState copyWith({
    int? currentStep,
    List<String>? selectedImages,
    String? selectedTemplateId,
    String? selectedStyleId,
    GenerationSettings? settings,
    bool? isLoading,
    List<TemplateItem>? templates,
    bool? isLoadingTemplates,
  }) {
    return CreateState(
      currentStep: currentStep ?? this.currentStep,
      selectedImages: selectedImages ?? this.selectedImages,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      templates: templates ?? this.templates,
      isLoadingTemplates: isLoadingTemplates ?? this.isLoadingTemplates,
    );
  }
}
