/// Test ElevenLabs Integration
/// Quick test to verify the real API integration works
library;
import '../core/services/elevenlabs_service.dart';
import '../core/config/api_config.dart';

class ElevenLabsTest {
  /// Test basic ElevenLabs API integration
  static Future<void> testBasicIntegration() async {
    print('🧪 Testing ElevenLabs API Integration...');
    
    // Check configuration
    if (!ApiConfig.isElevenlabsConfigured) {
      print('❌ ElevenLabs API not configured. Please set ELEVENLABS_API_KEY in .env file');
      return;
    }
    
    print('✅ API key configured');
    
    try {
      // Test 1: Get available voices
      print('📋 Fetching available voices...');
      final voices = await ElevenLabsService.getVoices();
      print('✅ Found ${voices.length} voices');
      
      if (voices.isNotEmpty) {
        final firstVoice = voices.first;
        print('   Sample voice: ${firstVoice['name']} (${firstVoice['voice_id']})');
      }
      
      // Test 2: Generate simple speech
      print('🎤 Testing speech generation...');
      final testText = "Hello, this is a test of the WISME audio system.";
      final voiceId = "pNInz6obpgDQGcFmaJgB"; // Adam voice
      
      final result = await ElevenLabsService.generateSpeech(
        text: testText,
        voiceId: voiceId,
      );
      
      if (result['success'] == true) {
        final audioBytes = result['audioBytes'];
        print('✅ Speech generated successfully!');
        print('   Audio size: ${audioBytes.length} bytes');
        print('   Content type: ${result['contentType']}');
      } else {
        print('❌ Speech generation failed: ${result['error']}');
      }
      
      // Test 3: Check usage/quota
      print('📊 Checking API usage...');
      final usage = await ElevenLabsService.getUsage();
      print('✅ Usage data retrieved');
      print('   Available characters: ${usage['subscription']?['character_limit'] ?? 'Unknown'}');
      
    } catch (e) {
      print('❌ Test failed with error: $e');
    }
    
    print('🏁 ElevenLabs integration test completed');
  }

  /// Test voice quality with different settings
  static Future<void> testVoiceQuality() async {
    print('🎵 Testing voice quality settings...');
    
    if (!ApiConfig.isElevenlabsConfigured) {
      print('❌ API not configured');
      return;
    }
    
    final testText = "The quick brown fox jumps over the lazy dog. This sentence contains various phonetic sounds for testing voice quality.";
    final voiceId = "pNInz6obpgDQGcFmaJgB"; // Adam voice
    
    final testSettings = [
      {'stability': 0.3, 'similarity_boost': 0.7}, // More variable
      {'stability': 0.7, 'similarity_boost': 0.7}, // More stable
      {'stability': 0.5, 'similarity_boost': 0.5}, // Balanced (default)
    ];
    
    for (int i = 0; i < testSettings.length; i++) {
      print('Testing setting ${i + 1}/${testSettings.length}...');
      
      try {
        final result = await ElevenLabsService.generateSpeech(
          text: testText,
          voiceId: voiceId,
          voiceSettings: testSettings[i],
        );
        
        if (result['success'] == true) {
          print('✅ Setting ${i + 1}: ${result['audioBytes'].length} bytes generated');
        } else {
          print('❌ Setting ${i + 1}: Failed - ${result['error']}');
        }
      } catch (e) {
        print('❌ Setting ${i + 1}: Error - $e');
      }
    }
    
    print('🏁 Voice quality test completed');
  }

  /// Test conversation generation (multiple speakers)
  static Future<void> testConversationGeneration() async {
    print('💬 Testing conversation generation...');
    
    if (!ApiConfig.isElevenlabsConfigured) {
      print('❌ API not configured');
      return;
    }
    
    final conversationSegments = [
      {'speaker': 'Host', 'voiceId': '21m00Tcm4TlvDq8ikWAM', 'text': 'Welcome to today\'s episode about artificial intelligence!'},
      {'speaker': 'Expert', 'voiceId': 'pNInz6obpgDQGcFmaJgB', 'text': 'Thank you for having me. AI is a fascinating topic with many practical applications.'},
      {'speaker': 'Host', 'voiceId': '21m00Tcm4TlvDq8ikWAM', 'text': 'Can you explain how machine learning works in simple terms?'},
      {'speaker': 'Expert', 'voiceId': 'pNInz6obpgDQGcFmaJgB', 'text': 'Absolutely! Machine learning is like teaching a computer to recognize patterns, similar to how humans learn from experience.'},
    ];
    
    print('Generating ${conversationSegments.length} conversation segments...');
    
    for (int i = 0; i < conversationSegments.length; i++) {
      final segment = conversationSegments[i];
      print('   Generating segment ${i + 1}: ${segment['speaker']}');
      
      try {
        final result = await ElevenLabsService.generateSpeech(
          text: segment['text'] as String,
          voiceId: segment['voiceId'] as String,
        );
        
        if (result['success'] == true) {
          print('   ✅ Generated ${result['audioBytes'].length} bytes');
        } else {
          print('   ❌ Failed: ${result['error']}');
        }
      } catch (e) {
        print('   ❌ Error: $e');
      }
    }
    
    print('🏁 Conversation generation test completed');
  }
}
