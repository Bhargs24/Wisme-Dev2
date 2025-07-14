import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/core.dart';
import 'features/features.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Environment Configuration
    await EnvironmentConfig.initialize();
    
    // Print configuration status for debugging
    if (EnvironmentConfig.debugMode) {
      EnvironmentConfig.printConfigurationStatus();
    }
    
    // Initialize Supabase Backend
    await SupabaseService.initialize();
    
    // Test OpenAI Integration (if configured)
    if (EnvironmentConfig.openaiApiKey.isNotEmpty) {
      print('🤖 Testing OpenAI integration...');
      try {
        final isWorking = await OpenAIService().testConnection();
        print(isWorking ? '✅ OpenAI integration working!' : '⚠️ OpenAI connection issues');
      } catch (e) {
        print('⚠️ OpenAI test failed: $e');
      }
    } else {
      print('⚠️ OpenAI API key not configured - using mock data');
    }
    
  } catch (e) {
    print('❌ Initialization Error: $e');
    // In production, you might want to show an error screen
  }
  
  runApp(
    ProviderScope(
      child: const WismeApp(),
    ),
  );
}

class WismeApp extends StatelessWidget {
  const WismeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisme - AI-Powered Learning',
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
    );
  }
}
