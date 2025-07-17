import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../models/episode.dart';

/// Background Audio Service
/// Handles audio playback even when app is in background
class BackgroundAudioService {
  static final BackgroundAudioService _instance = BackgroundAudioService._internal();
  factory BackgroundAudioService() => _instance;
  BackgroundAudioService._internal();

  late AudioPlayer _audioPlayer;
  Episode? _currentEpisode;
  bool _isInitialized = false;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;

  // Listeners
  final List<VoidCallback> _playStateListeners = [];
  final List<Function(Duration)> _positionListeners = [];
  final List<Function(Duration)> _durationListeners = [];
  final List<VoidCallback> _completionListeners = [];

  /// Initialize background audio service
  Future<void> initialize() async {
    if (_isInitialized) return;

    _audioPlayer = AudioPlayer();
    
    // Configure audio session for background playback
    await _configureAudioSession();

    // Set up audio player listeners
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      _notifyPlayStateListeners();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      _notifyPositionListeners(position);
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      _notifyDurationListeners(duration);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _currentPosition = Duration.zero;
      _notifyCompletionListeners();
    });

    _isInitialized = true;
  }

  /// Configure audio session for background playback
  Future<void> _configureAudioSession() async {
    try {
      // Use method channel to configure iOS audio session
      const platform = MethodChannel('com.wisme.background_audio');
      await platform.invokeMethod('configureAudioSession');
    } catch (e) {
      print('Failed to configure audio session: $e');
    }
  }

  /// Load and play episode
  Future<bool> loadAndPlay(Episode episode, {String? audioUrl}) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      _currentEpisode = episode;
      
      if (audioUrl != null && audioUrl.isNotEmpty) {
        // Load from URL
        await _audioPlayer.setSourceUrl(audioUrl);
      } else {
        // Load from local file path if available
        final localPath = episode.audioUrl;
        if (localPath != null && localPath.isNotEmpty) {
          await _audioPlayer.setSourceDeviceFile(localPath);
        } else {
          throw Exception('No audio source available');
        }
      }

      // Start playback
      await _audioPlayer.resume();
      return true;
    } catch (e) {
      print('Error loading episode: $e');
      return false;
    }
  }

  /// Play/Resume audio
  Future<void> play() async {
    if (!_isInitialized) return;
    await _audioPlayer.resume();
  }

  /// Pause audio
  Future<void> pause() async {
    if (!_isInitialized) return;
    await _audioPlayer.pause();
  }

  /// Stop audio
  Future<void> stop() async {
    if (!_isInitialized) return;
    await _audioPlayer.stop();
    _currentPosition = Duration.zero;
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    if (!_isInitialized) return;
    await _audioPlayer.seek(position);
  }

  /// Set playback speed
  Future<void> setPlaybackSpeed(double speed) async {
    if (!_isInitialized) return;
    await _audioPlayer.setPlaybackRate(speed);
  }

  /// Get current playback state
  bool get isPlaying => _isPlaying;
  Episode? get currentEpisode => _currentEpisode;
  Duration get currentPosition => _currentPosition;
  Duration get duration => _duration;

  /// Add listeners
  void addPlayStateListener(VoidCallback listener) {
    _playStateListeners.add(listener);
  }

  void addPositionListener(Function(Duration) listener) {
    _positionListeners.add(listener);
  }

  void addDurationListener(Function(Duration) listener) {
    _durationListeners.add(listener);
  }

  void addCompletionListener(VoidCallback listener) {
    _completionListeners.add(listener);
  }

  /// Remove listeners
  void removePlayStateListener(VoidCallback listener) {
    _playStateListeners.remove(listener);
  }

  void removePositionListener(Function(Duration) listener) {
    _positionListeners.remove(listener);
  }

  void removeDurationListener(Function(Duration) listener) {
    _durationListeners.remove(listener);
  }

  void removeCompletionListener(VoidCallback listener) {
    _completionListeners.remove(listener);
  }

  /// Notify listeners
  void _notifyPlayStateListeners() {
    for (final listener in _playStateListeners) {
      listener();
    }
  }

  void _notifyPositionListeners(Duration position) {
    for (final listener in _positionListeners) {
      listener(position);
    }
  }

  void _notifyDurationListeners(Duration duration) {
    for (final listener in _durationListeners) {
      listener(duration);
    }
  }

  void _notifyCompletionListeners() {
    for (final listener in _completionListeners) {
      listener();
    }
  }

  /// Dispose service
  Future<void> dispose() async {
    if (_isInitialized) {
      await _audioPlayer.dispose();
      _playStateListeners.clear();
      _positionListeners.clear();
      _durationListeners.clear();
      _completionListeners.clear();
      _isInitialized = false;
    }
  }
}

/// Audio Notification Service
/// Handles media controls in notification panel
class AudioNotificationService {
  static final AudioNotificationService _instance = AudioNotificationService._internal();
  factory AudioNotificationService() => _instance;
  AudioNotificationService._internal();

  static const platform = MethodChannel('com.wisme.audio_notification');

  /// Show audio notification
  Future<void> showNotification({
    required String title,
    required String artist,
    required String album,
    required bool isPlaying,
    String? albumArt,
  }) async {
    try {
      await platform.invokeMethod('showNotification', {
        'title': title,
        'artist': artist,
        'album': album,
        'isPlaying': isPlaying,
        'albumArt': albumArt,
      });
    } catch (e) {
      print('Failed to show notification: $e');
    }
  }

  /// Update notification playback state
  Future<void> updatePlaybackState(bool isPlaying) async {
    try {
      await platform.invokeMethod('updatePlaybackState', {
        'isPlaying': isPlaying,
      });
    } catch (e) {
      print('Failed to update playback state: $e');
    }
  }

  /// Update notification position
  Future<void> updatePosition(Duration position, Duration duration) async {
    try {
      await platform.invokeMethod('updatePosition', {
        'position': position.inMilliseconds,
        'duration': duration.inMilliseconds,
      });
    } catch (e) {
      print('Failed to update position: $e');
    }
  }

  /// Hide notification
  Future<void> hideNotification() async {
    try {
      await platform.invokeMethod('hideNotification');
    } catch (e) {
      print('Failed to hide notification: $e');
    }
  }

  /// Set up notification callback handlers
  void setupCallbacks({
    required VoidCallback onPlay,
    required VoidCallback onPause,
    required VoidCallback onStop,
    required VoidCallback onNext,
    required VoidCallback onPrevious,
    required Function(Duration) onSeek,
  }) {
    platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onPlay':
          onPlay();
          break;
        case 'onPause':
          onPause();
          break;
        case 'onStop':
          onStop();
          break;
        case 'onNext':
          onNext();
          break;
        case 'onPrevious':
          onPrevious();
          break;
        case 'onSeek':
          final position = Duration(milliseconds: call.arguments['position']);
          onSeek(position);
          break;
      }
    });
  }
}

/// Background Audio Manager
/// Coordinates background audio service and notifications
class BackgroundAudioManager {
  static final BackgroundAudioManager _instance = BackgroundAudioManager._internal();
  factory BackgroundAudioManager() => _instance;
  BackgroundAudioManager._internal();

  final BackgroundAudioService _audioService = BackgroundAudioService();
  final AudioNotificationService _notificationService = AudioNotificationService();

  bool _isInitialized = false;

  /// Initialize background audio manager
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _audioService.initialize();
    
    // Set up notification callbacks
    _notificationService.setupCallbacks(
      onPlay: () => _audioService.play(),
      onPause: () => _audioService.pause(),
      onStop: () => _audioService.stop(),
      onNext: () => _handleNext(),
      onPrevious: () => _handlePrevious(),
      onSeek: (position) => _audioService.seek(position),
    );

    // Listen to audio service events
    _audioService.addPlayStateListener(_updateNotificationState);
    _audioService.addPositionListener(_updateNotificationPosition);
    _audioService.addDurationListener(_updateNotificationDuration);
    _audioService.addCompletionListener(_handleCompletion);

    _isInitialized = true;
  }

  /// Load and play episode with background support
  Future<bool> loadAndPlay(Episode episode, {String? audioUrl}) async {
    if (!_isInitialized) {
      await initialize();
    }

    final success = await _audioService.loadAndPlay(episode, audioUrl: audioUrl);
    
    if (success) {
      // Show notification
      await _notificationService.showNotification(
        title: episode.title,
        artist: 'Learning with ${episode.coachPersonality}',
        album: episode.category,
        isPlaying: _audioService.isPlaying,
      );
    }

    return success;
  }

  /// Play/Resume
  Future<void> play() async {
    await _audioService.play();
  }

  /// Pause
  Future<void> pause() async {
    await _audioService.pause();
  }

  /// Stop
  Future<void> stop() async {
    await _audioService.stop();
    await _notificationService.hideNotification();
  }

  /// Seek
  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  /// Set playback speed
  Future<void> setPlaybackSpeed(double speed) async {
    await _audioService.setPlaybackSpeed(speed);
  }

  /// Get current state
  bool get isPlaying => _audioService.isPlaying;
  Episode? get currentEpisode => _audioService.currentEpisode;
  Duration get currentPosition => _audioService.currentPosition;
  Duration get duration => _audioService.duration;

  /// Add listeners
  void addPlayStateListener(VoidCallback listener) {
    _audioService.addPlayStateListener(listener);
  }

  void addPositionListener(Function(Duration) listener) {
    _audioService.addPositionListener(listener);
  }

  void addCompletionListener(VoidCallback listener) {
    _audioService.addCompletionListener(listener);
  }

  /// Private methods
  void _updateNotificationState() {
    _notificationService.updatePlaybackState(_audioService.isPlaying);
  }

  void _updateNotificationPosition(Duration position) {
    _notificationService.updatePosition(position, _audioService.duration);
  }

  void _updateNotificationDuration(Duration duration) {
    // Duration updated, notification will be updated with next position update
  }

  void _handleNext() {
    // Handle next episode logic
    print('Next episode requested from notification');
  }

  void _handlePrevious() {
    // Handle previous episode logic
    print('Previous episode requested from notification');
  }

  void _handleCompletion() {
    // Handle episode completion
    print('Episode completed');
  }

  /// Dispose
  Future<void> dispose() async {
    await _audioService.dispose();
    await _notificationService.hideNotification();
    _isInitialized = false;
  }
}
