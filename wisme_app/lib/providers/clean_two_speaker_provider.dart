/// Clean Two Speaker Audio Provider
/// Provider for managing two-speaker conversational audio experiences
library;

import 'package:flutter/foundation.dart';
import '../core/services/two_speaker_audio_system.dart';
import '../core/audio/audio_models.dart';

/// State for two-speaker audio generation
enum AudioGenerationState {
  idle,
  generating,
  completed,
  error,
}

/// Two-speaker audio provider with personalization
class CleanTwoSpeakerAudioProvider extends ChangeNotifier {
  List<ConversationAudioData> _audioData = [];
  AudioGenerationState _state = AudioGenerationState.idle;
  String? _error;
  double _progress = 0.0;
  
  // User interaction tracking
  final Map<String, int> _userInterests = {};
  final Map<String, double> _categoryEngagement = {};
  
  // Getters
  List<ConversationAudioData> get audioData => List.unmodifiable(_audioData);
  AudioGenerationState get state => _state;
  String? get error => _error;
  double get progress => _progress;
  Map<String, int> get userInterests => Map.unmodifiable(_userInterests);
  Map<String, double> get categoryEngagement => Map.unmodifiable(_categoryEngagement);
  
  bool get isGenerating => _state == AudioGenerationState.generating;
  bool get hasError => _state == AudioGenerationState.error;
  bool get isCompleted => _state == AudioGenerationState.completed;
  
  /// Generate conversational audio experience
  Future<void> generateAudioExperience({
    required String topic,
    required String category,
    required List<Map<String, dynamic>> exchanges,
  }) async {
    try {
      _setState(AudioGenerationState.generating);
      _error = null;
      _progress = 0.0;
      
      // Get optimal speakers for category
      final speakers = TwoSpeakerAudioSystem.getVoicesForCategory(category);
      if (speakers.length < 2) {
        throw Exception('Insufficient speakers available for category: $category');
      }
      
      final primarySpeaker = speakers[0];
      final secondarySpeaker = speakers[1];
      
      // Track user interests
      _trackInterest(topic);
      _trackCategoryEngagement(category);
      
      // Generate conversation audio
      final conversationData = await TwoSpeakerAudioSystem.generateConversation(
        exchanges: exchanges,
        primarySpeaker: primarySpeaker,
        secondarySpeaker: secondarySpeaker,
      );
      
      _audioData = conversationData;
      _progress = 1.0;
      _setState(AudioGenerationState.completed);
      
    } catch (e) {
      _error = e.toString();
      _setState(AudioGenerationState.error);
      rethrow;
    }
  }
  
  /// Clear current audio data
  void clearAudioData() {
    _audioData = [];
    _progress = 0.0;
    _error = null;
    _setState(AudioGenerationState.idle);
  }
  
  /// Set state and notify listeners
  void _setState(AudioGenerationState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }
  
  /// Track user interest in topics
  void _trackInterest(String topic) {
    _userInterests[topic] = (_userInterests[topic] ?? 0) + 1;
    notifyListeners();
  }
  
  /// Track category engagement
  void _trackCategoryEngagement(String category) {
    final currentEngagement = _categoryEngagement[category] ?? 0.5;
    _categoryEngagement[category] = (currentEngagement + 0.1).clamp(0.0, 1.0);
    notifyListeners();
  }
}
