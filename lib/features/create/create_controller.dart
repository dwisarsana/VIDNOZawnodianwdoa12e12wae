import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/cost_calculator.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../data/repositories/draft_repository.dart';
import '../../data/repositories/template_repository.dart';
import '../../domain/enums/generation_quality.dart';
import '../../domain/models/generation_settings.dart';
import '../../domain/models/template_item.dart';
import '../../domain/models/wizard_draft.dart';
import 'create_state.dart';

class CreateController extends ChangeNotifier {
  final SharedPrefsService _prefs;
  final TemplateRepository _templateRepo;
  final DraftRepository _draftRepo;
  final ImagePicker _picker = ImagePicker();

  CreateState _state = const CreateState();

  CreateController(this._prefs, this._templateRepo, this._draftRepo) {
    _loadTemplatesAndCheckDraft();
  }

  CreateState get state => _state;

  Future<void> _loadTemplatesAndCheckDraft() async {
    _state = _state.copyWith(isLoadingTemplates: true);
    notifyListeners();
    try {
      final templates = await _templateRepo.getTemplates();
      _state = _state.copyWith(templates: templates, isLoadingTemplates: false);

      // Check Draft
      final draft = _draftRepo.getDraft();
      if (draft != null) {
        _state = _state.copyWith(hasDraftDetected: true);
      }
    } catch (e) {
      _state = _state.copyWith(isLoadingTemplates: false);
    }
    notifyListeners();
  }

  void resumeDraft() {
    final draft = _draftRepo.getDraft();
    if (draft == null) return;

    // Restore logic
    TemplateItem? template;
    if (draft.templateId != null) {
      try {
        template = _state.templates.firstWhere((t) => t.id == draft.templateId);
      } catch (_) {}
    }

    final restoredSettings = GenerationSettings(
      durationSeconds: draft.durationSeconds,
      quality: draft.quality,
      cinematicMotion: draft.cameraMotion,
      decorationLevel: draft.decorationLevel,
      moodIntensity: draft.moodIntensity,
      includeTransitions: draft.enhancementFlags, // Simplified mapping
      // stabilization not mapped in draft model yet?
      // "enhancementFlags" in WizardDraft can map to multiple bools if we used bitmask or list.
      // For now, mapping includeTransitions to it.
    );

    _state = _state.copyWith(
      selectedImages: draft.selectedImages,
      selectedTemplateId: draft.templateId,
      selectedTemplate: template,
      selectedStyleId: draft.styleId,
      settings: restoredSettings,
      estimatedCost: draft.estimatedCost,
      hasDraftDetected: false, // Dialog handled
    );
    notifyListeners();
  }

  void discardDraft() {
    _draftRepo.clearDraft();
    _state = _state.copyWith(hasDraftDetected: false);
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

    final template = _state.templates.firstWhere(
      (t) => t.id == id,
      orElse: () => _state.templates.first,
    );

    final newSettings = template.defaultSettings;

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

  void toggleReviewConfirmation() {
    _state = _state.copyWith(isReviewConfirmed: !_state.isReviewConfirmed);
    notifyListeners();
  }

  void nextStep() {
    if (_state.currentStep < 3) {
      _state = _state.copyWith(currentStep: _state.currentStep + 1);
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
    final draft = WizardDraft(
      selectedImages: _state.selectedImages,
      templateId: _state.selectedTemplateId,
      styleId: _state.selectedStyleId,
      durationSeconds: _state.settings.durationSeconds,
      quality: _state.settings.quality,
      enhancementFlags: _state.settings.includeTransitions,
      decorationLevel: _state.settings.decorationLevel,
      cameraMotion: _state.settings.cinematicMotion,
      moodIntensity: _state.settings.moodIntensity,
      estimatedCost: _state.estimatedCost,
      updatedAt: DateTime.now(),
    );
    _draftRepo.saveDraft(draft);
  }

  bool canProceed() {
    switch (_state.currentStep) {
      case 0:
        return true;
      case 1:
        return _state.selectedTemplateId != null;
      case 3: // Review
        return _state.isReviewConfirmed; // Block generate if not confirmed
      default:
        return true;
    }
  }
}
