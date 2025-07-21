/// Two Speaker Audio Provider
/// Manages state for two-speaker conversation audio system
library;

import 'package:flutter/foundation.dart';

/// Provider for managing two-speaker audio state
class TwoSpeakerAudioProvider extends ChangeNotifier {
  bool _isTwoSpeakerMode = true;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String? _currentEpisodeId;

  // Getters
  bool get isTwoSpeakerMode => _isTwoSpeakerMode;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  String? get currentEpisodeId => _currentEpisodeId;

  /// Toggle two-speaker mode
  void toggleTwoSpeakerMode() {
    _isTwoSpeakerMode = !_isTwoSpeakerMode;
    notifyListeners();
  }

  /// Set playing state
  void setPlaying(bool playing) {
    _isPlaying = playing;
    notifyListeners();
  }

  /// Update position
  void updatePosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  /// Update duration
  void updateDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  /// Set current episode
  void setCurrentEpisode(String episodeId) {
    _currentEpisodeId = episodeId;
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _isPlaying = false;
    _position = Duration.zero;
    _duration = Duration.zero;
    _currentEpisodeId = null;
    notifyListeners();
  }
}
