import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../shared/shared.dart';
import '../../models/models.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/core.dart';
import '../../shared/shared.dart';
import '../../models/models.dart';
import 'dart:io';




/// Audio Learning Engine with PlayHT Integration
/// Handles TTS generation, audio playback, transcript sync, and progress tracking
/// Production-ready with real audio player integration and audio compression
class AudioLearningEngine extends StatefulWidget {
  final String topic;
  final String episodeTitle;
  final String episodeContent;
  final String coachPersonality;
  final int episodeIndex;
  final int totalEpisodes;

  const AudioLearningEngine({
    super.key,
    required this.topic,
    required this.episodeTitle,
    required this.episodeContent,
    this.coachPersonality = 'Kai',
    required this.episodeIndex,
    required this.totalEpisodes,
  });

  @override
  State<AudioLearningEngine> createState() => _AudioLearningEngineState();
}

class _AudioLearningEngineState extends State<AudioLearningEngine>
    with TickerProviderStateMixin {
  // Real audio player for production
  late AudioPlayer _audioPlayer;
  late AnimationController _playButtonController;
  late AnimationController _waveController;
  
  bool _isPlaying = false;
  bool _isGeneratingAudio = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;
  
  List<String> _transcriptSentences = [];
  int _currentSentenceIndex = 0;
  String? _audioUrl;
  
  // PlayHT Configuration from centralized config
  Map<String, String> get _voiceIds => ApiConfig.voiceIds;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudio();
    _parseTranscript();
    _generateAudioContent();
  }

  void _initializeAudio() {
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    // Set up audio player listeners
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
        _updateCurrentSentence(position);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
      
      if (state == PlayerState.playing) {
        _playButtonController.forward();
      } else {
        _playButtonController.reverse();
      }
    });
  }

  void _parseTranscript() {
    // Split episode content into sentences for highlighting
    _transcriptSentences = widget.episodeContent
        .split(RegExp(r'[.!?]+'))
        .where((sentence) => sentence.trim().isNotEmpty)
        .map((sentence) => sentence.trim())
        .toList();
  }

  Future<void> _generateAudioContent() async {
    setState(() {
      _isGeneratingAudio = true;
    });

    try {
      // Generate episode script using real AI
      final contentGenerator = PodcastContentGenerator();
      final script = await contentGenerator.generateEpisodeScript(
        widget.topic,
        widget.episodeTitle,
        widget.episodeContent,
        widget.coachPersonality,
        'beginner', // This would come from user profile
        openAiApiKey: ApiConfig.isOpenAiConfigured ? null : 'YOUR_OPENAI_API_KEY', // You'll replace this
      );
      
      // Generate audio using PlayHT with compression
      final audioData = await _generatePlayHTAudio(script);
      
      // Load the generated audio file
      await _loadAudioFromFile(audioData['audioUrl']);
      
      setState(() {
        _audioUrl = audioData['audioUrl'];
        _duration = Duration(seconds: audioData['duration']);
        _transcriptSentences = script.split(RegExp(r'[.!?]+'))
            .where((sentence) => sentence.trim().isNotEmpty)
            .map((sentence) => sentence.trim())
            .toList();
      });
    } catch (e) {
      _showError('Failed to generate audio: $e');
    } finally {
      setState(() {
        _isGeneratingAudio = false;
      });
    }
  }

  /// Real PlayHT TTS generation with compression and file storage
  Future<Map<String, dynamic>> _generatePlayHTAudio(String script) async {
    if (!ApiConfig.isPlayHtConfigured) {
      throw Exception('PlayHT API not configured. Please set up API keys.');
    }

    final voiceId = _voiceIds[widget.coachPersonality] ?? _voiceIds['Kai']!;
    
    // Use PlayHTService for generation with compression
    final result = await PlayHTService.generateAudio(
      text: script,
      voiceId: voiceId,
      quality: 'medium', // Balanced quality/size
      speed: 1.0,
    );

    if (!result['success']) {
      throw Exception('PlayHT generation failed: ${result['error']}');
    }

    // Get audio duration from the compressed file
    final duration = await _getAudioDuration(File(result['audioPath']));

    return {
      'audioUrl': result['audioPath'],
      'duration': duration.inSeconds,
      'fileSize': result['fileSize'],
      'compression': result['compression'],
    };
  }

  /// Get actual audio duration from file
  Future<Duration> _getAudioDuration(File audioFile) async {
    try {
      await _audioPlayer.setSourceDeviceFile(audioFile.path);
      final duration = await _audioPlayer.getDuration();
      return duration ?? const Duration(seconds: 180); // fallback
    } catch (e) {
      // Fallback: estimate duration based on text length
      return Duration(seconds: (widget.episodeContent.length / 20).round() + 60);
    }
  }

  void _updateCurrentSentence(Duration position) {
    if (_transcriptSentences.isEmpty) return;
    
    // Estimate sentence timing based on position
    final progress = _duration.inMilliseconds > 0 
        ? position.inMilliseconds / _duration.inMilliseconds 
        : 0.0;
    
    final newIndex = (progress * _transcriptSentences.length).floor()
        .clamp(0, _transcriptSentences.length - 1);
    
    if (newIndex != _currentSentenceIndex) {
      setState(() {
        _currentSentenceIndex = newIndex;
      });
    }
  }

  Future<void> _togglePlayPause() async {
    if (_audioUrl == null) {
      // Generate audio first if needed
      if (!_isGeneratingAudio) {
        await _generateAudioContent();
      }
      return;
    }

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        // Load audio file if not already loaded
        if (_audioPlayer.source == null) {
          await _loadAudioFromFile(_audioUrl!);
        }
        await _audioPlayer.resume();
      }
    } catch (e) {
      _showError('Playback error: $e');
    }
  }

  /// Load and play audio from file path
  Future<void> _loadAudioFromFile(String filePath) async {
    try {
      await _audioPlayer.setSourceDeviceFile(filePath);
      setState(() {
        _audioUrl = filePath;
      });
    } catch (e) {
      _showError('Failed to load audio: $e');
    }
  }


  void _seek(double value) {
    final position = Duration(milliseconds: (value * _duration.inMilliseconds).round());
    setState(() {
      _position = position;
      _updateCurrentSentence(position);
    });
  }

  void _changePlaybackSpeed() async {
    setState(() {
      _playbackSpeed = _playbackSpeed == 1.0 ? 1.25 : 
                     _playbackSpeed == 1.25 ? 1.5 : 
                     _playbackSpeed == 1.5 ? 0.75 : 1.0;
    });
    
    // Set real playback rate
    try {
      await _audioPlayer.setPlaybackRate(_playbackSpeed);
    } catch (e) {
      _showError('Failed to change playback speed: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _playButtonController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episode ${widget.episodeIndex + 1}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: _changePlaybackSpeed,
            icon: Text(
              '${_playbackSpeed}x',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: _isGeneratingAudio
          ? _buildLoadingScreen()
          : _buildAudioPlayer(),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                ),
                Icon(
                  widget.coachPersonality == 'Kai' ? Icons.spa : Icons.bolt,
                  size: 40,
                  color: const Color(0xFF2196F3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Generating audio with ${widget.coachPersonality}...',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Using PlayHT AI voice synthesis with compression',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Episode Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.coachPersonality == 'Kai'
                      ? [const Color(0xFF4CAF50), const Color(0xFF388E3C)]
                      : [const Color(0xFFFF9800), const Color(0xFFF57C00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        widget.coachPersonality == 'Kai' ? Icons.spa : Icons.bolt,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.coachPersonality,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.episodeTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.topic,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Audio Controls
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Progress Bar
                  Column(
                    children: [
                      Slider(
                        value: _duration.inMilliseconds > 0
                            ? _position.inMilliseconds / _duration.inMilliseconds
                            : 0.0,
                        onChanged: _seek,
                        activeColor: const Color(0xFF2196F3),
                        inactiveColor: Colors.grey[300],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Play/Pause Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          _seek((_position.inMilliseconds - 15000) / _duration.inMilliseconds);
                        },
                        icon: const Icon(Icons.replay_10),
                        iconSize: 32,
                      ),
                      
                      const SizedBox(width: 24),
                      
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: AnimatedBuilder(
                          animation: _playButtonController,
                          builder: (context, child) {
                            return Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2196F3),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2196F3).withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 36,
                              ),
                            );
                          },
                        ),
                      ),
                      
                      const SizedBox(width: 24),
                      
                      IconButton(
                        onPressed: () {
                          _seek((_position.inMilliseconds + 15000) / _duration.inMilliseconds);
                        },
                        icon: const Icon(Icons.forward_10),
                        iconSize: 32,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Transcript with Highlighting
            const Text(
              'Transcript',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: SingleChildScrollView(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                      children: _transcriptSentences.asMap().entries.map((entry) {
                        final index = entry.key;
                        final sentence = entry.value;
                        final isActive = index == _currentSentenceIndex;
                        
                        return TextSpan(
                          text: '$sentence. ',
                          style: TextStyle(
                            backgroundColor: isActive 
                                ? const Color(0xFF2196F3).withOpacity(0.2)
                                : null,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
