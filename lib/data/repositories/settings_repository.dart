import '../local/shared_prefs_service.dart';
import '../../domain/models/app_preferences.dart';

class SettingsRepository {
  final SharedPrefsService _prefs;

  SettingsRepository(this._prefs);

  AppPreferences getPreferences() {
    return _prefs.getAppPreferences();
  }

  Future<void> savePreferences(AppPreferences prefs) async {
    await _prefs.saveAppPreferences(prefs);
  }

  Future<void> clearAllData() async {
    // Clear all shared preferences
    await _prefs.clearAll(); // Need to implement clearAll in SharedPrefsService
  }
}
