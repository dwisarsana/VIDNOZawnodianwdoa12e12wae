import 'package:flutter/material.dart';
import '../../../../data/repositories/wallet_repository.dart';

class PaywallController extends ChangeNotifier {
  final WalletRepository _walletRepo;
  bool _isLoading = false;

  PaywallController(this._walletRepo);

  bool get isLoading => _isLoading;

  Future<bool> purchasePack(int amount) async {
    _isLoading = true;
    notifyListeners();

    // Mock network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Success logic
    await _walletRepo.addTokens(amount);

    _isLoading = false;
    notifyListeners();
    return true;
  }
}
