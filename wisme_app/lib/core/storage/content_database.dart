import 'dart:math' as math;
import '../../models/episode.dart';
import '../../models/episode_engagement.dart';
import '../../models/user_learning_profile.dart';
import '../../models/content_metadata.dart';

/// Content Database interface for storing and retrieving learning content
abstract class ContentDatabase {
  /// Search episodes by hashtags
  Future<List<Episode>> searchByHashtags({
    required List<String> hashtags,
    required String category,
    required String knowledgeLevel,
    int limit = 50,
  });

  /// Search episodes by semantic embedding similarity
  Future<List<Episode>> searchByEmbedding({
    required List<double> embedding,
    double similarityThreshold = 0.7,
    int limit = 30,
  });

  /// Search episodes by text content
  Future<List<Episode>> searchByText(String query, {int limit = 30});

  /// Get user learning profile
  Future<UserLearningProfile> getUserLearningProfile(String userId);

  /// Get episode engagement metrics
  Future<EpisodeEngagement> getEpisodeEngagement(String episodeId);

  /// Get episodes user has already seen
  Future<Set<String>> getUserSeenEpisodes(String userId);

  /// Store new episode
  Future<void> storeEpisode(Episode episode);

  /// Update episode metadata
  Future<void> updateEpisodeMetadata(String episodeId, ContentMetadata metadata);

  /// Record user interaction with episode
  Future<void> recordUserInteraction(String userId, String episodeId, {
    double? rating,
    double? completionRate,
    bool? completed,
  });

  /// Store user learning profile
  Future<void> storeUserProfile(UserLearningProfile profile);
}

/// In-memory implementation for development
class InMemoryContentDatabase implements ContentDatabase {
  final Map<String, Episode> _episodes = {};
  final Map<String, UserLearningProfile> _userProfiles = {};
  final Map<String, EpisodeEngagement> _episodeEngagement = {};
  final Map<String, Set<String>> _userSeenEpisodes = {};

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
        final episodeHashtags = episode.contentMetadata?.hashtags ?? [];
        final overlap = hashtags.where((tag) => episodeHashtags.contains(tag)).length;
        if (overlap > 0) {
          results.add(episode);
        }
      }
    }
    
    return results.take(limit).toList();
  }

  @override
  Future<List<Episode>> searchByEmbedding({
    required List<double> embedding,
    double similarityThreshold = 0.7,
    int limit = 30,
  }) async {
    final results = <Episode>[];
    
    for (final episode in _episodes.values) {
      final episodeEmbedding = episode.contentMetadata?.embedding ?? [];
      if (episodeEmbedding.isNotEmpty) {
        final similarity = _calculateCosineSimilarity(embedding, episodeEmbedding);
        if (similarity >= similarityThreshold) {
          results.add(episode);
        }
      }
    }
    
    return results.take(limit).toList();
  }

  @override
  Future<List<Episode>> searchByText(String query, {int limit = 30}) async {
    final queryLower = query.toLowerCase();
    final results = <Episode>[];
    
    for (final episode in _episodes.values) {
      if (episode.title.toLowerCase().contains(queryLower) ||
          episode.description.toLowerCase().contains(queryLower) ||
          episode.script.toLowerCase().contains(queryLower)) {
        results.add(episode);
      }
    }
    
    return results.take(limit).toList();
  }

  @override
  Future<UserLearningProfile> getUserLearningProfile(String userId) async {
    return _userProfiles[userId] ?? UserLearningProfile(
      userId: userId,
      preferredCategories: [],
      preferredKnowledgeLevel: '🔹 Core Concepts',
      preferredCoach: 'Vee',
      categoryEngagement: {},
      totalLearningHours: 0,
      lastActive: DateTime.now(),
    );
  }

  @override
  Future<EpisodeEngagement> getEpisodeEngagement(String episodeId) async {
    return _episodeEngagement[episodeId] ?? EpisodeEngagement(
      averageRating: 3.5,
      completionRate: 0.7,
      totalPlays: 0,
      reuseCount: 0,
      lastAccessed: DateTime.now(),
    );
  }

  @override
  Future<Set<String>> getUserSeenEpisodes(String userId) async {
    return _userSeenEpisodes[userId] ?? <String>{};
  }

  @override
  Future<void> storeEpisode(Episode episode) async {
    _episodes[episode.id] = episode;
  }

  @override
  Future<void> updateEpisodeMetadata(String episodeId, ContentMetadata metadata) async {
    final episode = _episodes[episodeId];
    if (episode != null) {
      final updatedEpisode = Episode(
        id: episode.id,
        title: episode.title,
        description: episode.description,
        script: episode.script,
        category: episode.category,
        knowledgeLevel: episode.knowledgeLevel,
        coachPersonality: episode.coachPersonality,
        duration: episode.duration,
        createdAt: episode.createdAt,
        updatedAt: DateTime.now(),
        contentMetadata: metadata,
        engagement: episode.engagement,
      );
      _episodes[episodeId] = updatedEpisode;
    }
  }

  @override
  Future<void> recordUserInteraction(String userId, String episodeId, {
    double? rating,
    double? completionRate,
    bool? completed,
  }) async {
    // Record that user has seen this episode
    _userSeenEpisodes.putIfAbsent(userId, () => <String>{}).add(episodeId);
    
    // Update engagement metrics
    final currentEngagement = await getEpisodeEngagement(episodeId);
    final updatedEngagement = EpisodeEngagement(
      averageRating: rating ?? currentEngagement.averageRating,
      completionRate: completionRate ?? currentEngagement.completionRate,
      totalPlays: currentEngagement.totalPlays + 1,
      reuseCount: currentEngagement.reuseCount,
      lastAccessed: DateTime.now(),
    );
    _episodeEngagement[episodeId] = updatedEngagement;
  }

  @override
  Future<void> storeUserProfile(UserLearningProfile profile) async {
    _userProfiles[profile.userId] = profile;
  }

  /// Helper method to calculate cosine similarity
  double _calculateCosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) return 0.0;
    
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    
    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    
    if (normA == 0.0 || normB == 0.0) return 0.0;
    return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
  }
}
