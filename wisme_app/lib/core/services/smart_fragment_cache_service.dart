/// Smart Fragment Cache Service
/// Product-focused caching for immediate cost reduction and quality improvement
/// Focus: 30-50% cost reduction in Phase 1, not perfect technical implementation

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'audio_assembly_engine.dart';

class SmartFragmentCacheService {
  static final SmartFragmentCacheService _instance = SmartFragmentCacheService._internal();
  factory SmartFragmentCacheService() => _instance;
  SmartFragmentCacheService._internal();

  late Directory _cacheDirectory;
  late File _fragmentIndexFile;
  Map<String, AudioFragment> _fragmentIndex = {};
  bool _isInitialized = false;

  static const int maxCacheSize = 200 * 1024 * 1024; // 200MB for fragments
  static const int maxFragments = 1000;

  /// Initialize fragment cache
  Future<void> initialize() async {
    if (_isInitialized) return;

    final appDir = await getApplicationDocumentsDirectory();
    _cacheDirectory = Directory('${appDir.path}/fragment_cache');
    _fragmentIndexFile = File('${_cacheDirectory.path}/fragment_index.json');

    if (!await _cacheDirectory.exists()) {
      await _cacheDirectory.create(recursive: true);
    }

    await _loadFragmentIndex();
    _isInitialized = true;
  }

  /// Find reusable fragment for given content and speaker
  /// Product Goal: Immediate cost savings through smart reuse
  Future<AudioFragment?> findReusableFragment({
    required String content,
    required String speakerId,
    required String category,
  }) async {
    if (!_isInitialized) await initialize();

    // 1. Try exact match first (highest confidence)
    final exactMatch = await _findExactMatch(content, speakerId);
    if (exactMatch != null) {
      await _updateFragmentUsage(exactMatch.id);
      return exactMatch;
    }

    // 2. Try common phrases (for generic, reusable content only)
    final commonPhraseMatch = await _findCommonPhraseMatch(content, speakerId);
    if (commonPhraseMatch != null) {
      await _updateFragmentUsage(commonPhraseMatch.id);
      return commonPhraseMatch;
    }

    // No match found
    return null;
  }

  /// Cache new fragment for future reuse
  Future<void> cacheFragment({
    required String content,
    required String speakerId,
    required Uint8List audioData,
    required Duration duration,
    required String category,
  }) async {
    if (!_isInitialized) await initialize();

    final fragmentId = _generateFragmentId(content, speakerId);
    final audioPath = await _saveFragmentAudio(fragmentId, audioData);

    final fragment = AudioFragment(
      id: fragmentId,
      speakerId: speakerId,
      content: content,
      audioPath: audioPath,
      duration: duration,
      createdAt: DateTime.now(),
      category: category,
    );

    _fragmentIndex[fragmentId] = fragment;
    await _saveFragmentIndex();

    // Clean up cache if too large
    await _cleanupCacheIfNeeded();
  }

  /// Find exact content match
  Future<AudioFragment?> _findExactMatch(String content, String speakerId) async {
    final searchKey = _generateFragmentId(content, speakerId);
    final fragment = _fragmentIndex[searchKey];
    
    if (fragment != null && await _validateFragmentExists(fragment)) {
      return fragment;
    }
    return null;
  }

  /// Find common phrases (greetings, transitions, etc.)
  Future<AudioFragment?> _findCommonPhraseMatch(String content, String speakerId) async {
    final commonPhrases = [
      'welcome to',
      'thanks for listening',
      'that\'s a great question',
      'let me explain',
      'for example',
      'in other words',
      'to summarize',
      'what do you think',
    ];

    final lowerContent = content.toLowerCase();
    
    for (final phrase in commonPhrases) {
      if (lowerContent.contains(phrase)) {
        // Look for fragments with this phrase from same speaker
        final matches = _fragmentIndex.values
            .where((f) => f.speakerId == speakerId && 
                         f.content.toLowerCase().contains(phrase))
            .toList();
        
        if (matches.isNotEmpty) {
          final fragment = matches.first;
          if (await _validateFragmentExists(fragment)) {
            return fragment;
          }
        }
      }
    }

    return null;
  }

  /// Extract key words for similarity matching
  List<String> _extractKeyWords(String content) {
    final stopWords = {'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by', 'is', 'are', 'was', 'were', 'be', 'been', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could', 'should'};
    
    return content
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
        .split(' ')
        .where((word) => word.length > 2 && !stopWords.contains(word))
        .toList();
  }

  /// Calculate word-based similarity
  double _calculateWordSimilarity(List<String> words1, List<String> words2) {
    if (words1.isEmpty || words2.isEmpty) return 0.0;
    
    final set1 = Set<String>.from(words1);
    final set2 = Set<String>.from(words2);
    final intersection = set1.intersection(set2);
    final union = set1.union(set2);
    
    // Jaccard similarity
    return intersection.length / union.length;
  }

  /// Generate unique ID for fragment
  String _generateFragmentId(String content, String speakerId) {
    final input = '${content}_${speakerId}';
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16); // First 16 chars for shorter IDs
  }

  /// Save fragment audio to disk
  Future<String> _saveFragmentAudio(String fragmentId, Uint8List audioData) async {
    final file = File('${_cacheDirectory.path}/${fragmentId}.mp3');
    await file.writeAsBytes(audioData);
    return file.path;
  }

  /// Validate fragment file still exists
  Future<bool> _validateFragmentExists(AudioFragment fragment) async {
    final file = File(fragment.audioPath);
    return await file.exists();
  }

  /// Update fragment usage for popularity tracking
  Future<void> _updateFragmentUsage(String fragmentId) async {
    // For MVP: Just update access time
    // TODO: Implement proper usage statistics
    final fragment = _fragmentIndex[fragmentId];
    if (fragment != null) {
      // Update access time in metadata
      print('Fragment ${fragmentId} reused successfully');
    }
  }

  /// Load fragment index from disk
  Future<void> _loadFragmentIndex() async {
    try {
      if (await _fragmentIndexFile.exists()) {
        final content = await _fragmentIndexFile.readAsString();
        final jsonData = json.decode(content) as Map<String, dynamic>;
        
        _fragmentIndex = {};
        for (final entry in jsonData.entries) {
          _fragmentIndex[entry.key] = AudioFragment.fromJson(entry.value);
        }
      }
    } catch (e) {
      print('Error loading fragment index: $e');
      _fragmentIndex = {};
    }
  }

  /// Save fragment index to disk
  Future<void> _saveFragmentIndex() async {
    try {
      final jsonData = <String, dynamic>{};
      for (final entry in _fragmentIndex.entries) {
        jsonData[entry.key] = entry.value.toJson();
      }
      
      await _fragmentIndexFile.writeAsString(json.encode(jsonData));
    } catch (e) {
      print('Error saving fragment index: $e');
    }
  }

  /// Clean up cache when it gets too large
  Future<void> _cleanupCacheIfNeeded() async {
    if (_fragmentIndex.length <= maxFragments) return;

    // Sort by creation date (remove oldest first)
    final sortedFragments = _fragmentIndex.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Remove oldest 20% of fragments
    final removeCount = (_fragmentIndex.length * 0.2).round();
    for (int i = 0; i < removeCount; i++) {
      final fragment = sortedFragments[i];
      
      // Delete audio file
      final file = File(fragment.audioPath);
      if (await file.exists()) {
        await file.delete();
      }
      
      // Remove from index
      _fragmentIndex.remove(fragment.id);
    }

    await _saveFragmentIndex();
    print('Cache cleanup: Removed $removeCount old fragments');
  }

  /// Get cache statistics for monitoring
  Future<Map<String, dynamic>> getCacheStats() async {
    if (!_isInitialized) await initialize();

    final totalFragments = _fragmentIndex.length;
    final totalSize = await _calculateCacheSize();
    
    // Count fragments by speaker
    final speakerCounts = <String, int>{};
    for (final fragment in _fragmentIndex.values) {
      speakerCounts[fragment.speakerId] = (speakerCounts[fragment.speakerId] ?? 0) + 1;
    }

    return {
      'totalFragments': totalFragments,
      'totalSizeMB': (totalSize / (1024 * 1024)).round(),
      'speakerCounts': speakerCounts,
      'oldestFragment': _fragmentIndex.values.isEmpty ? null : 
          _fragmentIndex.values.map((f) => f.createdAt).reduce((a, b) => a.isBefore(b) ? a : b).toIso8601String(),
    };
  }

  /// Calculate total cache size
  Future<int> _calculateCacheSize() async {
    int totalSize = 0;
    
    await for (final entity in _cacheDirectory.list()) {
      if (entity is File && entity.path.endsWith('.mp3')) {
        final stat = await entity.stat();
        totalSize += stat.size;
      }
    }
    
    return totalSize;
  }
}


