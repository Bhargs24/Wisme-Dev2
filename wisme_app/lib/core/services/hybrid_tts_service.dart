/// Hybrid TTS Service
/// Combines multiple TTS providers for optimal performance and reliability
library;

import '../config/api_config.dart';
import '../audio/audio_models.dart';
import 'elevenlabs_service.dart';

/// Service that intelligently routes TTS requests between providers
class HybridTTSService {
  static ElevenLabsService? _elevenLabsService;
  
  /// Service statistics
  static final TTSServiceStats _serviceStats = const TTSServiceStats(
    totalRequests: 0,
    cacheHits: 0,
    cacheMisses: 0,
    cacheHitRate: 0.0,
    totalCostSaved: 0.0,
    estimatedMonthlySavings: 0.0,
  );

  /// Initialize the hybrid service
  static Future<void> initialize() async {
    if (ApiConfig.isElevenlabsConfigured) {
      _elevenLabsService = ElevenLabsService();
    }
  }

  /// Generate TTS audio using the best available provider
  static Future<Map<String, dynamic>> generateAudio({
    required String text,
    required String voiceId,
  }) async {

    try {
      // Determine best provider based on availability and requirements
      final provider = _selectBestProvider(text);
      
      switch (provider) {
        case 'elevenlabs':
          return await _generateWithElevenLabs(text, voiceId);
        default:
          throw Exception('No TTS provider available');
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Generate conversation audio for multiple exchanges
  static Future<Map<String, dynamic>> generateConversationAudio({
    required List<Map<String, dynamic>> exchanges,
    required Map<String, String> speakerVoiceMap,
    double speed = 1.0,
  }) async {
    try {
      final results = <Map<String, dynamic>>[];
      
      for (final exchange in exchanges) {
        final text = exchange['text'] as String;
        final speakerId = exchange['speakerId'] as String;
        final voiceId = speakerVoiceMap[speakerId] ?? speakerVoiceMap.values.first;
        
        final result = await generateAudio(
          text: text,
          voiceId: voiceId,
        );
        
        results.add({
          'exchangeId': exchange['id'],
          'speakerId': speakerId,
          'result': result,
        });
      }
      
      return {
        'success': true,
        'segments': results,
        'totalSegments': results.length,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Select the best provider based on criteria
  static String _selectBestProvider(String text) {
    // ElevenLabs for short, high-quality content
    if (ApiConfig.isElevenlabsConfigured) {
      return 'elevenlabs';
    }
    
    // Fallback to available provider
    if (ApiConfig.isElevenlabsConfigured) return 'elevenlabs';
    
    throw Exception('No TTS provider configured');
  }

  /// Generate audio using ElevenLabs
  static Future<Map<String, dynamic>> _generateWithElevenLabs(
    String text,
    String voiceId,
  ) async {
    if (_elevenLabsService == null) {
      throw Exception('ElevenLabs service not initialized');
    }
    
    final audioBytes = await _elevenLabsService!.generateSpeech(
      text: text,
      voiceId: voiceId,
    );
    
    if (audioBytes != null) {
      return {
        'success': true,
        'audioBytes': audioBytes,
        'provider': 'elevenlabs',
      };
    } else {
      return {
        'success': false,
        'error': 'ElevenLabs generation failed',
      };
    }
  }

  /// Get service statistics
  static TTSServiceStats getStats() => _serviceStats;

  /// Check if service is properly configured
  static bool get isConfigured => 
      ApiConfig.isElevenlabsConfigured;

  /// Get available providers
  static List<String> get availableProviders {
    final providers = <String>[];
    if (ApiConfig.isElevenlabsConfigured) providers.add('elevenlabs');
    return providers;
  }
}
