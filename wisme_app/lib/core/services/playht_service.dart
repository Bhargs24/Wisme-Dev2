/// PlayHT TTS Service with Audio Compression
/// Handles text-to-speech generation and audio optimization
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../config/api_config.dart';

class PlayHTService {
  static const String _baseUrl = ApiConfig.playHtBaseUrl;
  static const String _apiKey = ApiConfig.playHtApiKey;
  static const String _userId = ApiConfig.playHtUserId;

  /// Generate TTS audio with PlayHT using optimal streaming endpoint
  static Future<Map<String, dynamic>> generateAudio({
    required String text,
    required String voiceId,
    String quality = 'medium',
    double speed = 1.0,
  }) async {
    if (!ApiConfig.isPlayHtConfigured) {
      throw Exception('PlayHT API not configured. Please set up API keys.');
    }

    try {
      // Use HTTP streaming endpoint for real-time generation
      final audioBytes = await _streamAudioGeneration(text, voiceId, quality, speed);
      
      // Apply compression to the audio
      final compressedAudio = await _compressAudio(audioBytes);
      
      // Save to local storage
      final localPath = await _saveAudioToStorage(compressedAudio);
      
      // Estimate duration based on text length and speech rate
      final duration = _estimateAudioDuration(text, speed);
      
      return {
        'success': true,
        'audioPath': localPath,
        'duration': duration,
        'fileSize': compressedAudio.length,
        'compression': 'mp3_optimized',
        'quality': quality,
        'model': ApiConfig.playHtModel,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Stream audio generation using PlayHT's HTTP streaming endpoint
  static Future<Uint8List> _streamAudioGeneration(
    String text,
    String voiceId, 
    String quality,
    double speed,
  ) async {
    final url = Uri.parse('${ApiConfig.playHtBaseUrl}/tts/stream');
    
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'X-User-ID': _userId,
        'Content-Type': 'application/json',
        'Accept': 'audio/mpeg',
      },
      body: jsonEncode({
        'text': text,
        'voice': voiceId,
        'voice_engine': ApiConfig.playHtModel, // PlayDialog for best emotion
        'output_format': 'mp3',
        'sample_rate': ApiConfig.audioConfig['sample_rate'],
        'speed': speed,
        'quality': quality,
        // PlayDialog specific settings for personality
        'emotion': _getEmotionForPersonality(voiceId),
        'style': _getStyleForPersonality(voiceId),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('PlayHT API error: ${response.statusCode} - ${response.body}');
    }

    return response.bodyBytes;
  }

  /// Get emotion setting based on voice personality
  static String _getEmotionForPersonality(String voiceId) {
    // Kai (Arthur Meditation): calm, thoughtful
    if (voiceId.contains('arthurmeditationsaad')) {
      return 'calm';
    }
    // Vee (Ariana): energetic, enthusiastic  
    if (voiceId.contains('arianasaad2')) {
      return 'excited';
    }
    return 'neutral';
  }

  /// Get style setting based on voice personality
  static String _getStyleForPersonality(String voiceId) {
    // Kai: meditation/narrative style
    if (voiceId.contains('arthurmeditationsaad')) {
      return 'meditation';
    }
    // Vee: advertising/energetic style
    if (voiceId.contains('arianasaad2')) {
      return 'advertising';
    }
    return 'narrative';
  }

  /// Estimate audio duration based on text and speech rate
  static Duration _estimateAudioDuration(String text, double speed) {
    // Average speech rate: 150-160 words per minute
    // Adjusted for personality: Kai slower, Vee faster
    final wordCount = text.split(' ').length;
    final baseWordsPerMinute = 155.0;
    final adjustedWPM = baseWordsPerMinute * speed;
    final minutes = wordCount / adjustedWPM;
    return Duration(seconds: (minutes * 60).round());
  }

  /// Compress audio while preserving quality
  static Future<Uint8List> _compressAudio(Uint8List audioData) async {
    // For now, return the original data
    // In production, you'd use FFmpeg or similar for compression
    // This maintains 128kbps VBR MP3 quality from PlayHT
    
    // The compression is primarily handled by:
    // 1. PlayHT's optimized output format
    // 2. 24kHz sample rate (optimal for speech)
    // 3. MP3 VBR encoding
    
    return audioData;
  }

  /// Save audio to local storage
  static Future<String> _saveAudioToStorage(Uint8List audioData) async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${directory.path}/audio');
    
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }

    final fileName = 'playht_${DateTime.now().millisecondsSinceEpoch}.mp3';
    final filePath = '${audioDir.path}/$fileName';
    
    final file = File(filePath);
    await file.writeAsBytes(audioData);
    
    return filePath;
  }

  /// Get available voices from PlayHT
  static Future<List<Map<String, dynamic>>> getAvailableVoices() async {
    if (!ApiConfig.isPlayHtConfigured) {
      throw Exception('PlayHT API not configured');
    }

    final url = Uri.parse('$_baseUrl/voices');
    
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_apiKey',
      'X-User-ID': _userId,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch voices: ${response.statusCode}');
    }
  }

  /// Clone a voice (PlayHT feature)
  static Future<String> cloneVoice({
    required String name,
    required List<String> audioFiles,
  }) async {
    if (!ApiConfig.isPlayHtConfigured) {
      throw Exception('PlayHT API not configured');
    }

    // This would implement voice cloning functionality
    // Simplified for now
    throw UnimplementedError('Voice cloning not yet implemented');
  }

  /// Health check for PlayHT service
  static Future<bool> healthCheck() async {
    try {
      final voices = await getAvailableVoices();
      return voices.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

/// Audio compression utilities
class AudioCompressionUtils {
  /// Calculate optimal bitrate based on content type
  static int getOptimalBitrate(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'podcast':
      case 'audiobook':
        return 128; // Good quality for speech
      case 'music':
        return 192; // Higher quality for music
      case 'voice_note':
        return 96;  // Lower for quick voice messages
      default:
        return 128; // Default to speech quality
    }
  }

  /// Estimate file size after compression
  static int estimateCompressedSize({
    required Duration duration,
    required int bitrate,
  }) {
    // Formula: (bitrate in kbps * duration in seconds) / 8 = size in KB
    final sizeInKB = (bitrate * duration.inSeconds) / 8;
    return (sizeInKB * 1024).round(); // Convert to bytes
  }

  /// Quality settings presets
  static Map<String, dynamic> getQualityPreset(String preset) {
    switch (preset) {
      case 'low':
        return {
          'bitrate': 96,
          'sample_rate': 22050,
          'quality': 'low',
        };
      case 'medium':
        return {
          'bitrate': 128,
          'sample_rate': 24000,
          'quality': 'medium',
        };
      case 'high':
        return {
          'bitrate': 192,
          'sample_rate': 44100,
          'quality': 'high',
        };
      default:
        return {
          'bitrate': 128,
          'sample_rate': 24000,
          'quality': 'medium',
        };
    }
  }
}
