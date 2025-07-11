import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Wisme Typography System - Optimized for learning and readability
/// Based on research in educational typography and cognitive load theory
class WismeTypography {
  WismeTypography._();

  // ===== BASE FONT FAMILIES =====
  /// Primary font for headings and emphasis - Clean, authoritative
  static String get primaryFont => GoogleFonts.inter().fontFamily!;
  
  /// Secondary font for body text - Highly readable, optimized for learning
  static String get bodyFont => GoogleFonts.sourceSerif4().fontFamily!;
  
  /// Monospace font for code and technical content
  static String get monoFont => GoogleFonts.jetBrainsMono().fontFamily!;

  // ===== HEADING STYLES =====
  /// H1 - Page titles, major sections
  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// H2 - Section headings, modal titles
  static TextStyle get h2 => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.3,
  );

  /// H3 - Subsection headings, card titles
  static TextStyle get h3 => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
  );

  /// H4 - Component titles, list headers
  static TextStyle get h4 => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: -0.1,
  );

  /// H5 - Small headings, form labels
  static TextStyle get h5 => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
  );

  /// H6 - Tiny headings, metadata
  static TextStyle get h6 => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.1,
  );

  // ===== BODY TEXT STYLES =====
  /// Large body text - Important content, callouts
  static TextStyle get bodyLarge => GoogleFonts.sourceSerif4(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.1,
  );

  /// Medium body text - Standard reading content
  static TextStyle get bodyMedium => GoogleFonts.sourceSerif4(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.65,
    letterSpacing: 0.1,
  );

  /// Small body text - Secondary information
  static TextStyle get bodySmall => GoogleFonts.sourceSerif4(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0.15,
  );

  // ===== SPECIALIZED CONTENT STYLES =====
  /// Learning content - Optimized for educational material
  static TextStyle get learningContent => GoogleFonts.sourceSerif4(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.75, // Extra line height for better comprehension
    letterSpacing: 0.2,
  );

  /// Audio transcript - Clear, scannable
  static TextStyle get transcript => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.8,
    letterSpacing: 0.1,
  );

  /// Coach dialogue - Conversational, warm
  static TextStyle get coachDialogue => GoogleFonts.sourceSerif4(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0.1,
    fontStyle: FontStyle.italic,
  );

  // ===== UI ELEMENT STYLES =====
  /// Button text - Bold, clear calls to action
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// Large button text
  static TextStyle get buttonLarge => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// Small button text
  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// Tab labels
  static TextStyle get tabLabel => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.3,
  );

  /// Navigation labels
  static TextStyle get navLabel => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ===== FORM & INPUT STYLES =====
  /// Input field text
  static TextStyle get inputText => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.1,
  );

  /// Input field labels
  static TextStyle get inputLabel => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.2,
  );

  /// Helper text for forms
  static TextStyle get helperText => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.2,
  );

  // ===== METADATA & SUPPLEMENTARY STYLES =====
  /// Caption text - Image captions, timestamps
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.3,
  );

  /// Overline text - Section labels, categories
  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 1.5,
  );

  /// Label text - Tags, badges, status indicators
  static TextStyle get label => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ===== LEARNING-SPECIFIC STYLES =====
  /// Lesson title
  static TextStyle get lessonTitle => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.1,
  );

  /// Episode duration and metadata
  static TextStyle get episodeMetadata => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.3,
  );

  /// Progress indicators
  static TextStyle get progressText => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.3,
  );

  /// Achievement text
  static TextStyle get achievement => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.2,
  );

  // ===== CODE & TECHNICAL STYLES =====
  /// Inline code
  static TextStyle get inlineCode => GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Code blocks
  static TextStyle get codeBlock => GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0,
  );

  // ===== ACCESSIBILITY HELPERS =====
  /// Get larger text version for accessibility
  static TextStyle getLargerText(TextStyle style, {double scaleFactor = 1.2}) {
    return style.copyWith(fontSize: (style.fontSize ?? 16) * scaleFactor);
  }

  /// Get high contrast version
  static TextStyle getHighContrast(TextStyle style, Color color) {
    return style.copyWith(color: color, fontWeight: FontWeight.w600);
  }

  /// Get style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Get style with custom weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  // ===== RESPONSIVE HELPERS =====
  /// Scale font size based on screen size
  static TextStyle responsive(TextStyle style, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = 1.0;

    if (screenWidth < 360) {
      scaleFactor = 0.9; // Small phones
    } else if (screenWidth > 768) {
      scaleFactor = 1.1; // Tablets
    }

    return style.copyWith(
      fontSize: (style.fontSize ?? 16) * scaleFactor,
    );
  }

  // ===== LEARNING PSYCHOLOGY OPTIMIZED STYLES =====
  /// Question text - Clear and engaging
  static TextStyle get questionText => GoogleFonts.sourceSerif4(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 0.1,
  );

  /// Answer text - Easy to scan
  static TextStyle get answerText => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.1,
  );

  /// Key concept emphasis
  static TextStyle get keyConceptEmphasis => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.1,
  );

  /// Summary text
  static TextStyle get summaryText => GoogleFonts.sourceSerif4(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0.15,
  );
}
