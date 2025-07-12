import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/content_database.dart';
import '../services/supabase_service.dart';
import '../../models/episode.dart';

/// Content Reuse Engine - Intelligent content matching and reuse system
/// Implements semantic matching, hashtag filtering, and quality scoring
class ContentReuseEngine {
  final ContentDatabase _database;
  final String _openAiApiKey;

  ContentReuseEngine(this._database, this._openAiApiKey);

  /// Find reusable content for a given topic and user context
  Future<List<Episode>> findRelevantContent({
    required String query,
    required String category,
    required String knowledgeLevel,
    required String userId,
    String? personalContext,
    int maxResults = 5,
  }) async {
    // Multi-stage content matching pipeline
    
    // Stage 1: Hashtag filtering (fast)
    final hashtagMatches = await _hashtagSearch(query, category, knowledgeLevel);
    
    // Stage 2: Semantic similarity (deep understanding)
    final semanticMatches = await _semanticSearch(query, personalContext);
    
    // Stage 3: User preference weighting
    final personalizedScores = await _personalizeResults(hashtagMatches + semanticMatches, userId);
    
    // Stage 4: Quality and freshness scoring
    final qualityScored = await _applyQualityScoring(personalizedScores);
    
    // Stage 5: Remove already seen content
    final unseenContent = await _filterSeenContent(qualityScored, userId);
    
    // Stage 6: Composite ranking and final selection
    final rankedResults = _rankByCompositeScore(unseenContent);
    
    return rankedResults.map((scored) => scored.episode).take(maxResults).toList();
  }

  /// Fast hashtag-based content filtering
  Future<List<Episode>> _hashtagSearch(String query, String category, String knowledgeLevel) async {
    // Extract key terms from query for hashtag matching
    final queryTerms = _extractKeyTerms(query);
    
    return await _database.searchByHashtags(
      hashtags: queryTerms,
      category: category,
      knowledgeLevel: knowledgeLevel,
      limit: 50, // Pre-filter to manageable set
    );
  }

  /// Deep semantic search using AI embeddings
  Future<List<Episode>> _semanticSearch(String query, String? personalContext) async {
    try {
      // Generate embedding for the search query
      final queryEmbedding = await _generateEmbedding(query, personalContext);
      
      // Find episodes with similar embeddings
      return await _database.searchByEmbedding(
        embedding: queryEmbedding,
        similarityThreshold: 0.7,
        limit: 30,
      );
    } catch (e) {
      // Fallback to text search if embedding fails
      return await _database.searchByText(query, limit: 30);
    }
  }

  /// Generate AI embeddings for semantic search
  Future<List<double>> _generateEmbedding(String text, String? context) async {
    final contextualText = context != null 
        ? '$text\nContext: $context'
        : text;

    final response = await http.post(
      Uri.parse('${ApiConfig.openAiBaseUrl}/embeddings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_openAiApiKey',
      },
      body: jsonEncode({
        'model': 'text-embedding-ada-002',
        'input': contextualText,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<double>.from(data['data'][0]['embedding']);
    } else {
      throw Exception('Failed to generate embedding: ${response.statusCode}');
    }
  }

  /// Personalize results based on user learning history and preferences
  Future<List<ScoredEpisode>> _personalizeResults(List<Episode> episodes, String userId) async {
    final userProfile = await _database.getUserLearningProfile(userId);
    
    return episodes.map((episode) {
      double personalScore = 1.0;
      
      // Boost episodes in user's preferred categories
      if (userProfile.preferredCategories.contains(episode.category)) {
        personalScore *= 1.3;
      }
      
      // Boost episodes at user's preferred knowledge level
      if (userProfile.preferredKnowledgeLevel == episode.knowledgeLevel) {
        personalScore *= 1.2;
      }
      
      // Boost episodes by user's preferred coach
      if (userProfile.preferredCoach == episode.coachPersonality) {
        personalScore *= 1.1;
      }
      
      // Reduce score if user has low engagement with similar content
      final categoryEngagement = userProfile.getCategoryEngagement(episode.category);
      personalScore *= (0.5 + categoryEngagement * 0.5);
      
      return ScoredEpisode(episode, personalScore);
    }).toList();
  }

  /// Apply quality scoring based on content metrics
  Future<List<ScoredEpisode>> _applyQualityScoring(List<ScoredEpisode> episodes) async {
    for (final scoredEpisode in episodes) {
      final episode = scoredEpisode.episode;
      double qualityScore = 1.0;
      
      // Boost based on user engagement metrics
      final engagement = await _database.getEpisodeEngagement(episode.id);
      qualityScore *= (0.7 + engagement.averageRating * 0.3);
      qualityScore *= (0.8 + engagement.completionRate * 0.2);
      
      // Penalize very old content
      final daysSinceCreated = DateTime.now().difference(episode.createdAt).inDays;
      if (daysSinceCreated > 180) {
        qualityScore *= 0.9; // Slight penalty for old content
      }
      
      // Boost highly reused content (proves quality)
      if (engagement.reuseCount > 10) {
        qualityScore *= 1.1;
      }
      
      scoredEpisode.qualityScore = qualityScore;
    }
    
    return episodes;
  }

  /// Filter out content the user has already seen
  Future<List<ScoredEpisode>> _filterSeenContent(List<ScoredEpisode> episodes, String userId) async {
    final seenEpisodeIds = await _database.getUserSeenEpisodes(userId);
    
    return episodes.where((scoredEpisode) => 
        !seenEpisodeIds.contains(scoredEpisode.episode.id)
    ).toList();
  }

  /// Final composite ranking of content
  List<ScoredEpisode> _rankByCompositeScore(List<ScoredEpisode> episodes) {
    // Calculate composite score: semantic relevance + personalization + quality
    for (final scoredEpisode in episodes) {
      scoredEpisode.compositeScore = 
          scoredEpisode.semanticScore * 0.4 +
          scoredEpisode.personalScore * 0.3 +
          scoredEpisode.qualityScore * 0.3;
    }
    
    // Sort by composite score (descending)
    episodes.sort((a, b) => b.compositeScore.compareTo(a.compositeScore));
    
    return episodes;
  }

  /// Extract key terms from query for hashtag matching
  List<String> _extractKeyTerms(String query) {
    // Simple term extraction - in production would use NLP
    final words = query.toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(' ')
        .where((word) => word.length > 2)
        .toList();
    
    // Remove common stop words
    final stopWords = {'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can', 'had', 'her', 'was', 'one', 'our', 'out', 'day', 'get', 'has', 'him', 'his', 'how', 'its', 'may', 'new', 'old', 'see', 'two', 'boy', 'did', 'she', 'use', 'way', 'oil', 'sit', 'run', 'say', 'ate', 'far', 'sea', 'eye'};
    
    return words.where((word) => !stopWords.contains(word)).toList();
  }

  /// Generate semantic hashtags for content
  Future<List<String>> generateContentHashtags(String content, String category, String knowledgeLevel) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.openAiBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAiApiKey',
        },
        body: jsonEncode({
          'model': ApiConfig.gptModel,
          'messages': [
            {
              'role': 'system',
              'content': '''Generate 8-12 semantic hashtags for this learning content.
              
Focus on:
- Core concepts and key terms
- Learning objectives and skills
- Related topics and connections
- Practical applications
- Difficulty indicators

Return as JSON array of strings.'''
            },
            {
              'role': 'user',
              'content': '''Content: $content
Category: $category
Level: $knowledgeLevel

Generate hashtags that will help match this content to relevant user queries.'''
            }
          ],
          'max_tokens': 300,
          'temperature': 0.3,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        
        try {
          final hashtags = List<String>.from(jsonDecode(content));
          return hashtags;
        } catch (e) {
          // Fallback hashtag extraction
          return _extractHashtagsFromText(content);
        }
      }
    } catch (e) {
      // Fallback to simple hashtag generation
    }
    
    return _generateFallbackHashtags(content, category, knowledgeLevel);
  }

  /// Extract hashtags from text response
  List<String> _extractHashtagsFromText(String text) {
    final hashtagPattern = RegExp(r'#\w+');
    final matches = hashtagPattern.allMatches(text);
    return matches.map((match) => match.group(0)!.substring(1)).toList();
  }

  /// Generate fallback hashtags when AI fails
  List<String> _generateFallbackHashtags(String content, String category, String knowledgeLevel) {
    final hashtags = <String>[];
    
    // Category-based hashtags
    hashtags.add(category.toLowerCase().replaceAll(' ', '_'));
    hashtags.add('${category.toLowerCase().replaceAll(' ', '_')}_$knowledgeLevel');
    
    // Extract terms from content
    final keyTerms = _extractKeyTerms(content);
    hashtags.addAll(keyTerms.take(8));
    
    // Level-based hashtags
    if (knowledgeLevel.contains('Core') || knowledgeLevel.contains('Fundamental')) {
      hashtags.addAll(['basics', 'fundamentals', 'introduction']);
    } else if (knowledgeLevel.contains('Advanced') || knowledgeLevel.contains('Expert')) {
      hashtags.addAll(['advanced', 'expert', 'mastery']);
    }
    
    return hashtags.take(12).toList();
  }

  /// Check if content should be reused or new content generated
  Future<ContentReuseDecision> shouldReuseContent({
    required String query,
    required String category,
    required String knowledgeLevel,
    required String userId,
    String? personalContext,
  }) async {
    final relevantContent = await findRelevantContent(
      query: query,
      category: category,
      knowledgeLevel: knowledgeLevel,
      userId: userId,
      personalContext: personalContext,
      maxResults: 3,
    );
    
    if (relevantContent.isEmpty) {
      return ContentReuseDecision.generateNew('No relevant existing content found');
    }
    
    final bestMatch = relevantContent.first;
    final matchScore = await _calculateMatchScore(bestMatch, query, personalContext);
    
    if (matchScore > 0.85) {
      return ContentReuseDecision.reuseExisting(bestMatch, matchScore);
    } else if (matchScore > 0.65) {
      return ContentReuseDecision.adaptExisting(bestMatch, matchScore);
    } else {
      return ContentReuseDecision.generateNew('Match score too low: $matchScore');
    }
  }

  /// Calculate how well content matches the query
  Future<double> _calculateMatchScore(Episode episode, String query, String? personalContext) async {
    double score = 0.0;
    
    // Semantic similarity (40%)
    try {
      final queryEmbedding = await _generateEmbedding(query, personalContext);
      final contentEmbedding = episode.contentMetadata?.embedding ?? [];
      if (contentEmbedding.isNotEmpty) {
        score += _calculateCosineSimilarity(queryEmbedding, contentEmbedding) * 0.4;
      }
    } catch (e) {
      // Fallback to text similarity
      score += _calculateTextSimilarity(query, episode.script) * 0.4;
    }
    
    // Hashtag overlap (30%)
    final queryHashtags = _extractKeyTerms(query);
    final contentHashtags = episode.contentMetadata?.hashtags ?? [];
    final hashtagOverlap = _calculateHashtagOverlap(queryHashtags, contentHashtags);
    score += hashtagOverlap * 0.3;
    
    // Quality metrics (30%)
    final engagement = await _database.getEpisodeEngagement(episode.id);
    score += (engagement.averageRating / 5.0) * 0.15; // Rating component
    score += engagement.completionRate * 0.15; // Completion component
    
    return score.clamp(0.0, 1.0);
  }

  /// Calculate cosine similarity between two vectors
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

  /// Calculate text similarity using simple word overlap
  double _calculateTextSimilarity(String query, String content) {
    final queryWords = _extractKeyTerms(query).toSet();
    final contentWords = _extractKeyTerms(content).toSet();
    
    final intersection = queryWords.intersection(contentWords);
    final union = queryWords.union(contentWords);
    
    return union.isEmpty ? 0.0 : intersection.length / union.length;
  }

  /// Calculate hashtag overlap ratio
  double _calculateHashtagOverlap(List<String> query, List<String> content) {
    final querySet = query.toSet();
    final contentSet = content.toSet();
    
    final intersection = querySet.intersection(contentSet);
    return querySet.isEmpty ? 0.0 : intersection.length / querySet.length;
  }
}

/// Scored episode for ranking
class ScoredEpisode {
  final Episode episode;
  double semanticScore;
  double personalScore;
  double qualityScore;
  double compositeScore;

  ScoredEpisode(this.episode, this.semanticScore)
      : personalScore = 1.0,
        qualityScore = 1.0,
        compositeScore = 0.0;
}

/// Content reuse decision
class ContentReuseDecision {
  final ContentReuseAction action;
  final Episode? episode;
  final double? matchScore;
  final String reason;

  ContentReuseDecision._(this.action, this.episode, this.matchScore, this.reason);

  factory ContentReuseDecision.reuseExisting(Episode episode, double score) =>
      ContentReuseDecision._(ContentReuseAction.reuseExisting, episode, score, 'High match score');

  factory ContentReuseDecision.adaptExisting(Episode episode, double score) =>
      ContentReuseDecision._(ContentReuseAction.adaptExisting, episode, score, 'Moderate match score');

  factory ContentReuseDecision.generateNew(String reason) =>
      ContentReuseDecision._(ContentReuseAction.generateNew, null, null, reason);
}

enum ContentReuseAction {
  reuseExisting,
  adaptExisting,
  generateNew,
}
