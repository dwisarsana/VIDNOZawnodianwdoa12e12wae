import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/cost_calculator.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../data/mocks/mock_generation_service.dart';
import '../../data/repositories/draft_repository.dart';
import '../../data/repositories/project_repository.dart';
import '../../data/repositories/template_repository.dart';
import '../../data/repositories/wallet_repository.dart';
import '../../domain/enums/generation_quality.dart';
import '../../domain/enums/project_status.dart';
import '../../domain/models/generation_progress.dart';
import '../../domain/models/generation_settings.dart';
import '../../domain/models/project_item.dart';
import '../../domain/models/template_item.dart';
import '../../domain/models/wizard_draft.dart';
import 'create_state.dart';

class CreateController extends ChangeNotifier {
  final SharedPrefsService _prefs;
  final TemplateRepository _templateRepo;
  final DraftRepository _draftRepo;
  final WalletRepository _walletRepo;
  final ProjectRepository _projectRepo;
  final MockGenerationService _generationService = MockGenerationService(); // Mock service
  final ImagePicker _picker = ImagePicker();

  CreateState _state = const CreateState();

  CreateController(
    this._prefs,
    this._templateRepo,
    this._draftRepo,
    this._walletRepo,
    this._projectRepo,
  ) {
    _loadTemplatesAndCheckDraft();
  }

  CreateState get state => _state;

  Future<void> _loadTemplatesAndCheckDraft() async {
    _state = _state.copyWith(isLoadingTemplates: true);
    notifyListeners();
    try {
      final templates = await _templateRepo.getTemplates();
      _state = _state.copyWith(templates: templates, isLoadingTemplates: false);

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
      includeTransitions: draft.enhancementFlags,
    );

    _state = _state.copyWith(
      selectedImages: draft.selectedImages,
      selectedTemplateId: draft.templateId,
      selectedTemplate: template,
      selectedStyleId: draft.styleId,
      settings: restoredSettings,
      estimatedCost: draft.estimatedCost,
      hasDraftDetected: false,
    );
    notifyListeners();
  }

  void applyProjectSettings(ProjectItem project) {
    // 1. Clear current state mostly
    // 2. Find template
    TemplateItem? template;
    try {
      template = _state.templates.firstWhere((t) => t.id == project.styleId);
    } catch (_) {}

    // 3. Restore Settings from snapshot
    GenerationSettings settings;
    if (project.settingsSnapshotJson != null) {
      settings = GenerationSettings.fromJson(project.settingsSnapshotJson!);
    } else {
      // Fallback
      settings = GenerationSettings(
        durationSeconds: project.durationSeconds,
        quality: project.quality,
      );
    }

    _state = _state.copyWith(
      currentStep: 0, // Start at beginning? Or review? Usually Upload step if images needed.
      selectedImages: [], // Project might have path, but if local file, might be gone. Let user pick?
      // Or if project.thumbnailPath is valid... let's assume empty for safety or add if exists.
      // Ideally "Remix" means "Reuse Settings". "Duplicate" might mean reuse everything.
      // Prompt says "Duplicate settings". So images empty is safer.
      selectedTemplateId: project.styleId,
      selectedTemplate: template,
      settings: settings,
      hasDraftDetected: false, // Don't prompt for draft
    );

    _recalculateCost();
    _saveDraft();
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

  Future<bool> attemptGenerate() async {
    final cost = _state.estimatedCost;
    final hasEnough = _walletRepo.hasSufficientTokens(cost);

    if (!hasEnough) {
      return false; // Show paywall
    }

    return true; // Proceed
  }

  // Start Generation Flow
  Stream<GenerationProgress> startGeneration() {
    // 1. Deduct tokens
    _walletRepo.deductTokens(_state.estimatedCost);

    // 2. Create Project Record
    final projectId = const Uuid().v4();

    // Update state with ID so UI can use it
    _state = _state.copyWith(lastCreatedProjectId: projectId);

    final project = ProjectItem(
      id: projectId,
      title: _state.selectedTemplate?.name ?? 'Untitled Project',
      thumbnailPath: _state.selectedImages.firstOrNull ?? '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      styleId: _state.selectedTemplateId ?? '',
      styleName: _state.selectedTemplate?.name ?? 'Custom',
      durationSeconds: _state.settings.durationSeconds,
      quality: _state.settings.quality,
      tokenCostEstimated: _state.estimatedCost,
      tokenCostCharged: _state.estimatedCost,
      status: ProjectStatus.generating,
      settingsSnapshotJson: _state.settings.toJson(),
    );

    _projectRepo.saveProject(project);
    _draftRepo.clearDraft(); // Clear draft on start

    // 3. Start Mock Simulation
    return _generationService.startGeneration(_state.settings).map((progress) {
      // Side effect: update project status in repo on completion/failure?
      // Or just return the stream and let UI handle it.
      // Better: UI listens and calls finalize.
      return progress;
    });
  }

  Future<void> finalizeGeneration(bool success, String? resultPath) async {
    // Should update project status to success/failed
    // Ideally we track currentProjectId in state to update it.
    // But for mock flow, we just saved it as 'generating'.
    // In real app, backend updates status.
    // Here we should update the LAST saved project (most recent) if we didn't track ID.
    // Or simpler: pass ID around.

    // For simplicity in this mock, we assume the last project added is the current one.
    final projects = await _projectRepo.getProjects();
    if (projects.isNotEmpty) {
      final current = projects.first;
      // Update status
      final updated = current.copyWith(
        status: success ? ProjectStatus.success : ProjectStatus.failed,
        updatedAt: DateTime.now(),
        mockVideoUrlOrPath: resultPath,
      );
      await _projectRepo.saveProject(updated);
    }
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
        return _state.isReviewConfirmed;
      default:
        return true;
    }
  }
}
