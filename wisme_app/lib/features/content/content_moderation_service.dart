import '../../../core/services/openai_service.dart';
import '../../../models/episode.dart';
import '../../../models/user_learning_profile.dart';

/// Content Moderation Service
/// Handles AI-powered content moderation and safety filtering with age-based filtering
class ContentModerationService {
  static final ContentModerationService _instance = ContentModerationService._internal();
  factory ContentModerationService() => _instance;
  ContentModerationService._internal();

  final OpenAIService _openaiService = OpenAIService();

  /// Age-based moderation thresholds
  static const Map<String, Map<String, double>> ageBasedThresholds = {
    'strict': { // Under 13
      'hate': 0.3,
      'hate/threatening': 0.2,
      'harassment': 0.3,
      'harassment/threatening': 0.2,
      'self-harm': 0.2,
      'self-harm/intent': 0.1,
      'self-harm/instructions': 0.1,
      'sexual': 0.2,
      'sexual/minors': 0.0,
      'violence': 0.3,
      'violence/graphic': 0.2,
    },
    'moderate': { // 13-15
      'hate': 0.5,
      'hate/threatening': 0.4,
      'harassment': 0.5,
      'harassment/threatening': 0.4,
      'self-harm': 0.3,
      'self-harm/intent': 0.2,
      'self-harm/instructions': 0.2,
      'sexual': 0.4,
      'sexual/minors': 0.0,
      'violence': 0.5,
      'violence/graphic': 0.4,
    },
    'teen': { // 16-17
      'hate': 0.6,
      'hate/threatening': 0.5,
      'harassment': 0.6,
      'harassment/threatening': 0.5,
      'self-harm': 0.4,
      'self-harm/intent': 0.3,
      'self-harm/instructions': 0.3,
      'sexual': 0.6,
      'sexual/minors': 0.0,
      'violence': 0.6,
      'violence/graphic': 0.5,
    },
    'adult': { // 18+
      'hate': 0.7,
      'hate/threatening': 0.6,
      'harassment': 0.7,
      'harassment/threatening': 0.6,
      'self-harm': 0.5,
      'self-harm/intent': 0.4,
      'self-harm/instructions': 0.3,
      'sexual': 0.8,
      'sexual/minors': 0.0,
      'violence': 0.7,
      'violence/graphic': 0.6,
    },
  };

  /// Get appropriate thresholds based on user age
  Map<String, double> _getThresholdsForUser(UserLearningProfile? userProfile) {
    if (userProfile == null) return ageBasedThresholds['adult']!;
    
    return ageBasedThresholds[userProfile.contentFilterLevel] ?? ageBasedThresholds['adult']!;
  }

  /// Moderate text content with age-based filtering
  Future<ModerationResult> moderateText(String text, {UserLearningProfile? userProfile}) async {
    try {
      final response = await _openaiService.moderateContent(text);
      
      final moderation = response['results'][0];
      final categories = moderation['categories'] as Map<String, dynamic>;
      final scores = moderation['category_scores'] as Map<String, dynamic>;
      
      final thresholds = _getThresholdsForUser(userProfile);
      final violations = <String>[];
      final highRiskCategories = <String>[];
      
      for (final category in categories.keys) {
        final flagged = categories[category] as bool;
        final score = scores[category] as double;
        final threshold = thresholds[category] ?? 0.5;
        
        if (flagged || score > threshold) {
          violations.add(category);
          
          if (score > threshold + 0.2) {
            highRiskCategories.add(category);
          }
        }
      }
      
      return ModerationResult(
        isSafe: violations.isEmpty,
        overallScore: _calculateOverallScore(scores),
        violations: violations,
        highRiskCategories: highRiskCategories,
        categoryScores: Map<String, double>.from(scores),
        flaggedCategories: Map<String, bool>.from(categories),
        recommendation: _generateRecommendation(violations, highRiskCategories),
      );
    } catch (e) {
      return ModerationResult(
        isSafe: false,
        overallScore: 1.0,
        violations: ['error'],
        highRiskCategories: ['error'],
        categoryScores: {},
        flaggedCategories: {},
        recommendation: ContentAction.block,
        error: 'Moderation failed: $e',
      );
    }
  }

  /// Moderate episode content with age-based filtering
  Future<EpisodeModerationResult> moderateEpisode(Episode episode, {UserLearningProfile? userProfile}) async {
    final results = <String, ModerationResult>{};
    
    // Moderate title
    if (episode.title.isNotEmpty) {
      results['title'] = await moderateText(episode.title, userProfile: userProfile);
    }
    
    // Moderate description (using content field)
    if (episode.content.isNotEmpty) {
      results['description'] = await moderateText(episode.content, userProfile: userProfile);
    }
    
    // Moderate transcript if available
    if (episode.transcript?.isNotEmpty == true) {
      results['transcript'] = await moderateText(episode.transcript!, userProfile: userProfile);
    }
    
    // Moderate hashtags as key takeaways
    if (episode.hashtags.isNotEmpty) {
      for (int i = 0; i < episode.hashtags.length; i++) {
        results['takeaway_$i'] = await moderateText(episode.hashtags[i], userProfile: userProfile);
      }
    }
    
    // Calculate overall episode safety
    final overallSafety = _calculateEpisodeSafety(results);
    
    return EpisodeModerationResult(
      episodeId: episode.id ?? '',
      overallSafety: overallSafety,
      componentResults: results,
      recommendation: _generateEpisodeRecommendation(overallSafety, results),
      moderatedAt: DateTime.now(),
    );
  }

  /// Batch moderate multiple episodes with age-based filtering
  Future<List<EpisodeModerationResult>> moderateEpisodes(
    List<Episode> episodes, {
    UserLearningProfile? userProfile,
    Function(int, int)? onProgress,
  }) async {
    final results = <EpisodeModerationResult>[];
    
    for (int i = 0; i < episodes.length; i++) {
      try {
        final result = await moderateEpisode(episodes[i], userProfile: userProfile);
        results.add(result);
        onProgress?.call(i + 1, episodes.length);
      } catch (e) {
        results.add(EpisodeModerationResult(
          episodeId: episodes[i].id ?? '',
          overallSafety: SafetyLevel.blocked,
          componentResults: {},
          recommendation: ContentAction.block,
          moderatedAt: DateTime.now(),
          error: 'Moderation failed: $e',
        ));
      }
    }
    
    return results;
  }

  /// Real-time content filtering with age-based filtering
  Future<bool> isContentSafe(String content, {UserLearningProfile? userProfile}) async {
    final result = await moderateText(content, userProfile: userProfile);
    return result.isSafe;
  }

  /// Get content safety score with age-based filtering
  Future<double> getContentSafetyScore(String content, {UserLearningProfile? userProfile}) async {
    final result = await moderateText(content, userProfile: userProfile);
    return 1.0 - result.overallScore;
  }

  /// Custom content filtering with rules and age-based filtering
  Future<CustomModerationResult> customModerate(
    String content, {
    UserLearningProfile? userProfile,
    required List<String> customRules,
    required Map<String, double> customThresholds,
  }) async {
    final standardResult = await moderateText(content, userProfile: userProfile);
    final customViolations = <String>[];
    
    // Apply custom rules
    for (final rule in customRules) {
      if (_checkCustomRule(content, rule)) {
        customViolations.add(rule);
      }
    }
    
    // Apply custom thresholds
    for (final category in customThresholds.keys) {
      final score = standardResult.categoryScores[category] ?? 0.0;
      final threshold = customThresholds[category]!;
      
      if (score > threshold && !standardResult.violations.contains(category)) {
        customViolations.add('custom_$category');
      }
    }
    
    return CustomModerationResult(
      standardResult: standardResult,
      customViolations: customViolations,
      isSafe: standardResult.isSafe && customViolations.isEmpty,
      recommendation: customViolations.isEmpty 
        ? standardResult.recommendation 
        : ContentAction.review,
    );
  }

  /// Educational content specific moderation with age-based filtering
  Future<EducationalModerationResult> moderateEducationalContent(
    String content, {
    UserLearningProfile? userProfile,
    required String subjectArea,
    required String targetAge,
  }) async {
    final standardResult = await moderateText(content, userProfile: userProfile);
    
    // Educational content specific checks
    final educationalIssues = <String>[];
    
    // Check for age-appropriate content based on user profile
    final effectiveAge = userProfile?.age.toString() ?? targetAge;
    if (!_isAgeAppropriate(content, effectiveAge)) {
      educationalIssues.add('age_inappropriate');
    }
    
    // Check for subject relevance
    if (!_isSubjectRelevant(content, subjectArea)) {
      educationalIssues.add('subject_irrelevant');
    }
    
    // Check for misinformation
    if (await _containsMisinformation(content, subjectArea)) {
      educationalIssues.add('potential_misinformation');
    }
    
    return EducationalModerationResult(
      standardResult: standardResult,
      educationalIssues: educationalIssues,
      subjectArea: subjectArea,
      targetAge: targetAge,
      isSafe: standardResult.isSafe && educationalIssues.isEmpty,
      educationalQualityScore: _calculateEducationalQuality(content, subjectArea),
      recommendation: _generateEducationalRecommendation(
        standardResult, 
        educationalIssues
      ),
    );
  }

  /// Private helper methods
  double _calculateOverallScore(Map<String, dynamic> scores) {
    double maxScore = 0.0;
    for (final score in scores.values) {
      if (score is double && score > maxScore) {
        maxScore = score;
      }
    }
    return maxScore;
  }

  ContentAction _generateRecommendation(
    List<String> violations, 
    List<String> highRiskCategories
  ) {
    if (highRiskCategories.isNotEmpty) {
      return ContentAction.block;
    }
    if (violations.isNotEmpty) {
      return ContentAction.review;
    }
    return ContentAction.approve;
  }

  SafetyLevel _calculateEpisodeSafety(Map<String, ModerationResult> results) {
    if (results.isEmpty) return SafetyLevel.unknown;
    
    final hasBlocked = results.values.any((r) => r.recommendation == ContentAction.block);
    final hasReview = results.values.any((r) => r.recommendation == ContentAction.review);
    
    if (hasBlocked) return SafetyLevel.blocked;
    if (hasReview) return SafetyLevel.review;
    return SafetyLevel.safe;
  }

  ContentAction _generateEpisodeRecommendation(
    SafetyLevel safety, 
    Map<String, ModerationResult> results
  ) {
    switch (safety) {
      case SafetyLevel.blocked:
        return ContentAction.block;
      case SafetyLevel.review:
        return ContentAction.review;
      case SafetyLevel.safe:
        return ContentAction.approve;
      case SafetyLevel.unknown:
        return ContentAction.review;
    }
  }

  bool _checkCustomRule(String content, String rule) {
    // Implement custom rule checking logic
    final lowercaseContent = content.toLowerCase();
    final lowercaseRule = rule.toLowerCase();
    
    return lowercaseContent.contains(lowercaseRule);
  }

  bool _isAgeAppropriate(String content, String targetAge) {
    // Implement age appropriateness checking
    final ageGroups = ['child', 'teen', 'adult'];
    return ageGroups.contains(targetAge.toLowerCase());
  }

  bool _isSubjectRelevant(String content, String subjectArea) {
    // Implement subject relevance checking
    final relevantKeywords = _getSubjectKeywords(subjectArea);
    final lowercaseContent = content.toLowerCase();
    
    return relevantKeywords.any((keyword) => 
      lowercaseContent.contains(keyword.toLowerCase())
    );
  }

  List<String> _getSubjectKeywords(String subjectArea) {
    // Return subject-specific keywords
    final keywordMap = {
      'technology': ['tech', 'software', 'programming', 'digital', 'computer'],
      'science': ['scientific', 'research', 'experiment', 'theory', 'study'],
      'business': ['business', 'market', 'finance', 'strategy', 'management'],
      'health': ['health', 'medical', 'wellness', 'fitness', 'nutrition'],
      'education': ['learning', 'teaching', 'academic', 'school', 'study'],
    };
    
    return keywordMap[subjectArea.toLowerCase()] ?? [];
  }

  Future<bool> _containsMisinformation(String content, String subjectArea) async {
    // Implement misinformation detection
    // This would typically involve checking against known fact-checking databases
    // For now, return false as a placeholder
    return false;
  }

  double _calculateEducationalQuality(String content, String subjectArea) {
    // Implement educational quality scoring
    double score = 0.5;
    
    // Check for educational indicators
    if (content.contains('learn') || content.contains('understand')) score += 0.1;
    if (content.contains('example') || content.contains('demonstrate')) score += 0.1;
    if (content.contains('practice') || content.contains('apply')) score += 0.1;
    if (content.contains('concept') || content.contains('principle')) score += 0.1;
    
    return score.clamp(0.0, 1.0);
  }

  ContentAction _generateEducationalRecommendation(
    ModerationResult standardResult, 
    List<String> educationalIssues
  ) {
    if (standardResult.recommendation == ContentAction.block) {
      return ContentAction.block;
    }
    if (educationalIssues.contains('potential_misinformation')) {
      return ContentAction.block;
    }
    if (educationalIssues.isNotEmpty) {
      return ContentAction.review;
    }
    return ContentAction.approve;
  }
}

/// Moderation result models
class ModerationResult {
  final bool isSafe;
  final double overallScore;
  final List<String> violations;
  final List<String> highRiskCategories;
  final Map<String, double> categoryScores;
  final Map<String, bool> flaggedCategories;
  final ContentAction recommendation;
  final String? error;

  ModerationResult({
    required this.isSafe,
    required this.overallScore,
    required this.violations,
    required this.highRiskCategories,
    required this.categoryScores,
    required this.flaggedCategories,
    required this.recommendation,
    this.error,
  });
}

class EpisodeModerationResult {
  final String episodeId;
  final SafetyLevel overallSafety;
  final Map<String, ModerationResult> componentResults;
  final ContentAction recommendation;
  final DateTime moderatedAt;
  final String? error;

  EpisodeModerationResult({
    required this.episodeId,
    required this.overallSafety,
    required this.componentResults,
    required this.recommendation,
    required this.moderatedAt,
    this.error,
  });
}

class CustomModerationResult {
  final ModerationResult standardResult;
  final List<String> customViolations;
  final bool isSafe;
  final ContentAction recommendation;

  CustomModerationResult({
    required this.standardResult,
    required this.customViolations,
    required this.isSafe,
    required this.recommendation,
  });
}

class EducationalModerationResult {
  final ModerationResult standardResult;
  final List<String> educationalIssues;
  final String subjectArea;
  final String targetAge;
  final bool isSafe;
  final double educationalQualityScore;
  final ContentAction recommendation;

  EducationalModerationResult({
    required this.standardResult,
    required this.educationalIssues,
    required this.subjectArea,
    required this.targetAge,
    required this.isSafe,
    required this.educationalQualityScore,
    required this.recommendation,
  });
}

/// Enums
enum ContentAction { approve, review, block }
enum SafetyLevel { safe, review, blocked, unknown }
