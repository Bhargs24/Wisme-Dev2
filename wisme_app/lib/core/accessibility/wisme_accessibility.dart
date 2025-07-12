import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

/// Wisme Accessibility System
/// Ensures WCAG 2.1 AA compliance and superior accessibility experience
/// Provides inclusive design for users with disabilities
class WismeAccessibility {
  WismeAccessibility._();

  // ===== SEMANTIC LABELS =====
  static const String welcomeScreenLabel = 'Welcome to Wisme - Your AI Learning Companion';
  static const String signInButtonLabel = 'Sign in to your account';
  static const String signUpButtonLabel = 'Create a new account';
  static const String emailFieldLabel = 'Email address input field';
  static const String passwordFieldLabel = 'Password input field';
  static const String showPasswordLabel = 'Show password';
  static const String hidePasswordLabel = 'Hide password';
  static const String backButtonLabel = 'Go back to previous screen';
  static const String closeButtonLabel = 'Close current screen';
  static const String menuButtonLabel = 'Open navigation menu';

  // ===== ACCESSIBILITY FOCUS =====
  static void announceMessage(String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  static void announcePageChange(String pageName) {
    SemanticsService.announce(
      'Navigated to $pageName',
      TextDirection.ltr,
    );
  }

  static void announceError(String errorMessage) {
    SemanticsService.announce(
      'Error: $errorMessage',
      TextDirection.ltr,
    );
  }

  static void announceSuccess(String successMessage) {
    SemanticsService.announce(
      'Success: $successMessage',
      TextDirection.ltr,
    );
  }

  // ===== HAPTIC FEEDBACK =====
  static void lightHaptic() {
    HapticFeedback.lightImpact();
  }

  static void mediumHaptic() {
    HapticFeedback.mediumImpact();
  }

  static void heavyHaptic() {
    HapticFeedback.heavyImpact();
  }

  static void selectionHaptic() {
    HapticFeedback.selectionClick();
  }

  static void errorHaptic() {
    HapticFeedback.vibrate();
  }

  // ===== ACCESSIBLE BUTTON =====
  static Widget accessibleButton({
    required String label,
    required VoidCallback onPressed,
    required Widget child,
    String? tooltip,
    String? hint,
    bool excludeSemantics = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: true,
      excludeSemantics: excludeSemantics,
      child: Tooltip(
        message: tooltip ?? label,
        child: InkWell(
          onTap: () {
            lightHaptic();
            onPressed();
          },
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }

  // ===== ACCESSIBLE TEXT FIELD =====
  static Widget accessibleTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? errorText,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Function(String)? onChanged,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      textField: true,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  // ===== ACCESSIBLE CARD =====
  static Widget accessibleCard({
    required String label,
    required Widget child,
    VoidCallback? onTap,
    String? hint,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: onTap != null,
      child: Card(
        child: InkWell(
          onTap: onTap != null ? () {
            lightHaptic();
            onTap();
          } : null,
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }

  // ===== ACCESSIBLE ICON BUTTON =====
  static Widget accessibleIconButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
    Color? color,
    double? size,
  }) {
    return Semantics(
      label: label,
      hint: 'Double tap to activate',
      button: true,
      child: Tooltip(
        message: tooltip ?? label,
        child: IconButton(
          icon: Icon(icon, color: color, size: size),
          onPressed: () {
            lightHaptic();
            onPressed();
          },
          splashRadius: 24,
        ),
      ),
    );
  }

  // ===== ACCESSIBLE LIST TILE =====
  static Widget accessibleListTile({
    required String label,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    String? hint,
  }) {
    return Semantics(
      label: label,
      hint: hint ?? (onTap != null ? 'Double tap to select' : null),
      button: onTap != null,
      child: ListTile(
        title: Text(label),
        subtitle: subtitle != null ? Text(subtitle) : null,
        leading: leading,
        trailing: trailing,
        onTap: onTap != null ? () {
          lightHaptic();
          onTap();
        } : null,
      ),
    );
  }

  // ===== ACCESSIBLE NAVIGATION =====
  static Widget accessibleBottomNavigationBar({
    required List<BottomNavigationBarItem> items,
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return Semantics(
      label: 'Navigation bar',
      child: BottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onTap: (index) {
          selectionHaptic();
          onTap(index);
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // ===== ACCESSIBLE DRAWER =====
  static Widget accessibleDrawer({
    required List<Widget> children,
  }) {
    return Semantics(
      label: 'Navigation drawer',
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: children,
        ),
      ),
    );
  }

  // ===== ACCESSIBLE APP BAR =====
  static PreferredSizeWidget accessibleAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
  }) {
    return AppBar(
      title: Semantics(
        header: true,
        child: Text(title),
      ),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  // ===== SCREEN READER UTILITIES =====
  static Widget screenReaderOnly({
    required String text,
  }) {
    return Semantics(
      label: text,
      child: const SizedBox.shrink(),
    );
  }

  static Widget excludeFromSemantics({
    required Widget child,
  }) {
    return ExcludeSemantics(child: child);
  }

  // ===== FOCUS MANAGEMENT =====
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  static void clearFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void nextFocus(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  static void previousFocus(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  // ===== KEYBOARD NAVIGATION =====
  static Widget keyboardNavigable({
    required Widget child,
    required VoidCallback onActivate,
    FocusNode? focusNode,
  }) {
    return Focus(
      focusNode: focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.space) {
            onActivate();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }

  // ===== ACCESSIBLE ERROR DISPLAY =====
  static void showAccessibleError({
    required BuildContext context,
    required String message,
  }) {
    announceError(message);
    errorHaptic();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // ===== ACCESSIBLE SUCCESS DISPLAY =====
  static void showAccessibleSuccess({
    required BuildContext context,
    required String message,
  }) {
    announceSuccess(message);
    lightHaptic();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // ===== ACCESSIBILITY TESTING =====
  static bool isAccessibilityEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  static bool isLargeTextEnabled(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor > 1.3;
  }

  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  // ===== ACCESSIBLE LOADING =====
  static Widget accessibleLoading({
    String? label,
  }) {
    return Semantics(
      label: label ?? 'Loading, please wait',
      liveRegion: true,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // ===== ACCESSIBLE PROGRESS =====
  static Widget accessibleProgress({
    required double value,
    String? label,
  }) {
    final percentage = (value * 100).round();
    return Semantics(
      label: label ?? 'Progress: $percentage percent complete',
      value: percentage.toString(),
      child: LinearProgressIndicator(value: value),
    );
  }

  // ===== ACCESSIBLE MODAL =====
  static Future<T?> showAccessibleDialog<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => Semantics(
        label: 'Dialog: $title',
        child: AlertDialog(
          title: Text(title),
          content: content,
          actions: actions,
        ),
      ),
    );
  }
}
