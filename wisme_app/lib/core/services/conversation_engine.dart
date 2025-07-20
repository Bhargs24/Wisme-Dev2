/// Conversation Engine
/// Generates conversational content for the NEW_AUDIO_ARCHITECTURE system
library;

import 'dart:math';
import '../../models/conversation_models.dart';
import '../services/hybrid_tts_service.dart';

/// Service for generating dynamic conversations between speakers
class ConversationEngine {
  static const String _version = '1.0.0';
  static bool _initialized = false;

  // Available speaker voices for conversations
  static final Map<String, SpeakerVoice> availableVoices = {
    'kai': SpeakerVoice(
      id: 'kai',
      name: 'Kai',
      role: SpeakerRole.narrator,
      voiceId: 'pNInz6obpgDQGcFmaJgB', // Adam from ElevenLabs
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'friendly',
        accent: 'neutral',
      ),
    ),
    'alex': SpeakerVoice(
      id: 'alex',
      name: 'Alex',
      role: SpeakerRole.expert,
      voiceId: '21m00Tcm4TlvDq8ikWAM', // Rachel from ElevenLabs
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'professional',
        accent: 'neutral',
      ),
    ),
    'maya': SpeakerVoice(
      id: 'maya',
      name: 'Maya',
      role: SpeakerRole.interviewer,
      voiceId: 'AZnzlk1XvdvUeBnXmlld', // Domi from ElevenLabs
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'curious',
        accent: 'neutral',
      ),
    ),
    'david': SpeakerVoice(
      id: 'david',
      name: 'David',
      role: SpeakerRole.interviewee,
      voiceId: 'EXAVITQu4vr4xnSDxMaL', // Bella from ElevenLabs
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'thoughtful',
        accent: 'neutral',
      ),
    ),
    'sara': SpeakerVoice(
      id: 'sara',
      name: 'Sara',
      role: SpeakerRole.primary,
      voiceId: 'ErXwobaYiN019PkySvjV', // Antoni from ElevenLabs
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'engaging',
        accent: 'neutral',
      ),
    ),
    'zoe': SpeakerVoice(
      id: 'zoe',
      name: 'Zoe',
      role: SpeakerRole.secondary,
      voiceId: 'MF3mGyEYCl7XYWbV9V6O', // Elli from ElevenLabs
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'supportive',
        accent: 'neutral',
      ),
    ),
  };

  /// Initialize the conversation engine
  static Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      // Ensure HybridTTSService is available
      if (!HybridTTSService.isConfigured) {
        await HybridTTSService.initialize();
      }

      _initialized = true;
      return true;
    } catch (e) {
      print('Failed to initialize ConversationEngine: $e');
      return false;
    }
  }

  /// Generate a conversation based on topic and format
  static Future<GeneratedConversation> generateConversation({
    required String topic,
    required String category,
    ConversationFormat format = ConversationFormat.dialogue,
    Duration targetDuration = const Duration(minutes: 5),
    List<String>? preferredSpeakerIds,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    // Select speakers based on format and preferences
    final speakers = _selectSpeakersForFormat(format, preferredSpeakerIds);
    
    // Generate conversation exchanges
    final exchanges = _generateExchanges(
      topic: topic,
      category: category,
      format: format,
      speakers: speakers,
      targetDuration: targetDuration,
    );

    final conversationId = _generateId();
    final title = _generateTitle(topic, format);

    return GeneratedConversation(
      id: conversationId,
      title: title,
      format: format,
      exchanges: exchanges,
      speakers: speakers,
      estimatedDuration: _calculateTotalDuration(exchanges),
      createdAt: DateTime.now(),
      metadata: {
        'topic': topic,
        'category': category,
        'version': _version,
        'generated_at': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Select appropriate speakers for the conversation format
  static List<SpeakerVoice> _selectSpeakersForFormat(
    ConversationFormat format,
    List<String>? preferredIds,
  ) {
    switch (format) {
      case ConversationFormat.interview:
        return [
          availableVoices['maya']!, // Interviewer
          availableVoices['david']!, // Interviewee
        ];
      case ConversationFormat.dialogue:
        return [
          availableVoices['sara']!, // Primary
          availableVoices['zoe']!, // Secondary
        ];
      case ConversationFormat.debate:
        return [
          availableVoices['alex']!, // Expert 1
          availableVoices['david']!, // Expert 2
          availableVoices['maya']!, // Moderator
        ];
      case ConversationFormat.narrative:
        return [
          availableVoices['kai']!, // Narrator
        ];
      case ConversationFormat.educational:
        return [
          availableVoices['alex']!, // Teacher/Expert
          availableVoices['maya']!, // Student/Questioner
        ];
      case ConversationFormat.documentary:
        return [
          availableVoices['kai']!, // Narrator
          availableVoices['alex']!, // Expert
        ];
    }
  }

  /// Generate conversation exchanges based on format and content
  static List<ConversationExchange> _generateExchanges({
    required String topic,
    required String category,
    required ConversationFormat format,
    required List<SpeakerVoice> speakers,
    required Duration targetDuration,
  }) {
    final exchanges = <ConversationExchange>[];
    final random = Random();
    var currentTime = Duration.zero;

    // Introduction
    exchanges.add(ConversationExchange(
      id: _generateId(),
      speakerId: speakers[0].id,
      text: _generateIntroText(topic, format),
      timestamp: currentTime,
      speakerRole: speakers[0].role,
      type: ExchangeType.introduction,
      estimatedDuration: Duration(seconds: 10 + random.nextInt(10)),
    ));

    currentTime += exchanges.last.estimatedDuration ?? Duration(seconds: 15);

    // Main content exchanges
    final mainExchangeCount = _calculateMainExchangeCount(format, targetDuration);
    
    for (int i = 0; i < mainExchangeCount; i++) {
      final speaker = speakers[i % speakers.length];
      final duration = Duration(seconds: 15 + random.nextInt(20));
      
      exchanges.add(ConversationExchange(
        id: _generateId(),
        speakerId: speaker.id,
        text: _generateMainContentText(topic, category, i, format),
        timestamp: currentTime,
        speakerRole: speaker.role,
        type: ExchangeType.mainContent,
        estimatedDuration: duration,
      ));

      currentTime += duration;

      // Add transitions occasionally
      if (i > 0 && i % 3 == 0) {
        final transitionSpeaker = speakers[(i + 1) % speakers.length];
        exchanges.add(ConversationExchange(
          id: _generateId(),
          speakerId: transitionSpeaker.id,
          text: _generateTransitionText(),
          timestamp: currentTime,
          speakerRole: transitionSpeaker.role,
          type: ExchangeType.transition,
          estimatedDuration: Duration(seconds: 5),
        ));
        currentTime += Duration(seconds: 5);
      }
    }

    // Summary
    exchanges.add(ConversationExchange(
      id: _generateId(),
      speakerId: speakers[0].id,
      text: _generateSummaryText(topic),
      timestamp: currentTime,
      speakerRole: speakers[0].role,
      type: ExchangeType.summary,
      estimatedDuration: Duration(seconds: 20),
    ));

    currentTime += Duration(seconds: 20);

    // Conclusion
    exchanges.add(ConversationExchange(
      id: _generateId(),
      speakerId: speakers[0].id,
      text: _generateConclusionText(),
      timestamp: currentTime,
      speakerRole: speakers[0].role,
      type: ExchangeType.conclusion,
      estimatedDuration: Duration(seconds: 10),
    ));

    return exchanges;
  }

  // Helper methods for text generation
  static String _generateIntroText(String topic, ConversationFormat format) {
    switch (format) {
      case ConversationFormat.interview:
        return "Welcome to today's interview where we'll be exploring $topic. I'm excited to dive deep into this fascinating subject.";
      case ConversationFormat.dialogue:
        return "Today we're having a conversation about $topic. Let's explore this topic together.";
      case ConversationFormat.educational:
        return "In today's lesson, we'll be learning about $topic. Let's start with the fundamentals.";
      default:
        return "Welcome! Today we're discussing $topic.";
    }
  }

  static String _generateMainContentText(String topic, String category, int index, ConversationFormat format) {
    final contentVariations = [
      "Let's explore how $topic impacts our daily lives.",
      "One interesting aspect of $topic is its applications in $category.",
      "When we consider $topic, it's important to understand the broader context.",
      "Research shows that $topic has significant implications for the future.",
      "Many experts believe that $topic will continue to evolve rapidly.",
    ];
    return contentVariations[index % contentVariations.length];
  }

  static String _generateTransitionText() {
    final transitions = [
      "That's a great point. Let's explore this further.",
      "Building on that idea...",
      "This brings us to another important consideration.",
      "Let's shift our focus to...",
      "That connects well to our next topic.",
    ];
    return transitions[Random().nextInt(transitions.length)];
  }

  static String _generateSummaryText(String topic) {
    return "To summarize our discussion about $topic, we've covered several key points that highlight its importance and potential impact.";
  }

  static String _generateConclusionText() {
    return "Thank you for joining this conversation. We hope you found these insights valuable and thought-provoking.";
  }

  // Utility methods
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(9999).toString().padLeft(4, '0');
  }

  static String _generateTitle(String topic, ConversationFormat format) {
    final formatName = format.name.capitalize();
    return "$formatName: $topic";
  }

  static int _calculateMainExchangeCount(ConversationFormat format, Duration targetDuration) {
    final baseCount = (targetDuration.inMinutes * 2).clamp(4, 20);
    return baseCount;
  }

  static Duration _calculateTotalDuration(List<ConversationExchange> exchanges) {
    return exchanges.fold(Duration.zero, (total, exchange) {
      return total + (exchange.estimatedDuration ?? Duration(seconds: 15));
    });
  }

  /// Check if the engine is properly configured
  static bool get isConfigured => _initialized && HybridTTSService.isConfigured;

  /// Get engine status information
  static Map<String, dynamic> get status => {
    'initialized': _initialized,
    'version': _version,
    'available_voices': availableVoices.length,
    'tts_configured': HybridTTSService.isConfigured,
  };
}

/// Extension to capitalize strings
extension StringCapitalization on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
