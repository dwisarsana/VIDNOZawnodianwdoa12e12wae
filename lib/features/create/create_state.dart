import 'package:flutter/foundation.dart';
import '../../core/utils/cost_calculator.dart';
import '../../domain/models/generation_settings.dart';
import '../../domain/models/template_item.dart';

@immutable
class CreateState {
  final int currentStep;
  final List<String> selectedImages;
  final String? selectedTemplateId;
  final TemplateItem? selectedTemplate;
  final String? selectedStyleId;
  final GenerationSettings settings;
  final bool isLoading;
  final List<TemplateItem> templates;
  final bool isLoadingTemplates;
  final int estimatedCost;
  final bool isReviewConfirmed;
  final bool hasDraftDetected; // Signal to UI

  const CreateState({
    this.currentStep = 0,
    this.selectedImages = const [],
    this.selectedTemplateId,
    this.selectedTemplate,
    this.selectedStyleId,
    this.settings = const GenerationSettings(),
    this.isLoading = false,
    this.templates = const [],
    this.isLoadingTemplates = false,
    this.estimatedCost = 0,
    this.isReviewConfirmed = false,
    this.hasDraftDetected = false,
  });

  CreateState copyWith({
    int? currentStep,
    List<String>? selectedImages,
    String? selectedTemplateId,
    TemplateItem? selectedTemplate,
    String? selectedStyleId,
    GenerationSettings? settings,
    bool? isLoading,
    List<TemplateItem>? templates,
    bool? isLoadingTemplates,
    int? estimatedCost,
    bool? isReviewConfirmed,
    bool? hasDraftDetected,
  }) {
    return CreateState(
      currentStep: currentStep ?? this.currentStep,
      selectedImages: selectedImages ?? this.selectedImages,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      templates: templates ?? this.templates,
      isLoadingTemplates: isLoadingTemplates ?? this.isLoadingTemplates,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      isReviewConfirmed: isReviewConfirmed ?? this.isReviewConfirmed,
      hasDraftDetected: hasDraftDetected ?? this.hasDraftDetected,
    );
  }
}
