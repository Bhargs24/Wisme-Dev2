import '../services/optimized_openai_service.dart';
import '../../models/models.dart';

/// Advanced AI Topic Classification System - Optimized with God-Level Prompts
/// Uses single API call for complete learning experience generation
class AdvancedTopicClassifier {

  /// Complete 60 Knowledge Levels (15 categories × 4 levels each)
  static const Map<String, List<String>> categoryLevels = OptimizedOpenAIService.knowledgeLevels;

  /// MASTER ANALYSIS: Single API call for complete learning experience
  static Future<TopicClassification> analyzeTopicWithAI(String topic, {
    String? userBackground,
    String? learningIntent,
    String? personalContext,
    List<String>? previousTopics,
    String? preferredCoach,
    String? learningGoal,
  }) async {
    try {
      // Single optimized API call for everything
      final completeExperience = await OptimizedOpenAIService().generateCompleteLearningExperience(
        topic: topic,
        userBackground: userBackground,
        learningIntent: learningIntent,
        personalContext: personalContext,
        previousTopics: previousTopics,
        preferredCoach: preferredCoach,
        learningGoal: learningGoal,
      );

      // Extract topic analysis from comprehensive response
      final analysis = completeExperience['topicAnalysis'] as Map<String, dynamic>;
      final journey = completeExperience['learningJourney'] as Map<String, dynamic>;
      final episodes = journey['episodes'] as List<dynamic>;

      // Convert to TopicClassification model
      return TopicClassification(
        originalTopic: topic,
        category: analysis['category'] as String,
        knowledgeLevel: analysis['knowledgeLevel'] as String,
        confidence: (analysis['confidence'] as num).toDouble(),
        subtopics: _extractSubtopics(episodes),
        contentHints: _extractLearningHints(analysis),
        episodePlan: EpisodePlan(
          progressionPath: episodes.map((e) => e['title'] as String).toList(),
          learningObjectives: _extractAllObjectives(episodes),
          totalEpisodes: episodes.length,
        ),
        recommendedCoach: analysis['recommendedCoach'] as String,
        estimatedDuration: analysis['estimatedTotalDuration'] as int,
        prerequisiteTopics: previousTopics ?? [],
        personalContext: personalContext,
        // Store complete experience for later use
        completeLearningExperience: completeExperience,
      );
    } catch (e) {
      print('⚠️ Optimized OpenAI analysis failed, using fallback: $e');
      return _createFallbackClassification(topic, personalContext);
    }
  }

  /// Extract subtopics from generated episodes
  static List<SubtopicResult> _extractSubtopics(List<dynamic> episodes) {
    return episodes.map((episode) {
      final keyInsights = episode['keyInsights'] as List<dynamic>? ?? [];
      return SubtopicResult(
        title: episode['title'] as String,
        description: episode['description'] as String,
        keyConcepts: keyInsights.map((insight) => insight.toString()).toList(),
        estimatedDuration: episode['duration'] as int,
        difficultyProgression: (episodes.indexOf(episode) + 1) / episodes.length,
      );
    }).toList();
  }

  /// Extract content presentation hints from analysis
  static List<String> _extractLearningHints(Map<String, dynamic> analysis) {
    final coach = analysis['recommendedCoach'] as String;
    final knowledgeLevel = analysis['knowledgeLevel'] as String;
    
    final hints = <String>[];
    
    // Coach-based hints
    if (coach == 'Kai') {
      hints.addAll(['analytical', 'philosophical', 'deep-thinking']);
    } else {
      hints.addAll(['practical', 'energetic', 'action-oriented']);
    }
    
    // Knowledge level-based hints
    if (knowledgeLevel.contains('Core Concepts')) {
      hints.addAll(['foundational', 'systematic']);
    } else if (knowledgeLevel.contains('Case Studies')) {
      hints.addAll(['example-driven', 'real-world']);
    } else if (knowledgeLevel.contains('Tools & Trends')) {
      hints.addAll(['cutting-edge', 'practical-tools']);
    } else {
      hints.addAll(['comprehensive', 'balanced']);
    }
    
    return hints.take(5).toList();
  }

  /// Extract all learning objectives from episodes
  static List<String> _extractAllObjectives(List<dynamic> episodes) {
    final allObjectives = <String>[];
    for (final episode in episodes) {
      final objectives = episode['learningObjectives'] as List<dynamic>? ?? [];
      allObjectives.addAll(objectives.map((obj) => obj.toString()));
    }
    return allObjectives.take(8).toList(); // Limit to prevent overload
  }

  /// Create fallback classification when AI fails
  static TopicClassification _createFallbackClassification(String topic, String? personalContext) {
    // Smart category detection based on keywords
    String category = 'Personal Development'; // Default
    String knowledgeLevel = '🔹 Core Concepts';
    String coach = 'Kai';
    
    final topicLower = topic.toLowerCase();
    
    // Advanced keyword matching with context awareness
    if (topicLower.contains(RegExp(r'tech|ai|program|code|software|data|machine|algorithm|computer'))) {
      category = 'Technology & AI';
      knowledgeLevel = personalContext?.toLowerCase().contains(RegExp(r'beginner|new|start')) ?? false 
          ? '🔹 Core Concepts' : '🛠 Tools & Trends';
      coach = 'Kai';
    } else if (topicLower.contains(RegExp(r'business|money|finance|market|startup|entrepreneur|strategy'))) {
      category = 'Business & Finance';
      knowledgeLevel = personalContext?.toLowerCase().contains(RegExp(r'example|case|company')) ?? false 
          ? '💼 Case Studies' : '💡 Fundamentals';
      coach = 'Vee';
    } else if (topicLower.contains(RegExp(r'psychology|mind|behavior|emotion|mental|cognitive'))) {
      category = 'Psychology & Mind';
      knowledgeLevel = personalContext?.toLowerCase().contains(RegExp(r'practical|apply|real')) ?? false 
          ? '💬 Real-Life Application' : '🧠 Theories & Experiments';
      coach = 'Kai';
    } else if (topicLower.contains(RegExp(r'science|physics|chemistry|biology|research|study'))) {
      category = 'Science & Nature';
      knowledgeLevel = '🔬 Scientific Concepts';
      coach = 'Kai';
    } else if (topicLower.contains(RegExp(r'design|art|creative|music|visual|aesthetic'))) {
      category = 'Creativity & Design';
      knowledgeLevel = personalContext?.toLowerCase().contains(RegExp(r'tool|software|technique')) ?? false 
          ? '🛠 Frameworks & Tools' : '🎨 Design Fundamentals';
      coach = 'Vee';
    } else if (topicLower.contains(RegExp(r'career|job|work|professional|skill|leadership'))) {
      category = 'Career & Strategy';
      knowledgeLevel = '🪞 Identity & Purpose';
      coach = 'Vee';
    } else if (topicLower.contains(RegExp(r'history|culture|society|social|political'))) {
      category = 'History & Culture';
      knowledgeLevel = '🗺️ Timelines';
      coach = 'Kai';
    } else if (topicLower.contains(RegExp(r'environment|climate|sustainability|green|eco'))) {
      category = 'Environment & Sustainability';
      knowledgeLevel = '🌱 Climate & Ecology';
      coach = 'Kai';
    }

    return TopicClassification(
      originalTopic: topic,
      category: category,
      knowledgeLevel: knowledgeLevel,
      confidence: 0.6, // Lower confidence for fallback
      subtopics: [
        SubtopicResult(
          title: 'Introduction to $topic',
          description: 'Foundation and overview concepts',
          keyConcepts: ['fundamentals', 'basics', 'overview'],
          estimatedDuration: 8,
          difficultyProgression: 0.2,
        ),
        SubtopicResult(
          title: 'Core Principles',
          description: 'Key concepts and important ideas',
          keyConcepts: ['principles', 'concepts', 'theory'],
          estimatedDuration: 10,
          difficultyProgression: 0.5,
        ),
        SubtopicResult(
          title: 'Practical Applications',
          description: 'Real-world implementation and usage',
          keyConcepts: ['application', 'practice', 'implementation'],
          estimatedDuration: 12,
          difficultyProgression: 0.8,
        ),
      ],
      contentHints: coach == 'Kai' 
          ? ['analytical', 'systematic', 'thoughtful'] 
          : ['practical', 'energetic', 'action-oriented'],
      episodePlan: EpisodePlan(
        progressionPath: ['Foundation', 'Core Concepts', 'Applications'],
        learningObjectives: [
          'Understand $topic fundamentals',
          'Learn key principles and concepts',
          'Apply knowledge in practical scenarios',
        ],
        totalEpisodes: 3,
      ),
      recommendedCoach: coach,
      estimatedDuration: 30,
      prerequisiteTopics: const [],
      personalContext: personalContext,
    );
  }

  /// Quick classification without AI (for testing/fallback)
  static TopicClassification classifyTopicBasic(String topic) {
    return _createFallbackClassification(topic, null);
  }

  /// Test connection using optimized service
  static Future<bool> testConnection() async {
    try {
      return await OptimizedOpenAIService().testConnection();
    } catch (e) {
      print('Topic classifier connection test failed: $e');
      return false;
    }
  }

  /// Get all available categories
  static List<String> get availableCategories => categoryLevels.keys.toList();

  /// Get knowledge levels for a specific category
  static List<String> getKnowledgeLevelsForCategory(String category) {
    return categoryLevels[category] ?? [];
  }

  /// Validate if a knowledge level exists
  static bool isValidKnowledgeLevel(String category, String level) {
    return categoryLevels[category]?.contains(level) ?? false;
  }
}
