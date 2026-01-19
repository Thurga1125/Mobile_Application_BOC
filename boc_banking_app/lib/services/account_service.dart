import '../models/account.dart';
import '../models/transaction.dart';
import '../models/card.dart';

class AccountService {
  static final AccountService _instance = AccountService._internal();
  factory AccountService() => _instance;
  AccountService._internal();

  Future<List<Account>> getAccounts() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      Account(
        id: '1',
        type: 'Current',
        accountNumber: '****4551',
        balance: 125750.5,
      ),
      Account(
        id: '2',
        type: 'Savings',
        accountNumber: '****4221',
        balance: 245000,
      ),
      Account(
        id: '3',
        type: 'Fixed',
        accountNumber: '****8621',
        balance: 2500000,
      ),
    ];
  }

  Future<List<Transaction>> getTransactions({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      Transaction(
        id: '1',
        type: 'debit',
        description: 'Keels super',
        amount: 2450,
        date: DateTime(2025, 11, 5),
        category: 'Shopping',
      ),
      Transaction(
        id: '2',
        type: 'credit',
        description: 'Salary Credit',
        amount: 85000,
        date: DateTime(2025, 11, 1),
        category: 'Salary',
      ),
      Transaction(
        id: '3',
        type: 'debit',
        description: 'Uber Rides',
        amount: 650,
        date: DateTime(2025, 11, 4),
        category: 'Transport',
      ),
      Transaction(
        id: '4',
        type: 'debit',
        description: 'Netflix',
        amount: 1200,
        date: DateTime(2025, 11, 3),
        category: 'Entertainment',
      ),
    ];
  }

  Future<List<BankCard>> getCards() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      BankCard(
        id: '1',
        type: 'Platinum',
        cardNumber: '************4551',
        balance: 245000,
        expiryDate: '12/28',
        status: 'active',
      ),
      BankCard(
        id: '2',
        type: 'Platinum',
        cardNumber: '************4221',
        balance: 245000,
        expiryDate: '08/27',
        status: 'active',
      ),
    ];
  }

  Future<Map<String, dynamic>> transferFunds({
    required String fromAccount,
    required String toAccount,
    required double amount,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return {
      'success': true,
      'transactionId': 'TXN${DateTime.now().millisecondsSinceEpoch}',
      'message': 'Transfer successful',
    };
  }

  Future<Map<String, dynamic>> payBill({
    required String billerId,
    required double amount,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return {
      'success': true,
      'transactionId': 'BILL${DateTime.now().millisecondsSinceEpoch}',
      'message': 'Bill payment successful',
    };
  }

  Future<Map<String, dynamic>> blockCard(String cardId) async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'message': 'Card blocked successfully',
    };
  }
}
