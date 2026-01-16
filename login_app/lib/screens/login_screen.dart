import 'package:flutter/material.dart';
import '../core/design_system.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _formController;
  late AnimationController _pawController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _formAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pawAnimation;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pawController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);

    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutBack),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
        );

    _pawAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pawController, curve: Curves.elasticOut),
    );

    _backgroundController.repeat();
    _formController.forward();
    _pawController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _formController.dispose();
    _pawController.dispose();
    super.dispose();
  }

  void _handleLoginSuccess() {
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
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
                : AppColors.sunsetGradient,
          ),
        ),
        child: Stack(
          children: [
            // Animated paw prints background
            ...List.generate(5, (index) {
              return AnimatedBuilder(
                animation: _backgroundAnimation,
                builder: (context, child) {
                  final offset = (index * 0.2) + _backgroundAnimation.value;
                  return Positioned(
                    top: 50 + (index * 120.0) + (30 * (offset % 1)),
                    right: index.isEven ? 20 + (50 * (offset % 1)) : null,
                    left: index.isOdd ? 20 + (50 * (offset % 1)) : null,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        Icons.pets,
                        size: 40 + (index * 10.0),
                        color: AppColors.white,
                      ),
                    ),
                  );
                },
              );
            }),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.xxxl),

                      // App logo and title
                      FadeTransition(
                        opacity: _formAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              // Animated paw icon
                              AnimatedBuilder(
                                animation: _pawAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.0 + (_pawAnimation.value * 0.1),
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            AppColors.white.withValues(
                                              alpha: 0.1,
                                            ),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.pets,
                                        size: 60,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Text(
                                '🐾 PawPal',
                                style: AppTextStyles.h1.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Find Your Perfect Furry Friend',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xxxl),

                      // Login form
                      FadeTransition(
                        opacity: _formAnimation,
                        child: LoginForm(onLoginSuccess: _handleLoginSuccess),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Sign up link
                      FadeTransition(
                        opacity: _formAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New to PawPal? ",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showComingSoon('Sign up'),
                              child: Text(
                                'Join Now',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.white,
                                  decorationThickness: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Fun tagline
                      FadeTransition(
                        opacity: _formAnimation,
                        child: Text(
                          '🐶 🐱 🐰 Every pet deserves a loving home 🏡',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white.withValues(alpha: 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.pets, color: Colors.white),
            const SizedBox(width: 8),
            Text('$feature coming soon! 🐾'),
          ],
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
      ),
    );
  }
}
