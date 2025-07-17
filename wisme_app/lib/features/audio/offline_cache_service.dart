import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../../../../models/episode.dart';

/// Offline Audio Cache Service
/// Handles downloading, storing, and managing cached audio files
class OfflineAudioCacheService {
  static final OfflineAudioCacheService _instance = OfflineAudioCacheService._internal();
  factory OfflineAudioCacheService() => _instance;
  OfflineAudioCacheService._internal();

  late Directory _cacheDirectory;
  late File _cacheIndexFile;
  Map<String, CacheEntry> _cacheIndex = {};
  bool _isInitialized = false;

  static const int maxCacheSize = 500 * 1024 * 1024; // 500MB
  static const int maxCacheFiles = 50;

  /// Initialize cache service
  Future<void> initialize() async {
    if (_isInitialized) return;

    final appDir = await getApplicationDocumentsDirectory();
    _cacheDirectory = Directory('${appDir.path}/audio_cache');
    _cacheIndexFile = File('${_cacheDirectory.path}/cache_index.json');

    if (!await _cacheDirectory.exists()) {
      await _cacheDirectory.create(recursive: true);
    }

    await _loadCacheIndex();
    _isInitialized = true;
  }

  /// Load cache index from disk
  Future<void> _loadCacheIndex() async {
    try {
      if (await _cacheIndexFile.exists()) {
        final content = await _cacheIndexFile.readAsString();
        final jsonData = json.decode(content) as Map<String, dynamic>;
        
        _cacheIndex = {};
        for (final entry in jsonData.entries) {
          _cacheIndex[entry.key] = CacheEntry.fromJson(entry.value);
        }
      }
    } catch (e) {
      print('Error loading cache index: $e');
      _cacheIndex = {};
    }
  }

  /// Save cache index to disk
  Future<void> _saveCacheIndex() async {
    try {
      final jsonData = <String, dynamic>{};
      for (final entry in _cacheIndex.entries) {
        jsonData[entry.key] = entry.value.toJson();
      }
      
      await _cacheIndexFile.writeAsString(json.encode(jsonData));
    } catch (e) {
      print('Error saving cache index: $e');
    }
  }

  /// Generate cache key for episode
  String _generateCacheKey(Episode episode) {
    final input = '${episode.id}_${episode.title}_${episode.audioUrl}';
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Check if episode is cached
  bool isCached(Episode episode) {
    if (!_isInitialized) return false;
    
    final cacheKey = _generateCacheKey(episode);
    final entry = _cacheIndex[cacheKey];
    
    if (entry == null) return false;
    
    final file = File('${_cacheDirectory.path}/${entry.fileName}');
    return file.existsSync();
  }

  /// Get cached file path for episode
  String? getCachedFilePath(Episode episode) {
    if (!isCached(episode)) return null;
    
    final cacheKey = _generateCacheKey(episode);
    final entry = _cacheIndex[cacheKey];
    
    if (entry == null) return null;
    
    // Update last accessed time
    entry.lastAccessed = DateTime.now();
    _saveCacheIndex();
    
    return '${_cacheDirectory.path}/${entry.fileName}';
  }

  /// Cache episode audio
  Future<bool> cacheEpisode(Episode episode, {
    Function(double)? onProgress,
    Function(String)? onError,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final audioUrl = episode.audioUrl;
      if (audioUrl == null || audioUrl.isEmpty) {
        onError?.call('No audio URL provided');
        return false;
      }

      final cacheKey = _generateCacheKey(episode);
      
      // Check if already cached
      if (isCached(episode)) {
        return true;
      }

      // Clean up cache if needed
      await _cleanupCache();

      // Download audio file
      final response = await http.get(
        Uri.parse(audioUrl),
        headers: {'Accept': 'audio/*'},
      );

      if (response.statusCode != 200) {
        onError?.call('Failed to download audio: ${response.statusCode}');
        return false;
      }

      // Generate file name
      final fileName = '$cacheKey.mp3';
      final filePath = '${_cacheDirectory.path}/$fileName';
      final file = File(filePath);

      // Save audio file
      await file.writeAsBytes(response.bodyBytes);

      // Update cache index
      final cacheEntry = CacheEntry(
        fileName: fileName,
        originalUrl: audioUrl,
        fileSize: response.bodyBytes.length,
        createdAt: DateTime.now(),
        lastAccessed: DateTime.now(),
        episodeId: episode.id ?? '',
        episodeTitle: episode.title,
      );

      _cacheIndex[cacheKey] = cacheEntry;
      await _saveCacheIndex();

      onProgress?.call(1.0);
      return true;
    } catch (e) {
      onError?.call('Error caching episode: $e');
      return false;
    }
  }

  /// Cache multiple episodes
  Future<void> cacheEpisodes(
    List<Episode> episodes, {
    Function(int, int)? onProgress,
    Function(String)? onError,
  }) async {
    for (int i = 0; i < episodes.length; i++) {
      try {
        await cacheEpisode(
          episodes[i],
          onError: onError,
        );
        onProgress?.call(i + 1, episodes.length);
      } catch (e) {
        onError?.call('Error caching episode ${episodes[i].title}: $e');
      }
    }
  }

  /// Remove episode from cache
  Future<bool> removeCachedEpisode(Episode episode) async {
    if (!_isInitialized) return false;

    try {
      final cacheKey = _generateCacheKey(episode);
      final entry = _cacheIndex[cacheKey];
      
      if (entry == null) return false;

      // Delete file
      final file = File('${_cacheDirectory.path}/${entry.fileName}');
      if (await file.exists()) {
        await file.delete();
      }

      // Remove from index
      _cacheIndex.remove(cacheKey);
      await _saveCacheIndex();

      return true;
    } catch (e) {
      print('Error removing cached episode: $e');
      return false;
    }
  }

  /// Clear all cached episodes
  Future<void> clearCache() async {
    if (!_isInitialized) return;

    try {
      // Delete all cache files
      final files = await _cacheDirectory.list().toList();
      for (final file in files) {
        if (file is File && file.path != _cacheIndexFile.path) {
          await file.delete();
        }
      }

      // Clear index
      _cacheIndex.clear();
      await _saveCacheIndex();
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  /// Clean up cache (remove old files if over limits)
  Future<void> _cleanupCache() async {
    if (_cacheIndex.isEmpty) return;

    // Sort by last accessed time (oldest first)
    final sortedEntries = _cacheIndex.entries.toList()
      ..sort((a, b) => a.value.lastAccessed.compareTo(b.value.lastAccessed));

    // Calculate total size
    int totalSize = 0;
    for (final entry in sortedEntries) {
      totalSize += entry.value.fileSize;
    }

    // Remove old files if over limits
    while ((sortedEntries.length > maxCacheFiles || totalSize > maxCacheSize) && 
           sortedEntries.isNotEmpty) {
      final oldestEntry = sortedEntries.removeAt(0);
      
      // Delete file
      final file = File('${_cacheDirectory.path}/${oldestEntry.value.fileName}');
      if (await file.exists()) {
        await file.delete();
      }

      // Remove from index
      _cacheIndex.remove(oldestEntry.key);
      totalSize -= oldestEntry.value.fileSize;
    }

    await _saveCacheIndex();
  }

  /// Get cache statistics
  Future<CacheStats> getCacheStats() async {
    if (!_isInitialized) {
      await initialize();
    }

    int totalSize = 0;
    int fileCount = 0;
    DateTime? oldestAccess;
    DateTime? newestAccess;

    for (final entry in _cacheIndex.values) {
      totalSize += entry.fileSize;
      fileCount++;

      if (oldestAccess == null || entry.lastAccessed.isBefore(oldestAccess)) {
        oldestAccess = entry.lastAccessed;
      }

      if (newestAccess == null || entry.lastAccessed.isAfter(newestAccess)) {
        newestAccess = entry.lastAccessed;
      }
    }

    return CacheStats(
      totalSize: totalSize,
      fileCount: fileCount,
      maxSize: maxCacheSize,
      maxFiles: maxCacheFiles,
      oldestAccess: oldestAccess,
      newestAccess: newestAccess,
    );
  }

  /// Get all cached episodes
  List<CacheEntry> getCachedEpisodes() {
    if (!_isInitialized) return [];
    return _cacheIndex.values.toList();
  }

  /// Pre-cache episodes for offline use
  Future<void> preCacheEpisodes(
    List<Episode> episodes, {
    Function(int, int)? onProgress,
    Function(String)? onError,
  }) async {
    // Sort by priority (e.g., user's learning preferences)
    episodes.sort((a, b) => a.title.compareTo(b.title));

    await cacheEpisodes(
      episodes,
      onProgress: onProgress,
      onError: onError,
    );
  }
}

/// Cache entry model
class CacheEntry {
  final String fileName;
  final String originalUrl;
  final int fileSize;
  final DateTime createdAt;
  DateTime lastAccessed;
  final String episodeId;
  final String episodeTitle;

  CacheEntry({
    required this.fileName,
    required this.originalUrl,
    required this.fileSize,
    required this.createdAt,
    required this.lastAccessed,
    required this.episodeId,
    required this.episodeTitle,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'originalUrl': originalUrl,
      'fileSize': fileSize,
      'createdAt': createdAt.toIso8601String(),
      'lastAccessed': lastAccessed.toIso8601String(),
      'episodeId': episodeId,
      'episodeTitle': episodeTitle,
    };
  }

  factory CacheEntry.fromJson(Map<String, dynamic> json) {
    return CacheEntry(
      fileName: json['fileName'],
      originalUrl: json['originalUrl'],
      fileSize: json['fileSize'],
      createdAt: DateTime.parse(json['createdAt']),
      lastAccessed: DateTime.parse(json['lastAccessed']),
      episodeId: json['episodeId'],
      episodeTitle: json['episodeTitle'],
    );
  }
}

/// Cache statistics model
class CacheStats {
  final int totalSize;
  final int fileCount;
  final int maxSize;
  final int maxFiles;
  final DateTime? oldestAccess;
  final DateTime? newestAccess;

  CacheStats({
    required this.totalSize,
    required this.fileCount,
    required this.maxSize,
    required this.maxFiles,
    this.oldestAccess,
    this.newestAccess,
  });

  double get sizePercentage => (totalSize / maxSize) * 100;
  double get fileCountPercentage => (fileCount / maxFiles) * 100;
  String get formattedSize => _formatBytes(totalSize);
  String get formattedMaxSize => _formatBytes(maxSize);

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
