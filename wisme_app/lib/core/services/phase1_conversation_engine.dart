/// Phase 1 Conversation Engine
/// Handles AI-powered topic analysis and conversational learning journey generation
/// Uses ElevenLabs voices with predetermined pairs for each category

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../../models/phase1_models.dart';

class Phase1ConversationEngine {
  static const String _version = '1.0.0';
  static bool _initialized = false;

  /// Initialize the conversation engine
  static Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      _initialized = true;
      return true;
    } catch (e) {
      print('Failed to initialize Phase1ConversationEngine: $e');
      return false;
    }
  }

  /// Analyze topic and determine category
  static Future<Map<String, dynamic>> analyzeTopic(
    String topic, {
    String? personalContext,
  }) async {
    try {
      final response = await _makeOpenAICall(
        systemPrompt: _buildTopicAnalysisPrompt(),
        userPrompt: _buildTopicAnalysisUserPrompt(topic, personalContext),
      );

      return _parseTopicAnalysisResponse(response);
    } catch (e) {
      print('Topic analysis failed: $e');
      // Fallback to default analysis
      return {
        'category': 'Personal Development',
        'confidence': 0.7,
        'reasoning': 'Fallback analysis due to API error',
      };
    }
  }

  /// Generate complete learning journey with conversational episodes
  static Future<Map<String, dynamic>> generateLearningJourney({
    required String topic,
    required String category,
    required LearningType learningType,
    required int episodeCount,
    required int episodeDuration,
    String? personalContext,
  }) async {
    try {
      // Get voice pair for category
      final voicePair = Phase1VoiceMapping.getVoicePairForCategory(category);
      
      final response = await _makeOpenAICall(
        systemPrompt: _buildJourneyGenerationPrompt(voicePair),
        userPrompt: _buildJourneyGenerationUserPrompt(
          topic: topic,
          category: category,
          learningType: learningType,
          episodeCount: episodeCount,
          episodeDuration: episodeDuration,
          personalContext: personalContext,
        ),
      );

      return _parseJourneyGenerationResponse(response, voicePair);
    } catch (e) {
      print('Journey generation failed: $e');
      // Return fallback journey
      return _createFallbackJourney(
        topic: topic,
        category: category,
        learningType: learningType,
        episodeCount: episodeCount,
        episodeDuration: episodeDuration,
      );
    }
  }

  /// Generate conversational script for a single episode
  static Future<Map<String, dynamic>> generateConversationalScript({
    required String topic,
    required String episodeTitle,
    required String category,
    required VoicePair voicePair,
    required int targetDurationMinutes,
    required int episodeNumber,
    required int totalEpisodes,
    String? personalContext,
  }) async {
    try {
      final response = await _makeOpenAICall(
        systemPrompt: _buildConversationalScriptPrompt(voicePair),
        userPrompt: _buildConversationalScriptUserPrompt(
          topic: topic,
          episodeTitle: episodeTitle,
          category: category,
          targetDurationMinutes: targetDurationMinutes,
          episodeNumber: episodeNumber,
          totalEpisodes: totalEpisodes,
          personalContext: personalContext,
        ),
      );

      return _parseConversationalScriptResponse(response, voicePair);
    } catch (e) {
      print('Conversational script generation failed: $e');
      return _createFallbackScript(
        episodeTitle: episodeTitle,
        voicePair: voicePair,
      );
    }
  }

  // MARK: - Private Methods

  static Future<String> _makeOpenAICall({
    required String systemPrompt,
    required String userPrompt,
  }) async {
    final url = Uri.parse('${ApiConfig.openAiBaseUrl}');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ApiConfig.openAiApiKey}',
    };

    final body = json.encode({
      'model': ApiConfig.gptModel,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userPrompt},
      ],
      'temperature': 0.7,
      'max_tokens': 4000,
    });

    final response = await http.post(url, headers: headers, body: body);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('OpenAI API call failed: ${response.statusCode}');
    }
  }

  static String _buildTopicAnalysisPrompt() {
    return '''
You are an expert educational content classifier for WISME, an AI-powered learning platform.

Your task is to analyze a user's learning topic and determine the most appropriate category from our 15 predefined categories.

AVAILABLE CATEGORIES:
1. Technology & AI
2. Business & Finance  
3. Psychology & Mind
4. Science & Nature
5. Creativity & Design
6. Personal Development
7. History & Culture
8. Skills & Tools
9. Career & Strategy
10. Law & Governance
11. Geopolitics & Global Affairs
12. Environment & Sustainability
13. Mathematics & Logic
14. Gaming & Interactive Media
15. Society & Ethics

RESPONSE FORMAT:
Return a JSON object with:
{
  "category": "exact category name from the list above",
  "confidence": 0.95,
  "reasoning": "brief explanation of why this category fits"
}

Focus on the primary domain of the topic. If a topic spans multiple categories, choose the most dominant one.
''';
  }

  static String _buildTopicAnalysisUserPrompt(String topic, String? personalContext) {
    return '''
Topic: $topic
${personalContext != null ? 'Personal Context: $personalContext' : ''}

Please analyze this topic and determine the most appropriate category.
''';
  }

  static Map<String, dynamic> _parseTopicAnalysisResponse(String response) {
    try {
      // Try to extract JSON from response
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      final jsonString = response.substring(jsonStart, jsonEnd);
      
      return json.decode(jsonString);
    } catch (e) {
      // Fallback parsing
      return {
        'category': 'Personal Development',
        'confidence': 0.7,
        'reasoning': 'Fallback parsing due to response format issues',
      };
    }
  }

  static String _buildJourneyGenerationPrompt(VoicePair voicePair) {
    return '''
You are WISME's AI Learning Journey Architect, creating personalized conversational learning experiences.

VOICE CONFIGURATION:
- Host Voice: ${voicePair.host} (${voicePair.hostVoiceId})
- Expert Voice: ${voicePair.expert} (${voicePair.expertVoiceId})

CONVERSATIONAL FORMAT:
Create engaging two-speaker conversations where:
- The Host asks questions, provides context, and guides the learning
- The Expert provides detailed explanations, examples, and insights
- Both speakers have distinct personalities that match their roles
- The conversation flows naturally with smooth transitions

EPISODE STRUCTURE:
Each episode should be a complete conversational unit with:
- Engaging opening that hooks the listener
- Clear learning objectives
- Natural dialogue between host and expert
- Practical examples and real-world applications
- Thoughtful conclusion that reinforces key points

RESPONSE FORMAT:
Return a JSON object with:
{
  "journey": {
    "title": "Journey title",
    "description": "Journey description",
    "totalEpisodes": 5,
    "estimatedTotalDuration": 60,
    "episodes": [
      {
        "episodeNumber": 1,
        "title": "Episode title",
        "description": "Episode description", 
        "targetDurationMinutes": 12,
        "learningObjectives": ["objective1", "objective2"],
        "keyTopics": ["topic1", "topic2"],
        "conversationOutline": [
          {
            "speaker": "host",
            "content": "Host's opening question or statement",
            "purpose": "introduction"
          },
          {
            "speaker": "expert", 
            "content": "Expert's detailed response",
            "purpose": "explanation"
          }
        ]
      }
    ]
  }
}

Make each episode engaging, educational, and perfectly suited for the target duration and knowledge level.
''';
  }

  static String _buildJourneyGenerationUserPrompt({
    required String topic,
    required String category,
    required LearningType learningType,
    required int episodeCount,
    required int episodeDuration,
    String? personalContext,
  }) {
    return '''
TOPIC: $topic
CATEGORY: $category
LEARNING TYPE: ${learningType.name} (${learningType.description})
APPROACH: ${learningType.approach}
TARGET EPISODES: $episodeCount
EPISODE DURATION: $episodeDuration minutes per episode
${personalContext != null ? 'PERSONAL CONTEXT: $personalContext' : ''}

Create a comprehensive learning journey with conversational episodes that match these specifications.
''';
  }

  static Map<String, dynamic> _parseJourneyGenerationResponse(String response, VoicePair voicePair) {
    try {
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      final jsonString = response.substring(jsonStart, jsonEnd);
      
      final data = json.decode(jsonString);
      
      // Add voice configuration to the response
      data['voiceConfiguration'] = {
        'host': voicePair.host,
        'expert': voicePair.expert,
        'hostVoiceId': voicePair.hostVoiceId,
        'expertVoiceId': voicePair.expertVoiceId,
      };
      
      return data;
    } catch (e) {
      return _createFallbackJourney(
        topic: 'Learning Topic',
        category: 'Personal Development',
        learningType: Phase1LearningTypes.getLearningTypesForCategory('Personal Development').first,
        episodeCount: 5,
        episodeDuration: 12,
      );
    }
  }

  static String _buildConversationalScriptPrompt(VoicePair voicePair) {
    return '''
You are creating a conversational learning script for WISME's two-speaker audio system.

VOICE ROLES:
- HOST (${voicePair.host}): Curious, engaging, asks questions, provides context
- EXPERT (${voicePair.expert}): Knowledgeable, authoritative, provides detailed explanations

CONVERSATION GUIDELINES:
1. Natural dialogue flow with smooth speaker transitions
2. Host asks thoughtful questions that guide the learning
3. Expert provides comprehensive, engaging responses
4. Include real-world examples and practical applications
5. Use conversational language, not formal academic tone
6. Add personality and warmth to both speakers
7. Include natural pauses and emphasis markers for audio production

SCRIPT FORMAT:
Return a JSON object with:
{
  "episodeTitle": "Episode title",
  "durationMinutes": 12,
  "conversation": [
    {
      "speaker": "host",
      "text": "Host's dialogue with [PAUSE] and [EMPHASIS] markers",
      "timestamp": 0,
      "duration": 30
    },
    {
      "speaker": "expert", 
      "text": "Expert's detailed response with examples",
      "timestamp": 30,
      "duration": 45
    }
  ],
  "learningObjectives": ["objective1", "objective2"],
  "keyInsights": ["insight1", "insight2"]
}

Make the conversation engaging, educational, and perfectly timed for the target duration.
''';
  }

  static String _buildConversationalScriptUserPrompt({
    required String topic,
    required String episodeTitle,
    required String category,
    required int targetDurationMinutes,
    required int episodeNumber,
    required int totalEpisodes,
    String? personalContext,
  }) {
    return '''
TOPIC: $topic
EPISODE: $episodeTitle (Episode $episodeNumber of $totalEpisodes)
CATEGORY: $category
TARGET DURATION: $targetDurationMinutes minutes
${personalContext != null ? 'PERSONAL CONTEXT: $personalContext' : ''}

Create a conversational script for this episode that fits the target duration and maintains engagement throughout.
''';
  }

  static Map<String, dynamic> _parseConversationalScriptResponse(String response, VoicePair voicePair) {
    try {
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      final jsonString = response.substring(jsonStart, jsonEnd);
      
      final data = json.decode(jsonString);
      
      // Add voice configuration
      data['voiceConfiguration'] = {
        'host': voicePair.host,
        'expert': voicePair.expert,
        'hostVoiceId': voicePair.hostVoiceId,
        'expertVoiceId': voicePair.expertVoiceId,
      };
      
      return data;
    } catch (e) {
      return _createFallbackScript(
        episodeTitle: 'Learning Episode',
        voicePair: voicePair,
      );
    }
  }

  static Map<String, dynamic> _createFallbackJourney({
    required String topic,
    required String category,
    required LearningType learningType,
    required int episodeCount,
    required int episodeDuration,
  }) {
    final voicePair = Phase1VoiceMapping.getVoicePairForCategory(category);
    
    return {
      'journey': {
        'title': 'Learning $topic',
        'description': 'A personalized learning journey about $topic',
        'totalEpisodes': episodeCount,
        'estimatedTotalDuration': episodeCount * episodeDuration,
        'episodes': List.generate(episodeCount, (index) => {
          'episodeNumber': index + 1,
          'title': 'Episode ${index + 1}: Introduction to $topic',
          'description': 'Learn about $topic in this engaging episode',
          'targetDurationMinutes': episodeDuration,
          'learningObjectives': ['Understand basic concepts', 'Apply knowledge'],
          'keyTopics': ['Fundamentals', 'Applications'],
          'conversationOutline': [
            {
              'speaker': 'host',
              'content': 'Welcome to our learning journey about $topic!',
              'purpose': 'introduction'
            },
            {
              'speaker': 'expert',
              'content': 'Let me explain the key concepts of $topic...',
              'purpose': 'explanation'
            }
          ]
        })
      },
      'voiceConfiguration': {
        'host': voicePair.host,
        'expert': voicePair.expert,
        'hostVoiceId': voicePair.hostVoiceId,
        'expertVoiceId': voicePair.expertVoiceId,
      }
    };
  }

  static Map<String, dynamic> _createFallbackScript({
    required String episodeTitle,
    required VoicePair voicePair,
  }) {
    return {
      'episodeTitle': episodeTitle,
      'durationMinutes': 12,
      'conversation': [
        {
          'speaker': 'host',
          'text': 'Welcome to today\'s learning episode! [PAUSE] Let\'s dive into our topic.',
          'timestamp': 0,
          'duration': 30
        },
        {
          'speaker': 'expert',
          'text': 'I\'m excited to share insights about this fascinating subject with you.',
          'timestamp': 30,
          'duration': 45
        }
      ],
      'learningObjectives': ['Understand key concepts', 'Apply knowledge'],
      'keyInsights': ['Important insight 1', 'Important insight 2'],
      'voiceConfiguration': {
        'host': voicePair.host,
        'expert': voicePair.expert,
        'hostVoiceId': voicePair.hostVoiceId,
        'expertVoiceId': voicePair.expertVoiceId,
      }
    };
  }
} 