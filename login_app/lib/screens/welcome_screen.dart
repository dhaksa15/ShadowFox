import 'package:flutter/material.dart';
import '../core/design_system.dart';
import '../widgets/app_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _heartController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _heartAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );

    _mainController.forward();
    _floatingController.repeat(reverse: true);
    _heartController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Leave PawPal?'),
            ],
          ),
          content: const Text(
            'The pets will miss you! Are you sure you want to sign out?',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            AppButton(
              text: 'Stay',
              type: AppButtonType.text,
              size: AppButtonSize.small,
              onPressed: () => Navigator.of(context).pop(),
            ),
            AppButton(
              text: 'Sign Out',
              type: AppButtonType.primary,
              size: AppButtonSize.small,
              gradientColors: const [AppColors.error, Color(0xFFDC2626)],
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1625),
                    const Color(0xFF2D2438),
                    const Color(0xFF1A1625),
                  ]
                : [
                    const Color(0xFFFFE5EC),
                    const Color(0xFFFFF5E1),
                    const Color(0xFFE5F5FF),
                  ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Stack(
                      children: [
                        // Floating pet icons
                        _buildFloatingPets(screenWidth, screenHeight),

                        // Main scrollable content
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                _buildHeader(),
                                const SizedBox(height: 30),
                                _buildWelcomeCard(),
                                const SizedBox(height: 30),
                                _buildPetCategories(),
                                const SizedBox(height: 30),
                                _buildBottomActions(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingPets(double screenWidth, double screenHeight) {
    final pets = ['🐶', '🐱', '🐰', '🐦', '🐹'];
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(pets.length, (index) {
            return Positioned(
              top:
                  screenHeight * (0.15 + index * 0.15) +
                  _floatingAnimation.value * (index.isEven ? 1 : -1),
              right: index.isEven ? 20 + (index * 10.0) : null,
              left: index.isOdd ? 20 + (index * 10.0) : null,
              child: Opacity(
                opacity: 0.15,
                child: Text(
                  pets[index],
                  style: TextStyle(fontSize: 40 + (index * 5.0)),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('🐾 ', style: AppTextStyles.h2),
                Text(
                  'PawPal',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Your pet adoption companion',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            boxShadow: AppShadows.small,
          ),
          child: IconButton(
            onPressed: _showLogoutDialog,
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return AnimatedBuilder(
      animation: _heartAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.sunsetGradient),
            borderRadius: BorderRadius.circular(AppBorderRadius.xxl),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Transform.scale(
                scale: _heartAnimation.value,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.3),
                  ),
                  child: const Center(
                    child: Text('❤️', style: TextStyle(fontSize: 35)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome Back!',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ready to find your perfect companion?',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatBadge('127', 'Pets Available'),
                  Container(
                    width: 1,
                    height: 30,
                    color: AppColors.white.withValues(alpha: 0.3),
                  ),
                  _buildStatBadge('42', 'Adopted Today'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatBadge(String value, String label) {
    return Column(
      children: [
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
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildPetCategories() {
    final categories = [
      {
        'icon': '🐶',
        'name': 'Dogs',
        'color': AppColors.dogBrown,
        'count': '45',
      },
      {
        'icon': '🐱',
        'name': 'Cats',
        'color': AppColors.catOrange,
        'count': '38',
      },
      {
        'icon': '🐰',
        'name': 'Rabbits',
        'color': AppColors.rabbitGrey,
        'count': '22',
      },
      {
        'icon': '🐦',
        'name': 'Birds',
        'color': AppColors.birdBlue,
        'count': '18',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Browse by Category',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.grey800,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(
              icon: category['icon'] as String,
              name: category['name'] as String,
              count: category['count'] as String,
              color: category['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String icon,
    required String name,
    required String count,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/search');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Showing $name 🐾'),
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: AppShadows.small,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.grey800,
              ),
            ),
            Text(
              '$count available',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Column(
      children: [
        AppButton(
          text: 'Explore All Pets',
          type: AppButtonType.gradient,
          size: AppButtonSize.large,
          fullWidth: true,
          icon: Icons.pets,
          gradientColors: AppColors.primaryGradient,
          onPressed: () => Navigator.pushNamed(context, '/dashboard'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'My Profile',
                type: AppButtonType.outline,
                size: AppButtonSize.medium,
                icon: Icons.person_outline,
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: 'Settings',
                type: AppButtonType.outline,
                size: AppButtonSize.medium,
                icon: Icons.settings_outlined,
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
