/// Personalization Engine
/// Advanced personalization system for tailored learning experiences
library;

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

/// User Interest Profile - tracks learning preferences and behavior
class UserInterestProfile {
  final String userId;
  final Map<String, double> topicInterests; // topic -> interest score (0.0 - 1.0)
  final Map<String, double> categoryWeights; // category -> weight (0.0 - 1.0)
  final Map<String, int> engagementHistory; // activity -> count
  final Map<String, dynamic> learningPreferences;
  final DateTime lastUpdated;
  final DateTime createdAt;

  const UserInterestProfile({
    required this.userId,
    required this.topicInterests,
    required this.categoryWeights,
    required this.engagementHistory,
    required this.learningPreferences,
    required this.lastUpdated,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'topicInterests': topicInterests,
    'categoryWeights': categoryWeights,
    'engagementHistory': engagementHistory,
    'learningPreferences': learningPreferences,
    'lastUpdated': lastUpdated.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserInterestProfile.fromJson(Map<String, dynamic> json) {
    return UserInterestProfile(
      userId: json['userId'] as String,
      topicInterests: Map<String, double>.from(json['topicInterests'] ?? {}),
      categoryWeights: Map<String, double>.from(json['categoryWeights'] ?? {}),
      engagementHistory: Map<String, int>.from(json['engagementHistory'] ?? {}),
      learningPreferences: Map<String, dynamic>.from(json['learningPreferences'] ?? {}),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Create a new profile with default values
  factory UserInterestProfile.create(String userId) {
    final now = DateTime.now();
    return UserInterestProfile(
      userId: userId,
      topicInterests: <String, double>{},
      categoryWeights: <String, double>{},
      engagementHistory: <String, int>{},
      learningPreferences: <String, dynamic>{},
      lastUpdated: now,
      createdAt: now,
    );
  }
}

/// Advanced Personalization Engine
/// Manages user learning personalization and content recommendations
class PersonalizationEngine extends ChangeNotifier {
  static final PersonalizationEngine _instance = PersonalizationEngine._internal();
  static PersonalizationEngine get instance => _instance;
  
  PersonalizationEngine._internal();

  // State management
  final Map<String, UserInterestProfile> _userProfiles = {};
  Database? _database;
  bool _isInitialized = false;

  // Getters
  bool get isInitialized => _isInitialized;
  
  /// Initialize the personalization engine
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize database connection
      // Note: Database initialization would happen here in production
      _isInitialized = true;
      print('Personalization engine initialized successfully');
    } catch (e) {
      print('Error initializing personalization engine: $e');
      throw Exception('Failed to initialize personalization engine: $e');
    }
  }

  /// Get user interest profile
  Future<UserInterestProfile?> getUserProfile(String userId) async {
    if (!_isInitialized) await initialize();
    
    // Return cached profile if available
    if (_userProfiles.containsKey(userId)) {
      return _userProfiles[userId];
    }

    try {
      // In production, this would load from database
      final profile = UserInterestProfile.create(userId);
      _userProfiles[userId] = profile;
      return profile;
    } catch (e) {
      print('Error loading user profile: $e');
      return null;
    }
  }

  /// Update user interest profile
  Future<bool> updateUserProfile(String userId, UserInterestProfile profile) async {
    if (!_isInitialized) await initialize();

    try {
      _userProfiles[userId] = profile;
      
      // In production, this would save to database
      // await _database?.insert('user_profiles', profile.toJson(),
      //     conflictAlgorithm: ConflictAlgorithm.replace);
      
      notifyListeners();
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  /// Track user interest in a topic
  Future<void> trackTopicInterest(String userId, String topic, double interestScore) async {
    final profile = await getUserProfile(userId);
    if (profile == null) return;

    final updatedInterests = Map<String, double>.from(profile.topicInterests);
    final currentScore = updatedInterests[topic] ?? 0.0;
    
    // Weighted average of current and new score
    updatedInterests[topic] = (currentScore * 0.7 + interestScore * 0.3).clamp(0.0, 1.0);

    final updatedProfile = UserInterestProfile(
      userId: profile.userId,
      topicInterests: updatedInterests,
      categoryWeights: profile.categoryWeights,
      engagementHistory: profile.engagementHistory,
      learningPreferences: profile.learningPreferences,
      lastUpdated: DateTime.now(),
      createdAt: profile.createdAt,
    );

    await updateUserProfile(userId, updatedProfile);
  }

  /// Track user engagement activity
  Future<void> trackEngagement(String userId, String activity) async {
    final profile = await getUserProfile(userId);
    if (profile == null) return;

    final updatedHistory = Map<String, int>.from(profile.engagementHistory);
    updatedHistory[activity] = (updatedHistory[activity] ?? 0) + 1;

    final updatedProfile = UserInterestProfile(
      userId: profile.userId,
      topicInterests: profile.topicInterests,
      categoryWeights: profile.categoryWeights,
      engagementHistory: updatedHistory,
      learningPreferences: profile.learningPreferences,
      lastUpdated: DateTime.now(),
      createdAt: profile.createdAt,
    );

    await updateUserProfile(userId, updatedProfile);
  }

  /// Get personalized content recommendations
  Future<List<Map<String, dynamic>>> getContentRecommendations(String userId, {int limit = 10}) async {
    final profile = await getUserProfile(userId);
    if (profile == null) return [];

    // Simple recommendation logic based on interests
    final recommendations = <Map<String, dynamic>>[];
    
    // Sort topics by interest score
    final sortedInterests = profile.topicInterests.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedInterests.take(limit)) {
      recommendations.add({
        'topic': entry.key,
        'score': entry.value,
        'type': 'interest_based',
        'reason': 'High interest in ${entry.key}',
      });
    }

    return recommendations;
  }

  /// Get learning analytics for user
  Future<Map<String, dynamic>> getUserAnalytics(String userId) async {
    final profile = await getUserProfile(userId);
    if (profile == null) return {};

    final totalEngagement = profile.engagementHistory.values.fold(0, (sum, count) => sum + count);
    final topInterests = profile.topicInterests.entries
        .where((e) => e.value > 0.5)
        .map((e) => e.key)
        .toList();

    return {
      'totalEngagement': totalEngagement,
      'topInterests': topInterests,
      'profileAge': DateTime.now().difference(profile.createdAt).inDays,
      'lastActive': profile.lastUpdated,
      'diversityScore': _calculateDiversityScore(profile.topicInterests),
    };
  }

  /// Calculate diversity score for user interests
  double _calculateDiversityScore(Map<String, double> interests) {
    if (interests.isEmpty) return 0.0;
    
    final values = interests.values.toList();
    final mean = values.fold(0.0, (sum, val) => sum + val) / values.length;
    final variance = values.fold(0.0, (sum, val) => sum + pow(val - mean, 2)) / values.length;
    
    return (1.0 - sqrt(variance)).clamp(0.0, 1.0);
  }

  /// Cleanup resources
  @override
  Future<void> dispose() async {
    await _database?.close();
    _userProfiles.clear();
    _isInitialized = false;
    super.dispose();
  }

  // Learning pattern constants for engagement tracking
  static const Map<String, double> engagementWeights = {
    'episode_completed': 1.0,
    'episode_paused': 0.3,
    'episode_skipped': -0.2,
    'topic_searched': 0.5,
    'content_shared': 0.8,
    'feedback_positive': 0.7,
    'feedback_negative': -0.3,
    'speed_change': 0.2,
  };
}
