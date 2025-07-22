import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Simplified Local Audio Manager
/// Handles all local audio file operations without Firebase complexity
class LocalAudioManager {
  static const String audioBasePath = 'assets/audio/learning_journeys';
  
  /// Get the complete file path for an episode audio
  static String getEpisodeAudioPath(String journey, int episode) {
    return '$audioBasePath/$journey/episode_$episode/audio.mp3';
  }
  
  /// Check if an audio file exists locally
  static bool audioExists(String path) {
    try {
      return File(path).existsSync();
    } catch (e) {
      return false;
    }
  }
  
  /// Get audio file from app bundle assets
  /// For files included in the app package
  static Future<String> getAssetAudioPath(String journey, int episode) async {
    final directory = await getApplicationDocumentsDirectory();
    final assetPath = '${directory.path}/$audioBasePath/$journey/episode_$episode/audio.mp3';
    return assetPath;
  }
  
  /// Validate audio file and get metadata
  static Future<Map<String, dynamic>?> getAudioMetadata(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) return null;
      
      final stat = await file.stat();
      return {
        'path': path,
        'size': stat.size,
        'modified': stat.modified,
        'exists': true,
      };
    } catch (e) {
      return null;
    }
  }
  
  /// List all available audio files in a journey
  static Future<List<String>> getAvailableEpisodes(String journey) async {
    final episodes = <String>[];
    
    // Check episodes 1-10 (adjust as needed)
    for (int i = 1; i <= 25; i++) {
      final path = getEpisodeAudioPath(journey, i);
      if (audioExists(path)) {
        episodes.add(path);
      }
    }
    
    return episodes;
  }
  
  /// Get all journey names
  static List<String> get availableJourneys => [
    'data_structures_algorithms',
    'operating_systems', 
    'database_fundamentals',
    'financial_markets',
  ];
  
  /// Create episode metadata
  static Map<String, dynamic> createEpisodeMetadata({
    required String journey,
    required int episode,
    required String title,
    required Duration duration,
    required String transcript,
  }) {
    return {
      'journey': journey,
      'episode': episode,
      'title': title,
      'duration_seconds': duration.inSeconds,
      'transcript': transcript,
      'audio_path': getEpisodeAudioPath(journey, episode),
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}

/// Simplified ContentBlock for local-first audio
class SimpleContentBlock {
  final String id;
  final String title;
  final String description;
  final Duration duration;
  final String localAudioPath; // ALWAYS local - no Firebase
  final String journey;
  final int episode;
  final String category;
  final String transcript;
  final List<String> tags;
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
    required this.transcript,
    this.tags = const [],
    required this.createdAt,
  });
  
  /// Check if audio is available locally
  bool get isPlayable => LocalAudioManager.audioExists(localAudioPath);
  
  /// Get formatted duration
  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  /// Factory for creating from episode data
  factory SimpleContentBlock.fromEpisode({
    required String journey,
    required int episode,
    required String title,
    required String description,
    required Duration duration,
    required String transcript,
    required String category,
    List<String> tags = const [],
  }) {
    return SimpleContentBlock(
      id: '${journey}_episode_$episode',
      title: title,
      description: description,
      duration: duration,
      localAudioPath: LocalAudioManager.getEpisodeAudioPath(journey, episode),
      journey: journey,
      episode: episode,
      category: category,
      transcript: transcript,
      tags: tags,
      createdAt: DateTime.now(),
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
      'transcript': transcript,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
    };
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
      transcript: json['transcript'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
