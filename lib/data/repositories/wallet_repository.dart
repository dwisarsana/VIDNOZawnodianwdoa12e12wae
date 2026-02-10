import '../local/shared_prefs_service.dart';
import '../../domain/models/token_wallet.dart';
import '../../app/constants/app_constants.dart';

class WalletRepository {
  final SharedPrefsService _prefs;

  WalletRepository(this._prefs);

  TokenWallet getWallet() {
    return _prefs.getWallet() ??
      TokenWallet(
        balance: AppConstants.defaultTokenBalance,
        lastTransactionAt: DateTime.now(),
      );
  }

  Future<void> addTokens(int amount) async {
    final current = getWallet();
    final updated = TokenWallet(
      balance: current.balance + amount,
      lifetimeSpent: current.lifetimeSpent,
      lifetimePurchased: current.lifetimePurchased + amount,
      lastTransactionAt: DateTime.now(),
    );
    await _prefs.saveWallet(updated);
  }

  Future<bool> deductTokens(int amount) async {
    final current = getWallet();
    if (current.balance < amount) return false;

    final updated = TokenWallet(
      balance: current.balance - amount,
      lifetimeSpent: current.lifetimeSpent + amount,
      lifetimePurchased: current.lifetimePurchased,
      lastTransactionAt: DateTime.now(),
    );
    await _prefs.saveWallet(updated);
    return true;
  }

  bool hasSufficientTokens(int cost) {
    final current = getWallet();
    return current.balance >= cost;
  }
}
