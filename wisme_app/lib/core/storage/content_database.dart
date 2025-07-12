import '../../models/models.dart';

/// Abstract interface for content database operations
abstract class ContentDatabase {
  Future<List<Episode>> searchBySemantic({
    required String query,
    required String category,
    required String knowledgeLevel,
    int limit = 50,
  });
  
  Future<List<Episode>> searchByHashtags({
    required List<String> hashtags,
    required String category,
    required String knowledgeLevel,
    int limit = 50,
  });
  
  Future<UserLearningProfile> getUserProfile(String userId);
  Future<EpisodeEngagement> getEpisodeEngagement(String episodeId);
  Future<void> storeEpisode(Episode episode);
  Future<void> updateEpisodeContent(String episodeId, String newContent);
}

/// In-memory implementation for testing and development
class InMemoryContentDatabase implements ContentDatabase {
  final Map<String, Episode> _episodes = {};
  final Map<String, UserLearningProfile> _userProfiles = {};
  final Map<String, EpisodeEngagement> _episodeEngagements = {};
  
  @override
  Future<List<Episode>> searchBySemantic({
    required String query,
    required String category,
    required String knowledgeLevel,
    int limit = 50,
  }) async {
    // For testing, use simple keyword matching
    final queryLower = query.toLowerCase();
    final results = <Episode>[];
    
    for (final episode in _episodes.values) {
      if (episode.category == category && episode.knowledgeLevel == knowledgeLevel) {
        // Search in episode content - using actual Episode properties
        if (episode.title.toLowerCase().contains(queryLower) ||
            episode.content.toLowerCase().contains(queryLower)) {
          results.add(episode);
        }
      }
    }
    
    return results.take(limit).toList();
  }
  
  @override
  Future<List<Episode>> searchByHashtags({
    required List<String> hashtags,
    required String category,
    required String knowledgeLevel,
    int limit = 50,
  }) async {
    final results = <Episode>[];
    
    for (final episode in _episodes.values) {
      if (episode.category == category && episode.knowledgeLevel == knowledgeLevel) {
        // Use episode's hashtags property
        final episodeHashtags = episode.hashtags;
        final overlap = hashtags.where((tag) => episodeHashtags.contains(tag)).length;
        if (overlap > 0) {
          results.add(episode);
        }
      }
    }
    
    return results.take(limit).toList();
  }
  
  @override
  Future<UserLearningProfile> getUserProfile(String userId) async {
    return _userProfiles[userId] ?? UserLearningProfile(
      userId: userId,
      favoriteCategories: [], // Use correct property name
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }
  
  @override
  Future<EpisodeEngagement> getEpisodeEngagement(String episodeId) async {
    return _episodeEngagements[episodeId] ?? EpisodeEngagement(
      episodeId: episodeId,
      userId: 'default_user',
      rating: 3, // Use correct type (int)
      completionPercentage: 0.7, // Use correct property name
      firstPlayedAt: DateTime.now(),
      lastPlayedAt: DateTime.now(),
    );
  }
  
  @override
  Future<void> storeEpisode(Episode episode) async {
    // Handle nullable id
    final episodeId = episode.id ?? 'episode_${DateTime.now().millisecondsSinceEpoch}';
    final episodeWithId = Episode(
      id: episodeId,
      title: episode.title,
      content: episode.content, // Use correct property name
      category: episode.category,
      knowledgeLevel: episode.knowledgeLevel,
      coachPersonality: episode.coachPersonality, // Required parameter
      hashtags: episode.hashtags,
      durationMinutes: episode.durationMinutes, // Use correct property name
      createdAt: episode.createdAt,
    );
    _episodes[episodeId] = episodeWithId;
  }
  
  @override
  Future<void> updateEpisodeContent(String episodeId, String newContent) async {
    final existingEpisode = _episodes[episodeId];
    if (existingEpisode != null) {
      // Create new episode with updated content
      final updatedEpisode = Episode(
        id: existingEpisode.id,
        title: existingEpisode.title,
        content: newContent, // Use correct property name
        category: existingEpisode.category,
        knowledgeLevel: existingEpisode.knowledgeLevel,
        coachPersonality: existingEpisode.coachPersonality, // Required parameter
        hashtags: existingEpisode.hashtags,
        durationMinutes: existingEpisode.durationMinutes,
        createdAt: existingEpisode.createdAt,
      );
      _episodes[episodeId] = updatedEpisode;
    }
  }
  
  /// Add sample data for testing
  void addSampleData() {
    final episodes = [
      Episode(
        id: 'ep1',
        title: 'Introduction to Flutter',
        content: 'Learn the basics of Flutter development...',
        category: '💻 Programming',
        knowledgeLevel: '🔹 Core Concepts',
        coachPersonality: 'Kai', // Required parameter
        hashtags: ['flutter', 'mobile', 'development'],
        durationMinutes: 15,
        createdAt: DateTime.now(),
      ),
      Episode(
        id: 'ep2',
        title: 'Advanced Dart Features',
        content: 'Explore advanced Dart programming concepts...',
        category: '💻 Programming',
        knowledgeLevel: '🚀 Advanced',
        coachPersonality: 'Kai', // Required parameter
        hashtags: ['dart', 'programming', 'advanced'],
        durationMinutes: 25,
        createdAt: DateTime.now(),
      ),
    ];
    
    for (final episode in episodes) {
      _episodes[episode.id!] = episode;
    }
  }
}
