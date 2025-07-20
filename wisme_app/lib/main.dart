/// Wisme App - Main Entry Point
/// Flutter application for personalized podcast-style AI learning

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core services and providers
import 'core/services/audio_service_registry.dart';
import 'core/services/conversation_engine.dart';
import 'providers/two_speaker_audio_provider.dart';

// Shared themes and design system
import 'shared/themes/app_theme.dart';

// Navigation
import 'core/navigation/main_navigation_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core audio services
  try {
    print('Initializing Wisme App...');
    
    // Initialize audio service registry
    final audioRegistry = AudioServiceRegistry.instance;
    await audioRegistry.initializeServices();
    print('Audio services initialized successfully');
    
    // Initialize conversation engine - just verify it exists
    ConversationEngine();
    print('Conversation engine verified');
    
    runApp(WismeApp());
  } catch (e) {
    print('Error during app initialization: $e');
    print('Starting app in degraded mode...');
    runApp(WismeApp());
  }
}

class WismeApp extends StatelessWidget {
  const WismeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Audio system provider
        ChangeNotifierProvider(
          create: (context) => TwoSpeakerAudioProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Wisme - AI Learning Platform',
        theme: WismeTheme.lightTheme,
        darkTheme: WismeTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainNavigationWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
