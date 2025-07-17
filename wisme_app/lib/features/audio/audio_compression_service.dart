import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

/// Audio Compression Service
/// Handles real-time audio compression and optimization
class AudioCompressionService {
  static final AudioCompressionService _instance = AudioCompressionService._internal();
  factory AudioCompressionService() => _instance;
  AudioCompressionService._internal();

  static const platform = MethodChannel('com.wisme.audio_compression');
  
  late Directory _compressedDirectory;
  bool _isInitialized = false;

  /// Quality presets for audio compression
  static const Map<String, CompressionSettings> qualityPresets = {
    'ultra': CompressionSettings(
      bitrate: 320,
      sampleRate: 48000,
      channels: 2,
      quality: 'ultra',
      fileExtension: 'mp3',
    ),
    'high': CompressionSettings(
      bitrate: 192,
      sampleRate: 44100,
      channels: 2,
      quality: 'high',
      fileExtension: 'mp3',
    ),
    'medium': CompressionSettings(
      bitrate: 128,
      sampleRate: 44100,
      channels: 2,
      quality: 'medium',
      fileExtension: 'mp3',
    ),
    'low': CompressionSettings(
      bitrate: 96,
      sampleRate: 22050,
      channels: 1,
      quality: 'low',
      fileExtension: 'mp3',
    ),
    'voice': CompressionSettings(
      bitrate: 64,
      sampleRate: 16000,
      channels: 1,
      quality: 'voice',
      fileExtension: 'mp3',
    ),
  };

  /// Initialize compression service
  Future<void> initialize() async {
    if (_isInitialized) return;

    final appDir = await getApplicationDocumentsDirectory();
    _compressedDirectory = Directory('${appDir.path}/compressed_audio');

    if (!await _compressedDirectory.exists()) {
      await _compressedDirectory.create(recursive: true);
    }

    _isInitialized = true;
  }

  /// Compress audio file
  Future<CompressionResult> compressAudio({
    required String inputPath,
    required String outputPath,
    CompressionSettings? settings,
    Function(double)? onProgress,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      settings ??= qualityPresets['medium']!;

      final result = await platform.invokeMethod('compressAudio', {
        'inputPath': inputPath,
        'outputPath': outputPath,
        'bitrate': settings.bitrate,
        'sampleRate': settings.sampleRate,
        'channels': settings.channels,
        'quality': settings.quality,
      });

      if (result['success'] == true) {
        final originalSize = File(inputPath).lengthSync();
        final compressedSize = File(outputPath).lengthSync();
        
        return CompressionResult(
          success: true,
          originalSize: originalSize,
          compressedSize: compressedSize,
          compressionRatio: (compressedSize / originalSize),
          outputPath: outputPath,
          duration: Duration(milliseconds: result['duration'] ?? 0),
          settings: settings,
        );
      } else {
        return CompressionResult(
          success: false,
          error: result['error'] ?? 'Unknown compression error',
        );
      }
    } catch (e) {
      return CompressionResult(
        success: false,
        error: 'Compression failed: $e',
      );
    }
  }

  /// Compress audio with streaming support
  Future<CompressionResult> compressAudioStreaming({
    required String inputPath,
    required String outputPath,
    CompressionSettings? settings,
    Function(double)? onProgress,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      settings ??= qualityPresets['medium']!;

      // Set up progress listener
      final progressChannel = MethodChannel('com.wisme.audio_compression.progress');
      progressChannel.setMethodCallHandler((call) async {
        if (call.method == 'onProgress') {
          final progress = call.arguments['progress'] as double;
          onProgress?.call(progress);
        }
      });

      final result = await platform.invokeMethod('compressAudioStreaming', {
        'inputPath': inputPath,
        'outputPath': outputPath,
        'bitrate': settings.bitrate,
        'sampleRate': settings.sampleRate,
        'channels': settings.channels,
        'quality': settings.quality,
        'enableProgress': onProgress != null,
      });

      if (result['success'] == true) {
        final originalSize = File(inputPath).lengthSync();
        final compressedSize = File(outputPath).lengthSync();
        
        return CompressionResult(
          success: true,
          originalSize: originalSize,
          compressedSize: compressedSize,
          compressionRatio: (compressedSize / originalSize),
          outputPath: outputPath,
          duration: Duration(milliseconds: result['duration'] ?? 0),
          settings: settings,
        );
      } else {
        return CompressionResult(
          success: false,
          error: result['error'] ?? 'Unknown compression error',
        );
      }
    } catch (e) {
      return CompressionResult(
        success: false,
        error: 'Streaming compression failed: $e',
      );
    }
  }

  /// Batch compress multiple audio files
  Future<List<CompressionResult>> batchCompressAudio({
    required List<String> inputPaths,
    required List<String> outputPaths,
    CompressionSettings? settings,
    Function(int, int)? onProgress,
  }) async {
    if (inputPaths.length != outputPaths.length) {
      throw ArgumentError('Input and output paths must have the same length');
    }

    final results = <CompressionResult>[];
    
    for (int i = 0; i < inputPaths.length; i++) {
      try {
        final result = await compressAudio(
          inputPath: inputPaths[i],
          outputPath: outputPaths[i],
          settings: settings,
        );
        results.add(result);
        onProgress?.call(i + 1, inputPaths.length);
      } catch (e) {
        results.add(CompressionResult(
          success: false,
          error: 'Batch compression failed for ${inputPaths[i]}: $e',
        ));
      }
    }

    return results;
  }

  /// Get optimal compression settings based on content type
  CompressionSettings getOptimalSettings({
    required AudioContentType contentType,
    required NetworkSpeed networkSpeed,
    required StorageSpace storageSpace,
  }) {
    // Voice content (podcasts, lectures)
    if (contentType == AudioContentType.voice) {
      switch (networkSpeed) {
        case NetworkSpeed.slow:
          return qualityPresets['voice']!;
        case NetworkSpeed.medium:
          return qualityPresets['low']!;
        case NetworkSpeed.fast:
          return qualityPresets['medium']!;
      }
    }

    // Music content (background music, sound effects)
    if (contentType == AudioContentType.music) {
      if (storageSpace == StorageSpace.limited) {
        return qualityPresets['medium']!;
      }
      
      switch (networkSpeed) {
        case NetworkSpeed.slow:
          return qualityPresets['medium']!;
        case NetworkSpeed.medium:
          return qualityPresets['high']!;
        case NetworkSpeed.fast:
          return qualityPresets['ultra']!;
      }
    }

    // Mixed content (episodes with music and voice)
    return qualityPresets['medium']!;
  }

  /// Analyze audio file properties
  Future<AudioAnalysis> analyzeAudio(String filePath) async {
    try {
      final result = await platform.invokeMethod('analyzeAudio', {
        'filePath': filePath,
      });

      return AudioAnalysis(
        duration: Duration(milliseconds: result['duration'] ?? 0),
        bitrate: result['bitrate'] ?? 0,
        sampleRate: result['sampleRate'] ?? 0,
        channels: result['channels'] ?? 0,
        fileSize: result['fileSize'] ?? 0,
        format: result['format'] ?? 'unknown',
        hasVoice: result['hasVoice'] ?? false,
        hasMusic: result['hasMusic'] ?? false,
        averageVolume: result['averageVolume'] ?? 0.0,
        peakVolume: result['peakVolume'] ?? 0.0,
      );
    } catch (e) {
      throw Exception('Audio analysis failed: $e');
    }
  }

  /// Optimize audio for specific use case
  Future<CompressionResult> optimizeAudio({
    required String inputPath,
    required String outputPath,
    required AudioOptimization optimization,
    Function(double)? onProgress,
  }) async {
    CompressionSettings settings;

    switch (optimization) {
      case AudioOptimization.backgroundPlayback:
        settings = qualityPresets['medium']!;
        break;
      case AudioOptimization.offlineStorage:
        settings = qualityPresets['low']!;
        break;
      case AudioOptimization.streaming:
        settings = qualityPresets['voice']!;
        break;
      case AudioOptimization.highQuality:
        settings = qualityPresets['high']!;
        break;
      case AudioOptimization.ultraQuality:
        settings = qualityPresets['ultra']!;
        break;
    }

    return await compressAudioStreaming(
      inputPath: inputPath,
      outputPath: outputPath,
      settings: settings,
      onProgress: onProgress,
    );
  }

  /// Get compression statistics
  Future<CompressionStats> getCompressionStats() async {
    try {
      final result = await platform.invokeMethod('getCompressionStats');
      
      return CompressionStats(
        totalFilesCompressed: result['totalFilesCompressed'] ?? 0,
        totalOriginalSize: result['totalOriginalSize'] ?? 0,
        totalCompressedSize: result['totalCompressedSize'] ?? 0,
        averageCompressionRatio: result['averageCompressionRatio'] ?? 0.0,
        totalCompressionTime: Duration(milliseconds: result['totalCompressionTime'] ?? 0),
      );
    } catch (e) {
      return CompressionStats(
        totalFilesCompressed: 0,
        totalOriginalSize: 0,
        totalCompressedSize: 0,
        averageCompressionRatio: 0.0,
        totalCompressionTime: Duration.zero,
      );
    }
  }

  /// Clear compression cache
  Future<void> clearCompressionCache() async {
    try {
      if (await _compressedDirectory.exists()) {
        await _compressedDirectory.delete(recursive: true);
        await _compressedDirectory.create(recursive: true);
      }
    } catch (e) {
      print('Error clearing compression cache: $e');
    }
  }
}

/// Compression settings model
class CompressionSettings {
  final int bitrate;
  final int sampleRate;
  final int channels;
  final String quality;
  final String fileExtension;

  const CompressionSettings({
    required this.bitrate,
    required this.sampleRate,
    required this.channels,
    required this.quality,
    required this.fileExtension,
  });
}

/// Compression result model
class CompressionResult {
  final bool success;
  final int originalSize;
  final int compressedSize;
  final double compressionRatio;
  final String outputPath;
  final Duration duration;
  final CompressionSettings? settings;
  final String? error;

  CompressionResult({
    required this.success,
    this.originalSize = 0,
    this.compressedSize = 0,
    this.compressionRatio = 0.0,
    this.outputPath = '',
    this.duration = Duration.zero,
    this.settings,
    this.error,
  });

  double get spacesSaved => originalSize - compressedSize.toDouble();
  double get compressionPercentage => (1 - compressionRatio) * 100;
}

/// Audio analysis model
class AudioAnalysis {
  final Duration duration;
  final int bitrate;
  final int sampleRate;
  final int channels;
  final int fileSize;
  final String format;
  final bool hasVoice;
  final bool hasMusic;
  final double averageVolume;
  final double peakVolume;

  AudioAnalysis({
    required this.duration,
    required this.bitrate,
    required this.sampleRate,
    required this.channels,
    required this.fileSize,
    required this.format,
    required this.hasVoice,
    required this.hasMusic,
    required this.averageVolume,
    required this.peakVolume,
  });

  AudioContentType get contentType {
    if (hasVoice && !hasMusic) return AudioContentType.voice;
    if (hasMusic && !hasVoice) return AudioContentType.music;
    return AudioContentType.mixed;
  }
}

/// Compression statistics model
class CompressionStats {
  final int totalFilesCompressed;
  final int totalOriginalSize;
  final int totalCompressedSize;
  final double averageCompressionRatio;
  final Duration totalCompressionTime;

  CompressionStats({
    required this.totalFilesCompressed,
    required this.totalOriginalSize,
    required this.totalCompressedSize,
    required this.averageCompressionRatio,
    required this.totalCompressionTime,
  });

  double get totalSpaceSaved => totalOriginalSize - totalCompressedSize.toDouble();
  double get totalCompressionPercentage => (1 - averageCompressionRatio) * 100;
}

/// Enums for compression options
enum AudioContentType { voice, music, mixed }
enum NetworkSpeed { slow, medium, fast }
enum StorageSpace { limited, moderate, abundant }
enum AudioOptimization { 
  backgroundPlayback, 
  offlineStorage, 
  streaming, 
  highQuality, 
  ultraQuality 
}
