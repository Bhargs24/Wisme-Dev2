/// ElevenLabs TTS Service - Real API Integration
/// Handles text-to-speech generation using ElevenLabs API
library;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ElevenLabsService {
  static const String _baseUrl = 'https://api.elevenlabs.io/v1';
  
  /// Generate speech from text using ElevenLabs API
  static Future<Map<String, dynamic>> generateSpeech({
    required String text,
    required String voiceId,
    Map<String, dynamic>? voiceSettings,
  }) async {
    if (!ApiConfig.isElevenlabsConfigured) {
      throw Exception('ElevenLabs API not configured. Please set ELEVENLABS_API_KEY in environment.');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/text-to-speech/$voiceId'),
        headers: {
          'Accept': 'audio/mpeg',
          'Content-Type': 'application/json',
          'xi-api-key': ApiConfig.elevenlabsApiKey,
        },
        body: jsonEncode({
          'text': text,
          'model_id': 'eleven_monolingual_v1',
          'voice_settings': voiceSettings ?? {
            'stability': 0.5,
            'similarity_boost': 0.5,
          },
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'audioBytes': response.bodyBytes,
          'contentType': 'audio/mpeg',
          'audioPath': null, // Will be set when saved to storage
        };
      } else {
        print('ElevenLabs API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('ElevenLabs API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('ElevenLabs Service Error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get available voices from ElevenLabs
  static Future<List<Map<String, dynamic>>> getVoices() async {
    if (!ApiConfig.isElevenlabsConfigured) {
      throw Exception('ElevenLabs API not configured');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/voices'),
        headers: {'xi-api-key': ApiConfig.elevenlabsApiKey},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['voices']);
      } else {
        throw Exception('Failed to fetch voices: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching voices: $e');
      rethrow;
    }
  }

  /// Get voice details by ID
  static Future<Map<String, dynamic>?> getVoice(String voiceId) async {
    if (!ApiConfig.isElevenlabsConfigured) {
      throw Exception('ElevenLabs API not configured');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/voices/$voiceId'),
        headers: {'xi-api-key': ApiConfig.elevenlabsApiKey},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch voice: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching voice $voiceId: $e');
      return null;
    }
  }

  /// Check API quota and usage
  static Future<Map<String, dynamic>> getUsage() async {
    if (!ApiConfig.isElevenlabsConfigured) {
      throw Exception('ElevenLabs API not configured');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user'),
        headers: {'xi-api-key': ApiConfig.elevenlabsApiKey},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch usage: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching usage: $e');
      rethrow;
    }
  }
}