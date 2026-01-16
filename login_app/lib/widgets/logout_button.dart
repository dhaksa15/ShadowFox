import 'package:flutter/material.dart';
import '../core/design_system.dart';
import 'app_button.dart';

class LogoutButton extends StatelessWidget {
  final bool isIconOnly;
  final Color? iconColor;
  final Color? backgroundColor;

  const LogoutButton({
    super.key,
    this.isIconOnly = true,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isIconOnly) {
      return Container(
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              (isDark ? AppColors.surfaceDark : AppColors.white),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          boxShadow: AppShadows.small,
        ),
        child: IconButton(
          onPressed: () => _showLogoutDialog(context),
          icon: Icon(
            Icons.logout_rounded,
            color: iconColor ?? AppColors.primary,
            size: 20,
          ),
        ),
      );
    }

    return AppButton(
      text: 'Sign Out',
      type: AppButtonType.outline,
      size: AppButtonSize.small,
      icon: Icons.logout_rounded,
      onPressed: () => _showLogoutDialog(context),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
              type: AppButtonType.gradient,
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
}
