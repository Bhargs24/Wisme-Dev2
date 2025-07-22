/// OpenAI Service
/// Handles interactions with OpenAI API for content generation and processing
library;

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for OpenAI API interactions
class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static String? _apiKey;
  static bool _isConfigured = false;

  /// Initialize the service with API key
  static void initialize(String apiKey) {
    _apiKey = apiKey;
    _isConfigured = true;
  }

  /// Check if service is configured
  static bool get isConfigured => _isConfigured && _apiKey != null;

  /// Generate text using GPT model
  static Future<Map<String, dynamic>> generateText({
    required String prompt,
    String model = 'gpt-3.5-turbo',
    int maxTokens = 1000,
    double temperature = 0.7,
  }) async {
    if (!isConfigured) {
      throw Exception('OpenAI service not configured');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': maxTokens,
          'temperature': temperature,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'text': data['choices'][0]['message']['content'],
          'usage': data['usage'],
        };
      } else {
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Generate embeddings for text
  static Future<Map<String, dynamic>> generateEmbeddings({
    required String text,
    String model = 'text-embedding-ada-002',
  }) async {
    if (!isConfigured) {
      throw Exception('OpenAI service not configured');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/embeddings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': model,
          'input': text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'embeddings': data['data'][0]['embedding'],
          'usage': data['usage'],
        };
      } else {
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Moderate content using OpenAI's moderation API
  static Future<Map<String, dynamic>> moderateContent({
    required String content,
  }) async {
    if (!isConfigured) {
      throw Exception('OpenAI service not configured');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/moderations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'input': content,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'flagged': data['results'][0]['flagged'],
          'categories': data['results'][0]['categories'],
          'categoryScores': data['results'][0]['category_scores'],
        };
      } else {
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}


