import 'episode.dart';

/// Learning Journey Model
/// Represents a structured learning path with multiple episodes
class LearningJourney {
  final String? id;
  final String? userId;
  final String title;
  final String description;
  final String category;
  final String knowledgeType;
  final List<String> episodeIds;
  final List<Episode> episodes;
  final bool isCompleted;
  final double completionPercentage;
  final int currentEpisodeIndex;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? rewardBadge;
  final int estimatedDurationMinutes;

  const LearningJourney({
    this.id,
    this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.knowledgeType,
    this.episodeIds = const [],
    this.episodes = const [],
    this.isCompleted = false,
    this.completionPercentage = 0.0,
    this.currentEpisodeIndex = 0,
    required this.createdAt,
    this.completedAt,
    this.rewardBadge,
    this.estimatedDurationMinutes = 0,
  });

  /// Create Journey from Supabase JSON
  factory LearningJourney.fromJson(Map<String, dynamic> json) {
    return LearningJourney(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      knowledgeType: json['knowledge_type'] ?? '',
      episodeIds: List<String>.from(json['episode_ids'] ?? []),
      episodes: [], // Episodes loaded separately
      isCompleted: json['is_completed'] ?? false,
      completionPercentage: (json['completion_percentage'] ?? 0.0).toDouble(),
      currentEpisodeIndex: json['current_episode_index'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'])
          : null,
      rewardBadge: json['reward_badge'],
      estimatedDurationMinutes: json['estimated_duration_minutes'] ?? 0,
    );
  }

  /// Convert Journey to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'knowledge_type': knowledgeType,
      'episode_ids': episodeIds,
      'is_completed': isCompleted,
      'completion_percentage': completionPercentage,
      'current_episode_index': currentEpisodeIndex,
      'created_at': createdAt.toIso8601String(),
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
      if (rewardBadge != null) 'reward_badge': rewardBadge,
      'estimated_duration_minutes': estimatedDurationMinutes,
    };
  }

  /// Create a copy with updated fields
  LearningJourney copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? category,
    String? knowledgeType,
    List<String>? episodeIds,
    List<Episode>? episodes,
    bool? isCompleted,
    double? completionPercentage,
    int? currentEpisodeIndex,
    DateTime? createdAt,
    DateTime? completedAt,
    String? rewardBadge,
    int? estimatedDurationMinutes,
  }) {
    return LearningJourney(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      knowledgeType: knowledgeType ?? this.knowledgeType,
      episodeIds: episodeIds ?? this.episodeIds,
      episodes: episodes ?? this.episodes,
      isCompleted: isCompleted ?? this.isCompleted,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      currentEpisodeIndex: currentEpisodeIndex ?? this.currentEpisodeIndex,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      rewardBadge: rewardBadge ?? this.rewardBadge,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
    );
  }

  /// Get formatted duration string
  String get formattedDuration {
    if (estimatedDurationMinutes < 60) {
      return '${estimatedDurationMinutes}m';
    } else {
      final hours = estimatedDurationMinutes ~/ 60;
      final minutes = estimatedDurationMinutes % 60;
      return '${hours}h ${minutes}m';
    }
  }

  /// Get completion status
  String get completionStatus {
    if (isCompleted) return 'Completed';
    if (completionPercentage > 0) return '${(completionPercentage * 100).toInt()}% Complete';
    return 'Not Started';
  }

  /// Check if journey is in progress
  bool get isInProgress => completionPercentage > 0 && !isCompleted;

  /// Get next episode to play
  Episode? get nextEpisode {
    if (currentEpisodeIndex < episodes.length) {
      return episodes[currentEpisodeIndex];
    }
    return null;
  }

  /// Get current episode
  Episode? get currentEpisode {
    if (currentEpisodeIndex < episodes.length) {
      return episodes[currentEpisodeIndex];
    }
    return null;
  }

  /// Check if journey can advance to next episode
  bool get canAdvanceToNext {
    if (currentEpisodeIndex >= episodes.length) return false;
    final current = episodes[currentEpisodeIndex];
    return current.isCompleted;
  }

  /// Get reward badge icon
  String get rewardIcon {
    switch (rewardBadge) {
      case 'beginner':
        return '🎯';
      case 'intermediate':
        return '🏆';
      case 'advanced':
        return '👑';
      case 'expert':
        return '🔥';
      default:
        return '⭐';
    }
  }

  @override
  String toString() {
    return 'LearningJourney(id: $id, title: $title, completion: ${(completionPercentage * 100).toInt()}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LearningJourney && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
