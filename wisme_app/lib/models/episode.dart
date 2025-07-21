/// Episode Model for Supabase Integration
/// Enhanced with backend persistence capabilities
class Episode {
  final String? id; // Supabase UUID
  final String? userId; // User who owns this episode
  final String title;
  final String content;
  final String category;
  final String knowledgeType;
  final String coachPersonality;
  final int durationMinutes;
  final List<String> hashtags;
  final bool isCompleted;
  final double completionPercentage;
  final bool isFavorited;
  final String? audioUrl;
  final String? transcript;
  final DateTime createdAt;
  final DateTime? lastPlayedAt;

  const Episode({
    this.id,
    this.userId,
    required this.title,
    required this.content,
    required this.category,
    required this.knowledgeType,
    required this.coachPersonality,
    required this.durationMinutes,
    this.hashtags = const [],
    this.isCompleted = false,
    this.completionPercentage = 0.0,
    this.isFavorited = false,
    this.audioUrl,
    this.transcript,
    required this.createdAt,
    this.lastPlayedAt,
  });

  /// Create Episode from Supabase JSON
  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      knowledgeType: json['knowledge_type'] ?? '',
      coachPersonality: json['coach_personality'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      hashtags: List<String>.from(json['hashtags'] ?? []),
      isCompleted: json['is_completed'] ?? false,
      completionPercentage: (json['completion_percentage'] ?? 0.0).toDouble(),
      isFavorited: json['is_favorited'] ?? false,
      audioUrl: json['audio_url'],
      transcript: json['transcript'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      lastPlayedAt: json['last_played_at'] != null 
          ? DateTime.parse(json['last_played_at'])
          : null,
    );
  }

  /// Convert Episode to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      'title': title,
      'content': content,
      'category': category,
      'knowledge_type': knowledgeType,
      'coach_personality': coachPersonality,
      'duration_minutes': durationMinutes,
      'hashtags': hashtags,
      'is_completed': isCompleted,
      'completion_percentage': completionPercentage,
      'is_favorited': isFavorited,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (transcript != null) 'transcript': transcript,
      'created_at': createdAt.toIso8601String(),
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt!.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  Episode copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? category,
    String? knowledgeType,
    String? coachPersonality,
    int? durationMinutes,
    List<String>? hashtags,
    bool? isCompleted,
    double? completionPercentage,
    bool? isFavorited,
    String? audioUrl,
    String? transcript,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
  }) {
    return Episode(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      knowledgeType: knowledgeType ?? this.knowledgeType,
      coachPersonality: coachPersonality ?? this.coachPersonality,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      hashtags: hashtags ?? this.hashtags,
      isCompleted: isCompleted ?? this.isCompleted,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      isFavorited: isFavorited ?? this.isFavorited,
      audioUrl: audioUrl ?? this.audioUrl,
      transcript: transcript ?? this.transcript,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }

  /// Get formatted duration string
  String get formattedDuration {
    if (durationMinutes < 60) {
      return '${durationMinutes}m';
    } else {
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      return '${hours}h ${minutes}m';
    }
  }

  /// Get completion status
  String get completionStatus {
    if (isCompleted) return 'Completed';
    if (completionPercentage > 0) return '${(completionPercentage * 100).toInt()}% Complete';
    return 'Not Started';
  }

  /// Check if episode is partially completed
  bool get isInProgress => completionPercentage > 0 && !isCompleted;

  /// Check if episode uses two-speaker conversation format
  bool get isTwoSpeakerConversation => 
      coachPersonality.toLowerCase().contains('conversation') ||
      coachPersonality.toLowerCase().contains('dialogue') ||
      coachPersonality.toLowerCase().contains('interview');

  /// Get estimated remaining time
  int get remainingMinutes {
    if (isCompleted) return 0;
    return (durationMinutes * (1.0 - completionPercentage)).round();
  }

  @override
  String toString() {
    return 'Episode(id: $id, title: $title, category: $category, completion: ${(completionPercentage * 100).toInt()}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Episode && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
