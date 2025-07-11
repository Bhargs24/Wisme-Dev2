/// Secure API Key Management for Wisme App
/// 
/// IMPORTANT: This file should be added to .gitignore
/// Replace the placeholder values with your actual API keys
library;

class ApiKeys {
  // OpenAI API Key
  // Get yours from: https://platform.openai.com/api-keys
  static const String openAI = 'REDACTED_OPENAI_KEY_SET_VIA_ENV';
  
  // ElevenLabs API Key  
  // Get yours from: https://elevenlabs.io/speech-synthesis
  static const String elevenLabs = 'sk_4251133ba2069affc76cc7a2b55378362cfe9ac389f0e708';
  
  // Firebase Configuration (will be updated after Firebase setup)
  static const String firebaseApiKey = 'AIzaSyC5ZOdEAg7t1UfKd_n7_wonnDJA-6X9zJg';
  static const String firebaseProjectId = 'wisme-app';
  static const String firebaseMessagingSenderId = '71244676159';
  static const String firebaseAppId = '1:71244676159:android:481d374fd302bf88b28c8a';
  
  // Validation
  static bool get isOpenAIConfigured => openAI.isNotEmpty && !openAI.contains('REPLACE_WITH');
  static bool get isElevenLabsConfigured => elevenLabs.isNotEmpty && !elevenLabs.contains('REPLACE_WITH');
  static bool get isFirebaseConfigured => firebaseApiKey.isNotEmpty && !firebaseApiKey.contains('REPLACE_WITH');
  
  // Development mode fallback (for testing without real APIs)
  static bool get isDevelopmentMode => !isOpenAIConfigured || !isElevenLabsConfigured;
}
