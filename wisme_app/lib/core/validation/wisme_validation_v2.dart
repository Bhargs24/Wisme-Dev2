import 'package:flutter/material.dart';

/// Wisme Professional Validation System
/// Provides comprehensive form validation with user-friendly messaging
/// Ensures data integrity and superior user experience
class WismeValidation {
  WismeValidation._();

  // ===== EMAIL VALIDATION =====
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }

    // Remove whitespace
    value = value.trim();

    // Check minimum length
    if (value.length < 5) {
      return 'Email address is too short';
    }

    // Check maximum length
    if (value.length > 254) {
      return 'Email address is too long';
    }

    // Comprehensive email regex
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    // Check for common typos
    if (_hasCommonEmailTypos(value)) {
      return 'Please check your email address for typos';
    }

    return null;
  }

  static bool _hasCommonEmailTypos(String email) {
    final commonTypos = [
      'gmial.com',
      'gmai.com',
      'yahooo.com',
      'yaho.com',
      'hotmial.com',
      'hotmai.com',
      'outlok.com',
      'outloo.com',
    ];

    return commonTypos.any((typo) => email.toLowerCase().contains(typo));
  }

  // ===== PASSWORD VALIDATION =====
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (value.length > 128) {
      return 'Password must be less than 128 characters';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    // Check for common weak patterns
    if (_hasWeakPasswordPatterns(value)) {
      return 'Password contains common weak patterns';
    }

    return null;
  }

  static bool _hasWeakPasswordPatterns(String password) {
    final weakPatterns = [
      'password',
      '123456',
      'qwerty',
      'abc123',
      'password123',
      '12345678',
      'admin',
      'letmein',
    ];

    final lowerPassword = password.toLowerCase();
    return weakPatterns.any((pattern) => lowerPassword.contains(pattern));
  }

  // ===== PASSWORD STRENGTH CALCULATION =====
  static PasswordStrength calculatePasswordStrength(String password) {
    if (password.isEmpty) {
      return PasswordStrength.empty;
    }

    int score = 0;
    
    // Length scoring
    if (password.length >= 8) score += 1;
    if (password.length >= 12) score += 1;
    if (password.length >= 16) score += 1;

    // Character variety scoring
    if (RegExp(r'[a-z]').hasMatch(password)) score += 1;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 1;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 1;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score += 1;

    // Complexity bonus
    if (password.length > 12 && _hasVariedCharacters(password)) {
      score += 1;
    }

    // Penalty for weak patterns
    if (_hasWeakPasswordPatterns(password)) {
      score -= 2;
    }

    // Return strength based on score
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.fair;
    if (score <= 6) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  static bool _hasVariedCharacters(String password) {
    final charTypes = <String>{};
    for (final char in password.split('')) {
      if (RegExp(r'[a-z]').hasMatch(char)) charTypes.add('lower');
      if (RegExp(r'[A-Z]').hasMatch(char)) charTypes.add('upper');
      if (RegExp(r'[0-9]').hasMatch(char)) charTypes.add('digit');
      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(char)) charTypes.add('special');
    }
    return charTypes.length >= 3;
  }

  // ===== NAME VALIDATION =====
  static String? validateName(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    value = value.trim();

    if (value.length < 2) {
      return '$fieldName must be at least 2 characters long';
    }

    if (value.length > 50) {
      return '$fieldName must be less than 50 characters';
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return '$fieldName can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  // ===== CONFIRMATION VALIDATION =====
  static String? validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ===== GENERIC REQUIRED VALIDATION =====
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}

// ===== PASSWORD STRENGTH ENUM =====
enum PasswordStrength {
  empty,
  weak,
  fair,
  good,
  strong;

  String get label {
    switch (this) {
      case PasswordStrength.empty:
        return '';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  double get value {
    switch (this) {
      case PasswordStrength.empty:
        return 0.0;
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.fair:
        return 0.5;
      case PasswordStrength.good:
        return 0.75;
      case PasswordStrength.strong:
        return 1.0;
    }
  }

  Color get color {
    switch (this) {
      case PasswordStrength.empty:
        return const Color(0xFFE0E0E0);
      case PasswordStrength.weak:
        return const Color(0xFFF44336);
      case PasswordStrength.fair:
        return const Color(0xFFFF9800);
      case PasswordStrength.good:
        return const Color(0xFF2196F3);
      case PasswordStrength.strong:
        return const Color(0xFF4CAF50);
    }
  }
}
