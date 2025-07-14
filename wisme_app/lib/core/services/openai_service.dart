import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/environment_config.dart';

/// OpenAI API Service - Direct Integration
/// Handles all OpenAI API communications with proper error handling and rate limiting
class OpenAIService {
  static final OpenAIService _instance = OpenAIService._internal();
  factory OpenAIService() => _instance;
  OpenAIService._internal();

  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _model = 'gpt-4';
  
  /// Check if OpenAI is properly configured
  static bool get isConfigured => EnvironmentConfig.openaiApiKey.isNotEmpty;

  /// Make a chat completion request to OpenAI
  Future<String> chatCompletion({
    required String prompt,
    String? systemMessage,
    double temperature = 0.7,
    int maxTokens = 2000,
  }) async {
    if (!isConfigured) {
      throw Exception('OpenAI API key not configured. Please set OPENAI_API_KEY in your environment.');
    }

    try {
      final messages = <Map<String, String>>[];
      
      // Add system message if provided
      if (systemMessage != null) {
        messages.add({
          'role': 'system',
          'content': systemMessage,
        });
      }
      
      // Add user prompt
      messages.add({
        'role': 'user',
        'content': prompt,
      });

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${EnvironmentConfig.openaiApiKey}',
        },
        body: json.encode({
          'model': _model,
          'messages': messages,
          'temperature': temperature,
          'max_tokens': maxTokens,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else {
        final error = json.decode(response.body);
        throw Exception('OpenAI API Error (${response.statusCode}): ${error['error']['message']}');
      }
    } catch (e) {
      print('❌ OpenAI API Error: $e');
      rethrow;
    }
  }

  /// Generate topic analysis using OpenAI
  Future<Map<String, dynamic>> analyzeTopicWithAI({
    required String topic,
    String? userBackground,
    String? learningIntent,
    String? personalContext,
    List<String>? previousTopics,
  }) async {
    final systemMessage = '''
You are an expert educational content analyzer. Analyze topics for personalized learning experiences.

Categories: Technology & AI, Business & Finance, Psychology & Mind, Science & Nature, Creativity & Design, Personal Development, History & Culture, Skills & Tools, Career & Strategy, Law & Governance, Geopolitics & Global Affairs, Environment & Sustainability, Mathematics & Logic, Gaming & Interactive Media, Society & Ethics, Futurism & Exploration

Knowledge Levels: Beginner, Intermediate, Advanced, Expert

Coach Personalities:
- Kai: Thoughtful, analytical mentor who breaks down complex concepts
- Vee: Energetic, motivating coach who makes learning exciting

Respond with valid JSON only:
{
  "category": "category_name",
  "knowledgeLevel": "level",
  "recommendedCoach": "Kai|Vee",
  "estimatedDuration": minutes_number,
  "learningObjectives": ["objective1", "objective2", "objective3"],
  "subtopics": [{"title": "subtopic", "importance": "high|medium|low"}],
  "difficulty": "Easy|Moderate|Challenging",
  "prerequisites": ["prereq1", "prereq2"]
}
''';

    final prompt = '''
Analyze this learning topic: "$topic"

Context:
${userBackground != null ? "User Background: $userBackground" : ""}
${learningIntent != null ? "Learning Intent: $learningIntent" : ""}
${personalContext != null ? "Personal Context: $personalContext" : ""}
${previousTopics != null && previousTopics.isNotEmpty ? "Previous Topics: ${previousTopics.join(', ')}" : ""}

Provide a comprehensive analysis for personalized learning.
''';

    final response = await chatCompletion(
      prompt: prompt,
      systemMessage: systemMessage,
      temperature: 0.3, // Lower temperature for more consistent analysis
    );

    try {
      return json.decode(response);
    } catch (e) {
      throw Exception('Failed to parse OpenAI response as JSON: $e');
    }
  }

  /// Generate educational episode content using OpenAI
  Future<String> generateEpisodeContent({
    required String topic,
    required String title,
    required String category,
    required String knowledgeLevel,
    required String coachPersonality,
    String? personalContext,
    List<String>? learningObjectives,
    int durationMinutes = 10,
  }) async {
    final systemMessage = '''
You are an expert educational content creator specializing in conversational learning experiences.

Create engaging, educational podcast-style content that sounds natural and conversational.

Coach Personality:
- Kai: Thoughtful, analytical, uses thoughtful pauses, explains concepts clearly
- Vee: Energetic, enthusiastic, uses motivational language, keeps energy high

Format Guidelines:
- Use [PAUSE] for natural conversation breaks
- Use [EMPHASIS] for important points
- Keep sentences conversational and natural
- Include practical examples and analogies
- Structure: Introduction → Key Concepts → Practical Applications → Summary

Duration: Approximately $durationMinutes minutes of spoken content.
''';

    final prompt = '''
Create educational episode content for:

Topic: "$topic"
Title: "$title"
Category: $category
Knowledge Level: $knowledgeLevel
Coach: $coachPersonality
Duration: $durationMinutes minutes

${personalContext != null ? "Personal Context: $personalContext" : ""}
${learningObjectives != null ? "Learning Objectives: ${learningObjectives.join(', ')}" : ""}

Create natural, conversational content that teaches effectively while maintaining the coach's personality.
''';

    return await chatCompletion(
      prompt: prompt,
      systemMessage: systemMessage,
      temperature: 0.8, // Higher temperature for more creative content
      maxTokens: durationMinutes * 150, // Rough estimate: ~150 tokens per minute
    );
  }

  /// Generate learning journey with 5 episodes
  Future<List<Map<String, dynamic>>> generateLearningJourney({
    required String topic,
    required String knowledgeLevel,
    String? personalContext,
  }) async {
    final systemMessage = '''
You are an expert curriculum designer. Create a 5-episode learning journey that progressively builds knowledge.

Each episode should build on the previous ones, with clear progression from fundamentals to application.

Respond with valid JSON only:
{
  "episodes": [
    {
      "title": "Episode Title",
      "description": "Brief description",
      "learningObjectives": ["objective1", "objective2"],
      "keyTopics": ["topic1", "topic2", "topic3"],
      "estimatedDuration": minutes_number,
      "difficulty": "Easy|Moderate|Challenging"
    }
  ]
}
''';

    final prompt = '''
Create a 5-episode learning journey for: "$topic"

Knowledge Level: $knowledgeLevel
${personalContext != null ? "Personal Context: $personalContext" : ""}

Design a progressive curriculum that takes the learner from basics to practical application.

Episode Structure:
1. Foundation & Overview
2. Core Concepts
3. Practical Applications  
4. Advanced Insights
5. Integration & Next Steps

Each episode should be 8-12 minutes and build naturally on previous episodes.
''';

    final response = await chatCompletion(
      prompt: prompt,
      systemMessage: systemMessage,
      temperature: 0.5,
    );

    try {
      final data = json.decode(response);
      return List<Map<String, dynamic>>.from(data['episodes']);
    } catch (e) {
      throw Exception('Failed to parse learning journey response: $e');
    }
  }

  /// Health check - test OpenAI connection
  Future<bool> testConnection() async {
    if (!isConfigured) {
      return false;
    }

    try {
      final response = await chatCompletion(
        prompt: 'Respond with exactly: "OpenAI connection successful"',
        temperature: 0.0,
        maxTokens: 50,
      );
      
      return response.toLowerCase().contains('openai connection successful');
    } catch (e) {
      print('OpenAI connection test failed: $e');
      return false;
    }
  }
}
