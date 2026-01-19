class Account {
  final String id;
  final String type;
  final String accountNumber;
  final double balance;
  final String currency;

  Account({
    required this.id,
    required this.type,
    required this.accountNumber,
    required this.balance,
    this.currency = 'LKR',
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'LKR',
    );
  }

  String get formattedBalance {
    return '$currency ${balance.toStringAsFixed(2)}';
  }
}
