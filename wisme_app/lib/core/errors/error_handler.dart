import 'package:flutter/material.dart';
import '../core.dart';

/// Wisme Error Handling System - Comprehensive error management
/// Provides graceful error recovery and user-friendly error messages
class WismeErrorHandler {
  WismeErrorHandler._();

  // ===== ERROR TYPES =====
  static const String networkError = 'NETWORK_ERROR';
  static const String authError = 'AUTH_ERROR';
  static const String validationError = 'VALIDATION_ERROR';
  static const String serverError = 'SERVER_ERROR';
  static const String unknownError = 'UNKNOWN_ERROR';

  // ===== ERROR RECOVERY ACTIONS =====
  static void showErrorSnackBar(
    BuildContext context, 
    String message, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                onRetry();
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
      backgroundColor: WismeColors.error,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: WismeColors.success,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // ===== ERROR BOUNDARY WIDGET =====
  static Widget errorBoundary({
    required Widget child,
    Widget? fallback,
    Function(FlutterErrorDetails)? onError,
  }) {
    return Builder(
      builder: (context) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          onError?.call(details);
          return fallback ?? _defaultErrorWidget(details);
        };
        return child;
      },
    );
  }

  static Widget _defaultErrorWidget(FlutterErrorDetails details) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: WismeColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: WismeColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We\'re working to fix this issue',
              style: TextStyle(
                fontSize: 14,
                color: WismeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ===== NETWORK ERROR HANDLING =====
  static String getNetworkErrorMessage(Exception error) {
    if (error.toString().contains('SocketException')) {
      return 'Please check your internet connection and try again';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timed out. Please try again';
    } else if (error.toString().contains('401')) {
      return 'Authentication failed. Please sign in again';
    } else if (error.toString().contains('403')) {
      return 'Access denied. Please check your permissions';
    } else if (error.toString().contains('404')) {
      return 'The requested resource was not found';
    } else if (error.toString().contains('500')) {
      return 'Server error. Please try again later';
    } else {
      return 'An unexpected error occurred. Please try again';
    }
  }

  // ===== VALIDATION ERROR HANDLING =====
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
}
