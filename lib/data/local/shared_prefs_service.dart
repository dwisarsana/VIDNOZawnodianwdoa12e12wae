import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/constants/prefs_keys.dart';
import '../../domain/models/token_wallet.dart';
import '../../domain/models/app_preferences.dart';
import '../../domain/models/onboarding_profile.dart';
import '../../domain/models/project_item.dart';
import '../../domain/models/wizard_draft.dart';

class SharedPrefsService {
  static SharedPrefsService? _instance;
  static SharedPreferences? _prefs;

  SharedPrefsService._();

  static Future<SharedPrefsService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPrefsService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // VisibleForTesting
  static void reset() {
    _instance = null;
    _prefs = null;
  }

  // Generic Getters/Setters
  Future<bool> setBool(String key, bool value) => _prefs!.setBool(key, value);
  bool getBool(String key, {bool defaultValue = false}) => _prefs!.getBool(key) ?? defaultValue;

  Future<bool> setString(String key, String value) => _prefs!.setString(key, value);
  String getString(String key, {String defaultValue = ''}) => _prefs!.getString(key) ?? defaultValue;

  Future<bool> setInt(String key, int value) => _prefs!.setInt(key, value);
  int getInt(String key, {int defaultValue = 0}) => _prefs!.getInt(key) ?? defaultValue;

  // Domain Specific Helpers

  bool get onboardingDone => getBool(PrefsKeys.onboardingDone);
  Future<bool> setOnboardingDone(bool value) => setBool(PrefsKeys.onboardingDone, value);

  // Wallet
  TokenWallet? getWallet() {
    final jsonStr = getString(PrefsKeys.walletTokens);
    if (jsonStr.isEmpty) return null;
    try {
      return TokenWallet.fromJson(jsonDecode(jsonStr));
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveWallet(TokenWallet wallet) {
    return setString(PrefsKeys.walletTokens, jsonEncode(wallet.toJson()));
  }

  // App Preferences
  AppPreferences getAppPreferences() {
    final jsonStr = getString(PrefsKeys.appPreferencesJson);
    if (jsonStr.isEmpty) return const AppPreferences();
    try {
      return AppPreferences.fromJson(jsonDecode(jsonStr));
    } catch (e) {
      return const AppPreferences();
    }
  }

  Future<bool> saveAppPreferences(AppPreferences prefs) {
    return setString(PrefsKeys.appPreferencesJson, jsonEncode(prefs.toJson()));
  }

  // Wizard Draft
  WizardDraft? getWizardDraft() {
    final jsonStr = getString(PrefsKeys.wizardDraftJson);
    if (jsonStr.isEmpty) return null;
    try {
      return WizardDraft.fromJson(jsonDecode(jsonStr));
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveWizardDraft(WizardDraft draft) {
    return setString(PrefsKeys.wizardDraftJson, jsonEncode(draft.toJson()));
  }

  Future<bool> clearWizardDraft() {
    return _prefs!.remove(PrefsKeys.wizardDraftJson);
  }

  // Projects History
  List<ProjectItem> getProjectsHistory() {
    final jsonStr = getString(PrefsKeys.projectsHistoryJson);
    if (jsonStr.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => ProjectItem.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveProjectsHistory(List<ProjectItem> projects) {
    return setString(PrefsKeys.projectsHistoryJson, jsonEncode(projects.map((e) => e.toJson()).toList()));
  }

  // Tab Index
  int getLastOpenedTabIndex() => getInt(PrefsKeys.lastOpenedTabIndex, defaultValue: 0);
  Future<bool> setLastOpenedTabIndex(int index) => setInt(PrefsKeys.lastOpenedTabIndex, index);

  // Clear
  Future<bool> clearAll() => _prefs!.clear();
}
