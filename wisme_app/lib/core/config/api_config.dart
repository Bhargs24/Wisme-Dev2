import 'environment_config.dart';

/// API Configuration for Wisme App
/// Uses environment variables for secure API key management
class ApiConfig {
  // OpenAI API Configuration
  static String get openAiApiKey => EnvironmentConfig.openaiApiKey;
  static const String openAiBaseUrl = 'https://api.openai.com/v1/chat/completions';
  
  // Claude API Configuration
  static String get claudeApiKey => EnvironmentConfig.claudeApiKey;
  static const String claudeBaseUrl = 'https://api.anthropic.com/v1/messages';
  
  // PlayHT API Configuration  
  static String get playHtApiKey => EnvironmentConfig.playhtApiKey;
  static String get playHtUserId => EnvironmentConfig.playhtUserId;
  static const String playHtBaseUrl = 'https://api.play.ht/api/v2';
  
  // ElevenLabs API Configuration
  static String get elevenlabsApiKey => EnvironmentConfig.elevenlabsApiKey;
  static const String elevenlabsBaseUrl = 'https://api.elevenlabs.io/v1';
  
  // Voice IDs for coach personalities (PlayHT voices optimized for personalities)
  static const Map<String, String> voiceIds = {
    // Kai: Thoughtful, analytical mentor - calm, meditation-focused voice
    'Kai': 's3://voice-cloning-zero-shot/38a41ac2-f574-421c-adb9-ce1bcb6f4a84/arthurmeditationsaad/manifest.json',
    // Vee: Energetic, motivating coach - youthful, high-energy voice  
    'Vee': 's3://voice-cloning-zero-shot/f2863f63-5334-4f65-9d30-438feb79c2ec/arianasaad2/manifest.json',
  };
  
  // Model configurations (using PlayDialog for best emotional expression)
  static const String gptModel = 'gpt-4';
  static const String claudeModel = 'claude-3-sonnet-20240229';
  static const String playHtModel = 'PlayDialog'; // Best for emotive, contextual speech
  
  // Audio quality settings with compression
  static const Map<String, dynamic> audioConfig = {
    'format': 'mp3',
    'quality': 'high', // high, medium, low
    'sample_rate': 24000, // Optimal for speech: 24kHz
    'speed': 1.0,
    'compression': {
      'enabled': true,
      'bitrate': 128, // 128kbps - good quality/size balance
      'algorithm': 'mp3_vbr', // Variable bitrate for better compression
    }
  };
  
  // API validation
  static bool get isOpenAiConfigured => openAiApiKey.isNotEmpty;
  static bool get isClaudeConfigured => claudeApiKey.isNotEmpty;
  static bool get isPlayHtConfigured => playHtApiKey.isNotEmpty && playHtUserId.isNotEmpty;
  static bool get isElevenlabsConfigured => elevenlabsApiKey.isNotEmpty;
  
  static void validateConfiguration() {
    final errors = <String>[];
    
    if (!isOpenAiConfigured && !isClaudeConfigured) {
      errors.add('No AI service configured (OpenAI or Claude required)');
    }
    if (!isPlayHtConfigured && !isElevenlabsConfigured) {
      errors.add('No TTS service configured (PlayHT or ElevenLabs required)');
    }
    
    if (errors.isNotEmpty) {
      throw Exception('API Configuration errors:\n${errors.join('\n')}');
    }
  }
  
  /// Get preferred AI service
  static String get preferredAiService {
    if (isOpenAiConfigured) return 'openai';
    if (isClaudeConfigured) return 'claude';
    throw Exception('No AI service configured');
  }
  
  /// Get preferred TTS service
  static String get preferredTtsService {
    if (isPlayHtConfigured) return 'playht';
    if (isElevenlabsConfigured) return 'elevenlabs';
    throw Exception('No TTS service configured');
  }
}

/// Instructions for setting up API keys:
/// 
/// 1. OpenAI API Key:
///    - Go to https://platform.openai.com/api-keys
///    - Create a new API key
///    - Replace 'YOUR_OPENAI_API_KEY' with your actual key
/// 
/// 2. PlayHT API Key:
///    - Go to https://play.ht/
///    - Sign up and go to your profile
///    - Copy your API key and User ID
///    - Replace 'YOUR_PLAYHT_API_KEY' with your actual key
///    - Replace 'YOUR_PLAYHT_USER_ID' with your actual user ID
/// 
/// 3. Voice IDs (Optional):
///    - The default voice IDs are for high-quality PlayHT voices
///    - You can customize these with your preferred voices
///    - Get voice IDs from PlayHT voice library
/// 
/// 4. Security Note:
///    - Never commit real API keys to version control
///    - Use environment variables in production
///    - Consider using flutter_config or similar packages
