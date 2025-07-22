/// WISME - World's Most Successful AI Learning App
///
/// This is the main entry point for the WISME application.   
/// The app is built with a modular, scalable architecture that provides:
/// - Comprehensive state management
/// - Advanced analytics and personalization
/// - Modern UI components
/// - AI-powered learning experiences
/// - Coach-like adaptive behavior
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Core architecture
import 'core/state/app_state_manager.dart';
import 'core/analytics/comprehensive_analytics_system.dart';  
// Core services
import 'core/services/enhanced_auth_service.dart';
import 'core/services/supabase_service.dart';
// Shared design system
import 'shared/themes/app_theme.dart';
// Navigation
import 'core/navigation/main_navigation_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize core systems
    await _initializeCoreSystems();
    // Start the app
    runApp(const WismeApp());
  } catch (e) {
    // Fallback initialization
    await _initializeFallback();
    runApp(const WismeApp());
  }
}

/// Initialize all core systems
Future<void> _initializeCoreSystems() async {
  // Initialize state management
  await AppStateManager.instance.initialize();
  
  // Initialize analytics system
  await ComprehensiveAnalyticsSystem.instance.initialize();   
  
  // Initialize authentication
  final authService = EnhancedAuthService();
  authService.initialize();
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  // Track app launch
  ComprehensiveAnalyticsSystem.instance.trackEvent(
    PerformanceEvent(
      metric: 'app_launch',
      value: 'success',
    ),
  );
}

/// Fallback initialization for error cases
Future<void> _initializeFallback() async {
  // Minimal initialization for degraded mode
  await AppStateManager.instance.initialize();
  
  ComprehensiveAnalyticsSystem.instance.trackEvent(
    PerformanceEvent(
      metric: 'app_launch',
      value: 'degraded_mode',
    ),
  );
}

/// Main WISME App Widget
class WismeApp extends StatelessWidget {
  const WismeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // State management providers
        ...AppProviders.providers,
        // Additional providers can be added here
      ],
      child: MaterialApp(
        title: 'WISME - AI Learning Platform',
        theme: WismeTheme.lightTheme,
        darkTheme: WismeTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainNavigationWrapper(),
        debugShowCheckedModeBanner: false,
        // Global app configuration
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.of(context).textScaler.clamp(
                minScaleFactor: 0.8,
                maxScaleFactor: 1.5,
              ),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
