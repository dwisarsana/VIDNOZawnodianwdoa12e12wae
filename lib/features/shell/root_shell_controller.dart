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
    // After switching, the CreateScreen should check this.
    // BUT CreateScreen is kept alive in IndexedStack.
    // We need a way to push data to it.
    // The controller is shared via this notifyListeners.
    // But CreateScreen needs to listen to RootShellController?
    // Usually via passing the controller down or Context.

    // Alternative: setIndex updates, but we need to trigger CreateScreen action.
    // We will clear the pending selection after consumption.
  }

  void consumePendingTemplate() {
    _pendingTemplateSelection = null;
    // No notify needed if just clearing internal state after use,
    // unless UI depends on it being null.
  }
}
