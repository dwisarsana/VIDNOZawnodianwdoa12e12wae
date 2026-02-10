import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/cost_calculator.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../data/repositories/template_repository.dart';
import '../../domain/enums/generation_quality.dart';
import '../../domain/models/generation_settings.dart';
import '../../domain/models/template_item.dart';
import 'create_state.dart';

class CreateController extends ChangeNotifier {
  final SharedPrefsService _prefs;
  final TemplateRepository _templateRepo;
  final ImagePicker _picker = ImagePicker();

  CreateState _state = const CreateState();

  CreateController(this._prefs, this._templateRepo) {
    _loadTemplates();
  }

  CreateState get state => _state;

  Future<void> _loadTemplates() async {
    _state = _state.copyWith(isLoadingTemplates: true);
    notifyListeners();
    try {
      final templates = await _templateRepo.getTemplates();
      _state = _state.copyWith(templates: templates, isLoadingTemplates: false);
    } catch (e) {
      _state = _state.copyWith(isLoadingTemplates: false);
    }
    notifyListeners();
  }

  void _recalculateCost() {
    final cost = CostCalculator.calculate(
      durationSeconds: _state.settings.durationSeconds,
      settings: _state.settings,
      selectedTemplate: _state.selectedTemplate,
    );
    _state = _state.copyWith(estimatedCost: cost);
    notifyListeners();
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        final newPaths = images.map((e) => e.path).toList();
        final updatedList = [..._state.selectedImages, ...newPaths];
        _state = _state.copyWith(selectedImages: updatedList);
        _saveDraft();
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  void removeImage(String path) {
    final updatedList = List<String>.from(_state.selectedImages)..remove(path);
    _state = _state.copyWith(selectedImages: updatedList);
    _saveDraft();
    notifyListeners();
  }

  void selectTemplate(String id) {
    if (_state.selectedTemplateId == id) return;

    // Find template
    final template = _state.templates.firstWhere(
      (t) => t.id == id,
      orElse: () => _state.templates.first, // Fallback if not found
    );

    // Use template default settings
    final newSettings = template.defaultSettings;

    // Update state
    _state = _state.copyWith(
      selectedTemplateId: id,
      selectedTemplate: template,
      settings: newSettings,
    );

    _recalculateCost();
    _saveDraft();
    notifyListeners();
  }

  void setDuration(int seconds) {
    final newSettings = _state.settings.copyWith(durationSeconds: seconds);
    _state = _state.copyWith(settings: newSettings);
    _recalculateCost();
    _saveDraft();
    notifyListeners();
  }

  void setQuality(GenerationQuality quality) {
    final newSettings = _state.settings.copyWith(quality: quality);
    _state = _state.copyWith(settings: newSettings);
    _recalculateCost();
    _saveDraft();
    notifyListeners();
  }

  void toggleEnhancement(String key) {
    GenerationSettings s = _state.settings;
    switch (key) {
      case 'motion':
        s = s.copyWith(cinematicMotion: !s.cinematicMotion);
        break;
      case 'transitions':
        s = s.copyWith(includeTransitions: !s.includeTransitions);
        break;
      case 'stabilization':
        s = s.copyWith(stabilization: !s.stabilization);
        break;
    }
    _state = _state.copyWith(settings: s);
    _recalculateCost();
    _saveDraft();
    notifyListeners();
  }

  void nextStep() {
    if (_state.currentStep < 3) {
      _state = _state.copyWith(currentStep: _state.currentStep + 1);

      // If moving to Review (step 3), ensure cost is up to date just in case
      if (_state.currentStep == 3) {
        _recalculateCost();
      }

      notifyListeners();
      _saveDraft();
    }
  }

  void previousStep() {
    if (_state.currentStep > 0) {
      _state = _state.copyWith(currentStep: _state.currentStep - 1);
      notifyListeners();
    }
  }

  void _saveDraft() {
    // Implement draft saving logic here (Phase 6)
  }

  bool canProceed() {
    switch (_state.currentStep) {
      case 0:
        return true;
      case 1:
        return _state.selectedTemplateId != null;
      default:
        return true;
    }
  }
}
