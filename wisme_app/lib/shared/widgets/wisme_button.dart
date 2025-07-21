import 'package:flutter/material.dart';
import '../../core/core.dart';

/// Wisme Custom Button System - Beautiful, accessible, and engaging buttons
/// Supports multiple variants, animations, and states for optimal UX
enum WismeButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  gradient,
  destructive,
}

enum WismeButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

class WismeButton extends StatefulWidget {
  const WismeButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.variant = WismeButtonVariant.primary,
    this.size = WismeButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
    this.tooltip,
    this.semanticLabel,
  });

  final VoidCallback? onPressed;
  final String text;
  final WismeButtonVariant variant;
  final WismeButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final bool fullWidth;
  final String? tooltip;
  final String? semanticLabel;

  @override
  State<WismeButton> createState() => _WismeButtonState();
}

class _WismeButtonState extends State<WismeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isDisabled) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isDisabled) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (!_isDisabled) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  bool get _isDisabled => widget.isDisabled || widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final buttonTheme = _getButtonTheme();
    
    Widget button = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            constraints: BoxConstraints(
              minWidth: widget.fullWidth ? double.infinity : buttonTheme.minWidth,
              minHeight: buttonTheme.height,
            ),
            decoration: BoxDecoration(
              color: buttonTheme.backgroundColor,
              gradient: buttonTheme.gradient,
              borderRadius: BorderRadius.circular(buttonTheme.borderRadius),
              border: buttonTheme.border,
              boxShadow: _isPressed ? null : buttonTheme.shadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isDisabled ? null : widget.onPressed,
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                borderRadius: BorderRadius.circular(buttonTheme.borderRadius),
                splashColor: buttonTheme.splashColor,
                highlightColor: buttonTheme.highlightColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: buttonTheme.horizontalPadding,
                    vertical: buttonTheme.verticalPadding,
                  ),
                  child: _buildButtonContent(buttonTheme),
                ),
              ),
            ),
          ),
        );
      },
    );

    // Add loading shimmer effect (using built-in animation)
    if (widget.isLoading) {
      button = AnimatedOpacity(
        opacity: 0.7,
        duration: const Duration(milliseconds: 800),
        child: button,
      );
    }

    // Add entrance animation using built-in widgets
    button = AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 200),
        child: button,
      ),
    );

    // Wrap with tooltip if provided
    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    // Wrap with semantics for accessibility
    return Semantics(
      label: widget.semanticLabel ?? widget.text,
      button: true,
      enabled: !_isDisabled,
      child: button,
    );
  }

  Widget _buildButtonContent(_ButtonTheme theme) {
    final List<Widget> children = [];

    // Add icon if provided
    if (widget.icon != null && !widget.isLoading) {
      children.add(
        Icon(
          widget.icon,
          size: theme.iconSize,
          color: theme.textColor,
        ),
      );
      
      if (widget.text.isNotEmpty) {
        children.add(WismeSpacing.hGapSm);
      }
    }

    // Add loading indicator or text
    if (widget.isLoading) {
      children.add(
        SizedBox(
          width: theme.iconSize,
          height: theme.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(theme.textColor),
          ),
        ),
      );
      
      if (widget.text.isNotEmpty) {
        children.add(WismeSpacing.hGapSm);
        children.add(
          Text(
            'Loading...',
            style: theme.textStyle,
            textAlign: TextAlign.center,
          ),
        );
      }
    } else if (widget.text.isNotEmpty) {
      children.add(
        Flexible(
          child: Text(
            widget.text,
            style: theme.textStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  _ButtonTheme _getButtonTheme() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Size configurations
    late double height;
    late double horizontalPadding;
    late double verticalPadding;
    late double iconSize;
    late double borderRadius;
    late double minWidth;
    late TextStyle textStyle;

    switch (widget.size) {
      case WismeButtonSize.small:
        height = 36;
        horizontalPadding = WismeSpacing.md;
        verticalPadding = WismeSpacing.xs;
        iconSize = 16;
        borderRadius = 8;
        minWidth = 80;
        textStyle = WismeTypography.buttonSmall;
        break;
      case WismeButtonSize.medium:
        height = 48;
        horizontalPadding = WismeSpacing.lg;
        verticalPadding = WismeSpacing.sm;
        iconSize = 20;
        borderRadius = 12;
        minWidth = 120;
        textStyle = WismeTypography.button;
        break;
      case WismeButtonSize.large:
        height = 56;
        horizontalPadding = WismeSpacing.xl;
        verticalPadding = WismeSpacing.md;
        iconSize = 24;
        borderRadius = 14;
        minWidth = 160;
        textStyle = WismeTypography.buttonLarge;
        break;
      case WismeButtonSize.extraLarge:
        height = 64;
        horizontalPadding = WismeSpacing.xxl;
        verticalPadding = WismeSpacing.lg;
        iconSize = 28;
        borderRadius = 16;
        minWidth = 200;
        textStyle = WismeTypography.buttonLarge.copyWith(fontSize: 20);
        break;
    }

    // Variant configurations
    late Color backgroundColor;
    late Color textColor;
    late Border? border;
    late Gradient? gradient;
    late List<BoxShadow>? shadow;
    late Color splashColor;
    late Color highlightColor;

    if (_isDisabled) {
      backgroundColor = isDark 
          ? WismeColors.darkSurfaceVariant 
          : WismeColors.backgroundTertiary;
      textColor = isDark 
          ? WismeColors.darkTextTertiary 
          : WismeColors.textDisabled;
      border = null;
      gradient = null;
      shadow = null;
      splashColor = Colors.transparent;
      highlightColor = Colors.transparent;
    } else {
      switch (widget.variant) {
        case WismeButtonVariant.primary:
          backgroundColor = WismeColors.primaryBlue;
          textColor = Colors.white;
          border = null;
          gradient = null;
          shadow = [
            BoxShadow(
              color: WismeColors.primaryBlue.withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ];
          splashColor = Colors.white.withValues(alpha: 0.2);
          highlightColor = Colors.white.withValues(alpha: 0.1);
          break;

        case WismeButtonVariant.secondary:
          backgroundColor = isDark 
              ? WismeColors.darkSurface 
              : WismeColors.backgroundSecondary;
          textColor = isDark 
              ? WismeColors.darkTextPrimary 
              : WismeColors.textPrimary;
          border = Border.all(
            color: isDark ? WismeColors.darkBorder : WismeColors.border,
            width: 1,
          );
          gradient = null;
          shadow = null;
          splashColor = (isDark 
              ? WismeColors.darkTextPrimary 
              : WismeColors.textPrimary).withValues(alpha: 0.1);
          highlightColor = (isDark 
              ? WismeColors.darkTextPrimary 
              : WismeColors.textPrimary).withValues(alpha: 0.05);
          break;

        case WismeButtonVariant.outline:
          backgroundColor = Colors.transparent;
          textColor = WismeColors.primaryBlue;
          border = Border.all(
            color: WismeColors.primaryBlue,
            width: 1.5,
          );
          gradient = null;
          shadow = null;
          splashColor = WismeColors.primaryBlue.withValues(alpha: 0.1);
          highlightColor = WismeColors.primaryBlue.withValues(alpha: 0.05);
          break;

        case WismeButtonVariant.ghost:
          backgroundColor = Colors.transparent;
          textColor = WismeColors.primaryBlue;
          border = null;
          gradient = null;
          shadow = null;
          splashColor = WismeColors.primaryBlue.withValues(alpha: 0.1);
          highlightColor = WismeColors.primaryBlue.withValues(alpha: 0.05);
          break;

        case WismeButtonVariant.gradient:
          backgroundColor = Colors.transparent;
          textColor = Colors.white;
          border = null;
          gradient = WismeColors.primaryGradient;
          shadow = [
            BoxShadow(
              color: WismeColors.primaryBlue.withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ];
          splashColor = Colors.white.withValues(alpha: 0.2);
          highlightColor = Colors.white.withValues(alpha: 0.1);
          break;

        case WismeButtonVariant.destructive:
          backgroundColor = WismeColors.error;
          textColor = Colors.white;
          border = null;
          gradient = null;
          shadow = [
            BoxShadow(
              color: WismeColors.error.withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ];
          splashColor = Colors.white.withValues(alpha: 0.2);
          highlightColor = Colors.white.withValues(alpha: 0.1);
          break;
      }
    }

    return _ButtonTheme(
      height: height,
      minWidth: minWidth,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      borderRadius: borderRadius,
      iconSize: iconSize,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle.copyWith(color: textColor),
      border: border,
      gradient: gradient,
      shadow: shadow,
      splashColor: splashColor,
      highlightColor: highlightColor,
    );
  }
}

class _ButtonTheme {
  const _ButtonTheme({
    required this.height,
    required this.minWidth,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
    required this.iconSize,
    required this.backgroundColor,
    required this.textColor,
    required this.textStyle,
    required this.border,
    required this.gradient,
    required this.shadow,
    required this.splashColor,
    required this.highlightColor,
  });

  final double height;
  final double minWidth;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double iconSize;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle textStyle;
  final Border? border;
  final Gradient? gradient;
  final List<BoxShadow>? shadow;
  final Color splashColor;
  final Color highlightColor;
}

// ===== CONVENIENCE CONSTRUCTORS =====

/// Primary button with gradient background
class WismePrimaryButton extends StatelessWidget {
  const WismePrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.size = WismeButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
  });

  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final WismeButtonSize size;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return WismeButton(
      onPressed: onPressed,
      text: text,
      icon: icon,
      variant: WismeButtonVariant.gradient,
      size: size,
      isLoading: isLoading,
      fullWidth: fullWidth,
    );
  }
}

/// Secondary button with subtle styling
class WismeSecondaryButton extends StatelessWidget {
  const WismeSecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.size = WismeButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
  });

  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final WismeButtonSize size;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return WismeButton(
      onPressed: onPressed,
      text: text,
      icon: icon,
      variant: WismeButtonVariant.secondary,
      size: size,
      isLoading: isLoading,
      fullWidth: fullWidth,
    );
  }
}

/// Icon-only button for compact spaces
class WismeIconButton extends StatelessWidget {
  const WismeIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.variant = WismeButtonVariant.ghost,
    this.size = WismeButtonSize.medium,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final WismeButtonVariant variant;
  final WismeButtonSize size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return WismeButton(
      onPressed: onPressed,
      text: '',
      icon: icon,
      variant: variant,
      size: size,
      tooltip: tooltip,
    );
  }
}
