/// User Learning Profile Model
/// Tracks user preferences and learning patterns
class UserLearningProfile {
  final String userId;
  final String preferredCoach;
  final String learningStyle;
  final List<String> favoriteCategories;
  final List<String> difficultTopics;
  final int dailyGoalMinutes;
  final int currentStreak;
  final int longestStreak;
  final double averageSessionLength;
  final String preferredTimeOfDay;
  final double preferredPlaybackSpeed;
  final Map<String, double> categoryProgress;
  final DateTime createdAt;
  final DateTime lastUpdated;

  const UserLearningProfile({
    required this.userId,
    this.preferredCoach = 'Kai',
    this.learningStyle = 'Balanced',
    this.favoriteCategories = const [],
    this.difficultTopics = const [],
    this.dailyGoalMinutes = 30,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.averageSessionLength = 15.0,
    this.preferredTimeOfDay = 'morning',
    this.preferredPlaybackSpeed = 1.0,
    this.categoryProgress = const {},
    required this.createdAt,
    required this.lastUpdated,
  });

  factory UserLearningProfile.fromJson(Map<String, dynamic> json) {
    return UserLearningProfile(
      userId: json['user_id'],
      preferredCoach: json['preferred_coach'] ?? 'Kai',
      learningStyle: json['learning_style'] ?? 'Balanced',
      favoriteCategories: List<String>.from(json['favorite_categories'] ?? []),
      difficultTopics: List<String>.from(json['difficult_topics'] ?? []),
      dailyGoalMinutes: json['daily_goal_minutes'] ?? 30,
      currentStreak: json['current_streak'] ?? 0,
      longestStreak: json['longest_streak'] ?? 0,
      averageSessionLength: (json['average_session_length'] ?? 15.0).toDouble(),
      preferredTimeOfDay: json['preferred_time_of_day'] ?? 'morning',
      preferredPlaybackSpeed: (json['preferred_playback_speed'] ?? 1.0).toDouble(),
      categoryProgress: Map<String, double>.from(json['category_progress'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'preferred_coach': preferredCoach,
      'learning_style': learningStyle,
      'favorite_categories': favoriteCategories,
      'difficult_topics': difficultTopics,
      'daily_goal_minutes': dailyGoalMinutes,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'average_session_length': averageSessionLength,
      'preferred_time_of_day': preferredTimeOfDay,
      'preferred_playback_speed': preferredPlaybackSpeed,
      'category_progress': categoryProgress,
      'created_at': createdAt.toIso8601String(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  UserLearningProfile copyWith({
    String? userId,
    String? preferredCoach,
    String? learningStyle,
    List<String>? favoriteCategories,
    List<String>? difficultTopics,
    int? dailyGoalMinutes,
    int? currentStreak,
    int? longestStreak,
    double? averageSessionLength,
    String? preferredTimeOfDay,
    double? preferredPlaybackSpeed,
    Map<String, double>? categoryProgress,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return UserLearningProfile(
      userId: userId ?? this.userId,
      preferredCoach: preferredCoach ?? this.preferredCoach,
      learningStyle: learningStyle ?? this.learningStyle,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      difficultTopics: difficultTopics ?? this.difficultTopics,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      averageSessionLength: averageSessionLength ?? this.averageSessionLength,
      preferredTimeOfDay: preferredTimeOfDay ?? this.preferredTimeOfDay,
      preferredPlaybackSpeed: preferredPlaybackSpeed ?? this.preferredPlaybackSpeed,
      categoryProgress: categoryProgress ?? this.categoryProgress,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Calculate overall learning progress (0.0 - 1.0)
  double get overallProgress {
    if (categoryProgress.isEmpty) return 0.0;
    
    double totalProgress = categoryProgress.values.fold(0.0, (sum, progress) => sum + progress);
    return (totalProgress / categoryProgress.length).clamp(0.0, 1.0);
  }

  /// Get weakest category for targeted learning
  String? get weakestCategory {
    if (categoryProgress.isEmpty) return null;
    
    String? weakest;
    double lowestProgress = double.infinity;
    
    categoryProgress.forEach((category, progress) {
      if (progress < lowestProgress) {
        lowestProgress = progress;
        weakest = category;
      }
    });
    
    return weakest;
  }

  /// Get strongest category
  String? get strongestCategory {
    if (categoryProgress.isEmpty) return null;
    
    String? strongest;
    double highestProgress = -1.0;
    
    categoryProgress.forEach((category, progress) {
      if (progress > highestProgress) {
        highestProgress = progress;
        strongest = category;
      }
    });
    
    return strongest;
  }

  /// Check if user is meeting daily goals
  bool get isMeetingDailyGoals => currentStreak > 0;

  /// Get recommendation for next learning session
  Map<String, dynamic> get nextSessionRecommendation {
    return {
      'suggested_category': weakestCategory ?? favoriteCategories.first,
      'suggested_duration': dailyGoalMinutes,
      'suggested_coach': preferredCoach,
      'suggested_difficulty': learningStyle == 'Beginner' ? 'Basic' : 
                             learningStyle == 'Advanced' ? 'Expert' : 'Intermediate',
      'playback_speed': preferredPlaybackSpeed,
    };
  }
}
