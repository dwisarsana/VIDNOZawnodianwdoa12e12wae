import 'package:flutter/material.dart';
import '../../core/utils/cost_calculator.dart';
import '../../domain/models/generation_settings.dart';
import '../../domain/enums/generation_quality.dart';
import '../../domain/models/template_item.dart';

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
    );
  }
}
