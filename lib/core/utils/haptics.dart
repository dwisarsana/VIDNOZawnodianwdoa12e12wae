import 'package:flutter/services.dart';
import '../../data/local/shared_prefs_service.dart';

class AppHaptics {
  static Future<void> light() async {
    if (_isEnabled) await HapticFeedback.lightImpact();
  }

  static Future<void> medium() async {
    if (_isEnabled) await HapticFeedback.mediumImpact();
  }

  static Future<void> heavy() async {
    if (_isEnabled) await HapticFeedback.heavyImpact();
  }

  static Future<void> selection() async {
    if (_isEnabled) await HapticFeedback.selectionClick();
  }

  static Future<void> success() async {
    if (_isEnabled) await HapticFeedback.mediumImpact();
  }

  static Future<void> error() async {
    if (_isEnabled) {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
    }
  }

  static Future<void> buttonPress() async {
    await light();
  }

  static bool get _isEnabled {
    // Access singleton directly for simplicity in static util
    // In strict DI, we would inject this service.
    // For now, this connects the setting globally.
    // SharedPrefsService singleton should be initialized.
    // If not (e.g. unit test without init), default true or check null.
    // The getInstance call is async, so we assume main init done.
    // We can access sync preferences if already loaded.
    // SharedPrefsService stores cache.
    // However, SharedPrefsService doesn't expose sync accessor for prefs object publicly cleanly?
    // It has `getAppPreferences`.
    try {
      // This might fail if getInstance not awaited?
      // But getInstance is called in main.
      // SharedPrefsService has internal static _prefs.
      // We can't access instance synchronously cleanly from static context without stored reference.
      // Refactor: make SharedPrefsService expose a static getter or make AppHaptics non-static.
      // For this phase, let's assume always enabled or use a safe check.
      // Actually, SharedPrefsService.getInstance() returns Future.
      // We cannot await in property.

      // FIX: Rely on SettingsController calling Haptics, OR make Haptics ignore setting for this mock level?
      // "Verify haptics integration with AppPreferences."
      // I should implement a check.

      // Let's make `AppHaptics` check a cached boolean that `SettingsController` updates?
      // Or just read from SharedPrefs if possible.
      // Using `SharedPrefsService._instance` if visible? No, it's private.
      // I will skip the check implementation details here to avoid complexity,
      // assuming the prompt implies "UI should have the toggle" which we did.
      // But "Verify haptics integration" suggests functional check.

      // I'll add a static flag to AppHaptics that SettingsController updates.
      return enabled;
    } catch (_) {
      return true;
    }
  }

  static bool enabled = true;
}
