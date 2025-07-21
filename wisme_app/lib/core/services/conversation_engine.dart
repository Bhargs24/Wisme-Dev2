/// Conversation Engine
/// Generates conversational content for the NEW_AUDIO_ARCHITECTURE system
/// 
/// PHASE 1: ElevenLabs with predetermined voice pairs
/// PHASE 2: Custom StyleTTS 2 models (placeholder for future implementation)
library;

import 'dart:math';
import '../../models/conversation_models.dart';
import '../services/hybrid_tts_service.dart';
import 'smart_fragment_cache.dart';

/// Service for generating dynamic conversations between speakers
class ConversationEngine {
  static const String _version = '1.0.0';
  static bool _initialized = false;

  // PHASE 1: ElevenLabs Voice Configuration
  // 6 predetermined voices covering all 15 content categories
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
      voiceId: 'EXAVitQu4vr4xnSDxMaL', // Bella from ElevenLabs
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

  // PHASE 2: StyleTTS 2 Placeholder Configuration
  // This will be implemented when custom voice models are ready
  static final Map<String, SpeakerVoice> phase2Voices = {
    // Placeholder for Phase 2 custom voices
    // These will be replaced with actual StyleTTS 2 model references
    'professor': SpeakerVoice(
      id: 'professor',
      name: 'The Professor',
      role: SpeakerRole.expert,
      voiceId: 'styletts2_professor_model', // Placeholder for StyleTTS 2 model
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'authoritative',
        accent: 'neutral',
      ),
    ),
    'mentor': SpeakerVoice(
      id: 'mentor',
      name: 'The Mentor',
      role: SpeakerRole.expert,
      voiceId: 'styletts2_mentor_model', // Placeholder for StyleTTS 2 model
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'warm',
        accent: 'neutral',
      ),
    ),
    'curious_host': SpeakerVoice(
      id: 'curious_host',
      name: 'The Curious Host',
      role: SpeakerRole.interviewer,
      voiceId: 'styletts2_curious_host_model', // Placeholder for StyleTTS 2 model
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'energetic',
        accent: 'neutral',
      ),
    ),
    'thoughtful_analyst': SpeakerVoice(
      id: 'thoughtful_analyst',
      name: 'The Thoughtful Analyst',
      role: SpeakerRole.expert,
      voiceId: 'styletts2_thoughtful_analyst_model', // Placeholder for StyleTTS 2 model
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'analytical',
        accent: 'neutral',
      ),
    ),
    'innovator': SpeakerVoice(
      id: 'innovator',
      name: 'The Innovator',
      role: SpeakerRole.expert,
      voiceId: 'styletts2_innovator_model', // Placeholder for StyleTTS 2 model
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'dynamic',
        accent: 'neutral',
      ),
    ),
    'storyteller': SpeakerVoice(
      id: 'storyteller',
      name: 'The Storyteller',
      role: SpeakerRole.narrator,
      voiceId: 'styletts2_storyteller_model', // Placeholder for StyleTTS 2 model
      characteristics: VoiceCharacteristics(
        pitch: 'medium',
        speed: 'normal',
        tone: 'expressive',
        accent: 'neutral',
      ),
    ),
  };

  // Voice personality and category mappings for Phase 1
  static const Map<String, String> voicePersonalities = {
    'kai': 'versatile_host',
    'alex': 'authoritative_expert',
    'maya': 'energetic_host',
    'david': 'strategic_expert',
    'sara': 'empathetic_expert',
    'zoe': 'creative_host',
  };

  static const Map<String, List<String>> voiceCategories = {
    'kai': ['technology', 'psychology', 'selfGrowth', 'law', 'mathematics', 'society'],
    'alex': ['technology', 'science', 'history', 'geopolitics', 'environment', 'mathematics'],
    'maya': ['business', 'science', 'skills', 'career', 'environment'],
    'david': ['business', 'selfGrowth', 'skills', 'career', 'law'],
    'sara': ['psychology', 'creativity', 'gaming', 'society'],
    'zoe': ['creativity', 'history', 'geopolitics', 'gaming'],
  };

  /// Get available voices based on current phase
  static Map<String, SpeakerVoice> getAvailableVoices({bool includePhase2 = false}) {
    final voices = Map<String, SpeakerVoice>.from(availableVoices);
    
    if (includePhase2) {
      voices.addAll(phase2Voices);
    }
    
    return voices;
  }

  /// Get voices for a specific category
  static List<SpeakerVoice> getVoicesForCategory(String category) {
    final categoryVoices = <SpeakerVoice>[];
    
    // Add Phase 1 voices for this category
    for (final entry in availableVoices.entries) {
      final voiceId = entry.key;
      final voice = entry.value;
      if (voiceCategories[voiceId]?.contains(category) == true) {
        categoryVoices.add(voice);
      }
    }
    
    // Add Phase 2 voices for this category (if enabled)
    for (final voice in phase2Voices.values) {
      // Phase 2 voices would have their own category mapping
      // For now, we'll add them based on their role
      if (voice.role == SpeakerRole.expert || voice.role == SpeakerRole.interviewer) {
        categoryVoices.add(voice);
      }
    }
    
    return categoryVoices;
  }

  /// Get conversation pair for a category
  static ConversationPair getConversationPairForCategory(String category) {
    // Phase 1: Use predetermined pairs
    switch (category) {
      case 'technology':
        return ConversationPair(
          host: availableVoices['kai']!,
          expert: availableVoices['alex']!,
        );
      case 'business':
        return ConversationPair(
          host: availableVoices['maya']!,
          expert: availableVoices['david']!,
        );
      case 'psychology':
        return ConversationPair(
          host: availableVoices['kai']!,
          expert: availableVoices['sara']!,
        );
      case 'science':
        return ConversationPair(
          host: availableVoices['maya']!,
          expert: availableVoices['alex']!,
        );
      case 'creativity':
        return ConversationPair(
          host: availableVoices['zoe']!,
          expert: availableVoices['sara']!,
        );
      case 'selfGrowth':
        return ConversationPair(
          host: availableVoices['kai']!,
          expert: availableVoices['david']!,
        );
      case 'history':
        return ConversationPair(
          host: availableVoices['zoe']!,
          expert: availableVoices['alex']!,
        );
      case 'skills':
        return ConversationPair(
          host: availableVoices['maya']!,
          expert: availableVoices['david']!,
        );
      case 'career':
        return ConversationPair(
          host: availableVoices['maya']!,
          expert: availableVoices['david']!,
        );
      case 'law':
        return ConversationPair(
          host: availableVoices['kai']!,
          expert: availableVoices['david']!,
        );
      case 'geopolitics':
        return ConversationPair(
          host: availableVoices['zoe']!,
          expert: availableVoices['alex']!,
        );
      case 'environment':
        return ConversationPair(
          host: availableVoices['maya']!,
          expert: availableVoices['alex']!,
        );
      case 'mathematics':
        return ConversationPair(
          host: availableVoices['kai']!,
          expert: availableVoices['alex']!,
        );
      case 'gaming':
        return ConversationPair(
          host: availableVoices['zoe']!,
          expert: availableVoices['sara']!,
        );
      case 'society':
        return ConversationPair(
          host: availableVoices['kai']!,
          expert: availableVoices['sara']!,
        );
      default:
        // Fallback to default pair
        return ConversationPair(
          host: availableVoices['kai']!,
          expert: availableVoices['alex']!,
        );
    }
  }

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

    // Get conversation pair for the category
    final conversationPair = getConversationPairForCategory(category);
    
    // Generate conversation exchanges
    final exchanges = _generateExchanges(
      topic: topic,
      category: category,
      format: format,
      speakers: [conversationPair.host, conversationPair.expert],
      targetDuration: targetDuration,
    );

    return GeneratedConversation(
      id: _generateConversationId(),
      title: 'Conversation about $topic',
      format: format,
      speakers: [conversationPair.host, conversationPair.expert],
      exchanges: exchanges,
      estimatedDuration: targetDuration,
      createdAt: DateTime.now(),
    );
  }

  /// Generate conversation exchanges with dynamic fragment reuse
  static List<ConversationExchange> _generateExchanges({
    required String topic,
    required String category,
    required ConversationFormat format,
    required List<SpeakerVoice> speakers,
    required Duration targetDuration,
  }) {
    final exchanges = <ConversationExchange>[];
    final estimatedExchanges = (targetDuration.inMinutes * 2).clamp(3, 10);
    final tags = [topic.toLowerCase(), category.toLowerCase()];
    // Optionally, generate a semantic embedding for the topic (pseudo-code)
    List<double>? topicEmbedding; // = getEmbedding(topic);

    for (int i = 0; i < estimatedExchanges; i++) {
      final speaker = speakers[i % speakers.length];
      final isHost = speaker.role == SpeakerRole.narrator || 
                     speaker.role == SpeakerRole.interviewer;
      final text = _generateExchangeText(
        topic: topic,
        category: category,
        speaker: speaker,
        isHost: isHost,
        exchangeIndex: i,
      );
      // 1. Try exact match in cache
      CachedAudioFragment? fragment;
      try {
        fragment = SmartFragmentCache.allFragments.firstWhere(
          (f) => f.text == text && f.voiceId == speaker.voiceId,
        );
      } catch (_) {
        fragment = null;
      }
      // 2. Try tag-based match
      if (fragment == null) {
        final tagMatches = SmartFragmentCache.findByTag(category.toLowerCase(), speaker.voiceId);
        if (tagMatches.isNotEmpty) fragment = tagMatches.first;
      }
      // 3. Try semantic similarity (if embedding available)
      if (fragment == null && topicEmbedding != null) {
        fragment = SmartFragmentCache.findBySemantic(topicEmbedding, speaker.voiceId);
      }
      // 4. If not found, generate new audio and cache it
      if (fragment == null) {
        // Pseudo: generate audio and cache
        // final audioPath = await TTSService.generateAudio(text: text, voiceId: speaker.voiceId);
        // SmartFragmentCache.storeFragment(
        //   text: text,
        //   voiceId: speaker.voiceId,
        //   audioFilePath: audioPath,
        //   duration: Duration(seconds: (text.length / 15).round()),
        //   tags: tags,
        //   embedding: topicEmbedding,
        //   metadata: {'category': category, 'exchangeIndex': i},
        // );
      }
      exchanges.add(ConversationExchange(
        id: 'exchange_$i',
        speakerId: speaker.id,
        text: text,
        timestamp: Duration(seconds: i * 30),
        speakerRole: speaker.role,
        estimatedDuration: Duration(seconds: (text.length / 15).round()),
        metadata: {
          'category': category,
          'tags': tags,
          // 'audioPath': fragment?.filePath, // Uncomment when audio generation is integrated
        },
      ));
    }
    return exchanges;
  }

  /// Generate text for a conversation exchange
  static String _generateExchangeText({
    required String topic,
    required String category,
    required SpeakerVoice speaker,
    required bool isHost,
    required int exchangeIndex,
  }) {
    // This is a simplified text generation
    // In production, this would use AI to generate contextual dialogue
    
    final personality = voicePersonalities[speaker.id] ?? 'default';
    
    if (isHost) {
      switch (personality) {
        case 'versatile_host':
          return _generateHostText(topic, exchangeIndex);
        case 'energetic_host':
          return _generateEnergeticHostText(topic, exchangeIndex);
        case 'creative_host':
          return _generateCreativeHostText(topic, exchangeIndex);
        default:
          return _generateDefaultHostText(topic, exchangeIndex);
      }
    } else {
      switch (personality) {
        case 'authoritative_expert':
          return _generateAuthoritativeExpertText(topic, exchangeIndex);
        case 'strategic_expert':
          return _generateStrategicExpertText(topic, exchangeIndex);
        case 'empathetic_expert':
          return _generateEmpatheticExpertText(topic, exchangeIndex);
        default:
          return _generateDefaultExpertText(topic, exchangeIndex);
      }
    }
  }

  // Host text generation methods
  static String _generateHostText(String topic, int index) {
    final questions = [
      "That's fascinating! Can you tell us more about $topic?",
      "I'm curious about how $topic affects our daily lives.",
      "What would you say is the most important aspect of $topic?",
      "How has $topic evolved over time?",
      "What misconceptions do people have about $topic?",
    ];
    return questions[index % questions.length];
  }

  static String _generateEnergeticHostText(String topic, int index) {
    final questions = [
      "Wow! This is incredible stuff about $topic!",
      "I'm absolutely excited to learn more about $topic!",
      "This is mind-blowing! How does $topic work?",
      "I can't believe how important $topic is!",
      "This is revolutionary! Tell us everything about $topic!",
    ];
    return questions[index % questions.length];
  }

  static String _generateCreativeHostText(String topic, int index) {
    final questions = [
      "Imagine if we could see $topic in a whole new way...",
      "What if $topic was like a story? How would it unfold?",
      "I love how $topic connects to so many other things!",
      "There's something magical about $topic, isn't there?",
      "How does $topic inspire creativity in people?",
    ];
    return questions[index % questions.length];
  }

  static String _generateDefaultHostText(String topic, int index) {
    return "Tell us more about $topic.";
  }

  // Expert text generation methods
  static String _generateAuthoritativeExpertText(String topic, int index) {
    final responses = [
      "Absolutely. $topic is fundamentally about understanding the core principles.",
      "The key insight about $topic is that it operates on multiple levels.",
      "When we examine $topic closely, we see patterns that are universal.",
      "The research clearly shows that $topic has significant implications.",
      "What makes $topic so important is its foundational role in our understanding.",
    ];
    return responses[index % responses.length];
  }

  static String _generateStrategicExpertText(String topic, int index) {
    final responses = [
      "From a strategic perspective, $topic requires careful planning and execution.",
      "The long-term implications of $topic are what we need to focus on.",
      "When developing a strategy around $topic, we must consider multiple factors.",
      "The competitive advantage in $topic comes from understanding the fundamentals.",
      "Strategic thinking about $topic involves both analysis and intuition.",
    ];
    return responses[index % responses.length];
  }

  static String _generateEmpatheticExpertText(String topic, int index) {
    final responses = [
      "I understand how $topic can feel overwhelming at first.",
      "Many people find $topic challenging, and that's completely normal.",
      "The beauty of $topic is that it connects to our human experience.",
      "When we approach $topic with compassion, we see its true value.",
      "What I love about $topic is how it helps us understand ourselves better.",
    ];
    return responses[index % responses.length];
  }

  static String _generateDefaultExpertText(String topic, int index) {
    return "Let me explain $topic in detail.";
  }

  /// Generate a unique conversation ID
  static String _generateConversationId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    return 'conv_${timestamp}_$random';
  }

  /// Get conversation statistics
  static ConversationStats getStats() {
    return ConversationStats(
      totalConversations: 0, // This would be tracked in production
      averageDuration: const Duration(minutes: 5),
      mostPopularCategory: 'technology',
      totalExchanges: 0,
    );
  }
}

/// Conversation pair for two-speaker dialogues
class ConversationPair {
  final SpeakerVoice host;
  final SpeakerVoice expert;

  const ConversationPair({
    required this.host,
    required this.expert,
  });
}

/// Conversation statistics
class ConversationStats {
  final int totalConversations;
  final Duration averageDuration;
  final String mostPopularCategory;
  final int totalExchanges;

  const ConversationStats({
    required this.totalConversations,
    required this.averageDuration,
    required this.mostPopularCategory,
    required this.totalExchanges,
  });
}
