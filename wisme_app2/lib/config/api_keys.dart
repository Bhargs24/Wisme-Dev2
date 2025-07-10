/// Secure API Key Management for Wisme App
/// 
/// IMPORTANT: This file should be added to .gitignore
/// Replace the placeholder values with your actual API keys
library;

class ApiKeys {
  // OpenAI API Key
  // Get yours from: https://platform.openai.com/api-keys
  static const String openAI = 'REPLACE_WITH_YOUR_OPENAI_API_KEY';
  
  // ElevenLabs API Key  
  // Get yours from: https://elevenlabs.io/speech-synthesis
  static const String elevenLabs = 'REPLACE_WITH_YOUR_ELEVENLABS_API_KEY';
  
  // Firebase Configuration (will be updated after Firebase setup)
  static const String firebaseApiKey = 'REPLACE_WITH_FIREBASE_API_KEY';
  static const String firebaseProjectId = 'REPLACE_WITH_FIREBASE_PROJECT_ID';
  static const String firebaseMessagingSenderId = 'REPLACE_WITH_SENDER_ID';
  static const String firebaseAppId = 'REPLACE_WITH_FIREBASE_APP_ID';
  
  // Validation
  static bool get isOpenAIConfigured => openAI.isNotEmpty && !openAI.contains('REPLACE_WITH');
  static bool get isElevenLabsConfigured => elevenLabs.isNotEmpty && !elevenLabs.contains('REPLACE_WITH');
  static bool get isFirebaseConfigured => firebaseApiKey.isNotEmpty && !firebaseApiKey.contains('REPLACE_WITH');
  
  // Development mode fallback (for testing without real APIs)
  static bool get isDevelopmentMode => !isOpenAIConfigured || !isElevenLabsConfigured;
}
