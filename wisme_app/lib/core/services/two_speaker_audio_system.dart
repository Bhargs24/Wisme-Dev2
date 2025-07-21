/// Two-Speaker Audio System
/// Manages conversational audio with multiple speakers and voices
library;

import '../audio/audio_models.dart';
import '../services/hybrid_tts_service.dart';

/// Voice configuration for two-speaker conversations
class VoiceConfiguration {
  final String speakerId;
  final String voiceId;
  final Map<String, dynamic> settings;

  const VoiceConfiguration({
    required this.speakerId,
    required this.voiceId,
    this.settings = const {},
  });
}

/// Audio exchange between speakers
class ConversationAudioData {
  final String speakerId;
  final String text;
  final Duration timestamp;
  final Map<String, dynamic> metadata;

  const ConversationAudioData({
    required this.speakerId,
    required this.text,
    required this.timestamp,
    this.metadata = const {},
  });
}

/// Two-speaker audio system for conversational content
class TwoSpeakerAudioSystem {
  static const Map<String, VoiceConfiguration> _defaultVoices = {
    'Kai': VoiceConfiguration(
      speakerId: 'kai',
      voiceId: 'kai_voice_id',
    ),
    'Alex': VoiceConfiguration(
      speakerId: 'alex',
      voiceId: 'alex_voice_id', 
    ),
    'Maya': VoiceConfiguration(
      speakerId: 'maya',
      voiceId: 'maya_voice_id',
    ),
    'David': VoiceConfiguration(
      speakerId: 'david',
      voiceId: 'david_voice_id',
    ),
    'Sara': VoiceConfiguration(
      speakerId: 'sara', 
      voiceId: 'sara_voice_id',
    ),
    'Zoe': VoiceConfiguration(
      speakerId: 'zoe',
      voiceId: 'zoe_voice_id',
    ),
  };

  /// Generate conversational audio between two speakers
  static Future<List<ConversationAudioData>> generateConversation({
    required List<Map<String, dynamic>> exchanges,
    required String primarySpeaker,
    required String secondarySpeaker,
  }) async {
    final conversationData = <ConversationAudioData>[];
    
    for (int i = 0; i < exchanges.length; i++) {
      final exchange = exchanges[i];
      final speaker = i % 2 == 0 ? primarySpeaker : secondarySpeaker;
      final voiceConfig = _defaultVoices[speaker];
      
      if (voiceConfig != null) {
        final audioResult = await HybridTTSService.generateAudio(
          text: exchange['text'] ?? '',
          voiceId: voiceConfig.voiceId,
        );
        
        if (audioResult['success'] == true) {
          conversationData.add(ConversationAudioData(
            speakerId: speaker,
            text: exchange['text'] ?? '',
            timestamp: Duration(seconds: i * 10), // Simple timing
            metadata: {
              'audioPath': audioResult['audioPath'],
              'duration': audioResult['duration'],
            },
          ));
        }
      }
    }
    
    return conversationData;
  }

  /// Get available voice configurations
  static Map<String, VoiceConfiguration> get availableVoices => _defaultVoices;

  /// Check if system is properly configured
  static bool get isConfigured => HybridTTSService.isConfigured;

  /// Get voice mapping for category
  static List<String> getVoicesForCategory(String category) {
    // NEW_AUDIO_ARCHITECTURE Phase 1 voice mapping
    switch (category.toLowerCase()) {
      case 'mindfulness':
      case 'meditation':
        return ['Kai', 'Maya'];
      case 'productivity':
      case 'business':
        return ['Alex', 'David'];  
      case 'creativity':
      case 'arts':
        return ['Sara', 'Zoe'];
      case 'health':
      case 'fitness':
        return ['Alex', 'Maya'];
      case 'relationships':
      case 'communication':
        return ['Maya', 'Sara'];
      case 'technology':
      case 'science':
        return ['David', 'Alex'];
      case 'learning':
      case 'education':
        return ['Kai', 'Sara'];
      default:
        return ['Kai', 'Alex']; // Default voices
    }
  }
}
