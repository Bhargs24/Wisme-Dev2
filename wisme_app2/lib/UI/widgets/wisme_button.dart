import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';

enum WismeButtonVariant { 
  primary, 
  secondary, 
  outline, 
  ghost,
  destructive 
}

enum WismeButtonSize { 
  small, 
  medium, 
  large 
}

/// Modern, accessible button component for Wisme app
/// Supports multiple variants, sizes, and states
class WismeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final WismeButtonVariant variant;
  final WismeButtonSize size;
  final IconData? icon;
  final Widget? iconWidget;
  final bool isLoading;
  final bool isFullWidth;
  final bool enabled;

  const WismeButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = WismeButtonVariant.primary,
    this.size = WismeButtonSize.medium,
    this.icon,
    this.iconWidget,
    this.isLoading = false,
    this.isFullWidth = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = enabled && onPressed != null && !isLoading;
    
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(isEnabled),
          foregroundColor: _getForegroundColor(isEnabled),
          elevation: _getElevation(),
          shadowColor: _getShadowColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            side: _getBorderSide(isEnabled),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(),
            vertical: 0, // Height controlled by container
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getForegroundColor(true)),
        ),
      );
    }

    final List<Widget> children = [];
    
    if (icon != null || iconWidget != null) {
      children.add(
        iconWidget ?? Icon(
          icon,
          size: _getIconSize(),
        ),
      );
      children.add(const SizedBox(width: AppSpacing.sm));
    }
    
    children.add(
      Text(
        text,
        style: _getTextStyle(),
        textAlign: TextAlign.center,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  double _getHeight() {
    switch (size) {
      case WismeButtonSize.small:
        return 36;
      case WismeButtonSize.medium:
        return 44;
      case WismeButtonSize.large:
        return 52;
    }
  }

  Color _getBackgroundColor(bool isEnabled) {
    if (!isEnabled) {
      return AppColors.interactiveDisabled;
    }
    
    switch (variant) {
      case WismeButtonVariant.primary:
        return AppColors.primary;
      case WismeButtonVariant.secondary:
        return AppColors.backgroundSecondary;
      case WismeButtonVariant.outline:
      case WismeButtonVariant.ghost:
        return Colors.transparent;
      case WismeButtonVariant.destructive:
        return AppColors.error;
    }
  }

  Color _getForegroundColor(bool isEnabled) {
    if (!isEnabled) {
      return AppColors.textTertiary;
    }
    
    switch (variant) {
      case WismeButtonVariant.primary:
      case WismeButtonVariant.destructive:
        return AppColors.textInverse;
      case WismeButtonVariant.secondary:
      case WismeButtonVariant.outline:
      case WismeButtonVariant.ghost:
        return AppColors.textPrimary;
    }
  }

  double _getElevation() {
    switch (variant) {
      case WismeButtonVariant.primary:
      case WismeButtonVariant.destructive:
        return AppSpacing.elevationLow;
      case WismeButtonVariant.secondary:
      case WismeButtonVariant.outline:
      case WismeButtonVariant.ghost:
        return 0;
    }
  }

  Color? _getShadowColor() {
    switch (variant) {
      case WismeButtonVariant.primary:
        return AppColors.primary.withOpacity(0.2);
      case WismeButtonVariant.destructive:
        return AppColors.error.withOpacity(0.2);
      default:
        return null;
    }
  }

  BorderSide _getBorderSide(bool isEnabled) {
    if (variant == WismeButtonVariant.outline) {
      return BorderSide(
        color: isEnabled ? AppColors.border : AppColors.interactiveDisabled,
        width: 1,
      );
    }
    return BorderSide.none;
  }

  double _getHorizontalPadding() {
    switch (size) {
      case WismeButtonSize.small:
        return AppSpacing.md;
      case WismeButtonSize.medium:
        return AppSpacing.lg;
      case WismeButtonSize.large:
        return AppSpacing.xl;
    }
  }

  double _getIconSize() {
    switch (size) {
      case WismeButtonSize.small:
        return 16;
      case WismeButtonSize.medium:
        return 20;
      case WismeButtonSize.large:
        return 24;
    }
  }

  TextStyle _getTextStyle() {
    TextStyle baseStyle;
    
    switch (size) {
      case WismeButtonSize.small:
        baseStyle = AppTextStyles.labelMedium;
        break;
      case WismeButtonSize.medium:
        baseStyle = AppTextStyles.buttonLabel;
        break;
      case WismeButtonSize.large:
        baseStyle = AppTextStyles.buttonLabel.copyWith(fontSize: 16);
        break;
    }
    
    return baseStyle.copyWith(
      fontWeight: FontWeight.w600,
    );
  }
}

/// Icon-only button variant
class WismeIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final WismeButtonVariant variant;
  final WismeButtonSize size;
  final String? tooltip;
  final bool enabled;

  const WismeIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = WismeButtonVariant.ghost,
    this.size = WismeButtonSize.medium,
    this.tooltip,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: _getSize(),
      height: _getSize(),
      child: IconButton(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon),
        iconSize: _getIconSize(),
        color: _getForegroundColor(),
        style: IconButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            side: _getBorderSide(),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }

  double _getSize() {
    switch (size) {
      case WismeButtonSize.small:
        return 32;
      case WismeButtonSize.medium:
        return 40;
      case WismeButtonSize.large:
        return 48;
    }
  }

  double _getIconSize() {
    switch (size) {
      case WismeButtonSize.small:
        return 16;
      case WismeButtonSize.medium:
        return 20;
      case WismeButtonSize.large:
        return 24;
    }
  }

  Color _getBackgroundColor() {
    if (!enabled) {
      return AppColors.interactiveDisabled;
    }
    
    switch (variant) {
      case WismeButtonVariant.primary:
        return AppColors.primary;
      case WismeButtonVariant.secondary:
        return AppColors.backgroundSecondary;
      case WismeButtonVariant.outline:
      case WismeButtonVariant.ghost:
        return Colors.transparent;
      case WismeButtonVariant.destructive:
        return AppColors.error;
    }
  }

  Color _getForegroundColor() {
    if (!enabled) {
      return AppColors.textTertiary;
    }
    
    switch (variant) {
      case WismeButtonVariant.primary:
      case WismeButtonVariant.destructive:
        return AppColors.textInverse;
      case WismeButtonVariant.secondary:
      case WismeButtonVariant.outline:
      case WismeButtonVariant.ghost:
        return AppColors.textSecondary;
    }
  }

  BorderSide _getBorderSide() {
    if (variant == WismeButtonVariant.outline) {
      return BorderSide(
        color: enabled ? AppColors.border : AppColors.interactiveDisabled,
        width: 1,
      );
    }
    return BorderSide.none;
  }
}
