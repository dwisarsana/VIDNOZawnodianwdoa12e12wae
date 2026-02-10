import '../local/shared_prefs_service.dart';
import '../../domain/models/wizard_draft.dart';

class DraftRepository {
  final SharedPrefsService _prefs;

  DraftRepository(this._prefs);

  Future<void> saveDraft(WizardDraft draft) async {
    await _prefs.saveWizardDraft(draft);
  }

  WizardDraft? getDraft() {
    return _prefs.getWizardDraft();
  }

  Future<void> clearDraft() async {
    await _prefs.clearWizardDraft();
  }
}
