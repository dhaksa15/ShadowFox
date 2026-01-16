import 'package:flutter/material.dart';
import '../core/design_system.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.onTap,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      margin: margin,
      decoration: BoxDecoration(
        color:
            color ?? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        borderRadius: borderRadius ?? BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: isDark ? AppColors.grey700 : AppColors.grey200,
          width: 1,
        ),
        boxShadow:
            boxShadow ??
            (elevation != null && elevation! > 0 ? AppShadows.small : null),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppBorderRadius.md),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

class AppGradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<Color>? gradient;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const AppGradientCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.gradient,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient ?? AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(AppBorderRadius.md),
        boxShadow: AppShadows.medium,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppBorderRadius.md),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
