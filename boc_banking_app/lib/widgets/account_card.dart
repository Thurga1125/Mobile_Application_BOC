import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AccountCard extends StatelessWidget {
  final String accountType;
  final String accountNumber;
  final double balance;
  final VoidCallback? onTap;

  const AccountCard({
    super.key,
    required this.accountType,
    required this.accountNumber,
    required this.balance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.bocGold.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              accountType,
              style: const TextStyle(
                color: AppColors.bocBlack,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'LKR ${balance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.bocBlack,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              accountNumber,
              style: const TextStyle(
                color: AppColors.bocBlack,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
