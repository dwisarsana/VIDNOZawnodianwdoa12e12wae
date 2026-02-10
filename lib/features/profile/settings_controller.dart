import 'package:flutter/material.dart';
import '../../core/utils/haptics.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/models/app_preferences.dart';

class SettingsController extends ChangeNotifier {
  final SettingsRepository _repo;
  late AppPreferences _prefs;

  SettingsController(this._repo) {
    _loadPrefs();
  }

  AppPreferences get prefs => _prefs;

  void _loadPrefs() {
    _prefs = _repo.getPreferences();
    _updateGlobalHaptics();
    notifyListeners();
  }

  void _updateGlobalHaptics() {
    AppHaptics.enabled = _prefs.hapticsEnabled;
  }

  Future<void> toggleHaptics(bool value) async {
    _prefs = AppPreferences(
      hapticsEnabled: value,
      autoSaveDrafts: _prefs.autoSaveDrafts,
      reducedMotion: _prefs.reducedMotion,
    );
    await _repo.savePreferences(_prefs);
    _updateGlobalHaptics();
    notifyListeners();
  }

  Future<void> toggleAutoSave(bool value) async {
    _prefs = AppPreferences(
      hapticsEnabled: _prefs.hapticsEnabled,
      autoSaveDrafts: value,
      reducedMotion: _prefs.reducedMotion,
    );
    await _repo.savePreferences(_prefs);
    notifyListeners();
  }

  Future<void> toggleReducedMotion(bool value) async {
    _prefs = AppPreferences(
      hapticsEnabled: _prefs.hapticsEnabled,
      autoSaveDrafts: _prefs.autoSaveDrafts,
      reducedMotion: value,
    );
    await _repo.savePreferences(_prefs);
    notifyListeners();
  }

  Future<void> clearAppData() async {
    await _repo.clearAllData();
    // After clear, restart app? Or just reset state?
    // Since this is mock, we can just reload default prefs.
    _loadPrefs();
  }
}
