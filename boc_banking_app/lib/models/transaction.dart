class Transaction {
  final String id;
  final String type; // 'debit' or 'credit'
  final String description;
  final double amount;
  final DateTime date;
  final String category;

  Transaction({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      category: json['category'] ?? '',
    );
  }

  bool get isDebit => type.toLowerCase() == 'debit';

  String get formattedAmount {
    return '${isDebit ? '-' : '+'} LKR ${amount.toStringAsFixed(2)}';
  }
}
