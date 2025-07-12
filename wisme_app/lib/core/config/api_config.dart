/// API Configuration for Wisme App
/// Replace these with your actual API keys before production
class ApiConfig {
  // OpenAI API Configuration
  static const String openAiApiKey = 'YOUR_OPENAI_API_KEY';
  static const String openAiBaseUrl = 'https://api.openai.com/v1/chat/completions';
  
  // PlayHT API Configuration  
  static const String playHtApiKey = 'YOUR_PLAYHT_API_KEY';
  static const String playHtUserId = 'YOUR_PLAYHT_USER_ID';
  static const String playHtBaseUrl = 'https://api.play.ht/api/v2';
  
  // Voice IDs for coach personalities (PlayHT voices optimized for personalities)
  static const Map<String, String> voiceIds = {
    // Kai: Thoughtful, analytical mentor - calm, meditation-focused voice
    'Kai': 's3://voice-cloning-zero-shot/38a41ac2-f574-421c-adb9-ce1bcb6f4a84/arthurmeditationsaad/manifest.json',
    // Vee: Energetic, motivating coach - youthful, high-energy voice  
    'Vee': 's3://voice-cloning-zero-shot/f2863f63-5334-4f65-9d30-438feb79c2ec/arianasaad2/manifest.json',
  };
  
  // Model configurations (using PlayDialog for best emotional expression)
  static const String gptModel = 'gpt-4';
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
  static bool get isOpenAiConfigured => openAiApiKey != 'YOUR_OPENAI_API_KEY';
  static bool get isPlayHtConfigured => playHtApiKey != 'YOUR_PLAYHT_API_KEY' && playHtUserId != 'YOUR_PLAYHT_USER_ID';
  
  static void validateConfiguration() {
    if (!isOpenAiConfigured) {
      throw Exception('OpenAI API key not configured in ApiConfig');
    }
    if (!isPlayHtConfigured) {
      throw Exception('PlayHT API key not configured in ApiConfig');
    }
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
