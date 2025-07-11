import 'package:flutter/material.dart';

/// Wisme Color System - Carefully crafted for learning psychology
/// Based on research showing specific colors enhance learning and engagement
class WismeColors {
  WismeColors._();

  // ===== PRIMARY BRAND COLORS =====
  /// Deep learning blue - inspires trust and focus
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color primaryBlueLight = Color(0xFF3B82F6);

  /// Wisdom purple - creativity and insight
  static const Color wisdomPurple = Color(0xFF7C3AED);
  static const Color wisdomPurpleDark = Color(0xFF6D28D9);
  static const Color wisdomPurpleLight = Color(0xFF8B5CF6);

  // ===== GRADIENT DEFINITIONS =====
  /// Primary brand gradient for buttons and key UI elements
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, wisdomPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Soft learning gradient for backgrounds
  static const LinearGradient learningGradient = LinearGradient(
    colors: [Color(0xFFF0F9FF), Color(0xFFF5F3FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Success gradient for achievements
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== SEMANTIC COLORS =====
  /// Success states - learning achievements, completed lessons
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  /// Warning states - attention needed, streak at risk
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  /// Error states - mistakes, failed attempts
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  /// Info states - tips, helpful information
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // ===== COACH PERSONALITY COLORS =====
  /// Kai (Calm, Mindful) - Zen-inspired earth tones
  static const Color kaiPrimary = Color(0xFF6B7280);
  static const Color kaiSecondary = Color(0xFF9CA3AF);
  static const Color kaiAccent = Color(0xFF34D399);

  /// Vee (Energetic, Dynamic) - Vibrant energy colors
  static const Color veePrimary = Color(0xFFEF4444);
  static const Color veeSecondary = Color(0xFFF97316);
  static const Color veeAccent = Color(0xFFFBBF24);

  // ===== NEUTRAL SYSTEM =====
  /// Text hierarchy
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  /// Background hierarchy
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF9FAFB);
  static const Color backgroundTertiary = Color(0xFFF3F4F6);

  /// Surface colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8FAFC);
  static const Color surfaceContainer = Color(0xFFF1F5F9);

  /// Border and divider colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFE5E7EB);

  // ===== DARK MODE COLORS =====
  /// Dark mode primary colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);

  /// Dark mode text
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF94A3B8);

  /// Dark mode borders
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkDivider = Color(0xFF475569);

  // ===== LEARNING CONTEXT COLORS =====
  /// Category-specific colors for visual learning hierarchy
  static const Map<String, Color> categoryColors = {
    'Business & Finance': Color(0xFF059669),
    'Technology & AI': Color(0xFF3B82F6),
    'Health & Wellness': Color(0xFF10B981),
    'Arts & Creativity': Color(0xFF8B5CF6),
    'Science & Nature': Color(0xFF06B6D4),
    'History & Culture': Color(0xFFF59E0B),
    'Personal Development': Color(0xFFEF4444),
    'Language & Communication': Color(0xFF84CC16),
    'Food & Cooking': Color(0xFFF97316),
    'Travel & Adventure': Color(0xFF6366F1),
    'Sports & Fitness': Color(0xFF14B8A6),
    'Hobbies & Lifestyle': Color(0xFFEC4899),
    'Philosophy & Spirituality': Color(0xFF7C3AED),
    'Current Events': Color(0xFF64748B),
    'Career & Professional': Color(0xFF0EA5E9),
  };

  // ===== DIFFICULTY LEVEL COLORS =====
  /// Visual indicators for learning difficulty
  static const Color beginnerGreen = Color(0xFF10B981);
  static const Color intermediateBlue = Color(0xFF3B82F6);
  static const Color advancedPurple = Color(0xFF8B5CF6);
  static const Color expertRed = Color(0xFFEF4444);

  // ===== PROGRESS & GAMIFICATION COLORS =====
  /// Streak and achievement colors
  static const Color streakFire = Color(0xFFF97316);
  static const Color achievementGold = Color(0xFFFBBF24);
  static const Color masteryPlatinum = Color(0xFF6B7280);

  /// XP and level progression
  static const Color xpBlue = Color(0xFF3B82F6);
  static const Color levelGold = Color(0xFFF59E0B);

  // ===== HELPER METHODS =====
  /// Get category color by name
  static Color getCategoryColor(String category) {
    return categoryColors[category] ?? primaryBlue;
  }

  /// Get difficulty color by level
  static Color getDifficultyColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
      case 'core concepts':
        return beginnerGreen;
      case 'intermediate':
      case 'case studies':
        return intermediateBlue;
      case 'advanced':
      case 'tools & trends':
        return advancedPurple;
      case 'expert':
      case 'bit of everything':
        return expertRed;
      default:
        return primaryBlue;
    }
  }

  /// Get coach color by personality
  static Color getCoachColor(String personality) {
    switch (personality.toLowerCase()) {
      case 'kai':
        return kaiPrimary;
      case 'vee':
        return veePrimary;
      default:
        return primaryBlue;
    }
  }

  /// Create a color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Lighten a color by a percentage
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  /// Darken a color by a percentage
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
