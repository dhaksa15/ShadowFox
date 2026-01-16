import 'package:flutter/material.dart';
import '../core/design_system.dart';
import '../widgets/logout_button.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('❓ '), Text('Help & FAQ')],
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LogoutButton(
              backgroundColor: Colors.transparent,
              iconColor: isDark ? AppColors.white : AppColors.primary,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Contact Support Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.primaryGradient),
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              boxShadow: AppShadows.medium,
            ),
            child: Column(
              children: [
                const Text('💬', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text(
                  'Need Help?',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Our team is here to help you find your perfect pet companion',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                  ),
                  child: const Text('Contact Support'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Frequently Asked Questions',
            style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 16),

          _buildFAQItem(
            '🐾 How do I adopt a pet?',
            'Browse available pets, select your favorite, and submit an adoption request. Our team will guide you through the process!',
            isDark,
          ),
          _buildFAQItem(
            '❤️ Can I meet the pet before adopting?',
            'Absolutely! We encourage shelter visits to meet your potential new friend. Schedule a visit through the app.',
            isDark,
          ),
          _buildFAQItem(
            '🏠 What are the adoption requirements?',
            'Requirements vary by pet and shelter. Generally, you\'ll need to be 18+, have a stable home, and pass a background check.',
            isDark,
          ),
          _buildFAQItem(
            '💰 Are there adoption fees?',
            'Yes, adoption fees help cover veterinary care, food, and shelter costs. Fees vary by pet and are shown in each listing.',
            isDark,
          ),
          _buildFAQItem(
            '🐶 What if I have other pets?',
            'Many pets do great with companions! We can help you find a pet that matches your household. Mention this in your application.',
            isDark,
          ),
          _buildFAQItem(
            '📱 How do I use the app?',
            'Browse pets, save favorites, search by breed or type, and submit adoption requests. Check notifications for updates!',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        boxShadow: AppShadows.small,
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            question,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.grey300 : AppColors.grey600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
