/// Episode Engagement Model
/// Tracks user interaction and learning metrics for episodes
class EpisodeEngagement {
  final String episodeId;
  final String userId;
  final double completionPercentage;
  final int totalListenTime;
  final int pauseCount;
  final int rewindCount;
  final double averagePlaybackSpeed;
  final bool isBookmarked;
  final int rating; // 1-5 stars
  final DateTime firstPlayedAt;
  final DateTime lastPlayedAt;
  final List<String> notesAndHighlights;

  const EpisodeEngagement({
    required this.episodeId,
    required this.userId,
    this.completionPercentage = 0.0,
    this.totalListenTime = 0,
    this.pauseCount = 0,
    this.rewindCount = 0,
    this.averagePlaybackSpeed = 1.0,
    this.isBookmarked = false,
    this.rating = 0,
    required this.firstPlayedAt,
    required this.lastPlayedAt,
    this.notesAndHighlights = const [],
  });

  factory EpisodeEngagement.fromJson(Map<String, dynamic> json) {
    return EpisodeEngagement(
      episodeId: json['episode_id'],
      userId: json['user_id'],
      completionPercentage: (json['completion_percentage'] ?? 0.0).toDouble(),
      totalListenTime: json['total_listen_time'] ?? 0,
      pauseCount: json['pause_count'] ?? 0,
      rewindCount: json['rewind_count'] ?? 0,
      averagePlaybackSpeed: (json['average_playback_speed'] ?? 1.0).toDouble(),
      isBookmarked: json['is_bookmarked'] ?? false,
      rating: json['rating'] ?? 0,
      firstPlayedAt: DateTime.parse(json['first_played_at']),
      lastPlayedAt: DateTime.parse(json['last_played_at']),
      notesAndHighlights: List<String>.from(json['notes_and_highlights'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'episode_id': episodeId,
      'user_id': userId,
      'completion_percentage': completionPercentage,
      'total_listen_time': totalListenTime,
      'pause_count': pauseCount,
      'rewind_count': rewindCount,
      'average_playback_speed': averagePlaybackSpeed,
      'is_bookmarked': isBookmarked,
      'rating': rating,
      'first_played_at': firstPlayedAt.toIso8601String(),
      'last_played_at': lastPlayedAt.toIso8601String(),
      'notes_and_highlights': notesAndHighlights,
    };
  }

  EpisodeEngagement copyWith({
    String? episodeId,
    String? userId,
    double? completionPercentage,
    int? totalListenTime,
    int? pauseCount,
    int? rewindCount,
    double? averagePlaybackSpeed,
    bool? isBookmarked,
    int? rating,
    DateTime? firstPlayedAt,
    DateTime? lastPlayedAt,
    List<String>? notesAndHighlights,
  }) {
    return EpisodeEngagement(
      episodeId: episodeId ?? this.episodeId,
      userId: userId ?? this.userId,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      totalListenTime: totalListenTime ?? this.totalListenTime,
      pauseCount: pauseCount ?? this.pauseCount,
      rewindCount: rewindCount ?? this.rewindCount,
      averagePlaybackSpeed: averagePlaybackSpeed ?? this.averagePlaybackSpeed,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      rating: rating ?? this.rating,
      firstPlayedAt: firstPlayedAt ?? this.firstPlayedAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      notesAndHighlights: notesAndHighlights ?? this.notesAndHighlights,
    );
  }

  /// Calculate engagement score (0.0 - 1.0)
  double get engagementScore {
    double score = 0.0;
    
    // Completion contributes 40%
    score += completionPercentage * 0.4;
    
    // Rating contributes 30%
    score += (rating / 5.0) * 0.3;
    
    // Interaction quality contributes 20%
    double interactionScore = 0.0;
    if (totalListenTime > 0) {
      // Lower pause rate is better
      interactionScore += (1.0 - (pauseCount / (totalListenTime / 60).clamp(1, double.infinity))) * 0.5;
      // Normal playback speed is preferred
      interactionScore += (averagePlaybackSpeed >= 0.8 && averagePlaybackSpeed <= 1.2 ? 1.0 : 0.5) * 0.5;
    }
    score += interactionScore * 0.2;
    
    // Bookmark adds 10%
    score += (isBookmarked ? 1.0 : 0.0) * 0.1;
    
    return score.clamp(0.0, 1.0);
  }

  /// Check if episode was actively engaged with
  bool get isActivelyEngaged => completionPercentage > 0.1 || totalListenTime > 30 || isBookmarked;
}
