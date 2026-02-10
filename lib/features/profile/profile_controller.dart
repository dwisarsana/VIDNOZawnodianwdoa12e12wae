import 'package:flutter/material.dart';
import '../../../../data/local/shared_prefs_service.dart';
import '../../../../data/repositories/wallet_repository.dart';
import '../../../../domain/models/token_wallet.dart';

class ProfileController extends ChangeNotifier {
  final WalletRepository _walletRepo;
  TokenWallet? _wallet;

  ProfileController(this._walletRepo) {
    _loadData();
  }

  TokenWallet? get wallet => _wallet;

  void _loadData() {
    _wallet = _walletRepo.getWallet();
    notifyListeners();
  }

  Future<void> refresh() async {
    // In real app, might fetch API. Here just re-read prefs.
    _loadData();
  }
}
