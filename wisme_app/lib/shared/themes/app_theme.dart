import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';

/// Wisme Theme System - Complete design system implementation
/// Creates consistent, beautiful, and accessible themes for the entire app
class WismeTheme {
  WismeTheme._();

  // ===== LIGHT THEME =====
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // ===== COLOR SCHEME =====
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: WismeColors.primaryBlue,
        onPrimary: Colors.white,
        primaryContainer: WismeColors.primaryBlueLight,
        onPrimaryContainer: WismeColors.primaryBlueDark,
        secondary: WismeColors.wisdomPurple,
        onSecondary: Colors.white,
        secondaryContainer: WismeColors.wisdomPurpleLight,
        onSecondaryContainer: WismeColors.wisdomPurpleDark,
        tertiary: WismeColors.success,
        onTertiary: Colors.white,
        error: WismeColors.error,
        onError: Colors.white,
        errorContainer: WismeColors.errorLight,
        onErrorContainer: WismeColors.errorDark,
        surface: WismeColors.backgroundPrimary,
        onSurface: WismeColors.textPrimary,
        surfaceVariant: WismeColors.backgroundSecondary,
        onSurfaceVariant: WismeColors.textSecondary,
        outline: WismeColors.border,
        outlineVariant: WismeColors.borderLight,
        shadow: Color(0x1A000000), // Colors.black.withOpacity(0.1)
        scrim: Color(0x80000000), // Colors.black.withOpacity(0.5)
        inverseSurface: WismeColors.textPrimary,
        onInverseSurface: WismeColors.backgroundPrimary,
        inversePrimary: WismeColors.primaryBlueLight,
        surfaceTint: WismeColors.primaryBlue,
      ),

      // ===== SCAFFOLD THEME =====
      scaffoldBackgroundColor: WismeColors.backgroundPrimary,

      // ===== APP BAR THEME =====
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: WismeColors.backgroundPrimary,
        foregroundColor: WismeColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: WismeTypography.h3.copyWith(
          color: WismeColors.textPrimary,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(
          color: WismeColors.textPrimary,
          size: 24,
        ),
        actionsIconTheme: const IconThemeData(
          color: WismeColors.textPrimary,
          size: 24,
        ),
        centerTitle: true,
      ),

      // ===== BUTTON THEMES =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: WismeColors.primaryBlue,
          foregroundColor: Colors.white,
          textStyle: WismeTypography.button,
          padding: WismeSpacing.buttonContent,
          shape: RoundedRectangleBorder(
            borderRadius: WismeSpacing.borderRadiusLg,
          ),
          minimumSize: const Size(120, 48),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          textStyle: WismeTypography.button,
          padding: WismeSpacing.buttonContent,
          shape: RoundedRectangleBorder(
            borderRadius: WismeSpacing.borderRadiusLg,
          ),
          minimumSize: const Size(120, 48),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: WismeColors.primaryBlue,
          textStyle: WismeTypography.button,
          padding: WismeSpacing.buttonContent,
          side: const BorderSide(
            color: WismeColors.primaryBlue,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: WismeSpacing.borderRadiusLg,
          ),
          minimumSize: const Size(120, 48),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          elevation: 0,
          foregroundColor: WismeColors.primaryBlue,
          textStyle: WismeTypography.button,
          padding: WismeSpacing.buttonContent,
          shape: RoundedRectangleBorder(
            borderRadius: WismeSpacing.borderRadiusLg,
          ),
          minimumSize: const Size(88, 48),
        ),
      ),

      // ===== CARD THEME =====
      cardTheme: CardTheme(
        elevation: 0,
        color: WismeColors.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Color(0x0D000000), // Colors.black.withOpacity(0.05)
        shape: RoundedRectangleBorder(
          borderRadius: WismeSpacing.borderRadiusLg,
          side: const BorderSide(
            color: WismeColors.borderLight,
            width: 1,
          ),
        ),
      ),

      // ===== INPUT DECORATION THEME =====
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WismeColors.backgroundSecondary,
        border: OutlineInputBorder(
          borderRadius: WismeSpacing.borderRadiusLg,
          borderSide: const BorderSide(
            color: WismeColors.border,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: WismeSpacing.borderRadiusLg,
          borderSide: const BorderSide(
            color: WismeColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: WismeSpacing.borderRadiusLg,
          borderSide: const BorderSide(
            color: WismeColors.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: WismeSpacing.borderRadiusLg,
          borderSide: const BorderSide(
            color: WismeColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: WismeSpacing.borderRadiusLg,
          borderSide: const BorderSide(
            color: WismeColors.error,
            width: 2,
          ),
        ),
        contentPadding: WismeSpacing.inputContent,
        labelStyle: WismeTypography.inputLabel.copyWith(
          color: WismeColors.textSecondary,
        ),
        hintStyle: WismeTypography.inputText.copyWith(
          color: WismeColors.textTertiary,
        ),
        helperStyle: WismeTypography.helperText.copyWith(
          color: WismeColors.textSecondary,
        ),
        errorStyle: WismeTypography.helperText.copyWith(
          color: WismeColors.error,
        ),
      ),

      // ===== FLOATING ACTION BUTTON THEME =====
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: WismeColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 8,
        highlightElevation: 12,
        shape: CircleBorder(),
      ),

      // ===== BOTTOM NAVIGATION BAR THEME =====
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: WismeColors.surface,
        selectedItemColor: WismeColors.primaryBlue,
        unselectedItemColor: WismeColors.textTertiary,
        selectedLabelStyle: WismeTypography.navLabel.copyWith(
          color: WismeColors.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: WismeTypography.navLabel.copyWith(
          color: WismeColors.textTertiary,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ===== NAVIGATION BAR THEME (Material 3) =====
      navigationBarTheme: NavigationBarThemeData(
        height: WismeSpacing.bottomNavHeight,
        backgroundColor: WismeColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return WismeTypography.navLabel.copyWith(
              color: WismeColors.primaryBlue,
              fontWeight: FontWeight.w600,
            );
          }
          return WismeTypography.navLabel.copyWith(
            color: WismeColors.textTertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: WismeColors.primaryBlue,
              size: 24,
            );
          }
          return const IconThemeData(
            color: WismeColors.textTertiary,
            size: 24,
          );
        }),
      ),

      // ===== TAB BAR THEME =====
      tabBarTheme: TabBarTheme(
        labelColor: WismeColors.primaryBlue,
        unselectedLabelColor: WismeColors.textTertiary,
        labelStyle: WismeTypography.tabLabel.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: WismeTypography.tabLabel,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: WismeColors.primaryBlue,
            width: 3,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: WismeColors.borderLight,
      ),

      // ===== CHIP THEME =====
      chipTheme: ChipThemeData(
        backgroundColor: WismeColors.backgroundSecondary,
        selectedColor: WismeColors.primaryBlue,
        disabledColor: WismeColors.backgroundTertiary,
        deleteIconColor: WismeColors.textSecondary,
        labelStyle: WismeTypography.label.copyWith(
          color: WismeColors.textPrimary,
        ),
        secondaryLabelStyle: WismeTypography.label.copyWith(
          color: Colors.white,
        ),
        padding: WismeSpacing.allXs,
        labelPadding: WismeSpacing.horizontalSm,
        shape: RoundedRectangleBorder(
          borderRadius: WismeSpacing.borderRadiusXl,
        ),
        side: const BorderSide(
          color: WismeColors.border,
          width: 1,
        ),
        elevation: 0,
        pressElevation: 1,
      ),

      // ===== DIALOG THEME =====
      dialogTheme: DialogTheme(
        backgroundColor: WismeColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: WismeSpacing.borderRadiusXl,
        ),
        titleTextStyle: WismeTypography.h4.copyWith(
          color: WismeColors.textPrimary,
        ),
        contentTextStyle: WismeTypography.bodyMedium.copyWith(
          color: WismeColors.textSecondary,
        ),
        actionsPadding: WismeSpacing.allLg,
        insetPadding: WismeSpacing.allLg,
      ),

      // ===== BOTTOM SHEET THEME =====
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: WismeColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 16,
        modalElevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: WismeSpacing.radiusXl,
            topRight: WismeSpacing.radiusXl,
          ),
        ),
        showDragHandle: true,
        dragHandleColor: WismeColors.borderLight,
      ),

      // ===== SNACKBAR THEME =====
      snackBarTheme: SnackBarThemeData(
        backgroundColor: WismeColors.textPrimary,
        contentTextStyle: WismeTypography.bodyMedium.copyWith(
          color: Colors.white,
        ),
        actionTextColor: WismeColors.primaryBlueLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: WismeSpacing.borderRadiusLg,
        ),
        elevation: 8,
      ),

      // ===== PROGRESS INDICATOR THEME =====
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: WismeColors.primaryBlue,
        linearTrackColor: WismeColors.backgroundTertiary,
        circularTrackColor: WismeColors.backgroundTertiary,
      ),

      // ===== DIVIDER THEME =====
      dividerTheme: const DividerThemeData(
        color: WismeColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ===== LIST TILE THEME =====
      listTileTheme: ListTileThemeData(
        contentPadding: WismeSpacing.listItem,
        titleTextStyle: WismeTypography.bodyMedium.copyWith(
          color: WismeColors.textPrimary,
        ),
        subtitleTextStyle: WismeTypography.bodySmall.copyWith(
          color: WismeColors.textSecondary,
        ),
        iconColor: WismeColors.textSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: WismeSpacing.borderRadiusLg,
        ),
        tileColor: Colors.transparent,
        selectedTileColor: Color(0x1A2563EB), // WismeColors.primaryBlue.withOpacity(0.1)
      ),

      // ===== ICON THEME =====
      iconTheme: const IconThemeData(
        color: WismeColors.textSecondary,
        size: 24,
      ),

      primaryIconTheme: const IconThemeData(
        color: Colors.white,
        size: 24,
      ),

      // ===== RADIO THEME =====
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return WismeColors.primaryBlue;
          }
          return WismeColors.border;
        }),
      ),

      // ===== CHECKBOX THEME =====
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return WismeColors.primaryBlue;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(
          color: WismeColors.border,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: WismeSpacing.borderRadiusSm,
        ),
      ),

      // ===== SWITCH THEME =====
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return WismeColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return WismeColors.primaryBlue;
          }
          return WismeColors.backgroundTertiary;
        }),
      ),

      // ===== SLIDER THEME =====
      sliderTheme: const SliderThemeData(
        activeTrackColor: WismeColors.primaryBlue,
        inactiveTrackColor: WismeColors.backgroundTertiary,
        thumbColor: WismeColors.primaryBlue,
        overlayColor: Color(0x1F2563EB),
        valueIndicatorColor: WismeColors.primaryBlue,
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
      ),

      // ===== TEXT SELECTION THEME =====
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: WismeColors.primaryBlue,
        selectionColor: Color(0x662563EB),
        selectionHandleColor: WismeColors.primaryBlue,
      ),

      // ===== TYPOGRAPHY THEME =====
      textTheme: TextTheme(
        displayLarge: WismeTypography.h1,
        displayMedium: WismeTypography.h2,
        displaySmall: WismeTypography.h3,
        headlineLarge: WismeTypography.h3,
        headlineMedium: WismeTypography.h4,
        headlineSmall: WismeTypography.h5,
        titleLarge: WismeTypography.h4,
        titleMedium: WismeTypography.h5,
        titleSmall: WismeTypography.h6,
        bodyLarge: WismeTypography.bodyLarge,
        bodyMedium: WismeTypography.bodyMedium,
        bodySmall: WismeTypography.bodySmall,
        labelLarge: WismeTypography.button,
        labelMedium: WismeTypography.label,
        labelSmall: WismeTypography.caption,
      ),
    );
  }

  // ===== DARK THEME =====
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      
      // ===== DARK COLOR SCHEME =====
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: WismeColors.primaryBlueLight,
        onPrimary: WismeColors.darkBackground,
        primaryContainer: WismeColors.primaryBlueDark,
        onPrimaryContainer: WismeColors.primaryBlueLight,
        secondary: WismeColors.wisdomPurpleLight,
        onSecondary: WismeColors.darkBackground,
        secondaryContainer: WismeColors.wisdomPurpleDark,
        onSecondaryContainer: WismeColors.wisdomPurpleLight,
        tertiary: WismeColors.successLight,
        onTertiary: WismeColors.darkBackground,
        error: WismeColors.errorLight,
        onError: WismeColors.darkBackground,
        errorContainer: WismeColors.errorDark,
        onErrorContainer: WismeColors.errorLight,
        surface: WismeColors.darkBackground,
        onSurface: WismeColors.darkTextPrimary,
        surfaceVariant: WismeColors.darkSurface,
        onSurfaceVariant: WismeColors.darkTextSecondary,
        outline: WismeColors.darkBorder,
        outlineVariant: WismeColors.darkDivider,
        shadow: Color(0x4D000000), // Colors.black.withOpacity(0.3)
        scrim: Color(0xB3000000), // Colors.black.withOpacity(0.7)
        inverseSurface: WismeColors.backgroundPrimary,
        onInverseSurface: WismeColors.textPrimary,
        inversePrimary: WismeColors.primaryBlue,
        surfaceTint: WismeColors.primaryBlueLight,
      ),

      scaffoldBackgroundColor: WismeColors.darkBackground,

      // ===== DARK APP BAR THEME =====
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: WismeColors.darkBackground,
        foregroundColor: WismeColors.darkTextPrimary,
        titleTextStyle: WismeTypography.h3.copyWith(
          color: WismeColors.darkTextPrimary,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(
          color: WismeColors.darkTextPrimary,
          size: 24,
        ),
        actionsIconTheme: const IconThemeData(
          color: WismeColors.darkTextPrimary,
          size: 24,
        ),
      ),

      // Update other dark theme components...
      cardTheme: lightTheme.cardTheme.copyWith(
        color: WismeColors.darkSurface,
        shadowColor: Color(0x33000000), // Colors.black.withOpacity(0.2)
        shape: RoundedRectangleBorder(
          borderRadius: WismeSpacing.borderRadiusLg,
          side: const BorderSide(
            color: WismeColors.darkBorder,
            width: 1,
          ),
        ),
      ),

      bottomNavigationBarTheme: lightTheme.bottomNavigationBarTheme.copyWith(
        backgroundColor: WismeColors.darkSurface,
        selectedItemColor: WismeColors.primaryBlueLight,
        unselectedItemColor: WismeColors.darkTextTertiary,
        selectedLabelStyle: WismeTypography.navLabel.copyWith(
          color: WismeColors.primaryBlueLight,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: WismeTypography.navLabel.copyWith(
          color: WismeColors.darkTextTertiary,
        ),
      ),

      snackBarTheme: lightTheme.snackBarTheme.copyWith(
        backgroundColor: WismeColors.darkSurfaceVariant,
        contentTextStyle: WismeTypography.bodyMedium.copyWith(
          color: WismeColors.darkTextPrimary,
        ),
        actionTextColor: WismeColors.primaryBlueLight,
      ),
    );
  }

  // ===== CUSTOM THEME EXTENSIONS =====
  /// Get custom shadows for elevated components
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Color(0x0A000000), // Colors.black.withOpacity(0.04)
      offset: const Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1F000000), // Colors.black.withOpacity(0.12)
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Color(0x1A000000), // Colors.black.withOpacity(0.1)
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x0F000000), // Colors.black.withOpacity(0.06)
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  static List<BoxShadow> get modalShadow => [
    BoxShadow(
      color: Color(0x40000000), // Colors.black.withOpacity(0.25)
      offset: const Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
    ),
  ];

  // ===== LEARNING-SPECIFIC THEME HELPERS =====
  /// Get theme colors for coach personalities
  static ColorScheme getCoachColorScheme(String personality, Brightness brightness) {
    final baseScheme = brightness == Brightness.light 
        ? lightTheme.colorScheme 
        : darkTheme.colorScheme;
    
    switch (personality.toLowerCase()) {
      case 'kai':
        return baseScheme.copyWith(
          primary: WismeColors.kaiPrimary,
          secondary: WismeColors.kaiSecondary,
          tertiary: WismeColors.kaiAccent,
        );
      case 'vee':
        return baseScheme.copyWith(
          primary: WismeColors.veePrimary,
          secondary: WismeColors.veeSecondary,
          tertiary: WismeColors.veeAccent,
        );
      default:
        return baseScheme;
    }
  }

  /// Get category-specific color scheme
  static Color getCategoryThemeColor(String category) {
    return WismeColors.getCategoryColor(category);
  }

  /// Get difficulty-specific styling
  static Color getDifficultyThemeColor(String difficulty) {
    return WismeColors.getDifficultyColor(difficulty);
  }
}
