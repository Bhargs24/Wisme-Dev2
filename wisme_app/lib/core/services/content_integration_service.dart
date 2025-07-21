
import '../../models/models.dart';
import '../ai/advanced_topic_classifier.dart';
import '../content/podcast_content_generator.dart';
import '../storage/content_database.dart';
import '../services/supabase_service.dart';

/// Service that integrates all AI systems into a complete content pipeline
class ContentIntegrationService {
  static final ContentIntegrationService _instance = ContentIntegrationService._internal();
  factory ContentIntegrationService() => _instance;
  ContentIntegrationService._internal();

  final PodcastContentGenerator _generator = PodcastContentGenerator();
  final ContentDatabase _database = InMemoryContentDatabase();

  /// Generates a complete learning episode from a user's topic input
  Future<Episode> generateEpisodeFromTopic(
    String topic, {
    String? userBackground,
    String? learningIntent,
    String? personalContext,
    List<String>? previousTopics,
  }) async {
    try {
      // Step 1: Classify and analyze the topic using AI
      final classification = await AdvancedTopicClassifier.analyzeTopicWithAI(
        topic,
        userBackground: userBackground,
        learningIntent: learningIntent,
        personalContext: personalContext,
        previousTopics: previousTopics,
      );

      // Step 2: Generate personalized podcast content script
      final episodeScript = await _generator.generateEpisodeScript(
        topic,
        classification.episodePlan.learningObjectives.first, // title
        'Educational episode about $topic', // content
        classification.knowledgeType, // knowledgeType
        'Kai', // coachPersonality (or use classification.recommendedCoach if available)
      );

      // Step 3: Create Episode with generated content
      final episode = Episode(
        title: 'Learning About: $topic',
        content: episodeScript,
        category: classification.category,
        knowledgeType: classification.knowledgeType,
        coachPersonality: 'Kai', // Default coach
        hashtags: [topic.toLowerCase().replaceAll(' ', '_'), ...classification.subtopics.map((s) => s.title.toLowerCase().replaceAll(' ', '_'))],
        durationMinutes: classification.estimatedDuration,
        createdAt: DateTime.now(),
      );

      // Step 4: Store episode in both local database and Supabase
      await _database.storeEpisode(episode);
      final episodeId = await SupabaseService.saveEpisode(episode);
      
      // Return episode with the database-assigned ID
      return Episode(
        id: episodeId,
        title: episode.title,
        content: episode.content,
        category: episode.category,
        knowledgeType: episode.knowledgeType,
        coachPersonality: episode.coachPersonality,
        hashtags: episode.hashtags,
        durationMinutes: episode.durationMinutes,
        createdAt: episode.createdAt,
      );

    } catch (e) {
      print('Error generating episode: $e');
      
      // Fallback: Create basic episode without AI
      final basicScript = '''
      Welcome to your learning session about $topic!
      
      Today we're going to explore the fundamentals and key concepts that will help you understand this topic better.
      
      [PAUSE]
      
      Let's start by understanding what makes this topic important and how it can benefit your learning journey.
      
      [EMPHASIS] Key points we'll cover:
      - Basic concepts and definitions
      - Practical applications
      - How this connects to your goals
      
      [PAUSE]
      
      Remember, learning is a journey, and every step forward counts. Let's dive in!
      ''';
      
      final basicEpisode = Episode(
        title: 'Learning About: $topic',
        content: basicScript,
        category: 'Technology & AI', // Default category
        knowledgeType: '🔹 Core Concepts', // Default level
        coachPersonality: 'Kai', // Default coach
        hashtags: [topic.toLowerCase().replaceAll(' ', '_')],
        durationMinutes: 15,
        createdAt: DateTime.now(),
      );
      
      await _database.storeEpisode(basicEpisode);
      final episodeId = await SupabaseService.saveEpisode(basicEpisode);
      
      return Episode(
        id: episodeId,
        title: basicEpisode.title,
        content: basicEpisode.content,
        category: basicEpisode.category,
        knowledgeType: basicEpisode.knowledgeType,
        coachPersonality: basicEpisode.coachPersonality,
        hashtags: basicEpisode.hashtags,
        durationMinutes: basicEpisode.durationMinutes,
        createdAt: basicEpisode.createdAt,
      );
    }
  }

  /// Generate a complete learning journey with multiple episodes
  Future<List<Episode>> generateLearningJourney(
    String topic, {
    int episodeCount = 5,
    String? userBackground,
    String? learningIntent,
  }) async {
    final episodes = <Episode>[];
    
    for (int i = 0; i < episodeCount; i++) {
      try {
        final subtopic = '$topic - Part ${i + 1}';
        final episode = await generateEpisodeFromTopic(
          subtopic,
          userBackground: userBackground,
          learningIntent: learningIntent,
          personalContext: 'This is part ${i + 1} of $episodeCount in a learning journey about $topic',
        );
        episodes.add(episode);
      } catch (e) {
        print('Error generating episode ${i + 1}: $e');
        continue;
      }
    }
    
    return episodes;
  }

  /// Retrieve all user episodes
  Future<List<Episode>> getUserEpisodes() async {
    return await SupabaseService.getUserEpisodes();
  }

  /// Search episodes by query
  Future<List<Episode>> searchEpisodes(String query) async {
    return await SupabaseService.searchEpisodes(query);
  }

  /// Get episodes by category
  Future<List<Episode>> getEpisodesByCategory(String category) async {
    return await SupabaseService.getEpisodesByCategory(category);
  }

  /// Get recommended episodes for user
  Future<List<Episode>> getRecommendedEpisodes() async {
    return await SupabaseService.getRecommendedEpisodes();
  }

  /// Mark episode as completed
  Future<void> markEpisodeCompleted(String episodeId) async {
    await SupabaseService.updateEpisodeProgress(episodeId, 1.0, true);
  }

  /// Update episode progress
  Future<void> updateEpisodeProgress(String episodeId, double progress) async {
    await SupabaseService.updateEpisodeProgress(episodeId, progress, progress >= 1.0);
  }

  /// Update episode
  Future<void> updateEpisode(Episode episode) async {
    await SupabaseService.updateEpisode(episode);
  }

  /// Track learning session
  Future<void> trackLearningSession(String episodeId, int durationSeconds) async {
    await SupabaseService.trackLearningSession(episodeId, durationSeconds);
  }

  /// Get comprehensive learning analytics
  Future<Map<String, dynamic>> getLearningAnalytics() async {
    try {
      // Get Supabase learning stats
      final supabaseStats = await SupabaseService.getLearningStats();
      
      // Get user episodes for additional analytics
      final episodes = await getUserEpisodes();
      final completedEpisodes = episodes.where((e) => e.isCompleted).length;
      final totalDuration = episodes.fold<int>(
        0, 
        (sum, episode) => sum + episode.durationMinutes,
      );
      
      // Combine analytics
      return {
        'totalEpisodes': episodes.length,
        'completedEpisodes': completedEpisodes,
        'completionRate': episodes.isNotEmpty ? completedEpisodes / episodes.length : 0.0,
        'totalLearningTime': totalDuration,
        'averageEpisodeDuration': episodes.isNotEmpty ? totalDuration / episodes.length : 0.0,
        'supabaseStats': supabaseStats,
        'categoryCounts': _getCategoryCounts(episodes),
        'recentActivity': episodes.take(5).map((e) => {
          'title': e.title,
          'category': e.category,
          'completedAt': e.createdAt.toIso8601String(),
        }).toList(),
      };
    } catch (e) {
      print('Error getting learning analytics: $e');
      return {
        'totalEpisodes': 0,
        'completedEpisodes': 0,
        'completionRate': 0.0,
        'totalLearningTime': 0,
        'error': e.toString(),
      };
    }
  }

  /// Helper method to count episodes by category
  Map<String, int> _getCategoryCounts(List<Episode> episodes) {
    final counts = <String, int>{};
    for (final episode in episodes) {
      counts[episode.category] = (counts[episode.category] ?? 0) + 1;
    }
    return counts;
  }

  /// Initialize service with sample data for testing
  Future<void> initializeWithSampleData() async {
    final inMemoryDb = _database as InMemoryContentDatabase;
    inMemoryDb.addSampleData();
  }

  /// Sync offline data when connection is restored
  Future<void> syncOfflineData() async {
    await SupabaseService.syncOfflineData();
  }

  /// Get content database instance for direct access if needed
  ContentDatabase get database => _database;

  /// Get content generator instance for direct access if needed
  PodcastContentGenerator get generator => _generator;
}
