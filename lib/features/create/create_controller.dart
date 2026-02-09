import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../data/repositories/template_repository.dart';
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
      // Handle error (mock)
      _state = _state.copyWith(isLoadingTemplates: false);
    }
    notifyListeners();
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        final newPaths = images.map((e) => e.path).toList();
        final updatedList = [..._state.selectedImages, ...newPaths];
        _state = _state.copyWith(selectedImages: updatedList);
        notifyListeners();
        _saveDraft();
      }
    } catch (e) {
      // Handle picker error
    }
  }

  void removeImage(String path) {
    final updatedList = List<String>.from(_state.selectedImages)..remove(path);
    _state = _state.copyWith(selectedImages: updatedList);
    notifyListeners();
    _saveDraft();
  }

  void selectTemplate(String id) {
    if (_state.selectedTemplateId == id) return;
    _state = _state.copyWith(selectedTemplateId: id);
    notifyListeners();
    _saveDraft();
  }

  void nextStep() {
    if (_state.currentStep < 3) {
      _state = _state.copyWith(currentStep: _state.currentStep + 1);
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

  // Placeholder for later phases
  void _saveDraft() {
    // Implement draft saving logic here (Phase 6)
  }

  bool canProceed() {
    // Basic validation based on step
    switch (_state.currentStep) {
      case 0: // Upload
        // Strict check: must have at least one image
        return _state.selectedImages.isNotEmpty;
      case 1: // Style
        return _state.selectedTemplateId != null;
      default:
        return true;
    }
  }
}
