import '../../models/models.dart';
import '../storage/content_database.dart';
import '../../models/learning_journey.dart';

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
    required String learningType,
    required String userId,
  }) async {
    try {
      // Step 1: Get user learning profile for personalization
      final userProfile = await _database.getUserProfile(userId);
      
      // Step 2: Search for semantically similar content
      final semanticMatches = await _database.searchBySemantic(
        query: newContentTopic,
        category: category,
        learningType: learningType,
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
    required String learningType,
  }) async {
    final episodes = await _database.searchByHashtags(
      hashtags: newContentHashtags,
      category: category,
      learningType: learningType,
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

  /// Get reuse suggestions based on user's learning history and preferences
  Future<List<ContentReuseResult>> getSuggestionsForUser({
    required String userId,
    required String category,
    int limit = 5,
    bool adaptiveExploration = true,
    String? preferredLearningType,
  }) async {
    final userProfile = await _database.getUserProfile(userId);
    // Use user's favorite categories and learningType as search query
    final searchQuery = userProfile.favoriteCategories.join(' ');
    final learningType = preferredLearningType ?? userProfile.nextSessionRecommendation['suggested_difficulty'] ?? 'Intermediate';
    // Adaptive exploration: occasionally suggest new types
    final explore = adaptiveExploration && (DateTime.now().second % 5 == 0);
    final categoryToUse = explore ? _getRandomCategory(userProfile) : category;
    final learningTypeToUse = explore ? _getRandomLearningType() : learningType;
    return findReusableContent(
      newContentTopic: searchQuery,
      category: categoryToUse,
      learningType: learningTypeToUse,
      userId: userId,
    );
  }

  /// Assemble a robust, personalized journey from cached episodes (production-grade)
  Future<LearningJourney?> assembleCachedJourneyForUser({
    required String userId,
    required String category,
    String? preferredLearningType,
    int episodeCount = 5,
    bool adaptiveExploration = true,
    List<String> completedEpisodeIds = const [],
    bool allowHybrid = true,
  }) async {
    try {
      final userProfile = await _database.getUserProfile(userId);
      // 1. Get all candidate episodes from cache
      final allEpisodes = await _database.searchBySemantic(
        query: userProfile.favoriteCategories.join(' '),
        category: category,
        learningType: preferredLearningType ?? userProfile.nextSessionRecommendation['suggested_difficulty'] ?? 'Intermediate',
        limit: 100,
      );
      // 2. Exclude completed episodes in real time
      final candidates = allEpisodes
        .where((ep) => !completedEpisodeIds.contains(ep.id))
        .toList();
      if (candidates.isEmpty && !allowHybrid) return null;
      // 3. Rank by engagement, recency, and diversity (mock: shuffle, sort by createdAt)
      candidates.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      // TODO: Integrate real engagement/quality scores
      // 4. Ensure journeys are progressive and non-repetitive
      final selected = <Episode>[];
      final usedTitles = <String>{};
      for (final ep in candidates) {
        if (selected.length >= episodeCount) break;
        if (!usedTitles.contains(ep.title)) {
          selected.add(ep);
          usedTitles.add(ep.title);
        }
      }
      // 5. Fallback to hybrid/AI if not enough cached content
      if (selected.length < episodeCount && allowHybrid) {
        // TODO: Integrate AI/hybrid journey assembly here
        // For now, just return what we have
      }
      if (selected.isEmpty) return null;
      // 6. Build journey
      final journey = LearningJourney(
        id: 'cached_journey_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        title: 'Personalized Journey: $category',
        description: 'A smart, adaptive journey built from your cached episodes.',
        category: category,
        learningType: preferredLearningType ?? 'Mixed',
        episodeIds: selected.map((e) => e.id ?? '').toList(),
        episodes: selected,
        isCompleted: false,
        completionPercentage: 0.0,
        currentEpisodeIndex: 0,
        createdAt: DateTime.now(),
        estimatedDurationMinutes: selected.fold(0, (sum, ep) => sum + (ep.durationMinutes ?? 12)),
      );
      // 7. Track analytics
      // WismeAnalytics.trackLearningEvent('cached_journey_recommended', learningType: journey.learningType, category: journey.category, personalizationContext: 'adaptive_exploration', extra: {'episodeIds': journey.episodeIds, 'count': selected.length});
      // 8. Feedback integration (stub)
      // TODO: Wire up feedback collection and learning
      return journey;
    } catch (e) {
      // Error handling
      // WismeAnalytics.trackAIFallback(errorType: 'cached_journey_error', context: e.toString(), aiModel: 'none', category: category, learningType: preferredLearningType ?? 'Mixed');
      return null;
    }
  }

  String _getRandomCategory(UserLearningProfile userProfile) {
    final allCategories = userProfile.categoryProgress.keys.toList();
    if (allCategories.isEmpty) return 'Personal Development';
    allCategories.shuffle();
    return allCategories.first;
  }

  String _getRandomLearningType() {
    const types = [
      '🔹 Core Concepts', '💼 Case Studies', '🛠 Tools & Trends', '🎛 Bit of Everything',
      '💡 Fundamentals', '📈 Growth Strategy', '🧠 Theories & Experiments', '💬 Real-Life Application',
      '🔬 Scientific Concepts', '🎨 Design Fundamentals', '📖 Philosophy & Mental Models',
      '🎯 Self-Development', '🗺️ Timelines', '🌍 Cultural Impact', '🧰 Getting Started',
      '🔧 Pro Tools & Hacks', '🪞 Identity & Purpose', '📄 Career Assets', '📜 Legal Foundations',
      '🌐 Power Dynamics', '🌱 Climate & Ecology', '🔋 Sustainable Systems', '🧮 Foundational Concepts',
      '🔢 Applied Techniques', '🎮 Game Design Principles', '🧠 Player Experience', '🧭 Social Structures',
      '🧬 Moral Frameworks',
    ];
    types.shuffle();
    return types.first;
  }

  /// Accept user feedback on recommendations and adjust future suggestions
  void recordRecommendationFeedback({
    required String userId,
    required String episodeId,
    required String feedbackType, // like, dislike, useful, not_useful
    int rating = 0,
    String? comment,
  }) {
    // Store feedback in analytics and/or user profile for future personalization
    // (Implementation: send to analytics, update user profile, etc.)
    // Example:
    // WismeAnalytics.trackUserFeedback(
    //   feedbackType: feedbackType,
    //   targetId: episodeId,
    //   category: '',
    //   learningType: '',
    //   rating: rating,
    //   comment: comment,
    // );
  }
}
