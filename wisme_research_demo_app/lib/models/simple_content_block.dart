// Simple Content Block Model for Demo App
// Minimal model focused on local audio playback

class SimpleContentBlock {
  final String id;
  final String title;
  final String description;
  final Duration duration;
  final String localAudioPath;
  final String journey;
  final int episode;
  final String category;
  final String difficulty;
  final List<String> topics;
  final String? transcript;
  final DateTime createdAt;

  const SimpleContentBlock({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.localAudioPath,
    required this.journey,
    required this.episode,
    required this.category,
    required this.difficulty,
    required this.topics,
    this.transcript,
    required this.createdAt,
  });

  /// Create content block from episode data
  factory SimpleContentBlock.fromEpisode({
    required String journey,
    required int episode,
    required String title,
    required String description,
    required Duration duration,
    required String category,
    required String difficulty,
    required List<String> topics,
    String? transcript,
  }) {
    return SimpleContentBlock(
      id: '${journey}_episode_$episode',
      title: title,
      description: description,
      duration: duration,
      localAudioPath: 'assets/audio/learning_journeys/$journey/episode_$episode/audio.mp3',
      journey: journey,
      episode: episode,
      category: category,
      difficulty: difficulty,
      topics: topics,
      transcript: transcript,
      createdAt: DateTime.now(),
    );
  }

  /// Create from JSON
  factory SimpleContentBlock.fromJson(Map<String, dynamic> json) {
    return SimpleContentBlock(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: Duration(seconds: json['duration_seconds']),
      localAudioPath: json['local_audio_path'],
      journey: json['journey'],
      episode: json['episode'],
      category: json['category'],
      difficulty: json['difficulty'],
      topics: List<String>.from(json['topics']),
      transcript: json['transcript'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration_seconds': duration.inSeconds,
      'local_audio_path': localAudioPath,
      'journey': journey,
      'episode': episode,
      'category': category,
      'difficulty': difficulty,
      'topics': topics,
      'transcript': transcript,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Get formatted duration (e.g., "8:30")
  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get episode identifier
  String get episodeId => 'Episode $episode';

  /// Check if audio path is valid
  bool get isValidAudioPath {
    final validPattern = RegExp(r'^assets/audio/learning_journeys/[a-z_]+/episode_\d+/audio\.mp3$');
    return validPattern.hasMatch(localAudioPath);
  }

  /// Copy with modifications
  SimpleContentBlock copyWith({
    String? id,
    String? title,
    String? description,
    Duration? duration,
    String? localAudioPath,
    String? journey,
    int? episode,
    String? category,
    String? difficulty,
    List<String>? topics,
    String? transcript,
    DateTime? createdAt,
  }) {
    return SimpleContentBlock(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      localAudioPath: localAudioPath ?? this.localAudioPath,
      journey: journey ?? this.journey,
      episode: episode ?? this.episode,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      topics: topics ?? this.topics,
      transcript: transcript ?? this.transcript,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'SimpleContentBlock(id: $id, title: $title, journey: $journey, episode: $episode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SimpleContentBlock && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
