import 'package:flutter/foundation.dart';
import '../../domain/models/generation_settings.dart';

@immutable
class CreateState {
  final int currentStep;
  final List<String> selectedImages;
  final String? selectedTemplateId;
  final String? selectedStyleId;
  final GenerationSettings settings;
  final bool isLoading;

  const CreateState({
    this.currentStep = 0,
    this.selectedImages = const [],
    this.selectedTemplateId,
    this.selectedStyleId,
    this.settings = const GenerationSettings(),
    this.isLoading = false,
  });

  CreateState copyWith({
    int? currentStep,
    List<String>? selectedImages,
    String? selectedTemplateId,
    String? selectedStyleId,
    GenerationSettings? settings,
    bool? isLoading,
  }) {
    return CreateState(
      currentStep: currentStep ?? this.currentStep,
      selectedImages: selectedImages ?? this.selectedImages,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
