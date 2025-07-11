import 'package:flutter/material.dart';

/// Industrial-grade color system for Wisme app
/// High contrast, accessible, and consistent color palette
class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF2563EB);        // Blue 600
  static const Color primaryDark = Color(0xFF1D4ED8);    // Blue 700
  static const Color primaryLight = Color(0xFF3B82F6);   // Blue 500
  static const Color primaryVeryLight = Color(0xFFDEEBFF); // Blue 100
  
  // Secondary Colors
  static const Color secondary = Color(0xFF059669);      // Emerald 600
  static const Color accent = Color(0xFFEF4444);         // Red 500
  
  // Neutral Colors (High Contrast)
  static const Color textPrimary = Color(0xFF111827);    // Gray 900
  static const Color textSecondary = Color(0xFF6B7280);  // Gray 500
  static const Color textTertiary = Color(0xFF9CA3AF);   // Gray 400
  static const Color textInverse = Color(0xFFFFFFFF);    // White
  
  // Background Colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF9FAFB);
  static const Color backgroundTertiary = Color(0xFFF3F4F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF8FAFC);
  
  // Functional Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  
  // Interactive Colors
  static const Color interactive = Color(0xFF2563EB);
  static const Color interactiveHover = Color(0xFF1D4ED8);
  static const Color interactivePressed = Color(0xFF1E40AF);
  static const Color interactiveDisabled = Color(0xFFE5E7EB);
  
  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderStrong = Color(0xFFD1D5DB);
  static const Color borderSubtle = Color(0xFFF3F4F6);
  
  // Legacy color mappings for backward compatibility
  // TODO: Remove these once all components are migrated
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral900 = Color(0xFF111827);
  
  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, backgroundSecondary],
  );
}
