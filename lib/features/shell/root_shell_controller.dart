import 'package:flutter/material.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../domain/models/template_item.dart';

class RootShellController extends ChangeNotifier {
  final SharedPrefsService _prefs;
  int _currentIndex = 0;

  // To communicate template selection to Create tab
  TemplateItem? _pendingTemplateSelection;

  RootShellController(this._prefs) {
    _currentIndex = _prefs.getLastOpenedTabIndex();
  }

  int get currentIndex => _currentIndex;
  TemplateItem? get pendingTemplateSelection => _pendingTemplateSelection;

  void setIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _prefs.setLastOpenedTabIndex(index);
    notifyListeners();
  }

  void switchToCreateWithTemplate(TemplateItem template) {
    _pendingTemplateSelection = template;
    setIndex(0); // 0 is Create
    // The view (RootShell) will rebuild with new index and pass _pendingTemplateSelection to CreateScreen
  }

  void consumePendingTemplate() {
    _pendingTemplateSelection = null;
    // No notify needed if we just clear it to avoid re-triggering?
    // Actually, CreateScreen calls this. If we notify, it rebuilds CreateScreen with null?
    // Yes, that's fine.
    notifyListeners();
  }
}
