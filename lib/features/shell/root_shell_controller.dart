import 'package:flutter/material.dart';
import '../../data/local/shared_prefs_service.dart';

class RootShellController extends ChangeNotifier {
  final SharedPrefsService _prefs;
  int _currentIndex = 0;

  RootShellController(this._prefs) {
    _currentIndex = _prefs.getLastOpenedTabIndex();
  }

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _prefs.setLastOpenedTabIndex(index);
    notifyListeners();
  }
}
