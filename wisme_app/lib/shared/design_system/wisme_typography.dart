/// Wisme Design System - Typography
/// Consistent typography styles across the Wisme app
library;

import 'package:flutter/material.dart';

/// Typography system for Wisme app
class WismeTypography {
  // Private constructor to prevent instantiation
  WismeTypography._();

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Font sizes
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize24 = 24.0;
  static const double fontSize28 = 28.0;
  static const double fontSize32 = 32.0;
  static const double fontSize36 = 36.0;

  // Line heights
  static const double lineHeight12 = 1.2;
  static const double lineHeight14 = 1.4;
  static const double lineHeight16 = 1.6;

  // Text styles
  static const TextStyle h1 = TextStyle(
    fontSize: fontSize32,
    fontWeight: bold,
    height: lineHeight12,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: fontSize28,
    fontWeight: bold,
    height: lineHeight12,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: fontSize24,
    fontWeight: semiBold,
    height: lineHeight14,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: fontSize20,
    fontWeight: semiBold,
    height: lineHeight14,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: fontSize18,
    fontWeight: medium,
    height: lineHeight14,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: fontSize16,
    fontWeight: medium,
    height: lineHeight14,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSize18,
    fontWeight: regular,
    height: lineHeight16,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSize16,
    fontWeight: regular,
    height: lineHeight16,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSize14,
    fontWeight: regular,
    height: lineHeight16,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: fontSize16,
    fontWeight: medium,
    height: lineHeight14,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: fontSize14,
    fontWeight: medium,
    height: lineHeight14,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: fontSize12,
    fontWeight: medium,
    height: lineHeight14,
  );

  static const TextStyle caption = TextStyle(
    fontSize: fontSize12,
    fontWeight: regular,
    height: lineHeight14,
  );

  static const TextStyle overline = TextStyle(
    fontSize: fontSize12,
    fontWeight: medium,
    height: lineHeight14,
    letterSpacing: 0.5,
  );

  // Button text styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: fontSize16,
    fontWeight: semiBold,
    height: lineHeight14,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: fontSize14,
    fontWeight: semiBold,
    height: lineHeight14,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: fontSize12,
    fontWeight: semiBold,
    height: lineHeight14,
  );

  // Additional text styles for theme compatibility
  static const TextStyle button = buttonMedium; // Default button style
  static const TextStyle label = labelMedium; // Default label style
  
  // Input-related styles
  static const TextStyle inputLabel = TextStyle(
    fontSize: fontSize14,
    fontWeight: medium,
    height: lineHeight14,
  );
  
  static const TextStyle inputText = TextStyle(
    fontSize: fontSize16,
    fontWeight: regular,
    height: lineHeight16,
  );
  
  static const TextStyle helperText = TextStyle(
    fontSize: fontSize12,
    fontWeight: regular,
    height: lineHeight14,
  );
  
  // Navigation styles
  static const TextStyle navLabel = TextStyle(
    fontSize: fontSize12,
    fontWeight: medium,
    height: lineHeight14,
  );
  
  static const TextStyle tabLabel = TextStyle(
    fontSize: fontSize14,
    fontWeight: medium,
    height: lineHeight14,
  );
}
