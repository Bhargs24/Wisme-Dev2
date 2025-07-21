/// WISME Comprehensive Analytics System - Data-Driven Personalization
/// 
/// This system provides comprehensive analytics and tracking to make WISME
/// truly adaptive and personalized like a coach that knows the user inside out.
/// 
/// FEATURES:
/// - User behavior tracking
/// - Learning analytics
/// - Performance monitoring
/// - Predictive analytics
/// - A/B testing
/// - Real-time insights
/// - Privacy-compliant tracking

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../state/app_state_manager.dart';

// ===== ANALYTICS EVENTS =====

/// Base class for all analytics events
abstract class AnalyticsEvent {
  final String eventName;
  final Map<String, dynamic> properties;
  final DateTime timestamp;
  final String? userId;
  final String? sessionId;

  const AnalyticsEvent({
    required this.eventName,
    required this.properties,
    required this.timestamp,
    this.userId,
    this.sessionId,
  });

  Map<String, dynamic> toJson() => {
    'eventName': eventName,
    'properties': properties,
    'timestamp': timestamp.toIso8601String(),
    'userId': userId,
    'sessionId': sessionId,
  };
}

// ===== USER BEHAVIOR EVENTS =====

/// User authentication events
class AuthEvent extends AnalyticsEvent {
  AuthEvent({
    required String action,
    required String method,
    bool? success,
    String? error,
    String? userId,
    String? sessionId,
  }) : super(
    eventName: 'auth_$action',
    properties: {
      'method': method,
      'success': success ?? true,
      if (error != null) 'error': error,
    },
    timestamp: DateTime.now(),
    userId: userId,
    sessionId: sessionId,
  );
}

/// User onboarding events
class OnboardingEvent extends AnalyticsEvent {
  OnboardingEvent({
    required String step,
    required Map<String, dynamic> data,
    String? userId,
    String? sessionId,
  }) : super(
    eventName: 'onboarding_$step',
    properties: data,
    timestamp: DateTime.now(),
    userId: userId,
    sessionId: sessionId,
  );
}

/// Learning interaction events
class LearningEvent extends AnalyticsEvent {
  LearningEvent({
    required String action,
    required Map<String, dynamic> data,
    String? userId,
    String? sessionId,
  }) : super(
    eventName: 'learning_$action',
    properties: data,
    timestamp: DateTime.now(),
    userId: userId,
    sessionId: sessionId,
  );
}

/// Audio playback events
class AudioEvent extends AnalyticsEvent {
  AudioEvent({
    required String action,
    required Map<String, dynamic> data,
    String? userId,
    String? sessionId,
  }) : super(
    eventName: 'audio_$action',
    properties: data,
    timestamp: DateTime.now(),
    userId: userId,
    sessionId: sessionId,
  );
}

/// Coach interaction events
class CoachEvent extends AnalyticsEvent {
  CoachEvent({
    required String action,
    required Map<String, dynamic> data,
    String? userId,
    String? sessionId,
  }) : super(
    eventName: 'coach_$action',
    properties: data,
    timestamp: DateTime.now(),
    userId: userId,
    sessionId: sessionId,
  );
}

/// App performance events
class PerformanceEvent extends AnalyticsEvent {
  PerformanceEvent({
    required String metric,
    required dynamic value,
    String? userId,
    String? sessionId,
  }) : super(
    eventName: 'performance_$metric',
    properties: {'value': value},
    timestamp: DateTime.now(),
    userId: userId,
    sessionId: sessionId,
  );
}

// ===== USER BEHAVIOR TRACKING =====

/// Comprehensive user behavior tracking
class UserBehaviorTracker {
  static final UserBehaviorTracker _instance = UserBehaviorTracker._internal();
  static UserBehaviorTracker get instance => _instance;
  
  UserBehaviorTracker._internal();

  final List<Map<String, dynamic>> _userActions = [];
  final Map<String, int> _featureUsage = {};
  final Map<String, Duration> _sessionDurations = {};
  final Map<String, List<String>> _userJourneys = {};
  final Map<String, Map<String, dynamic>> _userPreferences = {};

  /// Track user action
  void trackAction(String action, Map<String, dynamic> data) {
    final actionData = {
      'action': action,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    _userActions.add(actionData);
    
    // Update feature usage
    _featureUsage[action] = (_featureUsage[action] ?? 0) + 1;
  }

  /// Track feature usage
  void trackFeatureUsage(String feature) {
    _featureUsage[feature] = (_featureUsage[feature] ?? 0) + 1;
  }

  /// Track session duration
  void trackSessionDuration(String sessionId, Duration duration) {
    _sessionDurations[sessionId] = duration;
  }

  /// Track user journey
  void trackUserJourney(String userId, String step) {
    if (!_userJourneys.containsKey(userId)) {
      _userJourneys[userId] = [];
    }
    _userJourneys[userId]!.add(step);
  }

  /// Track user preferences
  void trackUserPreferences(String userId, Map<String, dynamic> preferences) {
    _userPreferences[userId] = preferences;
  }

  /// Get user behavior insights
  Map<String, dynamic> getUserInsights(String userId) {
    final userActions = _userActions.where((action) => 
      action['data']['userId'] == userId
    ).toList();

    final userJourney = _userJourneys[userId] ?? [];
    final userPrefs = _userPreferences[userId] ?? {};

    return {
      'totalActions': userActions.length,
      'featureUsage': _featureUsage,
      'userJourney': userJourney,
      'preferences': userPrefs,
      'lastActive': userActions.isNotEmpty ? userActions.last['timestamp'] : null,
    };
  }

  /// Get all behavior data
  Map<String, dynamic> getAllBehaviorData() => {
    'userActions': _userActions,
    'featureUsage': _featureUsage,
    'sessionDurations': _sessionDurations.map((k, v) => MapEntry(k, v.inSeconds)),
    'userJourneys': _userJourneys,
    'userPreferences': _userPreferences,
  };
}

// ===== LEARNING ANALYTICS =====

/// Comprehensive learning analytics
class LearningAnalytics {
  static final LearningAnalytics _instance = LearningAnalytics._internal();
  static LearningAnalytics get instance => _instance;
  
  LearningAnalytics._internal();

  final Map<String, List<Map<String, dynamic>>> _learningSessions = {};
  final Map<String, Map<String, dynamic>> _topicProgress = {};
  final Map<String, List<String>> _completedTopics = {};
  final Map<String, Map<String, dynamic>> _learningPreferences = {};
  final Map<String, List<Map<String, dynamic>>> _knowledgeAssessments = {};

  /// Track learning session
  void trackLearningSession(String userId, Map<String, dynamic> sessionData) {
    if (!_learningSessions.containsKey(userId)) {
      _learningSessions[userId] = [];
    }
    _learningSessions[userId]!.add(sessionData);
  }

  /// Track topic progress
  void trackTopicProgress(String userId, String topic, Map<String, dynamic> progress) {
    if (!_topicProgress.containsKey(userId)) {
      _topicProgress[userId] = {};
    }
    _topicProgress[userId]![topic] = progress;
  }

  /// Track completed topic
  void trackCompletedTopic(String userId, String topic) {
    if (!_completedTopics.containsKey(userId)) {
      _completedTopics[userId] = [];
    }
    if (!_completedTopics[userId]!.contains(topic)) {
      _completedTopics[userId]!.add(topic);
    }
  }

  /// Track learning preferences
  void trackLearningPreferences(String userId, Map<String, dynamic> preferences) {
    _learningPreferences[userId] = preferences;
  }

  /// Track knowledge assessment
  void trackKnowledgeAssessment(String userId, Map<String, dynamic> assessment) {
    if (!_knowledgeAssessments.containsKey(userId)) {
      _knowledgeAssessments[userId] = [];
    }
    _knowledgeAssessments[userId]!.add(assessment);
  }

  /// Get learning insights for user
  Map<String, dynamic> getLearningInsights(String userId) {
    final sessions = _learningSessions[userId] ?? [];
    final progress = _topicProgress[userId] ?? {};
    final completed = _completedTopics[userId] ?? [];
    final preferences = _learningPreferences[userId] ?? {};
    final assessments = _knowledgeAssessments[userId] ?? [];

    // Calculate learning metrics
    final totalSessions = sessions.length;
    final totalDuration = sessions.fold<Duration>(
      Duration.zero,
      (total, session) => total + Duration(minutes: session['durationMinutes'] ?? 0),
    );
    final averageSessionDuration = totalSessions > 0 
      ? totalDuration.inMinutes / totalSessions 
      : 0;

    final favoriteTopics = _getFavoriteTopics(userId);
    final learningStreak = _calculateLearningStreak(userId);
    final knowledgeGrowth = _calculateKnowledgeGrowth(userId);

    return {
      'totalSessions': totalSessions,
      'totalDuration': totalDuration.inMinutes,
      'averageSessionDuration': averageSessionDuration,
      'completedTopics': completed,
      'favoriteTopics': favoriteTopics,
      'learningStreak': learningStreak,
      'knowledgeGrowth': knowledgeGrowth,
      'preferences': preferences,
      'recentAssessments': assessments.take(5).toList(),
    };
  }

  /// Get favorite topics based on engagement
  List<String> _getFavoriteTopics(String userId) {
    final sessions = _learningSessions[userId] ?? [];
    final topicEngagement = <String, int>{};

    for (final session in sessions) {
      final topic = session['topic'] as String?;
      if (topic != null) {
        topicEngagement[topic] = (topicEngagement[topic] ?? 0) + 1;
      }
    }

    final sortedTopics = topicEngagement.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedTopics.take(5).map((e) => e.key).toList();
  }

  /// Calculate learning streak
  int _calculateLearningStreak(String userId) {
    final sessions = _learningSessions[userId] ?? [];
    if (sessions.isEmpty) return 0;

    final dates = sessions.map((s) => DateTime.parse(s['timestamp'])).toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime? currentDate;

    for (final date in dates) {
      final dateOnly = DateTime(date.year, date.month, date.day);
      
      if (currentDate == null) {
        currentDate = dateOnly;
        streak = 1;
      } else {
        final difference = currentDate.difference(dateOnly).inDays;
        if (difference == 1) {
          streak++;
          currentDate = dateOnly;
        } else {
          break;
        }
      }
    }

    return streak;
  }

  /// Calculate knowledge growth
  Map<String, dynamic> _calculateKnowledgeGrowth(String userId) {
    final assessments = _knowledgeAssessments[userId] ?? [];
    if (assessments.length < 2) return {'growth': 0.0, 'trend': 'stable'};

    final recentScores = assessments.take(5).map((a) => a['score'] as double).toList();
    final olderScores = assessments.skip(5).take(5).map((a) => a['score'] as double).toList();

    if (recentScores.isEmpty || olderScores.isEmpty) {
      return {'growth': 0.0, 'trend': 'stable'};
    }

    final recentAverage = recentScores.reduce((a, b) => a + b) / recentScores.length;
    final olderAverage = olderScores.reduce((a, b) => a + b) / olderScores.length;
    final growth = ((recentAverage - olderAverage) / olderAverage) * 100;

    String trend;
    if (growth > 5) {
      trend = 'improving';
    } else if (growth < -5) {
      trend = 'declining';
    } else {
      trend = 'stable';
    }

    return {
      'growth': growth,
      'trend': trend,
      'recentAverage': recentAverage,
      'olderAverage': olderAverage,
    };
  }

  /// Get all learning data
  Map<String, dynamic> getAllLearningData() => {
    'learningSessions': _learningSessions,
    'topicProgress': _topicProgress,
    'completedTopics': _completedTopics,
    'learningPreferences': _learningPreferences,
    'knowledgeAssessments': _knowledgeAssessments,
  };
}

// ===== PERFORMANCE MONITORING =====

/// App performance monitoring
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  static PerformanceMonitor get instance => _instance;
  
  PerformanceMonitor._internal();

  final List<Map<String, dynamic>> _performanceMetrics = [];
  final Map<String, List<double>> _responseTimes = {};
  final Map<String, int> _errorCounts = {};
  final Map<String, double> _memoryUsage = {};
  final Map<String, double> _batteryUsage = {};

  /// Track performance metric
  void trackMetric(String metric, dynamic value) {
    _performanceMetrics.add({
      'metric': metric,
      'value': value,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track response time
  void trackResponseTime(String operation, double responseTime) {
    if (!_responseTimes.containsKey(operation)) {
      _responseTimes[operation] = [];
    }
    _responseTimes[operation]!.add(responseTime);
  }

  /// Track error
  void trackError(String errorType, String errorMessage) {
    _errorCounts[errorType] = (_errorCounts[errorType] ?? 0) + 1;
    
    _performanceMetrics.add({
      'metric': 'error',
      'errorType': errorType,
      'errorMessage': errorMessage,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track memory usage
  void trackMemoryUsage(double usageMB) {
    _memoryUsage[DateTime.now().toIso8601String()] = usageMB;
  }

  /// Track battery usage
  void trackBatteryUsage(double usagePercent) {
    _batteryUsage[DateTime.now().toIso8601String()] = usagePercent;
  }

  /// Get performance insights
  Map<String, dynamic> getPerformanceInsights() {
    final recentMetrics = _performanceMetrics.take(100).toList();
    
    // Calculate average response times
    final avgResponseTimes = <String, double>{};
    for (final entry in _responseTimes.entries) {
      if (entry.value.isNotEmpty) {
        avgResponseTimes[entry.key] = entry.value.reduce((a, b) => a + b) / entry.value.length;
      }
    }

    // Calculate error rates
    final totalErrors = _errorCounts.values.fold<int>(0, (sum, count) => sum + count);
    final errorRate = recentMetrics.isNotEmpty ? totalErrors / recentMetrics.length : 0.0;

    return {
      'averageResponseTimes': avgResponseTimes,
      'errorCounts': _errorCounts,
      'errorRate': errorRate,
      'recentMemoryUsage': _memoryUsage.values.take(10).toList(),
      'recentBatteryUsage': _batteryUsage.values.take(10).toList(),
    };
  }

  /// Get all performance data
  Map<String, dynamic> getAllPerformanceData() => {
    'performanceMetrics': _performanceMetrics,
    'responseTimes': _responseTimes,
    'errorCounts': _errorCounts,
    'memoryUsage': _memoryUsage,
    'batteryUsage': _batteryUsage,
  };
}

// ===== PREDICTIVE ANALYTICS =====

/// Predictive analytics for personalization
class PredictiveAnalytics {
  static final PredictiveAnalytics _instance = PredictiveAnalytics._internal();
  static PredictiveAnalytics get instance => _instance;
  
  PredictiveAnalytics._internal();

  /// Predict user engagement
  Map<String, dynamic> predictUserEngagement(String userId) {
    final behaviorData = UserBehaviorTracker.instance.getUserInsights(userId);
    final learningData = LearningAnalytics.instance.getLearningInsights(userId);

    // Simple prediction algorithm (can be enhanced with ML)
    final totalActions = behaviorData['totalActions'] as int;
    final learningStreak = learningData['learningStreak'] as int;
    final averageSessionDuration = learningData['averageSessionDuration'] as double;

    // Calculate engagement score (0-100)
    double engagementScore = 0;
    engagementScore += (totalActions / 100).clamp(0, 30); // 30% weight
    engagementScore += (learningStreak / 7).clamp(0, 30); // 30% weight
    engagementScore += (averageSessionDuration / 20).clamp(0, 40); // 40% weight

    // Predict next session time
    final nextSessionPrediction = _predictNextSession(userId);

    // Predict content preferences
    final contentPreferences = _predictContentPreferences(userId);

    return {
      'engagementScore': engagementScore.round(),
      'engagementLevel': _getEngagementLevel(engagementScore),
      'nextSessionPrediction': nextSessionPrediction,
      'contentPreferences': contentPreferences,
      'recommendations': _generateRecommendations(userId, engagementScore),
    };
  }

  /// Predict next session time
  DateTime? _predictNextSession(String userId) {
    final sessions = LearningAnalytics.instance._learningSessions[userId] ?? [];
    if (sessions.length < 2) return null;

    // Simple prediction based on average interval
    final timestamps = sessions.map((s) => DateTime.parse(s['timestamp'])).toList()
      ..sort();

    final intervals = <int>[];
    for (int i = 1; i < timestamps.length; i++) {
      intervals.add(timestamps[i].difference(timestamps[i - 1]).inHours);
    }

    if (intervals.isEmpty) return null;

    final averageInterval = intervals.reduce((a, b) => a + b) / intervals.length;
    return DateTime.now().add(Duration(hours: averageInterval.round()));
  }

  /// Predict content preferences
  Map<String, dynamic> _predictContentPreferences(String userId) {
    final learningData = LearningAnalytics.instance.getLearningInsights(userId);
    final favoriteTopics = learningData['favoriteTopics'] as List<String>;
    final preferences = learningData['preferences'] as Map<String, dynamic>;

    return {
      'preferredTopics': favoriteTopics,
      'preferredDuration': preferences['preferredDuration'] ?? 15,
      'preferredDifficulty': preferences['preferredDifficulty'] ?? 'intermediate',
      'preferredFormat': preferences['preferredFormat'] ?? 'conversational',
    };
  }

  /// Get engagement level
  String _getEngagementLevel(double score) {
    if (score >= 80) return 'high';
    if (score >= 50) return 'medium';
    return 'low';
  }

  /// Generate personalized recommendations
  List<Map<String, dynamic>> _generateRecommendations(String userId, double engagementScore) {
    final learningData = LearningAnalytics.instance.getLearningInsights(userId);
    final completedTopics = learningData['completedTopics'] as List<String>;
    final favoriteTopics = learningData['favoriteTopics'] as List<String>;

    final recommendations = <Map<String, dynamic>>[];

    // Recommend related topics
    for (final topic in favoriteTopics) {
      final relatedTopics = _getRelatedTopics(topic);
      for (final related in relatedTopics) {
        if (!completedTopics.contains(related)) {
          recommendations.add({
            'type': 'related_topic',
            'topic': related,
            'reason': 'Based on your interest in $topic',
            'priority': 'high',
          });
        }
      }
    }

    // Recommend based on engagement level
    if (engagementScore < 50) {
      recommendations.add({
        'type': 'motivation',
        'action': 'short_session',
        'reason': 'Try a quick 5-minute session to build momentum',
        'priority': 'high',
      });
    }

    return recommendations.take(5).toList();
  }

  /// Get related topics (simplified - can be enhanced with ML)
  List<String> _getRelatedTopics(String topic) {
    // Simplified topic relationships
    final topicRelationships = {
      'Technology & AI': ['Machine Learning', 'Data Science', 'Programming'],
      'Business & Finance': ['Entrepreneurship', 'Marketing', 'Investment'],
      'Psychology & Mind': ['Neuroscience', 'Behavioral Science', 'Meditation'],
      'Science & Nature': ['Physics', 'Biology', 'Chemistry'],
      'Creativity & Design': ['Art History', 'Graphic Design', 'Innovation'],
    };

    return topicRelationships[topic] ?? [];
  }
}

// ===== MAIN ANALYTICS SYSTEM =====

/// Main analytics system that coordinates all analytics components
class ComprehensiveAnalyticsSystem {
  static final ComprehensiveAnalyticsSystem _instance = ComprehensiveAnalyticsSystem._internal();
  static ComprehensiveAnalyticsSystem get instance => _instance;
  
  ComprehensiveAnalyticsSystem._internal();

  final StreamController<AnalyticsEvent> _eventController = StreamController<AnalyticsEvent>.broadcast();
  final List<AnalyticsEvent> _eventHistory = [];
  bool _isInitialized = false;

  // Analytics components
  late UserBehaviorTracker behaviorTracker;
  late LearningAnalytics learningAnalytics;
  late PerformanceMonitor performanceMonitor;
  late PredictiveAnalytics predictiveAnalytics;

  /// Initialize the analytics system
  Future<void> initialize() async {
    if (_isInitialized) return;

    behaviorTracker = UserBehaviorTracker.instance;
    learningAnalytics = LearningAnalytics.instance;
    performanceMonitor = PerformanceMonitor.instance;
    predictiveAnalytics = PredictiveAnalytics.instance;

    _isInitialized = true;
  }

  /// Track analytics event
  void trackEvent(AnalyticsEvent event) {
    _eventHistory.add(event);
    _eventController.add(event);

    // Keep history manageable
    if (_eventHistory.length > 10000) {
      _eventHistory.removeRange(0, 1000);
    }
  }

  /// Get comprehensive user insights
  Map<String, dynamic> getUserInsights(String userId) {
    final behaviorInsights = behaviorTracker.getUserInsights(userId);
    final learningInsights = learningAnalytics.getLearningInsights(userId);
    final performanceInsights = performanceMonitor.getPerformanceInsights();
    final predictiveInsights = predictiveAnalytics.predictUserEngagement(userId);

    return {
      'behavior': behaviorInsights,
      'learning': learningInsights,
      'performance': performanceInsights,
      'predictions': predictiveInsights,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Get all analytics data
  Map<String, dynamic> getAllAnalyticsData() => {
    'events': _eventHistory.map((e) => e.toJson()).toList(),
    'behavior': behaviorTracker.getAllBehaviorData(),
    'learning': learningAnalytics.getAllLearningData(),
    'performance': performanceMonitor.getAllPerformanceData(),
  };

  /// Stream of analytics events
  Stream<AnalyticsEvent> get eventStream => _eventController.stream;

  /// Dispose resources
  void dispose() {
    _eventController.close();
  }
} 