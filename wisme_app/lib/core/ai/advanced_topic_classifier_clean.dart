import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

/// Advanced AI Topic Classification System - Clean Implementation
/// Optimized prompts for cost efficiency and personalization support
class AdvancedTopicClassifier {

  /// 15 Primary Categories with 4 Knowledge Levels Each
  static const Map<String, List<String>> categoryLevels = {
    'Technology & AI': ['🔹 Core Concepts', '💼 Case Studies', '🛠 Tools & Trends', '🎛 Bit of Everything'],
    'Business & Finance': ['💡 Fundamentals', '💼 Case Studies', '📈 Growth Strategy', '🎛 Balanced Mix'],
    'Psychology & Mind': ['🧠 Theories & Experiments', '💬 Real-Life Application', '🧘 Mindfulness & Behavior', '🎛 Mixed Approach'],
    'Science & Nature': ['🔬 Scientific Concepts', '🧬 Discoveries', '🌱 Ethics & Controversies', '🎛 Narrative Mix'],
    'Creativity & Design': ['🎨 Design Fundamentals', '📚 Iconic Examples', '🛠 Frameworks & Tools', '🎛 Creative Blend'],
    'Personal Development': ['📖 Philosophy & Mental Models', '🎯 Self-Development', '💬 Habits & Mindset', '🎛 Reflective Mix'],
    'History & Culture': ['🗺️ Timelines', '🌍 Cultural Impact', '🎶 Media & Storytelling', '🎛 Blended Approach'],
    'Skills & Tools': ['🧰 Getting Started', '🔧 Pro Tools & Hacks', '📈 Workflows & Systems', '🎛 Practical Guide'],
    'Career & Strategy': ['🪞 Identity & Purpose', '📄 Career Assets', '🧭 Strategic Moves', '🎛 Holistic Journey'],
    'Law & Governance': ['📜 Legal Foundations', '🧭 Governance & Policy', '⚖️ Case Law & Precedents', '🎛 Civic Systems Mix'],
    'Geopolitics & Global Affairs': ['🌐 Power Dynamics', '🤝 Diplomacy & Alliances', '💣 Conflicts & Security', '🎛 Global Narrative Mix'],
    'Environment & Sustainability': ['🌱 Climate & Ecology', '🔋 Sustainable Systems', '🧪 Environmental Tech', '🎛 Eco-Strategy Blend'],
    'Mathematics & Logic': ['🧮 Foundational Concepts', '🔢 Applied Techniques', '🧠 Logic & Formal Systems', '🎛 Mathematical Narrative'],
    'Gaming & Interactive Media': ['🎮 Game Design Principles', '🧠 Player Experience', '📚 Iconic Games & Genres', '🎛 Gaming Culture Mix'],
    'Society & Ethics': ['🧭 Social Structures', '🧬 Moral Frameworks', '💬 Real-World Ethics', '🎛 Reflective Society Blend'],
    'Futurism & Exploration': ['🌌 Space & Cosmos', '🤖 Emerging Futures', '🔭 Exploration Scenarios', '🎛 Futuristic Outlooks'],
  };

  /// Main analysis with personalization support
  static Future<TopicClassification> analyzeTopicWithAI(String topic, {
    String? userBackground,
    String? learningIntent,
    String? personalContext, // NEW: Personal situation/goals
    List<String>? previousTopics,
    String? openAiApiKey,
  }) async {
    final apiKey = openAiApiKey ?? ApiConfig.openAiApiKey;
    
    if (!ApiConfig.isOpenAiConfigured && openAiApiKey == null) {
      throw Exception('OpenAI API key not configured. Please set up ApiConfig or provide openAiApiKey parameter.');
    }

    try {
      final analysis = await _performOptimizedAnalysis(
        topic, 
        apiKey,
        userBackground: userBackground,
        learningIntent: learningIntent,
        personalContext: personalContext,
        previousTopics: previousTopics,
      );

      return TopicClassification(
        originalTopic: topic,
        category: analysis['category'] as String,
        knowledgeLevel: analysis['knowledgeLevel'] as String,
        confidence: (analysis['confidence'] as num).toDouble(),
        subtopics: (analysis['subtopics'] as List).map((s) => SubtopicResult.fromJson(s)).toList(),
        learningStyleHints: List<String>.from(analysis['learningStyleHints'] ?? []),
        episodePlan: EpisodePlan.fromJson(analysis['episodePlan']),
        recommendedCoach: analysis['recommendedCoach'] as String,
        estimatedDuration: analysis['estimatedDuration'] as int,
        prerequisiteTopics: List<String>.from(analysis['prerequisiteTopics'] ?? []),
        personalContext: personalContext,
      );
    } catch (e) {
      return _createFallbackClassification(topic, personalContext);
    }
  }

  /// Optimized single API call - cost efficient
  static Future<Map<String, dynamic>> _performOptimizedAnalysis(
    String topic, 
    String apiKey, {
    String? userBackground,
    String? learningIntent,
    String? personalContext,
    List<String>? previousTopics,
  }) async {
    // Compact, efficient prompt
    final systemPrompt = '''Expert learning architect. Analyze topic & create personalized learning plan.

Categories: ${categoryLevels.keys.take(8).join(', ')}, ${categoryLevels.keys.skip(8).join(', ')}

Levels per category: 🔹 Core Concepts, 💼 Case Studies, 🛠 Tools & Trends, 🎛 Bit of Everything

JSON format:
{
  "category": "exact_match",
  "knowledgeLevel": "🔹 Core Concepts",
  "confidence": 0.9,
  "subtopics": [{"title": "...", "description": "...", "keyConcepts": ["..."], "estimatedDuration": 15, "difficultyProgression": 0.3}],
  "learningStyleHints": ["analytical"],
  "episodePlan": {"progressionPath": ["..."], "learningObjectives": ["..."], "totalEpisodes": 3},
  "recommendedCoach": "Kai",
  "estimatedDuration": 45,
  "prerequisiteTopics": ["..."]
}

Coach: Kai=analytical/technical, Vee=creative/practical. 3-4 subtopics, 10-20min each.''';

    // Build context efficiently
    String contextInfo = '';
    if (personalContext != null && personalContext.isNotEmpty) {
      contextInfo += 'Personal Context: $personalContext\n';
    }
    if (userBackground != null) contextInfo += 'Background: $userBackground\n';
    if (learningIntent != null) contextInfo += 'Intent: $learningIntent\n';

    final userPrompt = '''Topic: "$topic"
${contextInfo.isEmpty ? '' : contextInfo}
Personalize for context. Return JSON only.''';

    final response = await http.post(
      Uri.parse(ApiConfig.openAiBaseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': ApiConfig.gptModel,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userPrompt},
        ],
        'max_tokens': 1200, // Reduced for cost efficiency
        'temperature': 0.7,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'] as String;
    
    try {
      return jsonDecode(content);
    } catch (e) {
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
      if (jsonMatch != null) {
        return jsonDecode(jsonMatch.group(0)!);
      }
      throw Exception('Failed to parse AI response as JSON');
    }
  }

  static TopicClassification _createFallbackClassification(String topic, String? personalContext) {
    return TopicClassification(
      originalTopic: topic,
      category: 'Personal Development',
      knowledgeLevel: '🔹 Core Concepts',
      confidence: 0.5,
      subtopics: [
        SubtopicResult(
          title: 'Introduction to $topic',
          description: personalContext != null 
              ? 'Getting started with $topic in your specific context'
              : 'Getting started with the fundamentals',
          keyConcepts: ['core_concepts', 'basic_understanding'],
          estimatedDuration: 15,
          difficultyProgression: 0.3,
        ),
        SubtopicResult(
          title: 'Practical Applications',
          description: personalContext != null
              ? 'How to apply $topic to your specific situation'
              : 'How to apply these concepts in real life',
          keyConcepts: ['practical_use', 'real_world_examples'],
          estimatedDuration: 18,
          difficultyProgression: 0.6,
        ),
      ],
      learningStyleHints: ['practical_focus'],
      episodePlan: EpisodePlan(
        progressionPath: ['Introduction to $topic', 'Practical Applications'],
        learningObjectives: ['Understand core concepts', 'Apply knowledge practically'],
        totalEpisodes: 2,
      ),
      recommendedCoach: 'Vee',
      estimatedDuration: 33,
      prerequisiteTopics: [],
      personalContext: personalContext,
    );
  }
}

/// Data Models for Classification Results
class TopicClassification {
  final String originalTopic;
  final String category;
  final String knowledgeLevel;
  final double confidence;
  final List<SubtopicResult> subtopics;
  final List<String> learningStyleHints;
  final EpisodePlan episodePlan;
  final String recommendedCoach;
  final int estimatedDuration;
  final List<String> prerequisiteTopics;
  final String? personalContext; // NEW

  TopicClassification({
    required this.originalTopic,
    required this.category,
    required this.knowledgeLevel,
    required this.confidence,
    required this.subtopics,
    required this.learningStyleHints,
    required this.episodePlan,
    required this.recommendedCoach,
    required this.estimatedDuration,
    required this.prerequisiteTopics,
    this.personalContext,
  });
}

class SubtopicResult {
  final String title;
  final String description;
  final List<String> keyConcepts;
  final int estimatedDuration;
  final double difficultyProgression;

  SubtopicResult({
    required this.title,
    required this.description,
    required this.keyConcepts,
    required this.estimatedDuration,
    required this.difficultyProgression,
  });

  factory SubtopicResult.fromJson(Map<String, dynamic> json) {
    return SubtopicResult(
      title: json['title'] as String,
      description: json['description'] as String,
      keyConcepts: List<String>.from(json['keyConcepts'] ?? json['key_concepts'] ?? []),
      estimatedDuration: json['estimatedDuration'] ?? json['estimated_duration'] ?? 12,
      difficultyProgression: (json['difficultyProgression'] ?? json['difficulty_progression'] ?? 0.5).toDouble(),
    );
  }
}

class EpisodePlan {
  final List<String> progressionPath;
  final List<String> learningObjectives;
  final int totalEpisodes;

  EpisodePlan({
    required this.progressionPath,
    required this.learningObjectives,
    required this.totalEpisodes,
  });

  factory EpisodePlan.fromJson(Map<String, dynamic> json) {
    return EpisodePlan(
      progressionPath: List<String>.from(json['progressionPath'] ?? []),
      learningObjectives: List<String>.from(json['learningObjectives'] ?? []),
      totalEpisodes: json['totalEpisodes'] as int,
    );
  }
}
