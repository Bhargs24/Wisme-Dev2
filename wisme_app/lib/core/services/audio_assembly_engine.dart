/// Audio Assembly Engine
/// Handles seamless stitching of audio fragments into natural conversations
/// Focus: Product quality over technical complexity

import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AudioAssemblyEngine {
  static final AudioAssemblyEngine _instance = AudioAssemblyEngine._internal();
  factory AudioAssemblyEngine() => _instance;
  AudioAssemblyEngine._internal();

  /// Assemble audio fragments into a complete episode
  /// Product Goal: Natural conversation flow without awkward pauses
  Future<String> assembleEpisode({
    required List<AudioFragment> fragments,
    required String episodeId,
  }) async {
    if (fragments.isEmpty) {
      throw ArgumentError('Cannot assemble episode with no fragments');
    }

    final assembledSegments = <Uint8List>[];
    
    for (int i = 0; i < fragments.length; i++) {
      final fragment = fragments[i];
      final nextFragment = i < fragments.length - 1 ? fragments[i + 1] : null;
      
      // Load fragment audio
      final audioData = await _loadFragmentAudio(fragment);
      
      // Apply voice normalization for consistency
      final normalizedAudio = await _normalizeAudioLevel(audioData);
      
      // Add smart transition to next fragment
      if (nextFragment != null) {
        final transition = await _generateSmartTransition(fragment, nextFragment);
        assembledSegments.add(normalizedAudio);
        assembledSegments.add(transition);
      } else {
        // Last fragment - no transition needed
        assembledSegments.add(normalizedAudio);
      }
    }
    
    // Combine all segments
    final finalAudio = await _combineAudioSegments(assembledSegments);
    
    // Save assembled episode
    final outputPath = await _saveAssembledEpisode(finalAudio, episodeId);
    
    return outputPath;
  }

  /// Generate smart transitions between fragments
  /// Product Focus: Natural conversation rhythm
  Future<Uint8List> _generateSmartTransition(
    AudioFragment current, 
    AudioFragment next
  ) async {
    // Different speakers = longer pause for natural conversation flow
    if (current.speakerId != next.speakerId) {
      return await _generateSilence(Duration(milliseconds: 750)); // 0.75s
    }
    
    // Same speaker continuing = shorter pause
    return await _generateSilence(Duration(milliseconds: 350)); // 0.35s
  }

  /// Load audio fragment from storage
  Future<Uint8List> _loadFragmentAudio(AudioFragment fragment) async {
    final file = File(fragment.audioPath);
    if (!await file.exists()) {
      throw FileSystemException('Fragment audio file not found: ${fragment.audioPath}');
    }
    return await file.readAsBytes();
  }

  /// Normalize audio levels across fragments
  /// Product Goal: Consistent volume across speakers
  Future<Uint8List> _normalizeAudioLevel(Uint8List audioData) async {
    // For MVP: Return original audio
    // TODO: Implement actual audio normalization
    // This prevents jarring volume differences between cached fragments
    return audioData;
  }

  /// Generate silence for transitions
  Future<Uint8List> _generateSilence(Duration duration) async {
    // Generate MP3 silence - simplified approach for MVP
    // Standard MP3 silence frame is ~26ms, so calculate frames needed
    final framesNeeded = (duration.inMilliseconds / 26).ceil();
    final silenceSize = framesNeeded * 32; // Approximate bytes per frame
    
    // Create basic silence buffer (simplified for MVP)
    return Uint8List(silenceSize);
  }

  /// Combine multiple audio segments
  Future<Uint8List> _combineAudioSegments(List<Uint8List> segments) async {
    if (segments.isEmpty) return Uint8List(0);
    
    // Calculate total size
    final totalSize = segments.fold<int>(0, (sum, segment) => sum + segment.length);
    
    // Combine segments
    final combined = Uint8List(totalSize);
    int offset = 0;
    
    for (final segment in segments) {
      combined.setRange(offset, offset + segment.length, segment);
      offset += segment.length;
    }
    
    return combined;
  }

  /// Save assembled episode to storage
  Future<String> _saveAssembledEpisode(Uint8List audioData, String episodeId) async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${directory.path}/assembled_episodes');
    
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    
    final file = File('${audioDir.path}/episode_${episodeId}.mp3');
    await file.writeAsBytes(audioData);
    
    return file.path;
  }

  /// Validate fragment quality before assembly
  /// Product Goal: Ensure consistent user experience
  Future<bool> validateFragmentQuality(AudioFragment fragment) async {
    try {
      // Check if file exists
      final file = File(fragment.audioPath);
      if (!await file.exists()) return false;
      
      // Check minimum file size (avoid empty files)
      final stat = await file.stat();
      if (stat.size < 1000) return false; // Less than 1KB probably empty
      
      // Check duration is reasonable
      if (fragment.duration < Duration(seconds: 1) || 
          fragment.duration > Duration(minutes: 3)) {
        return false;
      }
      
      return true;
    } catch (e) {
      print('Fragment validation failed: $e');
      return false;
    }
  }
}

/// Audio Fragment Model
class AudioFragment {
  final String id;
  final String speakerId;
  final String content;
  final String audioPath;
  final Duration duration;
  final DateTime createdAt;
  final String category;
  
  const AudioFragment({
    required this.id,
    required this.speakerId,
    required this.content,
    required this.audioPath,
    required this.duration,
    required this.createdAt,
    required this.category,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'speakerId': speakerId,
    'content': content,
    'audioPath': audioPath,
    'duration': duration.inMilliseconds,
    'createdAt': createdAt.toIso8601String(),
    'category': category,
  };
  
  factory AudioFragment.fromJson(Map<String, dynamic> json) => AudioFragment(
    id: json['id'],
    speakerId: json['speakerId'],
    content: json['content'],
    audioPath: json['audioPath'],
    duration: Duration(milliseconds: json['duration']),
    createdAt: DateTime.parse(json['createdAt']),
    category: json['category'],
  );
}
