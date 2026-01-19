import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../widgets/navigation_bar.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bocBlack,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickPay(),
                    const SizedBox(height: 24),
                    _buildCategories(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BOCNavigationBar(
        currentIndex: 3,
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
          const Text(
            'My Payment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.bocGold, size: 28),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Pay',
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
            _buildQuickPayItem(Icons.flash_on, 'Electricity', Colors.orange),
            _buildQuickPayItem(Icons.water_drop, 'Water', Colors.blue),
            _buildQuickPayItem(Icons.wifi, 'Internet', Colors.purple),
            _buildQuickPayItem(Icons.phone_android, 'Mobile', Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickPayItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildCategoryItem(Icons.power, 'Utilities', '4 billers'),
        const SizedBox(height: 12),
        _buildCategoryItem(Icons.phone, 'Telecommunications', '3 billers'),
        const SizedBox(height: 12),
        _buildCategoryItem(Icons.favorite, 'Insurance', '2 billers'),
        const SizedBox(height: 12),
        _buildCategoryItem(Icons.school, 'Education', '3 billers'),
        const SizedBox(height: 12),
        _buildCategoryItem(Icons.account_balance, 'Government', '5 billers'),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bocDarkBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.bocGold.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bocGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.bocGold, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              color: AppColors.bocGold, size: 20),
        ],
      ),
    );
  }
}
