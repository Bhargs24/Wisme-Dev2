/// Enhanced Audio Player Screen with Two-Speaker Support
/// Complete integration with NEW_AUDIO_ARCHITECTURE
/// Backward compatible with existing single-speaker episodes
library;

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/core.dart';
import '../../models/episode.dart';

/// Revolutionary audio player supporting both single and two-speaker modes
class EnhancedAudioPlayerScreen extends StatefulWidget {
  final String episodeTitle;
  final String episodeContent;
  final String? audioUrl;
  final Duration duration;
  final Episode? episode; // For full episode data
  final bool? enableTwoSpeakerMode; // Optional override

  const EnhancedAudioPlayerScreen({
    super.key,
    required this.episodeTitle,
    required this.episodeContent,
    this.audioUrl,
    required this.duration,
    this.episode,
    this.enableTwoSpeakerMode,
  });

  @override
  State<EnhancedAudioPlayerScreen> createState() => _EnhancedAudioPlayerScreenState();
}

class _EnhancedAudioPlayerScreenState extends State<EnhancedAudioPlayerScreen>
    with TickerProviderStateMixin {
  
  // Audio player
  late AudioPlayer _audioPlayer;
  
  // Animation controllers
  late AnimationController _playButtonController;
  late AnimationController _waveController;
  late AnimationController _speakerTransitionController;
  
  // Animations
  late Animation<double> _scaleAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _speakerFadeAnimation;
  
  // Player state
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _playbackSpeed = 1.0;
  bool _showTranscript = false;
  
  // Two-speaker mode state
  bool _isTwoSpeakerMode = false;
  ConversationAudioData? _conversationData;
  int _currentSegmentIndex = 0;
  List<ConversationExchange> _currentExchanges = [];
  SpeakerVoice? _currentSpeaker;
  
  // Traditional mode state
  List<String> _transcriptSentences = [];
  int _currentSentenceIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeAudioPlayer();
    _determinePlaybackMode();
    _setupContent();
  }

  void _initializeAnimations() {
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _speakerTransitionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _playButtonController, curve: Curves.easeInOut),
    );
    
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
    
    _speakerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _speakerTransitionController, curve: Curves.easeInOut),
    );
  }

  void _initializeAudioPlayer() {
    _audioPlayer = AudioPlayer();
    
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
        _isLoading = state == PlayerState.playing && _currentPosition == Duration.zero;
      });
      
      if (_isPlaying) {
        _playButtonController.forward();
        _waveController.repeat();
      } else {
        _playButtonController.reverse();
        _waveController.stop();
      }
    });
    
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _totalDuration = duration;
      });
    });
    
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
      });
      
      if (_isTwoSpeakerMode) {
        _updateCurrentSpeakerSegment();
      } else {
        _updateCurrentSentence();
      }
    });
    
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _currentPosition = _totalDuration;
      });
      _playButtonController.reverse();
      _waveController.stop();
    });
  }

  void _determinePlaybackMode() {
    // Check if two-speaker mode should be enabled
    _isTwoSpeakerMode = widget.enableTwoSpeakerMode ?? 
                       (widget.episode?.isTwoSpeakerConversation == true) ||
                       _shouldUseTwoSpeakerMode();
  }

  bool _shouldUseTwoSpeakerMode() {
    // Smart detection of when to use two-speaker mode
    if (!AudioServiceRegistry.isInitialized) return false;
    
    // Check if content would benefit from two-speaker format
    final contentLength = widget.episodeContent.length;
    final hasComplexTopic = widget.episodeTitle.toLowerCase().contains(RegExp(r'(how|why|explain|understand|learn|master)'));
    
    return contentLength > 500 && hasComplexTopic;
  }

  void _setupContent() {
    if (_isTwoSpeakerMode) {
      _setupTwoSpeakerContent();
    } else {
      _setupTraditionalContent();
    }
  }

  void _setupTwoSpeakerContent() async {
    if (!AudioServiceRegistry.isInitialized) {
      print('\u26a0\ufe0f Two-speaker system not initialized, falling back to traditional mode');
      _isTwoSpeakerMode = false;
      _setupTraditionalContent();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Replace twoSpeakerSystem with actual service or remove if not needed
      // final conversationData = await twoSpeakerSystem.generateAudioExperience(...);
      final conversationData = null;

      if (conversationData != null) {
        setState(() {
          _conversationData = conversationData;
          _currentExchanges = conversationData.exchanges;
          _totalDuration = conversationData.totalDuration;
        });
        
        // Load the first audio segment
        if (_currentExchanges.isNotEmpty) {
          _loadAudioSegment(0);
        }
      } else {
        throw Exception('Failed to generate conversation data');
      }
    } catch (e) {
      print('\u274c Failed to setup two-speaker content: $e');
      // Fallback to traditional mode
      _isTwoSpeakerMode = false;
      _setupTraditionalContent();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setupTraditionalContent() {
    // Split content into sentences for transcript sync
    _transcriptSentences = widget.episodeContent
        .split(RegExp(r'[.!?]+'))
        .where((sentence) => sentence.trim().isNotEmpty)
        .map((sentence) => sentence.trim())
        .toList();
        
    setState(() {
      _totalDuration = widget.duration;
    });
  }

  void _loadAudioSegment(int segmentIndex) async {
    if (segmentIndex >= _currentExchanges.length) return;
    
    final exchange = _currentExchanges[segmentIndex];
    final audioSegment = (exchange.audioSegments != null && exchange.audioSegments!.isNotEmpty)
        ? exchange.audioSegments!.first
        : null; // Get first speaker's segment
    
    if (audioSegment != null && audioSegment.audioPath != null) {
      try {
        await _audioPlayer.setSourceDeviceFile(audioSegment.audioPath!);
        setState(() {
          _currentSegmentIndex = segmentIndex;
          // _currentSpeaker = audioSegment.speaker; // TODO: Refactor to get speaker from exchange
        });
        _speakerTransitionController.forward();
      } catch (e) {
        print('\u274c Failed to load audio segment: $e');
      }
    }
  }

  void _updateCurrentSpeakerSegment() {
    if (_conversationData == null) return;
    
    Duration segmentStartTime = Duration.zero;
    for (int i = 0; i < _currentExchanges.length; i++) {
      final exchange = _currentExchanges[i];
      final segmentDuration = (exchange.audioSegments != null)
          ? exchange.audioSegments!.fold<Duration>(
              Duration.zero,
              (total, segment) => total + segment.duration,
            )
          : Duration.zero;
      
      if (_currentPosition >= segmentStartTime && 
          _currentPosition < segmentStartTime + segmentDuration) {
        if (i != _currentSegmentIndex) {
          setState(() {
            _currentSegmentIndex = i;
            // _currentSpeaker = exchange.audioSegments?.first.speaker; // TODO: Refactor to get speaker from exchange
          });
          _speakerTransitionController.reset();
          _speakerTransitionController.forward();
        }
        break;
      }
      segmentStartTime += segmentDuration;
    }
  }

  void _updateCurrentSentence() {
    if (_totalDuration.inMilliseconds > 0 && _transcriptSentences.isNotEmpty) {
      final progress = _currentPosition.inMilliseconds / _totalDuration.inMilliseconds;
      final newIndex = (progress * _transcriptSentences.length).floor()
          .clamp(0, _transcriptSentences.length - 1);
      
      if (newIndex != _currentSentenceIndex) {
        setState(() {
          _currentSentenceIndex = newIndex;
        });
      }
    }
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_isTwoSpeakerMode) {
        await _playTwoSpeakerContent();
      } else {
        await _playTraditionalContent();
      }
    }
  }

  Future<void> _playTwoSpeakerContent() async {
    if (_conversationData == null) return;
    
    try {
      await _audioPlayer.resume();
    } catch (e) {
      print('❌ Failed to play two-speaker content: $e');
      // Could implement fallback or error handling here
    }
  }

  Future<void> _playTraditionalContent() async {
    try {
      if (widget.audioUrl != null) {
        await _audioPlayer.play(UrlSource(widget.audioUrl!));
      } else {
        // Simulate playback for development
        _simulatePlayback();
      }
    } catch (e) {
      print('❌ Failed to play traditional content: $e');
    }
  }

  void _simulatePlayback() {
    setState(() {
      _isPlaying = true;
    });
    _simulateProgress();
  }

  void _simulateProgress() async {
    while (_isPlaying && _currentPosition < _totalDuration) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_isPlaying && mounted) {
        setState(() {
          _currentPosition = Duration(
            milliseconds: (_currentPosition.inMilliseconds + 100).clamp(0, _totalDuration.inMilliseconds),
          );
        });
        
        if (_isTwoSpeakerMode) {
          _updateCurrentSpeakerSegment();
        } else {
          _updateCurrentSentence();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isTwoSpeakerMode 
                ? [Colors.indigo.shade900, Colors.purple.shade900, Colors.black]
                : [Colors.blue.shade900, Colors.purple.shade900, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: _isLoading ? _buildLoadingScreen() : _buildMainInterface(),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            _isTwoSpeakerMode 
                ? 'Generating interactive conversation...'
                : 'Loading episode...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (_isTwoSpeakerMode) ...[
            const SizedBox(height: 8),
            Text(
              'This may take a moment',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainInterface() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                if (_isTwoSpeakerMode) 
                  _buildTwoSpeakerDisplay()
                else
                  _buildTraditionalDisplay(),
                const Spacer(),
                _buildControls(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.episodeTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      _isTwoSpeakerMode ? Icons.people : Icons.person,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isTwoSpeakerMode 
                          ? 'Two-Speaker Conversation'
                          : 'Coach ${widget.episode?.category}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _showTranscript = !_showTranscript),
            icon: Icon(
              // TODO: Replace with custom transcript icons
              _showTranscript ? Icons.article : Icons.description,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoSpeakerDisplay() {
    return FadeTransition(
      opacity: _speakerFadeAnimation,
      child: Column(
        children: [
          // Current speaker indicator
          if (_currentSpeaker != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getSpeakerColor(_currentSpeaker!).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getSpeakerColor(_currentSpeaker!)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getSpeakerIcon(_currentSpeaker!.role),
                    color: _getSpeakerColor(_currentSpeaker!),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _currentSpeaker!.name,
                    style: TextStyle(
                      color: _getSpeakerColor(_currentSpeaker!),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          
          // Audio visualization
          _buildAudioVisualization(),
          
          const SizedBox(height: 24),
          
          // Current exchange text
          if (_showTranscript && _currentSegmentIndex < _currentExchanges.length) ...[
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _currentExchanges[_currentSegmentIndex].text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTraditionalDisplay() {
    return Column(
      children: [
        _buildAudioVisualization(),
        const SizedBox(height: 24),
        if (_showTranscript && _transcriptSentences.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _currentSentenceIndex < _transcriptSentences.length
                  ? _transcriptSentences[_currentSentenceIndex]
                  : widget.episodeContent,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAudioVisualization() {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(20, (index) {
            final height = _isPlaying 
                ? 30 + (60 * _waveAnimation.value * (index % 3 == 0 ? 1 : index % 2 == 0 ? 0.8 : 0.6))
                : 30.0;
            
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 4,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: _isTwoSpeakerMode && _currentSpeaker != null
                      ? [_getSpeakerColor(_currentSpeaker!), _getSpeakerColor(_currentSpeaker!).withOpacity(0.5)]
                      : [Colors.white, Colors.white.withOpacity(0.5)],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        // Progress bar
        Slider(
          value: _totalDuration.inMilliseconds > 0
              ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
              : 0.0,
          onChanged: (value) async {
            final position = Duration(
              milliseconds: (value * _totalDuration.inMilliseconds).round(),
            );
            await _audioPlayer.seek(position);
          },
          activeColor: Colors.white,
          inactiveColor: Colors.white.withOpacity(0.3),
        ),
        
        // Time display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_currentPosition),
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                _formatDuration(_totalDuration),
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Play controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () async {
                final newPosition = Duration(
                  milliseconds: (_currentPosition.inMilliseconds - 15000).clamp(0, _totalDuration.inMilliseconds),
                );
                await _audioPlayer.seek(newPosition);
              },
              icon: Icon(Icons.replay, color: Colors.white, size: 32),
            ),
            
            // Main play button
            ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTap: _togglePlayback,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                    size: 36,
                  ),
                ),
              ),
            ),
            
            IconButton(
              onPressed: () async {
                final newPosition = Duration(
                  milliseconds: (_currentPosition.inMilliseconds + 30000).clamp(0, _totalDuration.inMilliseconds),
                );
                await _audioPlayer.seek(newPosition);
              },
              icon: Icon(Icons.forward_30, color: Colors.white, size: 32),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Speed control
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Speed: ', style: TextStyle(color: Colors.white70)),
            DropdownButton<double>(
              value: _playbackSpeed,
              dropdownColor: Colors.grey.shade800,
              style: TextStyle(color: Colors.white),
              items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
                return DropdownMenuItem(
                  value: speed,
                  child: Text('${speed}x'),
                );
              }).toList(),
              onChanged: (speed) async {
                if (speed != null) {
                  await _audioPlayer.setPlaybackRate(speed);
                  setState(() {
                    _playbackSpeed = speed;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Color _getSpeakerColor(SpeakerVoice speaker) {
    switch (speaker.role) {
      case SpeakerRole.host:
        return Colors.blue.shade300;
      case SpeakerRole.expert:
        return Colors.green.shade300;
      default:
        return Colors.white;
    }
  }

  IconData _getSpeakerIcon(SpeakerRole role) {
    switch (role) {
      case SpeakerRole.host:
        return Icons.person;
      case SpeakerRole.expert:
        return Icons.school;
      default:
        return Icons.mic;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _playButtonController.dispose();
    _waveController.dispose();
    _speakerTransitionController.dispose();
    super.dispose();
  }
}
