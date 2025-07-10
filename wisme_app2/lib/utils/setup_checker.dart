import '../config/api_keys.dart' as config;

/// Simple setup checker that you can run to verify your configuration
class SetupChecker {
  
  /// Call this to test your setup progress
  static void checkSetup() {
    print('\n${'=' * 50}');
    print('🔧 WISME APP SETUP CHECKER');
    print('=' * 50);
    
    _checkApiKeys();
    _checkFirebase();
    _printNextSteps();
    
    print('=' * 50 + '\n');
  }
  
  static void _checkApiKeys() {
    print('\n📋 API KEYS STATUS:');
    print('-' * 25);
    
    // OpenAI
    bool hasOpenAI = config.ApiKeys.isOpenAIConfigured;
    print('OpenAI: ${hasOpenAI ? "✅ Ready" : "❌ Missing"}');
    if (!hasOpenAI) {
      print('  → Get from: https://platform.openai.com/api-keys');
    }
    
    // ElevenLabs
    bool hasElevenLabs = config.ApiKeys.isElevenLabsConfigured;
    print('ElevenLabs: ${hasElevenLabs ? "✅ Ready" : "❌ Missing"}');
    if (!hasElevenLabs) {
      print('  → Get from: https://elevenlabs.io/ (Profile → API Key)');
    }
  }
  
  static void _checkFirebase() {
    print('\n🔥 FIREBASE STATUS:');
    print('-' * 25);
    
    bool hasFirebase = config.ApiKeys.isFirebaseConfigured;
    print('Firebase: ${hasFirebase ? "✅ Ready" : "❌ Missing"}');
    if (!hasFirebase) {
      print('  → Follow: COMPLETE_SETUP_GUIDE.md (Part 2)');
      print('  → Console: https://console.firebase.google.com/');
    }
    
    // Check for config files
    print('\nConfig Files:');
    print('android/app/google-services.json: ${_fileExistsMessage("android/app/")}');
    print('ios/Runner/GoogleService-Info.plist: ${_fileExistsMessage("ios/Runner/")}');
  }
  
  static void _printNextSteps() {
    print('\n📚 NEXT STEPS:');
    print('-' * 25);
    
    bool hasOpenAI = config.ApiKeys.isOpenAIConfigured;
    bool hasElevenLabs = config.ApiKeys.isElevenLabsConfigured;
    bool hasFirebase = config.ApiKeys.isFirebaseConfigured;
    
    if (!hasOpenAI || !hasElevenLabs) {
      print('1. ⭐ PRIORITY: Get your API keys');
      print('   → Open: COMPLETE_SETUP_GUIDE.md (Part 1)');
      print('   → Edit: lib/config/api_keys.dart');
    } else if (!hasFirebase) {
      print('1. ⭐ PRIORITY: Set up Firebase');
      print('   → Open: COMPLETE_SETUP_GUIDE.md (Part 2)');
      print('   → Go to: https://console.firebase.google.com/');
    } else {
      print('1. 🎉 All set! Try running the app:');
      print('   → flutter run');
      print('   → Test lesson generation');
      print('   → Try voice features');
    }
    
    print('\n💡 HELPFUL COMMANDS:');
    print('   flutter clean && flutter pub get  (if you have issues)');
    print('   flutter run --verbose              (to see detailed output)');
  }
  
  static String _fileExistsMessage(String folder) {
    // For now, just give guidance since we can't check files directly
    return "Check if config file exists in $folder";
  }
  
  /// Quick development test - call this to test API integration
  static void testApiConnections() {
    print('\n🧪 TESTING API CONNECTIONS...');
    
    if (!config.ApiKeys.isOpenAIConfigured) {
      print('❌ OpenAI: Configure API key first');
      return;
    }
    
    if (!config.ApiKeys.isElevenLabsConfigured) {
      print('❌ ElevenLabs: Configure API key first');
      return;
    }
    
    print('✅ API keys are configured!');
    print('   Ready to test lesson generation');
    print('   Ready to test voice synthesis');
    
    // In a real app, you'd make actual API calls here
    print('\n💡 TIP: Run the app to test real API calls');
  }
}
