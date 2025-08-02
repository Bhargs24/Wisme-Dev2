/// Audio Storage Service
/// Handles saving, loading, and managing audio files on device
library;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AudioStorage {
  static const String _audioDirectoryName = 'wisme_audio';
  static const String _episodeDirectoryName = 'episodes';
  static const String _fragmentDirectoryName = 'fragments';

  /// Save audio file to device storage
  static Future<String> saveAudioFile({
    required Uint8List audioBytes,
    required String filename,
    String? subdirectory,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${directory.path}/$_audioDirectoryName${subdirectory != null ? '/$subdirectory' : ''}');
      
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }
      
      final file = File('${audioDir.path}/$filename.mp3');
      await file.writeAsBytes(audioBytes);
      
      print('Audio saved: ${file.path} (${audioBytes.length} bytes)');
      return file.path;
    } catch (e) {
      print('Error saving audio file: $e');
      rethrow;
    }
  }

  /// Save episode audio with metadata
  static Future<Map<String, dynamic>> saveEpisodeAudio({
    required Uint8List audioBytes,
    required String episodeId,
    Map<String, dynamic>? metadata,
  }) async {
    final filename = 'episode_$episodeId';
    final audioPath = await saveAudioFile(
      audioBytes: audioBytes,
      filename: filename,
      subdirectory: _episodeDirectoryName,
    );

    // Save metadata if provided
    if (metadata != null) {
      await _saveMetadata(audioPath, metadata);
    }

    return {
      'audioPath': audioPath,
      'filename': '$filename.mp3',
      'size': audioBytes.length,
      'savedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Save fragment audio for caching
  static Future<String> saveFragmentAudio({
    required Uint8List audioBytes,
    required String content,
    required String speakerId,
    required String category,
  }) async {
    // Generate unique filename based on content hash
    final contentHash = _generateContentHash(content, speakerId, category);
    final filename = 'fragment_$contentHash';
    
    return await saveAudioFile(
      audioBytes: audioBytes,
      filename: filename,
      subdirectory: _fragmentDirectoryName,
    );
  }

  /// Check if audio file exists
  static Future<bool> audioFileExists(String filePath) async {
    try {
      return await File(filePath).exists();
    } catch (e) {
      print('Error checking file existence: $e');
      return false;
    }
  }

  /// Get audio file size
  static Future<int> getAudioFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      print('Error getting file size: $e');
      return 0;
    }
  }

  /// Delete audio file
  static Future<void> deleteAudioFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print('Audio file deleted: $filePath');
      }
    } catch (e) {
      print('Error deleting audio file: $e');
    }
  }

  /// Get all episode audio files
  static Future<List<String>> getEpisodeAudioFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final episodeDir = Directory('${directory.path}/$_audioDirectoryName/$_episodeDirectoryName');
      
      if (!await episodeDir.exists()) {
        return [];
      }

      final files = await episodeDir.list().toList();
      return files
          .where((file) => file is File && file.path.endsWith('.mp3'))
          .map((file) => file.path)
          .toList();
    } catch (e) {
      print('Error getting episode files: $e');
      return [];
    }
  }

  /// Get total storage used by audio files
  static Future<int> getTotalStorageUsed() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${directory.path}/$_audioDirectoryName');
      
      if (!await audioDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      await for (final entity in audioDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.mp3')) {
          totalSize += await entity.length();
        }
      }
      
      return totalSize;
    } catch (e) {
      print('Error calculating storage usage: $e');
      return 0;
    }
  }

  /// Clean up old audio files (keep last N episodes)
  static Future<void> cleanupOldFiles({int keepRecentEpisodes = 50}) async {
    try {
      final files = await getEpisodeAudioFiles();
      
      if (files.length > keepRecentEpisodes) {
        // Sort by modification time, keep most recent
        final fileStats = <MapEntry<String, DateTime>>[];
        
        for (final filePath in files) {
          final file = File(filePath);
          final stats = await file.stat();
          fileStats.add(MapEntry(filePath, stats.modified));
        }
        
        fileStats.sort((a, b) => b.value.compareTo(a.value));
        
        // Delete older files
        for (int i = keepRecentEpisodes; i < fileStats.length; i++) {
          await deleteAudioFile(fileStats[i].key);
        }
        
        print('Cleaned up ${fileStats.length - keepRecentEpisodes} old audio files');
      }
    } catch (e) {
      print('Error during cleanup: $e');
    }
  }

  /// Generate content hash for fragment identification
  static String _generateContentHash(String content, String speakerId, String category) {
    final combined = '$content|$speakerId|$category';
    final bytes = utf8.encode(combined);
    final hash = sha256.convert(bytes);
    return hash.toString().substring(0, 16); // Use first 16 characters
  }

  /// Save metadata for audio file
  static Future<void> _saveMetadata(String audioPath, Map<String, dynamic> metadata) async {
    try {
      final metadataPath = audioPath.replaceAll('.mp3', '_metadata.json');
      final file = File(metadataPath);
      await file.writeAsString(jsonEncode(metadata));
    } catch (e) {
      print('Error saving metadata: $e');
    }
  }

  /// Load metadata for audio file
  static Future<Map<String, dynamic>?> loadMetadata(String audioPath) async {
    try {
      final metadataPath = audioPath.replaceAll('.mp3', '_metadata.json');
      final file = File(metadataPath);
      
      if (await file.exists()) {
        final content = await file.readAsString();
        return jsonDecode(content);
      }
      return null;
    } catch (e) {
      print('Error loading metadata: $e');
      return null;
    }
  }
}
