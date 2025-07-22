// Simple Audio Player Service for Demo App
// Clean local-first audio player with no Firebase dependencies

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/simple_content_block.dart';

/// Simple audio player service for local audio files only
class SimpleAudioPlayerService {
  static SimpleAudioPlayerService? _instance;
  static SimpleAudioPlayerService get instance => _instance ??= SimpleAudioPlayerService._internal();

  SimpleAudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();
  final String _serviceName = 'SimpleAudioPlayerService';

  // State tracking
  SimpleContentBlock? _currentContent;
  List<SimpleContentBlock> _playlist = [];
  int _currentIndex = 0;

  // Stream controllers
  final StreamController<SimpleContentBlock?> _currentContentController = 
      StreamController<SimpleContentBlock?>.broadcast();
  final StreamController<List<SimpleContentBlock>> _playlistController = 
      StreamController<List<SimpleContentBlock>>.broadcast();
  final StreamController<PlayerState> _playerStateController = 
      StreamController<PlayerState>.broadcast();
  final StreamController<Duration> _positionController = 
      StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController = 
      StreamController<Duration>.broadcast();

  // Public streams
  Stream<SimpleContentBlock?> get currentContentStream => _currentContentController.stream;
  Stream<List<SimpleContentBlock>> get playlistStream => _playlistController.stream;
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;

  // Getters
  SimpleContentBlock? get currentContent => _currentContent;
  List<SimpleContentBlock> get playlist => List.unmodifiable(_playlist);
  int get currentIndex => _currentIndex;
  bool get isPlaying => _player.playing;
  bool get hasNext => _currentIndex < _playlist.length - 1;
  bool get hasPrevious => _currentIndex > 0;
  Duration get position => _player.position;
  Duration get duration => _player.duration ?? Duration.zero;
  double get playbackSpeed => _player.speed;

  /// Initialize the audio player service
  Future<void> initialize() async {
    try {
      debugPrint('$_serviceName: Initializing...');
      
      // Set up event listeners
      _setupEventListeners();
      
      debugPrint('$_serviceName: Initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('$_serviceName: Failed to initialize: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Set up event listeners
  void _setupEventListeners() {
    // Player state changes
    _player.playerStateStream.listen((state) {
      debugPrint('$_serviceName: Player state changed to: $state');
      _playerStateController.add(state);
      
      // Handle completion
      if (state.processingState == ProcessingState.completed) {
        _handleTrackCompleted();
      }
    });

    // Position changes
    _player.positionStream.listen((position) {
      _positionController.add(position);
    });

    // Duration changes
    _player.durationStream.listen((duration) {
      if (duration != null) {
        _durationController.add(duration);
      }
    });
  }

  /// Play a single content block
  Future<bool> play(SimpleContentBlock content) async {
    try {
      debugPrint('$_serviceName: Playing content: ${content.title}');
      
      // Validate audio path
      if (!content.isValidAudioPath) {
        debugPrint('$_serviceName: Invalid audio path: ${content.localAudioPath}');
        return false;
      }

      // Set current content
      _currentContent = content;
      _currentContentController.add(content);

      // Load and play audio from assets
      await _player.setAsset(content.localAudioPath);
      await _player.play();

      debugPrint('$_serviceName: Successfully started playback');
      return true;
    } catch (e, stackTrace) {
      debugPrint('$_serviceName: Error playing content: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Pause playback
  Future<void> pause() async {
    try {
      await _player.pause();
      debugPrint('$_serviceName: Playback paused');
    } catch (e) {
      debugPrint('$_serviceName: Error pausing: $e');
    }
  }

  /// Resume playback
  Future<void> resume() async {
    try {
      await _player.play();
      debugPrint('$_serviceName: Playback resumed');
    } catch (e) {
      debugPrint('$_serviceName: Error resuming: $e');
    }
  }

  /// Stop playback
  Future<void> stop() async {
    try {
      await _player.stop();
      _currentContent = null;
      _currentContentController.add(null);
      debugPrint('$_serviceName: Playback stopped');
    } catch (e) {
      debugPrint('$_serviceName: Error stopping: $e');
    }
  }

  /// Seek to position
  Future<void> seekTo(Duration position) async {
    try {
      await _player.seek(position);
      debugPrint('$_serviceName: Seeked to: ${position.inSeconds}s');
    } catch (e) {
      debugPrint('$_serviceName: Error seeking: $e');
    }
  }

  /// Set playback speed
  Future<void> setSpeed(double speed) async {
    try {
      await _player.setSpeed(speed);
      debugPrint('$_serviceName: Speed set to: ${speed}x');
    } catch (e) {
      debugPrint('$_serviceName: Error setting speed: $e');
    }
  }

  /// Set playlist
  Future<void> setPlaylist(List<SimpleContentBlock> content, {int startIndex = 0}) async {
    try {
      if (content.isEmpty) {
        debugPrint('$_serviceName: Cannot set empty playlist');
        return;
      }

      if (startIndex < 0 || startIndex >= content.length) {
        debugPrint('$_serviceName: Invalid start index: $startIndex');
        return;
      }

      _playlist = List.from(content);
      _currentIndex = startIndex;
      _playlistController.add(_playlist);

      // Play first item
      await play(_playlist[_currentIndex]);

      debugPrint('$_serviceName: Playlist set with ${_playlist.length} items');
    } catch (e) {
      debugPrint('$_serviceName: Error setting playlist: $e');
    }
  }

  /// Skip to next track
  Future<void> skipToNext() async {
    try {
      if (!hasNext) {
        debugPrint('$_serviceName: No next track available');
        return;
      }

      _currentIndex++;
      await play(_playlist[_currentIndex]);
      debugPrint('$_serviceName: Skipped to next track');
    } catch (e) {
      debugPrint('$_serviceName: Error skipping to next: $e');
    }
  }

  /// Skip to previous track
  Future<void> skipToPrevious() async {
    try {
      if (!hasPrevious) {
        debugPrint('$_serviceName: No previous track available');
        return;
      }

      _currentIndex--;
      await play(_playlist[_currentIndex]);
      debugPrint('$_serviceName: Skipped to previous track');
    } catch (e) {
      debugPrint('$_serviceName: Error skipping to previous: $e');
    }
  }

  /// Handle track completion
  void _handleTrackCompleted() {
    debugPrint('$_serviceName: Track completed');
    
    // Auto-play next track if available
    if (hasNext) {
      skipToNext();
    } else {
      debugPrint('$_serviceName: Playlist completed');
      // Optionally reset to beginning or stop
      stop();
    }
  }

  /// Dispose of resources
  void dispose() {
    _player.dispose();
    _currentContentController.close();
    _playlistController.close();
    _playerStateController.close();
    _positionController.close();
    _durationController.close();
    debugPrint('$_serviceName: Disposed');
  }
}
