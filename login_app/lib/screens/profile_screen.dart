import 'package:flutter/material.dart';
import '../core/design_system.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.sunsetGradient),
                ),
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withValues(alpha: 0.3),
                        border: Border.all(color: AppColors.white, width: 3),
                      ),
                      child: const Center(
                        child: Text('👤', style: TextStyle(fontSize: 50)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pet Lover',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'petlover@pawpal.com',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatBadge('5', 'Favorites', '❤️'),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.white.withValues(alpha: 0.3),
                        ),
                        _buildStatBadge('2', 'Adopted', '🏠'),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.white.withValues(alpha: 0.3),
                        ),
                        _buildStatBadge('12', 'Reviews', '⭐'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Menu Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildMenuSection('My Activity', [
                      _buildMenuItem(
                        context,
                        icon: Icons.favorite,
                        title: 'Favorite Pets',
                        subtitle: '5 pets saved',
                        color: AppColors.primary,
                        onTap: () => _showFavorites(context),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.pets,
                        title: 'Adoption History',
                        subtitle: '2 pets adopted',
                        color: AppColors.secondary,
                        onTap: () => _showAdoptionHistory(context),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.star,
                        title: 'My Reviews',
                        subtitle: '12 reviews written',
                        color: AppColors.accent,
                        onTap: () => _showReviews(context),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _buildMenuSection('Account', [
                      _buildMenuItem(
                        context,
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        subtitle: 'Update your information',
                        color: AppColors.info,
                        onTap: () => _showEditProfile(context),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage alerts',
                        color: AppColors.warning,
                        onTap: () =>
                            Navigator.pushNamed(context, '/notifications'),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        subtitle: 'App preferences',
                        color: AppColors.grey600,
                        onTap: () => Navigator.pushNamed(context, '/settings'),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _buildMenuSection('Support', [
                      _buildMenuItem(
                        context,
                        icon: Icons.help_outline,
                        title: 'Help & FAQ',
                        subtitle: 'Get assistance',
                        color: AppColors.birdBlue,
                        onTap: () => Navigator.pushNamed(context, '/help'),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.info_outline,
                        title: 'About PawPal',
                        subtitle: 'Learn more about us',
                        color: AppColors.secondary,
                        onTap: () => _showAboutDialog(context),
                      ),
                    ]),

                    const SizedBox(height: 32),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _showLogoutDialog(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: AppColors.error,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppBorderRadius.md,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout, color: AppColors.error),
                            const SizedBox(width: 8),
                            Text(
                              'Sign Out',
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(String value, String label, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.h5.copyWith(
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

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        boxShadow: AppShadows.small,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.white : AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark ? AppColors.grey400 : AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDark ? AppColors.grey500 : AppColors.grey400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFavorites(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final favorites = [
          {'name': 'Max', 'breed': 'Golden Retriever', 'emoji': '🐕'},
          {'name': 'Luna', 'breed': 'Persian Cat', 'emoji': '🐈'},
          {'name': 'Coco', 'breed': 'Holland Lop', 'emoji': '🐰'},
          {'name': 'Charlie', 'breed': 'Parakeet', 'emoji': '🦜'},
          {'name': 'Bella', 'breed': 'Beagle', 'emoji': '🐶'},
        ];

        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
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
              Row(
                children: [
                  const Text('❤️', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    'My Favorite Pets',
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final pet = favorites[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Row(
                        children: [
                          Text(
                            pet['emoji']!,
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet['name']!,
                                  style: AppTextStyles.h6.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  pet['breed']!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.favorite, color: AppColors.primary),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAdoptionHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final adopted = [
          {
            'name': 'Buddy',
            'breed': 'Labrador',
            'emoji': '🐕‍🦺',
            'date': 'Jan 2025',
          },
          {
            'name': 'Whiskers',
            'breed': 'Siamese Cat',
            'emoji': '🐱',
            'date': 'Dec 2024',
          },
        ];

        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
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
              Row(
                children: [
                  const Text('🏠', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    'Adoption History',
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: adopted.length,
                  itemBuilder: (context, index) {
                    final pet = adopted[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Row(
                        children: [
                          Text(
                            pet['emoji']!,
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet['name']!,
                                  style: AppTextStyles.h6.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  pet['breed']!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.grey600,
                                  ),
                                ),
                                Text(
                                  'Adopted ${pet['date']}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReviews(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Text('⭐'),
            SizedBox(width: 8),
            Expanded(
              child: Text('You have 12 reviews! Great job helping pets!'),
            ),
          ],
        ),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Text('✏️'),
            SizedBox(width: 8),
            Expanded(child: Text('Edit profile feature coming soon!')),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          title: const Row(
            children: [Text('🐾'), SizedBox(width: 8), Text('Leaving PawPal?')],
          ),
          content: const Text(
            'The pets will miss you! Are you sure you want to sign out?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Stay'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          title: const Row(
            children: [Text('🐾'), SizedBox(width: 8), Text('About PawPal')],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PawPal - Pet Adoption & Care', style: AppTextStyles.h6),
              SizedBox(height: 8),
              Text('Version 1.0.0'),
              SizedBox(height: 16),
              Text(
                'Connecting loving homes with pets in need. Every pet deserves a family! 🏡',
                style: AppTextStyles.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                '🐶 🐱 🐰 🐦 🐹',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
