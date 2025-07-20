/// Smart Fragment Cache
/// Intelligent caching system for audio fragments and conversation pieces
library;

import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import '../audio/audio_models.dart';
import '../services/two_speaker_audio_system.dart';

/// Cached audio fragment
class CachedAudioFragment {
  final String id;
  final String textHash;
  final String voiceId;
  final AudioQuality quality;
  final String filePath;
  final int fileSize;
  final Duration duration;
  final DateTime createdAt;
  final DateTime lastAccessed;
  final Map<String, dynamic> metadata;

  const CachedAudioFragment({
    required this.id,
    required this.textHash,
    required this.voiceId,
    required this.quality,
    required this.filePath,
    required this.fileSize,
    required this.duration,
    required this.createdAt,
    required this.lastAccessed,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'textHash': textHash,
    'voiceId': voiceId,
    'quality': quality.name,
    'filePath': filePath,
    'fileSize': fileSize,
    'duration': duration.inMilliseconds,
    'createdAt': createdAt.toIso8601String(),
    'lastAccessed': lastAccessed.toIso8601String(),
    'metadata': metadata,
  };

  factory CachedAudioFragment.fromJson(Map<String, dynamic> json) {
    return CachedAudioFragment(
      id: json['id'] as String,
      textHash: json['textHash'] as String,
      voiceId: json['voiceId'] as String,
      quality: AudioQuality.values.firstWhere(
        (e) => e.name == json['quality'],
        orElse: () => AudioQuality.medium,
      ),
      filePath: json['filePath'] as String,
      fileSize: json['fileSize'] as int,
      duration: Duration(milliseconds: json['duration'] as int),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

/// Cache statistics and metrics
class CacheStats {
  final int totalFragments;
  final int hitCount;
  final int missCount;
  final double hitRate;
  final int totalSizeBytes;
  final Duration totalDuration;

  const CacheStats({
    required this.totalFragments,
    required this.hitCount,
    required this.missCount,
    required this.hitRate,
    required this.totalSizeBytes,
    required this.totalDuration,
  });

  Map<String, dynamic> toJson() => {
    'totalFragments': totalFragments,
    'hitCount': hitCount,
    'missCount': missCount,
    'hitRate': hitRate,
    'totalSizeBytes': totalSizeBytes,
    'totalDuration': totalDuration.inMilliseconds,
  };
}

/// Smart caching system for audio fragments
class SmartFragmentCache {
  static const String _cacheFileName = 'smart_fragment_cache.json';
  static const int _maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const Duration _maxAge = Duration(days: 30);

  static final Map<String, CachedAudioFragment> _cache = {};
  static int _hitCount = 0;
  static int _missCount = 0;

  /// Initialize the cache system
  static Future<void> initialize() async {
    await _loadCacheFromDisk();
    await _cleanupExpiredFragments();
  }

  /// Generate cache key for text and voice configuration
  static String _generateCacheKey({
    required String text,
    required VoiceConfiguration voiceConfig,
    required AudioQuality quality,
  }) {
    final input = '$text|${voiceConfig.voiceId}|${quality.name}';
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Check if fragment is cached and valid
  static Future<CachedAudioFragment?> getFragment({
    required String text,
    required VoiceConfiguration voiceConfig,
    required AudioQuality quality,
  }) async {
    final key = _generateCacheKey(
      text: text,
      voiceConfig: voiceConfig,
      quality: quality,
    );

    final fragment = _cache[key];
    if (fragment != null) {
      // Check if file still exists
      final file = File(fragment.filePath);
      if (await file.exists()) {
        // Update last accessed time
        final updatedFragment = CachedAudioFragment(
          id: fragment.id,
          textHash: fragment.textHash,
          voiceId: fragment.voiceId,
          quality: fragment.quality,
          filePath: fragment.filePath,
          fileSize: fragment.fileSize,
          duration: fragment.duration,
          createdAt: fragment.createdAt,
          lastAccessed: DateTime.now(),
          metadata: fragment.metadata,
        );
        
        _cache[key] = updatedFragment;
        _hitCount++;
        await _saveCacheToDisk();
        return updatedFragment;
      } else {
        // Remove invalid cache entry
        _cache.remove(key);
        await _saveCacheToDisk();
      }
    }

    _missCount++;
    return null;
  }

  /// Store generated audio fragment in cache
  static Future<void> storeFragment({
    required String text,
    required VoiceConfiguration voiceConfig,
    required AudioQuality quality,
    required String audioFilePath,
    required Duration duration,
  }) async {
    final key = _generateCacheKey(
      text: text,
      voiceConfig: voiceConfig,
      quality: quality,
    );

    final file = File(audioFilePath);
    if (!await file.exists()) {
      return; // Cannot cache non-existent file
    }

    final fileSize = await file.length();
    final now = DateTime.now();

    final fragment = CachedAudioFragment(
      id: key,
      textHash: key,
      voiceId: voiceConfig.voiceId,
      quality: quality,
      filePath: audioFilePath,
      fileSize: fileSize,
      duration: duration,
      createdAt: now,
      lastAccessed: now,
      metadata: {
        'personality': voiceConfig.personality,
        'speakerId': voiceConfig.speakerId,
      },
    );

    _cache[key] = fragment;
    await _saveCacheToDisk();
    await _enforceCacheSize();
  }

  /// Get cache statistics
  static CacheStats getStats() {
    final totalSize = _cache.values.fold(0, (sum, fragment) => sum + fragment.fileSize);
    final totalDuration = _cache.values.fold(
      Duration.zero,
      (sum, fragment) => sum + fragment.duration,
    );
    final totalAccesses = _hitCount + _missCount;
    final hitRate = totalAccesses > 0 ? _hitCount / totalAccesses : 0.0;

    return CacheStats(
      totalFragments: _cache.length,
      hitCount: _hitCount,
      missCount: _missCount,
      hitRate: hitRate,
      totalSizeBytes: totalSize,
      totalDuration: totalDuration,
    );
  }

  /// Clear all cached fragments
  static Future<void> clearCache() async {
    // Delete all cached files
    for (final fragment in _cache.values) {
      final file = File(fragment.filePath);
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (e) {
          print('Failed to delete cached file: ${fragment.filePath}, Error: $e');
        }
      }
    }

    _cache.clear();
    _hitCount = 0;
    _missCount = 0;
    await _saveCacheToDisk();
  }

  /// Load cache metadata from disk
  static Future<void> _loadCacheFromDisk() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_cacheFileName');
      
      if (await file.exists()) {
        final jsonStr = await file.readAsString();
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;
        
        final fragments = data['fragments'] as Map<String, dynamic>? ?? {};
        for (final entry in fragments.entries) {
          final fragment = CachedAudioFragment.fromJson(
            entry.value as Map<String, dynamic>,
          );
          _cache[entry.key] = fragment;
        }
        
        _hitCount = data['hitCount'] as int? ?? 0;
        _missCount = data['missCount'] as int? ?? 0;
      }
    } catch (e) {
      print('Failed to load cache from disk: $e');
      _cache.clear();
    }
  }

  /// Save cache metadata to disk
  static Future<void> _saveCacheToDisk() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_cacheFileName');
      
      final data = {
        'fragments': _cache.map((key, fragment) => MapEntry(key, fragment.toJson())),
        'hitCount': _hitCount,
        'missCount': _missCount,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print('Failed to save cache to disk: $e');
    }
  }

  /// Remove expired fragments from cache
  static Future<void> _cleanupExpiredFragments() async {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    for (final entry in _cache.entries) {
      final fragment = entry.value;
      if (now.difference(fragment.lastAccessed) > _maxAge) {
        expiredKeys.add(entry.key);
      }
    }
    
    for (final key in expiredKeys) {
      final fragment = _cache[key];
      if (fragment != null) {
        // Delete the cached file
        final file = File(fragment.filePath);
        if (await file.exists()) {
          try {
            await file.delete();
          } catch (e) {
            print('Failed to delete expired cached file: ${fragment.filePath}');
          }
        }
        _cache.remove(key);
      }
    }
    
    if (expiredKeys.isNotEmpty) {
      await _saveCacheToDisk();
    }
  }

  /// Enforce cache size limits
  static Future<void> _enforceCacheSize() async {
    final totalSize = _cache.values.fold(0, (sum, fragment) => sum + fragment.fileSize);
    
    if (totalSize > _maxCacheSize) {
      // Sort by last accessed time (oldest first)
      final sortedEntries = _cache.entries.toList()
        ..sort((a, b) => a.value.lastAccessed.compareTo(b.value.lastAccessed));
      
      int sizeToRemove = totalSize - _maxCacheSize;
      final keysToRemove = <String>[];
      
      for (final entry in sortedEntries) {
        if (sizeToRemove <= 0) break;
        
        keysToRemove.add(entry.key);
        sizeToRemove -= entry.value.fileSize;
      }
      
      for (final key in keysToRemove) {
        final fragment = _cache[key];
        if (fragment != null) {
          // Delete the cached file
          final file = File(fragment.filePath);
          if (await file.exists()) {
            try {
              await file.delete();
            } catch (e) {
              print('Failed to delete cached file during cleanup: ${fragment.filePath}');
            }
          }
          _cache.remove(key);
        }
      }
      
      await _saveCacheToDisk();
    }
  }
}
