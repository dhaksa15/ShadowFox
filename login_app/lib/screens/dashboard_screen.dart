import 'package:flutter/material.dart';
import '../core/design_system.dart';
import '../widgets/logout_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, dynamic>> _featuredPets = [
    {
      'name': 'Max',
      'type': 'Golden Retriever',
      'age': '2 years',
      'emoji': '🐕',
      'color': AppColors.dogBrown,
      'description': 'Friendly and energetic!',
    },
    {
      'name': 'Luna',
      'type': 'Persian Cat',
      'age': '1 year',
      'emoji': '🐈',
      'color': AppColors.catOrange,
      'description': 'Calm and cuddly',
    },
    {
      'name': 'Coco',
      'type': 'Holland Lop',
      'age': '6 months',
      'emoji': '🐰',
      'color': AppColors.rabbitGrey,
      'description': 'Adorable and playful',
    },
    {
      'name': 'Charlie',
      'type': 'Parakeet',
      'age': '8 months',
      'emoji': '🦜',
      'color': AppColors.birdBlue,
      'description': 'Chirpy and social',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
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
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🐾 '),
                    Text(
                      'Available Pets',
                      style: AppTextStyles.h5.copyWith(
                        color: isDark ? AppColors.white : AppColors.grey900,
                      ),
                    ),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.primaryGradient,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Stats Section
                  _buildStatsSection(),
                  const SizedBox(height: 24),

                  // Featured Pets Title
                  Text(
                    'Featured Pets 🌟',
                    style: AppTextStyles.h4.copyWith(
                      color: isDark ? AppColors.white : AppColors.grey900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Featured Pets Grid
                  ...List.generate(_featuredPets.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildPetCard(_featuredPets[index], isDark),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Adoption Tips
                  _buildAdoptionTips(isDark),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.secondaryGradient),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: AppShadows.medium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('127', 'Available', '🐾'),
          _buildStatItem('42', 'Adopted', '❤️'),
          _buildStatItem('15', 'Shelters', '🏠'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.h4.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: AppShadows.medium,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPetDetails(pet),
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Pet Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: (pet['color'] as Color).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Center(
                    child: Text(
                      pet['emoji'],
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Pet Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet['name'],
                        style: AppTextStyles.h5.copyWith(
                          color: isDark ? AppColors.white : AppColors.grey900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pet['type'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark ? AppColors.grey300 : AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.cake_outlined,
                            size: 14,
                            color: isDark
                                ? AppColors.grey400
                                : AppColors.grey500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            pet['age'],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.grey400
                                  : AppColors.grey500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pet['description'],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: pet['color'] as Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Heart Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdoptionTips(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppColors.accentGradient),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                'Adoption Tips',
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('Visit the shelter to meet pets in person'),
          _buildTipItem('Ask about the pet\'s personality and needs'),
          _buildTipItem('Prepare your home before bringing them'),
          _buildTipItem('Schedule a vet checkup within first week'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(color: AppColors.white, fontSize: 16),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.95),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPetDetails(Map<String, dynamic> pet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.surfaceDark
                : AppColors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppBorderRadius.xxl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(pet['emoji'], style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text(
                pet['name'],
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                '${pet['type']} • ${pet['age']}',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                pet['description'],
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showAdoptionInterest(pet['name']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                  ),
                  child: Text(
                    'I\'m Interested! ❤️',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAdoptionInterest(String petName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🎉'),
            const SizedBox(width: 8),
            Expanded(child: Text('Great! We\'ll help you adopt $petName!')),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
      ),
    );
  }
}
