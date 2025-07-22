/// WISME Typography System
/// 
/// Provides consistent typography across the entire application
/// with modern, accessible, and scalable text styles.

import 'package:flutter/material.dart';

/// WISME Typography System
class WismeTypography {
  WismeTypography._();

  // Base font family
  static const String _fontFamily = 'Inter';
  
  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // ===== HEADING STYLES =====
  
  /// H1 - Main page titles
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
  );
  
  /// H2 - Section titles
  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.3,
  );
  
  /// H3 - Subsection titles
  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: -0.2,
  );
  
  /// H4 - Card titles
  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: -0.1,
  );
  
  /// H5 - Component titles
  static const TextStyle h5 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );
  
  /// H6 - Small titles
  static const TextStyle h6 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
  );

  // ===== BODY TEXT STYLES =====
  
  /// Body Large - Main content text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0,
  );
  
  /// Body Medium - Standard body text
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );
  
  /// Body Small - Secondary text
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  // ===== UI COMPONENT STYLES =====
  
  /// Button text
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.1,
  );
  
  /// Button small
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.1,
  );
  
  /// Caption text
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.1,
  );
  
  /// Label text
  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // ===== DISPLAY STYLES =====
  
  /// Display Large - Hero text
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -1.0,
  );
  
  /// Display Medium - Feature text
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.8,
  );
  
  /// Display Small - Attention text
  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.6,
  );

  // ===== UTILITY METHODS =====
  
  /// Create a theme-compatible TextTheme
  static TextTheme createTextTheme() {
    return const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: h1,
      headlineMedium: h2,
      headlineSmall: h3,
      titleLarge: h4,
      titleMedium: h5,
      titleSmall: h6,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: button,
      labelMedium: label,
      labelSmall: caption,
    );
  }
  
  /// Get responsive font size based on screen width
  static double getResponsiveFontSize(double baseSize, double screenWidth) {
    if (screenWidth > 768) {
      return baseSize * 1.1; // Larger on tablets/desktop
    } else if (screenWidth < 320) {
      return baseSize * 0.9; // Smaller on very small screens
    }
    return baseSize; // Base size for mobile
  }
  
  /// Apply color to text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  /// Apply weight to text style
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
}
