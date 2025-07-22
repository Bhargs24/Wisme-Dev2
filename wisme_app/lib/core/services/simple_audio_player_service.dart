import 'dart:async';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'local_audio_manager.dart';

/// Simplified Audio Player Service for Local Files Only
/// Removed all Firebase, cache, and network complexity
class SimpleAudioPlayerService {
  static SimpleAudioPlayerService? _instance;
  static SimpleAudioPlayerService get instance => _instance ??= SimpleAudioPlayerService._internal();
  
  SimpleAudioPlayerService._internal();

  final ap.AudioPlayer _player = ap.AudioPlayer();
  final String _serviceName = 'SimpleAudioPlayerService';
  
  // Current state - simplified
  SimpleContentBlock? _currentContent;
  List<SimpleContentBlock> _playlist = [];
  int _currentIndex = 0;
  
  // Streams for UI updates
  final StreamController<ap.PlayerState> _playerStateController = StreamController<ap.PlayerState>.broadcast();
  final StreamController<Duration> _positionController = StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController = StreamController<Duration>.broadcast();
  final StreamController<SimpleContentBlock?> _currentContentController = StreamController<SimpleContentBlock?>.broadcast();
  
  // Configuration
  double _playbackSpeed = 1.0;
  bool _isRepeatMode = false;
  bool _isShuffleMode = false;
  
  // Getters for streams
  Stream<ap.PlayerState> get playerStateStream => _playerStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<SimpleContentBlock?> get currentContentStream => _currentContentController.stream;
  
  // Getters for current state
  SimpleContentBlock? get currentContent => _currentContent;
  List<SimpleContentBlock> get playlist => List.unmodifiable(_playlist);
  int get currentIndex => _currentIndex;
  double get playbackSpeed => _playbackSpeed;
  bool get isRepeatMode => _isRepeatMode;
  bool get isShuffleMode => _isShuffleMode;
  bool get isPlaying => _player.state == ap.PlayerState.playing;
  bool get isPaused => _player.state == ap.PlayerState.paused;
  bool get isStopped => _player.state == ap.PlayerState.stopped;

  /// Initialize the audio player service
  Future<void> initialize() async {
    try {
      print('$_serviceName: Initializing audio player service');
      
      // Set up event listeners
      _setupEventListeners();
      
      print('$_serviceName: Audio player service initialized successfully');
    } catch (e, stackTrace) {
      print('$_serviceName: Failed to initialize audio player service: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Set up event listeners for the audio player
  void _setupEventListeners() {
    // Player state changes
    _player.onPlayerStateChanged.listen((state) {
      print('$_serviceName: Player state changed to: $state');
      _playerStateController.add(state);
      
      // Handle automatic next track
      if (state == ap.PlayerState.completed) {
        _handleTrackCompleted();
      }
    });
    
    // Position changes
    _player.onPositionChanged.listen((position) {
      _positionController.add(position);
    });
    
    // Duration changes
    _player.onDurationChanged.listen((duration) {
      _durationController.add(duration);
    });
    
    // Player completion
    _player.onPlayerComplete.listen((_) {
      print('$_serviceName: Playback completed');
    });
  }

  /// Play a single content block (SIMPLIFIED - local files only)
  Future<bool> play(SimpleContentBlock content) async {
    try {
      print('$_serviceName: Playing content: ${content.title}');
      
      // Check if audio file exists locally
      if (!content.isPlayable) {
        print('$_serviceName: Audio file not found: ${content.localAudioPath}');
        return false;
      }
      
      // Update current content
      _currentContent = content;
      _currentContentController.add(content);
      
      // Play the local audio file (DeviceFileSource only)
      await _player.play(ap.DeviceFileSource(content.localAudioPath));
      
      // Set playback speed
      await _player.setPlaybackRate(_playbackSpeed);
      
      print('$_serviceName: Successfully started playback');
      return true;
    } catch (e, stackTrace) {
      print('$_serviceName: Error playing content: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Pause playback
  Future<void> pause() async {
    try {
      await _player.pause();
      print('$_serviceName: Playback paused');
    } catch (e) {
      print('$_serviceName: Error pausing playback: $e');
    }
  }

  /// Resume playback
  Future<void> resume() async {
    try {
      await _player.resume();
      print('$_serviceName: Playback resumed');
    } catch (e) {
      print('$_serviceName: Error resuming playback: $e');
    }
  }

  /// Stop playback
  Future<void> stop() async {
    try {
      await _player.stop();
      print('$_serviceName: Playback stopped');
    } catch (e) {
      print('$_serviceName: Error stopping playback: $e');
    }
  }

  /// Seek to position
  Future<void> seekTo(Duration position) async {
    try {
      await _player.seek(position);
      print('$_serviceName: Seeked to: ${position.inSeconds}s');
    } catch (e) {
      print('$_serviceName: Error seeking: $e');
    }
  }

  /// Set playback speed
  Future<void> setPlaybackSpeed(double speed) async {
    try {
      _playbackSpeed = speed;
      await _player.setPlaybackRate(speed);
      print('$_serviceName: Playback speed set to: ${speed}x');
    } catch (e) {
      print('$_serviceName: Error setting playback speed: $e');
    }
  }

  /// Set playlist for continuous playback
  Future<void> setPlaylist(List<SimpleContentBlock> contents, {int startIndex = 0}) async {
    if (contents.isEmpty) {
      print('$_serviceName: Cannot set empty playlist');
      return;
    }
    
    if (startIndex < 0 || startIndex >= contents.length) {
      print('$_serviceName: Invalid start index: $startIndex');
      return;
    }
    
    _playlist = contents;
    _currentIndex = startIndex;
    
    print('$_serviceName: Playlist set with ${contents.length} items, starting at index $startIndex');
  }

  /// Play next track in playlist
  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
    } else if (_isRepeatMode) {
      _currentIndex = 0; // Loop back to start
    } else {
      print('$_serviceName: End of playlist reached');
      return;
    }
    
    await play(_playlist[_currentIndex]);
  }

  /// Play previous track in playlist
  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    
    if (_currentIndex > 0) {
      _currentIndex--;
    } else if (_isRepeatMode) {
      _currentIndex = _playlist.length - 1; // Loop to end
    } else {
      print('$_serviceName: Beginning of playlist reached');
      return;
    }
    
    await play(_playlist[_currentIndex]);
  }

  /// Toggle repeat mode
  void toggleRepeatMode() {
    _isRepeatMode = !_isRepeatMode;
    print('$_serviceName: Repeat mode: $_isRepeatMode');
  }

  /// Toggle shuffle mode
  void toggleShuffleMode() {
    _isShuffleMode = !_isShuffleMode;
    print('$_serviceName: Shuffle mode: $_isShuffleMode');
  }

  /// Handle track completion
  void _handleTrackCompleted() {
    print('$_serviceName: Track completed');
    
    if (_playlist.isNotEmpty) {
      playNext(); // Auto-play next track
    }
  }

  /// Get current position
  Future<Duration> getCurrentPosition() async {
    try {
      return await _player.getCurrentPosition() ?? Duration.zero;
    } catch (e) {
      print('$_serviceName: Error getting position: $e');
      return Duration.zero;
    }
  }

  /// Get total duration
  Future<Duration> getDuration() async {
    try {
      return await _player.getDuration() ?? Duration.zero;
    } catch (e) {
      print('$_serviceName: Error getting duration: $e');
      return Duration.zero;
    }
  }

  /// Check if content is currently playing
  bool isPlayingContent(SimpleContentBlock content) {
    return _currentContent?.id == content.id && isPlaying;
  }

  /// Dispose resources
  void dispose() {
    _player.dispose();
    _playerStateController.close();
    _positionController.close();
    _durationController.close();
    _currentContentController.close();
    print('$_serviceName: Disposed');
  }
}
