


import '../storage/content_database.dart';

/// Configuration for content reuse matching
class ContentReuseConfig {
  final double semanticThreshold;
  final double qualityThreshold;
  final int maxSuggestions;
  final bool enablePersonalization;
  final Map<String, double> categoryWeights;

  const ContentReuseConfig({
    this.semanticThreshold = 0.7,
    this.qualityThreshold = 3.0,
    this.maxSuggestions = 5,
    this.enablePersonalization = true,
    this.categoryWeights = const {},
  });
}

/// Result of content reuse analysis
class ContentReuseResult {
  final Episode episode;
  final double semanticScore;
  final double qualityScore;
  final double personalizedScore;
  final Map<String, dynamic> reasoning;

  const ContentReuseResult({
    required this.episode,
    required this.semanticScore,
    required this.qualityScore,
    required this.personalizedScore,
    required this.reasoning,
  });
}

/// AI-powered content reuse engine for smart content recycling
class ContentReuseEngine {
  final ContentDatabase _database;
  final ContentReuseConfig _config;

  ContentReuseEngine({
    required ContentDatabase database,
    ContentReuseConfig? config,
  }) : _database = database,
       _config = config ?? const ContentReuseConfig();

  /// Find episodes that can be reused for new content generation
  Future<List<ContentReuseResult>> findReusableContent({
    required String newContentTopic,
    required String category,
    required String knowledgeLevel,
    required String userId,
  }) async {
    try {
      // Step 1: Get user learning profile for personalization
      final userProfile = await _database.getUserProfile(userId);
      
      // Step 2: Search for semantically similar content
      final semanticMatches = await _database.searchBySemantic(
        query: newContentTopic,
        category: category,
        knowledgeLevel: knowledgeLevel,
        limit: _config.maxSuggestions * 3, // Get more to filter later
      );

      // Step 3: Score and rank candidates
      final results = <ContentReuseResult>[];
      
      for (final episode in semanticMatches) {
        // Calculate semantic similarity score (mock implementation)
        final semanticScore = _calculateSemanticSimilarity(
          newContentTopic, 
          episode.content, // Use correct property
        );
        
        if (semanticScore < _config.semanticThreshold) continue;

        // Get episode engagement for quality scoring
        final engagement = await _database.getEpisodeEngagement(episode.id ?? '');
        
        // Calculate quality score based on engagement
        final qualityScore = _calculateQualityScore(engagement);
        
        if (qualityScore < _config.qualityThreshold) continue;

        // Calculate personalized score
        final personalizedScore = _config.enablePersonalization
            ? _calculatePersonalizedScore(episode, userProfile, engagement)
            : semanticScore;

        // Generate reasoning
        final reasoning = _generateReasoning(
          episode,
          semanticScore,
          qualityScore,
          personalizedScore,
          userProfile,
        );

        results.add(ContentReuseResult(
          episode: episode,
          semanticScore: semanticScore,
          qualityScore: qualityScore,
          personalizedScore: personalizedScore,
          reasoning: reasoning,
        ));
      }

      // Sort by personalized score and return top results
      results.sort((a, b) => b.personalizedScore.compareTo(a.personalizedScore));
      return results.take(_config.maxSuggestions).toList();
      
    } catch (e) {
      // Return empty list on error for testing
      return [];
    }
  }

  /// Calculate semantic similarity between topic and content
  double _calculateSemanticSimilarity(String topic, String content) {
    // Simple keyword-based similarity for testing
    final topicWords = topic.toLowerCase().split(' ');
    final contentWords = content.toLowerCase().split(' ');
    
    int matches = 0;
    for (final word in topicWords) {
      if (contentWords.contains(word)) {
        matches++;
      }
    }
    
    return matches / topicWords.length;
  }

  /// Calculate quality score based on engagement metrics
  double _calculateQualityScore(EpisodeEngagement engagement) {
    // Use actual properties from EpisodeEngagement
    final completionWeight = engagement.completionPercentage * 0.4;
    final ratingWeight = (engagement.rating / 5.0) * 0.6; // rating is int 0-5
    
    return (completionWeight + ratingWeight) * 5.0; // Scale to 0-5
  }

  /// Calculate personalized score based on user preferences
  double _calculatePersonalizedScore(
    Episode episode,
    UserLearningProfile userProfile,
    EpisodeEngagement engagement,
  ) {
    double score = _calculateSemanticSimilarity("", episode.content);
    
    // Boost score for favorite categories
    if (userProfile.favoriteCategories.contains(episode.category)) {
      score *= 1.2;
    }
    
    // Apply category weights from config
    final categoryWeight = _config.categoryWeights[episode.category] ?? 1.0;
    score *= categoryWeight;
    
    // Consider engagement quality
    score *= (_calculateQualityScore(engagement) / 5.0);
    
    return score.clamp(0.0, 1.0);
  }

  /// Generate human-readable reasoning for the recommendation
  Map<String, dynamic> _generateReasoning(
    Episode episode,
    double semanticScore,
    double qualityScore,
    double personalizedScore,
    UserLearningProfile userProfile,
  ) {
    final reasons = <String>[];
    
    if (semanticScore > 0.8) {
      reasons.add('High content similarity');
    }
    
    if (qualityScore > 4.0) {
      reasons.add('Excellent user engagement');
    }
    
    if (userProfile.favoriteCategories.contains(episode.category)) {
      reasons.add('Matches user preferences');
    }
    
    return {
      'primary_reasons': reasons,
      'semantic_score': semanticScore,
      'quality_score': qualityScore,
      'personalized_score': personalizedScore,
      'episode_title': episode.title,
      'episode_category': episode.category,
      'episode_duration': '${episode.durationMinutes} minutes', // Use correct property
    };
  }

  /// Analyze hashtag overlap for content reuse potential
  Future<Map<String, double>> analyzeHashtagOverlap({
    required List<String> newContentHashtags,
    required String category,
    required String knowledgeLevel,
  }) async {
    final episodes = await _database.searchByHashtags(
      hashtags: newContentHashtags,
      category: category,
      knowledgeLevel: knowledgeLevel,
    );

    final overlapScores = <String, double>{};
    
    for (final episode in episodes) {
      final episodeHashtags = episode.hashtags;
      final overlap = newContentHashtags
          .where((tag) => episodeHashtags.contains(tag))
          .length;
      
      final overlapScore = overlap / newContentHashtags.length;
      overlapScores[episode.id ?? ''] = overlapScore;
    }
    
    return overlapScores;
  }

  /// Get reuse suggestions based on user's learning history
  Future<List<ContentReuseResult>> getSuggestionsForUser({
    required String userId,
    required String category,
    int limit = 5,
  }) async {
    final userProfile = await _database.getUserProfile(userId);
    
    // Use user's favorite topics as search query
    final searchQuery = userProfile.favoriteCategories.join(' ');
    
    return findReusableContent(
      newContentTopic: searchQuery,
      category: category,
      knowledgeLevel: userProfile.learningStyle, // Use learning style as knowledge level fallback
      userId: userId,
    );
  }
}
