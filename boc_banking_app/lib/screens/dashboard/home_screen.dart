import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../widgets/navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bocBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Card
                    _buildAccountCard(),
                    const SizedBox(height: 24),

                    // Quick Actions
                    _buildQuickActions(context),
                    const SizedBox(height: 24),

                    // Spending Summary
                    _buildSpendingSummary(),
                    const SizedBox(height: 24),

                    // Recent Activity
                    _buildRecentActivity(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BOCNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // TODO: handle bottom navigation taps (change screen / update index)
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BOC',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.bocGold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Hello, User Name',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.bocGold),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.bocGold),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.bocGold.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.account_balance,
              size: 120,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Account',
                      style: TextStyle(
                        color: AppColors.bocBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility,
                          color: AppColors.bocBlack),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'LKR 125,750.50',
                  style: TextStyle(
                    color: AppColors.bocBlack,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '****4551',
                      style: TextStyle(
                        color: AppColors.bocBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Current',
                      style: TextStyle(
                        color: AppColors.bocBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickAction(Icons.swap_horiz, 'Transfers', () {}),
            _buildQuickAction(Icons.qr_code_scanner, 'QR Payment', () {}),
            _buildQuickAction(Icons.receipt, 'Pay Bills', () {}),
            _buildQuickAction(Icons.add_circle_outline, 'Top Up', () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bocDarkBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.bocGold.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: AppColors.bocGold, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bocDarkBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.bocGold.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "This Month's Spending",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.trending_up, color: AppColors.bocSuccess),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'LKR 45,200',
            style: TextStyle(
              color: AppColors.bocGold,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '12% less than last month',
            style: TextStyle(
              color: AppColors.bocSuccess,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final transactions = [
      {
        'name': 'Keels super',
        'amount': '- LKR 2,450',
        'date': '2025-11-05',
        'type': 'debit'
      },
      {
        'name': 'Salary Credit',
        'amount': '+ LKR 85,000',
        'date': '2025-11-01',
        'type': 'credit'
      },
      {
        'name': 'Uber Rides',
        'amount': '- LKR 650',
        'date': '2025-11-04',
        'type': 'debit'
      },
      {
        'name': 'Netflix',
        'amount': '- LKR 1,200',
        'date': '2025-11-03',
        'type': 'debit'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'See All',
                style: TextStyle(color: AppColors.bocGold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...transactions.map((tx) => _buildTransactionItem(
              tx['name']!,
              tx['amount']!,
              tx['date']!,
              tx['type']! == 'credit',
            )),
      ],
    );
  }

  Widget _buildTransactionItem(
      String name, String amount, String date, bool isCredit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bocDarkBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCredit
                  ? AppColors.bocSuccess.withValues(alpha: 0.2)
                  : AppColors.bocError.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              color: isCredit ? AppColors.bocSuccess : AppColors.bocError,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(DateTime.parse(date)),
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: isCredit ? AppColors.bocSuccess : AppColors.bocError,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
