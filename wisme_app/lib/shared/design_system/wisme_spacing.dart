/// WISME Spacing System
/// 
/// Provides consistent spacing values across the entire application
/// following a systematic approach for better visual hierarchy.

/// WISME Spacing Constants
class WismeSpacing {
  WismeSpacing._();

  // ===== BASE SPACING UNITS =====
  
  /// Extra small spacing - 4px
  static const double xs = 4.0;
  
  /// Small spacing - 8px
  static const double sm = 8.0;
  
  /// Medium spacing - 16px
  static const double md = 16.0;
  
  /// Large spacing - 24px
  static const double lg = 24.0;
  
  /// Extra large spacing - 32px
  static const double xl = 32.0;
  
  /// Extra extra large spacing - 48px
  static const double xxl = 48.0;

  // ===== SPECIFIC USE CASE SPACING =====
  
  /// Standard padding for containers
  static const double containerPadding = md;
  
  /// Standard margin between components
  static const double componentMargin = lg;
  
  /// Card internal padding
  static const double cardPadding = md;
  
  /// Card external margin
  static const double cardMargin = md;
  
  /// Section spacing (between major sections)
  static const double sectionSpacing = xl;
  
  /// Page padding (screen edges)
  static const double pagePadding = md;
  
  /// Button internal padding horizontal
  static const double buttonPaddingH = lg;
  
  /// Button internal padding vertical
  static const double buttonPaddingV = sm;
  
  /// Form field spacing
  static const double formFieldSpacing = md;
  
  /// List item spacing
  static const double listItemSpacing = sm;

  // ===== RESPONSIVE SPACING =====
  
  /// Get responsive spacing based on screen width
  static double getResponsiveSpacing(double baseSpacing, double screenWidth) {
    if (screenWidth > 768) {
      return baseSpacing * 1.25; // Larger spacing on tablets/desktop
    } else if (screenWidth < 320) {
      return baseSpacing * 0.8; // Smaller spacing on very small screens
    }
    return baseSpacing; // Base spacing for mobile
  }
  
  /// Get responsive padding for containers
  static double getResponsivePadding(double screenWidth) {
    return getResponsiveSpacing(containerPadding, screenWidth);
  }
  
  /// Get responsive margin for components
  static double getResponsiveMargin(double screenWidth) {
    return getResponsiveSpacing(componentMargin, screenWidth);
  }

  // ===== UTILITY SPACING SCALES =====
  
  /// Micro spacing scale (for fine adjustments)
  static const List<double> microScale = [2.0, 4.0, 6.0, 8.0];
  
  /// Standard spacing scale
  static const List<double> standardScale = [4.0, 8.0, 16.0, 24.0, 32.0, 48.0];
  
  /// Large spacing scale (for major layout elements)
  static const List<double> largeScale = [24.0, 32.0, 48.0, 64.0, 96.0, 128.0];
  
  /// Get spacing value from scale
  static double fromScale(List<double> scale, int index) {
    if (index < 0 || index >= scale.length) {
      return scale[0]; // Return first value as fallback
    }
    return scale[index];
  }
}
