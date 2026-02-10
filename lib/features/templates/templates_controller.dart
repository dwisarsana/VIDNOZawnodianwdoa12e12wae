import 'package:flutter/material.dart';
import '../../data/repositories/template_repository.dart';
import '../../domain/enums/template_category.dart';
import '../../domain/models/template_item.dart';
import 'templates_state.dart';

class TemplatesController extends ChangeNotifier {
  final TemplateRepository _repo;
  TemplatesState _state = const TemplatesState();

  TemplatesController(this._repo) {
    loadTemplates();
  }

  TemplatesState get state => _state;

  Future<void> loadTemplates() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final all = await _repo.getTemplates();
      // Pick featured (e.g. first premium or just first)
      final featured = all.isNotEmpty ? all.firstWhere((t) => t.isPremium, orElse: () => all.first) : null;

      _state = _state.copyWith(
        templates: all,
        filteredTemplates: all,
        isLoading: false,
        featuredTemplate: featured,
      );
    } catch (_) {
      _state = _state.copyWith(isLoading: false);
    }
    notifyListeners();
  }

  void setCategory(TemplateCategory? category) {
    if (_state.selectedCategory == category) return;

    List<TemplateItem> filtered;
    if (category == null) {
      filtered = List.from(_state.templates);
    } else {
      filtered = _state.templates.where((t) => t.category == category).toList();
    }

    _state = _state.copyWith(
      selectedCategory: category,
      filteredTemplates: filtered,
    );
    notifyListeners();
  }
}
