import 'package:flutter/material.dart';
import '../core/design_system.dart';

enum AppButtonType { primary, secondary, outline, text, gradient }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final List<Color>? gradientColors;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Size configurations
    double height;
    EdgeInsetsGeometry padding;
    TextStyle textStyle;

    switch (size) {
      case AppButtonSize.small:
        height = 36;
        padding = const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
        textStyle = AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
        );
        break;
      case AppButtonSize.medium:
        height = 44;
        padding = const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
        textStyle = AppTextStyles.button;
        break;
      case AppButtonSize.large:
        height = 52;
        padding = const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        );
        textStyle = AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        );
        break;
    }

    Widget buttonChild = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == AppButtonType.primary || type == AppButtonType.gradient
                    ? AppColors.white
                    : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(text, style: textStyle),
      ],
    );

    switch (type) {
      case AppButtonType.primary:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              padding: padding,
            ),
            child: buttonChild,
          ),
        );

      case AppButtonType.secondary:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.grey700 : AppColors.grey100,
              foregroundColor: isDark ? AppColors.white : AppColors.grey900,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              padding: padding,
            ),
            child: buttonChild,
          ),
        );

      case AppButtonType.outline:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              padding: padding,
            ),
            child: buttonChild,
          ),
        );

      case AppButtonType.text:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: height,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              padding: padding,
            ),
            child: buttonChild,
          ),
        );

      case AppButtonType.gradient:
        return Container(
          width: fullWidth ? double.infinity : null,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors ?? AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            boxShadow: [
              BoxShadow(
                color: (gradientColors?.first ?? AppColors.primary).withValues(
                  alpha: 0.3,
                ),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              child: Container(
                padding: padding,
                child: DefaultTextStyle(
                  style: textStyle.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      const Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                  child: IconTheme(
                    data: const IconThemeData(
                      color: AppColors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                    child: buttonChild,
                  ),
                ),
              ),
            ),
          ),
        );
    }
  }
}
