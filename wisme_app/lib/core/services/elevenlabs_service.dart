/// ElevenLabs TTS Service
/// Integrates with ElevenLabs API for high-quality text-to-speech
library;

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config/environment_config.dart';
import '../audio/audio_models.dart';

/// Voice settings for ElevenLabs API
class ElevenLabsVoiceSettings {
  final double stability;
  final double similarityBoost;
  final double style;
  final bool useSpeakerBoost;

  const ElevenLabsVoiceSettings({
    this.stability = 0.5,
    this.similarityBoost = 0.5,
    this.style = 0.0,
    this.useSpeakerBoost = true,
  });

  Map<String, dynamic> toJson() => {
    'stability': stability,
    'similarity_boost': similarityBoost,
    'style': style,
    'use_speaker_boost': useSpeakerBoost,
  };
}

/// ElevenLabs API service for text-to-speech conversion
class ElevenLabsService {
  static const String _baseUrl = 'https://api.elevenlabs.io/v1';
  late final String _apiKey;
  
  ElevenLabsService() {
    _apiKey = EnvironmentConfig.elevenlabsApiKey;
  }

  /// Generate speech from text using specified voice
  Future<Uint8List?> generateSpeech({
    required String text,
    required String voiceId,
    ElevenLabsVoiceSettings? voiceSettings,
  }) async {
    try {
      final settings = voiceSettings ?? const ElevenLabsVoiceSettings();
      
      final response = await http.post(
        Uri.parse('$_baseUrl/text-to-speech/$voiceId'),
        headers: {
          'Accept': 'audio/mpeg',
          'Content-Type': 'application/json',
          'xi-api-key': _apiKey,
        },
        body: jsonEncode({
          'text': text,
          'model_id': 'eleven_multilingual_v1', // Always use the best model
          'voice_settings': settings.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('ElevenLabs API Error: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('ElevenLabs Service Error: $e');
      return null;
    }
  }

  /// Get available voices from ElevenLabs
  Future<List<Map<String, dynamic>>> getVoices() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/voices'),
        headers: {
          'Accept': 'application/json',
          'xi-api-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['voices'] ?? []);
      } else {
        print('ElevenLabs Voices API Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('ElevenLabs Voices Error: $e');
      return [];
    }
  }

  /// Get model ID for quality level
  String _getModelForQuality(AudioQuality quality) {
    switch (quality) {
      case AudioQuality.low:
        return 'eleven_monolingual_v1';
      case AudioQuality.standard:
      case AudioQuality.medium:
        return 'eleven_multilingual_v1';
      case AudioQuality.high:
        return 'eleven_multilingual_v2';
      case AudioQuality.premium:
        return 'eleven_turbo_v2';
    }
  }

  /// Check if service is properly configured
  bool get isConfigured => _apiKey.isNotEmpty;
}
