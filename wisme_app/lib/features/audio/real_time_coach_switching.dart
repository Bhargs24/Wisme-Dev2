import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/services/playht_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/components/modern_card.dart';

/// Real-Time Coach Switching Service
/// Handles mid-episode coach switching with seamless audio transition
class RealTimeCoachSwitchingService {
  static final RealTimeCoachSwitchingService _instance = RealTimeCoachSwitchingService._internal();
  factory RealTimeCoachSwitchingService() => _instance;
  RealTimeCoachSwitchingService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  String _currentCoach = 'Kai';
  bool _isGeneratingNewAudio = false;
  
  // Coach voice IDs for PlayHT
  static const Map<String, String> _coachVoiceIds = {
    'Kai': 'arthurmeditationsaad', // Thoughtful, calm voice
    'Vee': 'arianasaad2', // Energetic, enthusiastic voice
  };

  /// Switch coach mid-episode with seamless transition
  Future<bool> switchCoach({
    required String newCoach,
    required String episodeScript,
    required Duration currentPosition,
    required Function(String) onAudioReady,
    required Function(String) onError,
  }) async {
    if (_isGeneratingNewAudio) {
      onError('Coach switching already in progress');
      return false;
    }

    if (newCoach == _currentCoach) {
      onError('Already using $newCoach');
      return false;
    }

    try {
      _isGeneratingNewAudio = true;
      
      // Get the voice ID for the new coach
      final voiceId = _coachVoiceIds[newCoach];
      if (voiceId == null) {
        onError('Coach voice not found: $newCoach');
        return false;
      }

      // Generate new audio with the new coach's voice
      final audioResult = await PlayHTService.generateAudio(
        text: episodeScript,
        voiceId: voiceId,
        quality: 'medium',
        speed: 1.0,
      );

      if (audioResult['success'] == true) {
        // Pause current audio
        await _audioPlayer.pause();
        
        // Switch to new audio
        await _audioPlayer.setSourceDeviceFile(audioResult['audioPath']);
        
        // Seek to the same position
        await _audioPlayer.seek(currentPosition);
        
        // Resume playback
        await _audioPlayer.resume();
        
        _currentCoach = newCoach;
        onAudioReady(audioResult['audioPath']);
        
        return true;
      } else {
        onError('Failed to generate audio: ${audioResult['error']}');
        return false;
      }
    } catch (e) {
      onError('Coach switching error: $e');
      return false;
    } finally {
      _isGeneratingNewAudio = false;
    }
  }

  /// Get current coach
  String get currentCoach => _currentCoach;

  /// Check if coach switching is in progress
  bool get isGeneratingNewAudio => _isGeneratingNewAudio;

  /// Pre-generate audio for both coaches to enable instant switching
  Future<Map<String, String>> preGenerateCoachAudio({
    required String episodeScript,
    required Function(String) onProgress,
  }) async {
    final audioFiles = <String, String>{};
    
    try {
      onProgress('Generating Kai\'s audio...');
      final kaiResult = await PlayHTService.generateAudio(
        text: episodeScript,
        voiceId: _coachVoiceIds['Kai']!,
        quality: 'medium',
        speed: 1.0,
      );

      if (kaiResult['success'] == true) {
        audioFiles['Kai'] = kaiResult['audioPath'];
      }

      onProgress('Generating Vee\'s audio...');
      final veeResult = await PlayHTService.generateAudio(
        text: episodeScript,
        voiceId: _coachVoiceIds['Vee']!,
        quality: 'medium',
        speed: 1.0,
      );

      if (veeResult['success'] == true) {
        audioFiles['Vee'] = veeResult['audioPath'];
      }

      onProgress('Audio generation complete!');
      return audioFiles;
    } catch (e) {
      onProgress('Error generating audio: $e');
      return audioFiles;
    }
  }

  /// Quick switch between pre-generated coach audio
  Future<bool> quickSwitchCoach({
    required String newCoach,
    required Map<String, String> audioFiles,
    required Duration currentPosition,
    required Function(String) onError,
  }) async {
    if (newCoach == _currentCoach) {
      onError('Already using $newCoach');
      return false;
    }

    final audioPath = audioFiles[newCoach];
    if (audioPath == null) {
      onError('Audio file not found for $newCoach');
      return false;
    }

    try {
      // Pause current audio
      await _audioPlayer.pause();
      
      // Switch to new audio
      await _audioPlayer.setSourceDeviceFile(audioPath);
      
      // Seek to the same position
      await _audioPlayer.seek(currentPosition);
      
      // Resume playback
      await _audioPlayer.resume();
      
      _currentCoach = newCoach;
      return true;
    } catch (e) {
      onError('Quick switch error: $e');
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _audioPlayer.dispose();
  }
}

/// Enhanced Audio Player with Real-Time Coach Switching
class EnhancedAudioPlayerWithCoachSwitching extends StatefulWidget {
  final Map<String, dynamic> episode;
  final String initialCoach;
  final String? audioUrl;
  final Function(double)? onProgressChanged;
  final VoidCallback? onCompleted;

  const EnhancedAudioPlayerWithCoachSwitching({
    super.key,
    required this.episode,
    this.initialCoach = 'Kai',
    this.audioUrl,
    this.onProgressChanged,
    this.onCompleted,
  });

  @override
  State<EnhancedAudioPlayerWithCoachSwitching> createState() => _EnhancedAudioPlayerWithCoachSwitchingState();
}

class _EnhancedAudioPlayerWithCoachSwitchingState extends State<EnhancedAudioPlayerWithCoachSwitching>
    with TickerProviderStateMixin {
  
  late AudioPlayer _audioPlayer;
  late AnimationController _playPauseController;
  late AnimationController _coachSwitchController;
  late RealTimeCoachSwitchingService _coachSwitchService;
  
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String _currentCoach = 'Kai';
  bool _isCoachSwitching = false;
  Map<String, String> _preGeneratedAudio = {};
  bool _hasPreGenerated = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _coachSwitchService = RealTimeCoachSwitchingService();
    _currentCoach = widget.initialCoach;
    
    _playPauseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _coachSwitchController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _initializeAudioPlayer();
    _preGenerateCoachAudio();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _playPauseController.dispose();
    _coachSwitchController.dispose();
    super.dispose();
  }

  void _initializeAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
      widget.onProgressChanged?.call(position.inSeconds.toDouble());
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
      
      if (state == PlayerState.playing) {
        _playPauseController.forward();
      } else {
        _playPauseController.reverse();
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      widget.onCompleted?.call();
      _resetPlayer();
    });
  }

  void _preGenerateCoachAudio() async {
    if (_hasPreGenerated) return;
    
    setState(() {
      _isLoading = true;
    });

    final episodeScript = widget.episode['content'] ?? widget.episode['script'] ?? '';
    
    _preGeneratedAudio = await _coachSwitchService.preGenerateCoachAudio(
      episodeScript: episodeScript,
      onProgress: (progress) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(progress),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
    );

    setState(() {
      _isLoading = false;
      _hasPreGenerated = true;
    });

    // Load initial audio
    if (_preGeneratedAudio.containsKey(_currentCoach)) {
      await _audioPlayer.setSourceDeviceFile(_preGeneratedAudio[_currentCoach]!);
    }
  }

  void _playPause() async {
    if (_isLoading) return;
    
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void _switchCoach() async {
    if (_isCoachSwitching || !_hasPreGenerated) return;

    setState(() {
      _isCoachSwitching = true;
    });

    _coachSwitchController.forward();

    final newCoach = _currentCoach == 'Kai' ? 'Vee' : 'Kai';
    
    final success = await _coachSwitchService.quickSwitchCoach(
      newCoach: newCoach,
      audioFiles: _preGeneratedAudio,
      currentPosition: _position,
      onError: (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: WismeColors.error,
            ),
          );
        }
      },
    );

    if (success) {
      setState(() {
        _currentCoach = newCoach;
      });
    }

    await _coachSwitchController.reverse();
    setState(() {
      _isCoachSwitching = false;
    });
  }

  void _resetPlayer() {
    setState(() {
      _isPlaying = false;
      _position = Duration.zero;
    });
    _playPauseController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Episode Title
            Text(
              widget.episode['title'] ?? 'Learning Episode',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Current Coach Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _currentCoach == 'Kai' ? Icons.psychology : Icons.bolt,
                  color: _currentCoach == 'Kai' ? WismeColors.kaiPrimary : WismeColors.veePrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Learning with $_currentCoach',
                  style: TextStyle(
                    color: _currentCoach == 'Kai' ? WismeColors.kaiPrimary : WismeColors.veePrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Audio Progress
            Column(
              children: [
                LinearProgressIndicator(
                  value: _duration.inMilliseconds > 0 
                    ? _position.inMilliseconds / _duration.inMilliseconds 
                    : 0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _currentCoach == 'Kai' ? WismeColors.kaiPrimary : WismeColors.veePrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Audio Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Rewind 15 seconds
                IconButton(
                  onPressed: () async {
                    final newPosition = _position - const Duration(seconds: 15);
                    await _audioPlayer.seek(newPosition > Duration.zero ? newPosition : Duration.zero);
                  },
                  icon: const Icon(Icons.replay_10),
                  iconSize: 32,
                ),
                
                // Play/Pause
                GestureDetector(
                  onTap: _playPause,
                  child: AnimatedBuilder(
                    animation: _playPauseController,
                    builder: (context, child) {
                      return Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentCoach == 'Kai' ? WismeColors.kaiPrimary : WismeColors.veePrimary,
                          boxShadow: [
                            BoxShadow(
                              color: (_currentCoach == 'Kai' ? WismeColors.kaiPrimary : WismeColors.veePrimary)
                                  .withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
                
                // Fast Forward 15 seconds
                IconButton(
                  onPressed: () async {
                    final newPosition = _position + const Duration(seconds: 15);
                    await _audioPlayer.seek(newPosition < _duration ? newPosition : _duration);
                  },
                  icon: const Icon(Icons.forward_10),
                  iconSize: 32,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Coach Switching Button
            AnimatedBuilder(
              animation: _coachSwitchController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_coachSwitchController.value * 0.1),
                  child: ElevatedButton.icon(
                    onPressed: _isCoachSwitching ? null : _switchCoach,
                    icon: _isCoachSwitching 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _currentCoach == 'Kai' ? Icons.bolt : Icons.psychology,
                        ),
                    label: Text(
                      _isCoachSwitching 
                        ? 'Switching...' 
                        : 'Switch to ${_currentCoach == 'Kai' ? 'Vee' : 'Kai'}',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentCoach == 'Kai' ? WismeColors.veePrimary : WismeColors.kaiPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                );
              },
            ),
            
            if (_isLoading) ...[
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Preparing coach audio...'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
