import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'config/api_keys.dart';
import 'providers/settings_provider.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    logger.i('🚀 Starting Wisme App...');
    
    // Test API configuration
    logger.i('API Status:');
    logger.i('  OpenAI: ${ApiKeys.isOpenAIConfigured ? "✅" : "❌"}');
    logger.i('  ElevenLabs: ${ApiKeys.isElevenLabsConfigured ? "✅" : "❌"}');
    logger.i('  Firebase: ${ApiKeys.isFirebaseConfigured ? "✅" : "❌"}');
    
    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    logger.i('✅ SharedPreferences initialized');
    
    // Simple provider setup
    runApp(
      MultiProvider(
        providers: [
          // Core settings provider
          ChangeNotifierProvider<SettingsProvider>(
            create: (_) => SettingsProvider(prefs: prefs),
          ),
        ],
        child: const WismeApp(),
      ),
    );
    
    logger.i('✅ App launched successfully');
    
  } catch (e, stackTrace) {
    logger.e('❌ Error during startup: $e');
    logger.e('Stack trace: $stackTrace');
    
    // Fallback to error app
    runApp(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Startup Error'),
            backgroundColor: Colors.red,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 100, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  'App failed to start',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Error: $e'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => main(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
