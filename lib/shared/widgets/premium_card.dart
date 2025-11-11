import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Premium card with glassmorphism effect
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final bool enableGlass;
  final bool enableBorder;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.gradient,
    this.boxShadow,
    this.onTap,
    this.enableGlass = false,
    this.enableBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient ?? (enableGlass ? null : AppTheme.cardGradient),
        color: enableGlass ? null : AppTheme.cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(AppBorderRadius.lg),
        border: enableBorder
            ? Border.all(
                color: AppTheme.borderColor.withOpacity(0.3),
                width: 1,
              )
            : null,
        boxShadow: boxShadow ?? AppTheme.shadowSm,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(AppBorderRadius.lg),
        child: enableGlass
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.glassLight,
                        AppTheme.glassDark,
                      ],
                    ),
                  ),
                  padding: padding ?? const EdgeInsets.all(AppSpacing.md),
                  child: child,
                ),
              )
            : Padding(
                padding: padding ?? const EdgeInsets.all(AppSpacing.md),
                child: child,
              ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(AppBorderRadius.lg),
        child: content,
      );
    }

    return content;
  }
}

/// Gradient card with beautiful gradients
class GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradientColors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: begin,
          end: end,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: AppTheme.shadowMd,
      ),
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(AppBorderRadius.lg),
        child: content,
      );
    }

    return content;
  }
}

/// Premium button with gradient and glow
class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final bool enableGlow;

  const PremiumButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.padding,
    this.gradient,
    this.enableGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        gradient: gradient ?? AppTheme.primaryGradient,
        boxShadow: enableGlow ? AppTheme.glowPrimary(opacity: 0.4) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Outlined button with premium style
class PremiumOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final Color? borderColor;

  const PremiumOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: borderColor ?? AppTheme.borderColor,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: borderColor ?? AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: borderColor ?? AppTheme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Chip with premium style
class PremiumChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool selected;

  const PremiumChip({
    super.key,
    required this.label,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppTheme.primaryColor
          : backgroundColor ?? AppTheme.surfaceColor,
      borderRadius: BorderRadius.circular(AppBorderRadius.circular),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.circular),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: selected
                      ? Colors.white
                      : textColor ?? AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : textColor ?? AppTheme.textSecondaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Badge with premium styling
class PremiumBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const PremiumBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppBorderRadius.xs),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? AppTheme.primaryColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.secondaryColor.withOpacity(0.05),
                  ],
                ),
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryColor,
                letterSpacing: 0.15,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                  letterSpacing: 0.25,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              PremiumButton(
                text: actionText!,
                onPressed: onAction,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
