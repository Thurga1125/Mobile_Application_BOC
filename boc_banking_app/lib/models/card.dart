class BankCard {
  final String id;
  final String type;
  final String cardNumber;
  final double balance;
  final String expiryDate;
  final String status;

  BankCard({
    required this.id,
    required this.type,
    required this.cardNumber,
    required this.balance,
    required this.expiryDate,
    required this.status,
  });

  factory BankCard.fromJson(Map<String, dynamic> json) {
    return BankCard(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      expiryDate: json['expiryDate'] ?? '',
      status: json['status'] ?? '',
    );
  }

  bool get isActive => status.toLowerCase() == 'active';

  String get maskedCardNumber {
    if (cardNumber.length >= 4) {
      return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
    }
    return cardNumber;
  }
}
