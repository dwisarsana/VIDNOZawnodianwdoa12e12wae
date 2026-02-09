class TokenWallet {
  final int balance;
  final int lifetimeSpent;
  final int lifetimePurchased;
  final DateTime lastTransactionAt;

  const TokenWallet({
    this.balance = 0,
    this.lifetimeSpent = 0,
    this.lifetimePurchased = 0,
    required this.lastTransactionAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'lifetimeSpent': lifetimeSpent,
      'lifetimePurchased': lifetimePurchased,
      'lastTransactionAt': lastTransactionAt.toIso8601String(),
    };
  }

  factory TokenWallet.fromJson(Map<String, dynamic> json) {
    return TokenWallet(
      balance: json['balance'] ?? 0,
      lifetimeSpent: json['lifetimeSpent'] ?? 0,
      lifetimePurchased: json['lifetimePurchased'] ?? 0,
      lastTransactionAt: DateTime.parse(json['lastTransactionAt']),
    );
  }
}
