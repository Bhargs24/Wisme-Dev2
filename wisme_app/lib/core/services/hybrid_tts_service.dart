/// Hybrid TTS Service
/// Combines multiple TTS providers for optimal performance and reliability
library;

import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../audio/audio_models.dart';
import 'elevenlabs_service.dart';
import 'playht_service.dart';

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
    AudioQuality quality = AudioQuality.medium,
    double speed = 1.0,
  }) async {
    try {
      // Determine best provider based on availability and requirements
      final provider = _selectBestProvider(text, quality);
      
      switch (provider) {
        case 'playht':
          return await _generateWithPlayHT(text, voiceId, quality, speed);
        case 'elevenlabs':
          return await _generateWithElevenLabs(text, voiceId, quality);
        default:
          throw Exception('No TTS provider available');
      }
    } catch (e) {
      debugPrint('Hybrid TTS Error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Select the best provider based on criteria
  static String _selectBestProvider(String text, AudioQuality quality) {
    // PlayHT for longer content and conversational style
    if (text.length > 500 && ApiConfig.isPlayHtConfigured) {
      return 'playht';
    }
    
    // ElevenLabs for short, high-quality content
    if (quality == AudioQuality.premium && ApiConfig.isElevenlabsConfigured) {
      return 'elevenlabs';
    }
    
    // Fallback to available provider
    if (ApiConfig.isPlayHtConfigured) return 'playht';
    if (ApiConfig.isElevenlabsConfigured) return 'elevenlabs';
    
    throw Exception('No TTS provider configured');
  }

  /// Generate audio using PlayHT
  static Future<Map<String, dynamic>> _generateWithPlayHT(
    String text,
    String voiceId,
    AudioQuality quality,
    double speed,
  ) async {
    return await PlayHTService.generateAudio(
      text: text,
      voiceId: voiceId,
      speed: speed,
    );
  }

  /// Generate audio using ElevenLabs
  static Future<Map<String, dynamic>> _generateWithElevenLabs(
    String text,
    String voiceId,
    AudioQuality quality,
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
        'quality': quality.name,
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
      ApiConfig.isPlayHtConfigured || ApiConfig.isElevenlabsConfigured;

  /// Get available providers
  static List<String> get availableProviders {
    final providers = <String>[];
    if (ApiConfig.isPlayHtConfigured) providers.add('playht');
    if (ApiConfig.isElevenlabsConfigured) providers.add('elevenlabs');
    return providers;
  }

  /// Generate conversation audio with multiple speakers
  static Future<Map<String, dynamic>> generateConversationAudio({
    required List<Map<String, dynamic>> exchanges,
    required Map<String, String> speakerVoiceMap,
    double speed = 1.0,
  }) async {
    try {
      final audioSegments = <Map<String, dynamic>>[];
      
      for (int i = 0; i < exchanges.length; i++) {
        final exchange = exchanges[i];
        final speakerId = exchange['speakerId'] as String?;
        final text = exchange['text'] as String?;
        
        if (speakerId == null || text == null) {
          debugPrint('Warning: Skipping exchange $i due to missing speakerId or text');
          continue;
        }
        
        final voiceId = speakerVoiceMap[speakerId];
        if (voiceId == null) {
          debugPrint('Warning: No voice mapping found for speaker: $speakerId');
          continue;
        }
        
        // Generate audio for this exchange
        final audioResult = await generateAudio(
          text: text,
          voiceId: voiceId,
          speed: speed,
        );
        
        if (audioResult['success'] == true) {
          audioSegments.add({
            'id': 'segment_$i',
            'exchangeId': exchange['id'] ?? 'exchange_$i',
            'speakerId': speakerId,
            'audioData': audioResult['audioBytes'],
            'audioPath': audioResult['audioPath'],
            'duration': _estimateAudioDuration(text).inMilliseconds,
            'format': 'mp3',
            'metadata': {
              'provider': audioResult['provider'],
              'quality': audioResult['quality'],
            },
          });
        } else {
          debugPrint('Failed to generate audio for exchange $i: ${audioResult['error']}');
        }
      }
      
      return {
        'success': true,
        'segments': audioSegments,
        'totalSegments': audioSegments.length,
        'totalDuration': audioSegments.fold<int>(
          0, 
          (sum, segment) => sum + (segment['duration'] as int? ?? 0),
        ),
      };
    } catch (e) {
      debugPrint('Conversation audio generation error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Estimate audio duration based on text length
  static Duration _estimateAudioDuration(String text) {
    // Rough estimation: ~150 words per minute, ~5 characters per word
    final estimatedWords = text.length / 5;
    final estimatedMinutes = estimatedWords / 150;
    return Duration(milliseconds: (estimatedMinutes * 60 * 1000).round());
  }
}
