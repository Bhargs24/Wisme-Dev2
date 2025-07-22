/// WISME Modern UI Components - Unique, Modern, Scalable
/// 
/// This system provides modern, unique UI components that are:
/// - Fully customizable and themeable
/// - Accessible and responsive
/// - Optimized for performance
/// - Ready for future asset integration
/// - Unique to WISME's brand identity

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../design_system/wisme_typography.dart';

// ===== CORE COMPONENT BASE =====

/// Base class for all WISME UI components
abstract class WismeComponent extends StatelessWidget {
  const WismeComponent({super.key});

  /// Get the component's theme data
  ThemeData getTheme(BuildContext context) => Theme.of(context);
  
  /// Get the component's color scheme
  ColorScheme getColors(BuildContext context) => getTheme(context).colorScheme;
  
  /// Get the component's text theme
  TextTheme getTextTheme(BuildContext context) => getTheme(context).textTheme;
}

// ===== MODERN BUTTONS =====

/// Modern gradient button with unique WISME styling
class WismeGradientButton extends WismeComponent {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;

  const WismeGradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height = 56,
    this.borderRadius,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? [
      WismeColors.primaryBlue,
      WismeColors.wisdomPurple,
    ];

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: isOutlined ? null : [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                if ((isLoading || icon != null) && text.isNotEmpty)
                  const SizedBox(width: 12),
                if (text.isNotEmpty)
                  Text(
                    text,
                    style: WismeTypography.button.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

/// Modern floating action button with unique styling
class WismeFloatingButton extends WismeComponent {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;

  const WismeFloatingButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor ?? WismeColors.primaryBlue,
            backgroundColor ?? WismeColors.wisdomPurple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? WismeColors.primaryBlue).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          child: Icon(
            icon,
            color: foregroundColor ?? Colors.white,
            size: size * 0.4,
          ),
        ),
      ),
    );
  }
}

// ===== MODERN CARDS =====

/// Modern card with gradient border and unique styling
class WismeGradientCard extends WismeComponent {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;
  final bool hasShadow;
  final VoidCallback? onTap;

  const WismeGradientCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.gradientColors,
    this.hasShadow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? [
      WismeColors.primaryBlue.withValues(alpha: 0.1),
      WismeColors.wisdomPurple.withValues(alpha: 0.1),
    ];

    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        border: Border.all(
          color: WismeColors.primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: hasShadow ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Modern learning journey card
class WismeJourneyCard extends WismeComponent {
  final String title;
  final String description;
  final String category;
  final int episodeCount;
  final int durationMinutes;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isActive;

  const WismeJourneyCard({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.episodeCount,
    required this.durationMinutes,
    this.imageUrl,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return WismeGradientCard(
      onTap: onTap,
      gradientColors: isActive ? [
        WismeColors.success.withValues(alpha: 0.1),
        WismeColors.primaryBlue.withValues(alpha: 0.1),
      ] : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Placeholder for journey image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      WismeColors.primaryBlue,
                      WismeColors.wisdomPurple,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: WismeTypography.h4.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: WismeTypography.caption.copyWith(
                        color: WismeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: WismeColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Active',
                    style: WismeTypography.caption.copyWith(
                      color: WismeColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: WismeTypography.bodySmall.copyWith(
              color: WismeColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(
                Icons.play_circle_outline,
                '$episodeCount episodes',
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                Icons.timer_outlined,
                '${durationMinutes}min',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: WismeColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: WismeColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: WismeTypography.caption.copyWith(
              color: WismeColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== MODERN INPUT FIELDS =====

/// Modern text input field with unique styling
class WismeTextField extends WismeComponent {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final FocusNode? focusNode;

  const WismeTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: WismeTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: WismeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                WismeColors.backgroundSecondary,
                WismeColors.backgroundPrimary,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: WismeColors.border,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            maxLength: maxLength,
            enabled: enabled,
            focusNode: focusNode,
            validator: validator,
            onChanged: onChanged,
            style: WismeTypography.bodyMedium.copyWith(
              color: WismeColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: WismeTypography.bodyMedium.copyWith(
                color: WismeColors.textSecondary,
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===== MODERN LOADING COMPONENTS =====

/// Modern loading indicator with WISME branding
class WismeLoadingIndicator extends WismeComponent {
  final String? message;
  final double size;
  final Color? color;

  const WismeLoadingIndicator({
    super.key,
    this.message,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color ?? WismeColors.primaryBlue,
                color ?? WismeColors.wisdomPurple,
              ],
            ),
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: WismeTypography.bodySmall.copyWith(
              color: WismeColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Modern skeleton loading component
class WismeSkeleton extends WismeComponent {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const WismeSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            WismeColors.backgroundSecondary,
            WismeColors.backgroundPrimary,
            WismeColors.backgroundSecondary,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

// ===== MODERN NAVIGATION COMPONENTS =====

/// Modern bottom navigation bar
class WismeBottomNavBar extends WismeComponent {
  final int currentIndex;
  final Function(int) onTap;
  final List<WismeNavItem> items;

  const WismeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            WismeColors.backgroundPrimary,
            WismeColors.backgroundSecondary,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected ? LinearGradient(
                      colors: [
                        WismeColors.primaryBlue.withValues(alpha: 0.1),
                        WismeColors.wisdomPurple.withValues(alpha: 0.1),
                      ],
                    ) : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.selectedIcon : item.icon,
                        color: isSelected ? WismeColors.primaryBlue : WismeColors.textSecondary,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: WismeTypography.caption.copyWith(
                          color: isSelected ? WismeColors.primaryBlue : WismeColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Navigation item model
class WismeNavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const WismeNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

// ===== MODERN DIALOGS =====

/// Modern confirmation dialog
class WismeConfirmDialog extends WismeComponent {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const WismeConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: WismeGradientCard(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: WismeTypography.h3.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: WismeTypography.bodyMedium.copyWith(
                color: WismeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: WismeGradientButton(
                    text: cancelText,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCancel?.call();
                    },
                    gradientColors: [
                      WismeColors.backgroundSecondary,
                      WismeColors.backgroundSecondary,
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: WismeGradientButton(
                    text: confirmText,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm?.call();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===== UTILITY COMPONENTS =====

/// Modern empty state component
class WismeEmptyState extends WismeComponent {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;

  const WismeEmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    WismeColors.primaryBlue.withValues(alpha: 0.1),
                    WismeColors.wisdomPurple.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                icon,
                size: 40,
                color: WismeColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: WismeTypography.h4.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: WismeTypography.bodyMedium.copyWith(
                color: WismeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24),
              WismeGradientButton(
                text: actionText!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Modern error state component
class WismeErrorState extends WismeComponent {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const WismeErrorState({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    WismeColors.error.withValues(alpha: 0.1),
                    WismeColors.error.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: WismeColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: WismeTypography.h4.copyWith(
                fontWeight: FontWeight.w600,
                color: WismeColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: WismeTypography.bodyMedium.copyWith(
                color: WismeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              WismeGradientButton(
                text: 'Try Again',
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
} 
