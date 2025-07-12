import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wisme Animation System - Professional micro-interactions and transitions
/// Provides delightful animations that surpass industry standards
class WismeAnimations {
  WismeAnimations._();

  // ===== ANIMATION DURATIONS =====
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration dramatic = Duration(milliseconds: 800);

  // ===== ANIMATION CURVES =====
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounceIn = Curves.elasticOut;
  static const Curve smoothEntry = Curves.easeOutCubic;
  static const Curve smoothExit = Curves.easeInCubic;

  // ===== FADE ANIMATIONS =====
  static Widget fadeIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = smoothEntry,
    double delay = 0.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration + Duration(milliseconds: (delay * 1000).round()),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: curve,
      builder: (context, opacity, _) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
    );
  }

  // ===== SLIDE ANIMATIONS =====
  static Widget slideInFromBottom({
    required Widget child,
    Duration duration = medium,
    Curve curve = smoothEntry,
    double delay = 0.0,
    double distance = 50.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration + Duration(milliseconds: (delay * 1000).round()),
      tween: Tween(begin: 1.0, end: 0.0),
      curve: curve,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, distance * value),
          child: Opacity(
            opacity: 1.0 - value,
            child: child,
          ),
        );
      },
    );
  }

  static Widget slideInFromLeft({
    required Widget child,
    Duration duration = medium,
    Curve curve = smoothEntry,
    double delay = 0.0,
    double distance = 100.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration + Duration(milliseconds: (delay * 1000).round()),
      tween: Tween(begin: 1.0, end: 0.0),
      curve: curve,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(-distance * value, 0),
          child: Opacity(
            opacity: 1.0 - value,
            child: child,
          ),
        );
      },
    );
  }

  // ===== SCALE ANIMATIONS =====
  static Widget scaleIn({
    required Widget child,
    Duration duration = medium,
    Curve curve = bounceIn,
    double delay = 0.0,
    double initialScale = 0.8,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration + Duration(milliseconds: (delay * 1000).round()),
      tween: Tween(begin: initialScale, end: 1.0),
      curve: curve,
      builder: (context, scale, _) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
    );
  }

  // ===== STAGGERED ANIMATIONS =====
  static List<Widget> staggeredList({
    required List<Widget> children,
    Duration interval = const Duration(milliseconds: 100),
    Duration itemDuration = medium,
    Curve curve = smoothEntry,
  }) {
    return children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;
      final delay = index * interval.inMilliseconds / 1000.0;
      
      return slideInFromBottom(
        delay: delay,
        duration: itemDuration,
        curve: curve,
        child: child,
      );
    }).toList();
  }

  // ===== BUTTON PRESS ANIMATION =====
  static Widget pressableScale({
    required Widget child,
    required VoidCallback? onPressed,
    double scaleDown = 0.95,
    Duration duration = const Duration(milliseconds: 100),
  }) {
    return AnimatedScale(
      scale: 1.0,
      duration: duration,
      child: GestureDetector(
        onTapDown: (_) {
          // Scale down animation would be handled by stateful widget
        },
        onTapUp: (_) {
          onPressed?.call();
        },
        child: child,
      ),
    );
  }

  // ===== HERO ANIMATIONS =====
  static Widget heroLogo({
    required Widget child,
    String tag = 'logo',
  }) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }

  // ===== SHIMMER LOADING =====
  static Widget shimmer({
    required Widget child,
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
    Duration period = const Duration(milliseconds: 1500),
  }) {
    return TweenAnimationBuilder<double>(
      duration: period,
      tween: Tween(begin: -2.0, end: 2.0),
      builder: (context, value, _) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + value, -1.0),
              end: Alignment(1.0 + value, 1.0),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }

  // ===== PAGE TRANSITIONS =====
  static PageRoute createRoute({
    required Widget page,
    Duration duration = medium,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: transitionsBuilder ?? _defaultTransition,
    );
  }

  static Widget _defaultTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  // ===== HAPTIC FEEDBACK =====
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selectionClick() {
    HapticFeedback.selectionClick();
  }
}
