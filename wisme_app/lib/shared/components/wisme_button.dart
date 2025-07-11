import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wisme Button System - Comprehensive button component with variants, sizes, and states
/// Provides consistent styling and behavior across the entire app
enum WismeButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger,
  success,
}

enum WismeButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

enum WismeButtonState {
  enabled,
  loading,
  disabled,
}

class WismeButton extends StatefulWidget {
  final String text;
  final WismeButtonVariant variant;
  final WismeButtonSize size;
  final WismeButtonState state;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isFullWidth;
  final bool hasHapticFeedback;

  const WismeButton({
    super.key,
    required this.text,
    this.variant = WismeButtonVariant.primary,
    this.size = WismeButtonSize.medium,
    this.state = WismeButtonState.enabled,
    this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.hasHapticFeedback = true,
  });

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

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.state == WismeButtonState.enabled && widget.onPressed != null;
    final isLoading = widget.state == WismeButtonState.loading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: isEnabled ? _onTapDown : null,
            onTapUp: isEnabled ? _onTapUp : null,
            onTapCancel: isEnabled ? _onTapCancel : null,
            child: Container(
              width: widget.isFullWidth ? double.infinity : null,
              child: ElevatedButton(
                onPressed: isEnabled ? _handleTap : null,
                style: _getButtonStyle(context),
                child: _buildButtonContent(context, isLoading),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTap() {
    if (widget.hasHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onPressed?.call();
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Size configurations
    final sizes = _getSizeConfig();
    
    // Color configurations
    final colors = _getColorConfig(context, colorScheme);

    return ElevatedButton.styleFrom(
      foregroundColor: colors.foreground,
      backgroundColor: colors.background,
      padding: sizes.padding,
      minimumSize: sizes.minimumSize,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sizes.borderRadius),
        side: colors.border,
      ),
      elevation: colors.elevation,
      shadowColor: colors.shadowColor,
      textStyle: sizes.textStyle,
    );
  }

  _SizeConfig _getSizeConfig() {
    switch (widget.size) {
      case WismeButtonSize.small:
        return _SizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(80, 36),
          borderRadius: 8,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        );
      case WismeButtonSize.medium:
        return _SizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          minimumSize: const Size(100, 44),
          borderRadius: 12,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        );
      case WismeButtonSize.large:
        return _SizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(120, 52),
          borderRadius: 16,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        );
      case WismeButtonSize.extraLarge:
        return _SizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          minimumSize: const Size(140, 60),
          borderRadius: 20,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        );
    }
  }

  _ColorConfig _getColorConfig(BuildContext context, ColorScheme colorScheme) {
    switch (widget.variant) {
      case WismeButtonVariant.primary:
        return _ColorConfig(
          background: colorScheme.primary,
          foreground: colorScheme.onPrimary,
          border: BorderSide.none,
          elevation: _isPressed ? 1 : 2,
          shadowColor: colorScheme.primary.withOpacity(0.3),
        );
        
      case WismeButtonVariant.secondary:
        return _ColorConfig(
          background: colorScheme.secondary,
          foreground: colorScheme.onSecondary,
          border: BorderSide.none,
          elevation: _isPressed ? 1 : 2,
          shadowColor: colorScheme.secondary.withOpacity(0.3),
        );
        
      case WismeButtonVariant.outline:
        return _ColorConfig(
          background: Colors.transparent,
          foreground: colorScheme.primary,
          border: BorderSide(color: colorScheme.primary, width: 1.5),
          elevation: 0,
          shadowColor: Colors.transparent,
        );
        
      case WismeButtonVariant.ghost:
        return _ColorConfig(
          background: Colors.transparent,
          foreground: colorScheme.primary,
          border: BorderSide.none,
          elevation: 0,
          shadowColor: Colors.transparent,
        );
        
      case WismeButtonVariant.danger:
        return _ColorConfig(
          background: colorScheme.error,
          foreground: colorScheme.onError,
          border: BorderSide.none,
          elevation: _isPressed ? 1 : 2,
          shadowColor: colorScheme.error.withOpacity(0.3),
        );
        
      case WismeButtonVariant.success:
        return _ColorConfig(
          background: colorScheme.tertiary,
          foreground: colorScheme.onTertiary,
          border: BorderSide.none,
          elevation: _isPressed ? 1 : 2,
          shadowColor: colorScheme.tertiary.withOpacity(0.3),
        );
    }
  }

  Widget _buildButtonContent(BuildContext context, bool isLoading) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getColorConfig(context, Theme.of(context).colorScheme).foreground,
          ),
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.icon!,
          const SizedBox(width: 8),
          Text(widget.text),
        ],
      );
    }

    return Text(widget.text);
  }
}

// Helper classes for configuration
class _SizeConfig {
  final EdgeInsetsGeometry padding;
  final Size minimumSize;
  final double borderRadius;
  final TextStyle textStyle;

  _SizeConfig({
    required this.padding,
    required this.minimumSize,
    required this.borderRadius,
    required this.textStyle,
  });
}

class _ColorConfig {
  final Color background;
  final Color foreground;
  final BorderSide border;
  final double elevation;
  final Color shadowColor;

  _ColorConfig({
    required this.background,
    required this.foreground,
    required this.border,
    required this.elevation,
    required this.shadowColor,
  });
}
