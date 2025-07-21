/// Enhanced Audio Learning Engine with Two-Speaker System
/// Integrates with NEW_AUDIO_ARCHITECTURE conversation system
/// Backward compatible with existing single-speaker episodes
library;

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/core.dart';
import '../../models/episode.dart';

/// Enhanced Audio Learning Engine with Two-Speaker Support
class EnhancedAudioLearningEngine extends StatefulWidget {
  final Episode episode;
  final String? userId;
  final bool useTwoSpeakerMode;

  const EnhancedAudioLearningEngine({
    super.key,
    required this.episode,
    this.userId,
    this.useTwoSpeakerMode = true,
  });

  @override
  State<EnhancedAudioLearningEngine> createState() => _EnhancedAudioLearningEngineState();
}

class _EnhancedAudioLearningEngineState extends State<EnhancedAudioLearningEngine>
    with TickerProviderStateMixin {
  
  // Audio player
  late AudioPlayer _audioPlayer;
  
  // Animation controllers
  late AnimationController _playButtonController;
  late AnimationController _waveController;
  
  // State variables
  bool _isPlaying = false;
  bool _isGenerating = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  
  // Conversation system
  GeneratedConversation? _conversation;
  ConversationAudio? _conversationAudio;
  List<String> _transcriptSentences = [];
  int _currentSegmentIndex = 0;
  
  // Services
  final PersonalizationEngine _personalizationEngine = PersonalizationEngine.instance;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    _initializeServices();
    _generateAudioContent();
  }

  Future<void> _initializeAudio() async {
    _audioPlayer = AudioPlayer();
    
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    // Set up audio player listeners
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
      
      if (state == PlayerState.playing) {
        _playButtonController.forward();
        _waveController.repeat();
      } else {
        _playButtonController.reverse();
        _waveController.stop();
      }
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
        _updateCurrentSegment(position);
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _trackCompletion();
    });
  }

  Future<void> _initializeServices() async {
    await HybridTTSService.initialize();
    await _personalizationEngine.initialize();
  }

  /// Generate audio content using two-speaker system or fallback to single speaker
  Future<void> _generateAudioContent() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      if (widget.useTwoSpeakerMode) {
        await _generateTwoSpeakerContent();
      } else {
        await _generateSingleSpeakerContent();
      }
    } catch (e) {
      _showErrorDialog('Failed to generate audio content: $e');
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  /// Generate two-speaker conversation content
  Future<void> _generateTwoSpeakerContent() async {
    // Generate conversation structure
    _conversation = await ConversationEngine.generateConversation(
      topic: widget.episode.title,
      category: widget.episode.category,
      format: ConversationFormat.dialogue,
      targetDuration: Duration(minutes: widget.episode.durationMinutes),
    );

    // Generate audio from conversation
    final audioResult = await HybridTTSService.generateConversationAudio(
      exchanges: _conversation!.exchanges.map((e) => e.toJson()).toList(),
      speakerVoiceMap: {for (var s in _conversation!.speakers) s.id: s.voiceId},
      speed: 1.0,
    );
    if (audioResult['success'] == true) {
      _conversationAudio = ConversationAudio(
        id: _conversation!.id,
        conversationId: _conversation!.id,
        segments: (audioResult['segments'] as List)
            .map((s) => ConversationAudioSegment.fromJson(s))
            .toList(),
        totalDuration: _conversation!.estimatedDuration,
        format: 'mp3',
        metadata: {},
        cacheHitRate: 0.0,
      );
    } else {
      _conversationAudio = null;
      _showErrorDialog('Failed to generate conversation audio: ${audioResult['error']}');
      return;
    }

    // Prepare transcript
    _prepareTranscript();

    // Track generation event
    if (widget.userId != null) {
      await _personalizationEngine.trackEngagement(
        widget.userId!,
        'audio_played',
      );
    }

    setState(() {
      _duration = _conversationAudio!.totalDuration;
    });
  }

  /// Generate single-speaker content (fallback/compatibility)
  Future<void> _generateSingleSpeakerContent() async {
    // Use existing single-speaker generation logic
    final contentGenerator = PodcastContentGenerator();
    final script = await contentGenerator.generateEpisodeScript(
      widget.episode.title,
      widget.episode.title,
      widget.episode.content,
      widget.episode.coachPersonality,
      widget.episode.knowledgeType,
      personalContext: null,
    );

    // For now, use existing PlayHT generation
    // This will be enhanced to use the hybrid TTS service
    final result = await _generateLegacyAudio(script);
    
    _transcriptSentences = script.split(RegExp(r'[.!?]+'))
        .where((sentence) => sentence.trim().isNotEmpty)
        .map((sentence) => sentence.trim())
        .toList();

    setState(() {
      _duration = Duration(seconds: result['duration'] ?? 0);
    });
  }

  /// Generate audio using legacy system (temporary)
  Future<Map<String, dynamic>> _generateLegacyAudio(String script) async {
    // This is a placeholder for backward compatibility
    // Will be replaced with hybrid TTS service integration
    return {
      'audioPath': 'placeholder_path',
      'duration': _estimateAudioDuration(script).inSeconds,
      'success': true,
    };
  }

  /// Prepare transcript from conversation
  void _prepareTranscript() {
    if (_conversation == null) return;

    _transcriptSentences = [];
    for (final exchange in _conversation!.exchanges) {
      if (exchange.content != null) {
        final sentences = exchange.content!.split(RegExp(r'[.!?]+'))
            .where((sentence) => sentence.trim().isNotEmpty)
            .map((sentence) => sentence.trim())
            .toList();
        _transcriptSentences.addAll(sentences);
      }
    }
  }

  /// Update current segment based on audio position
  void _updateCurrentSegment(Duration position) {
    if (_conversationAudio == null) return;

    Duration cumulativeTime = Duration.zero;
    for (int i = 0; i < _conversationAudio!.segments.length; i++) {
      final segment = _conversationAudio!.segments[i];
      if (position >= cumulativeTime && position < cumulativeTime + segment.duration) {
        if (_currentSegmentIndex != i) {
          setState(() {
            _currentSegmentIndex = i;
          });
        }
        break;
      }
      cumulativeTime += segment.duration;
    }
  }

  /// Play/pause toggle
  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _trackPauseEvent();
    } else {
      if (_conversationAudio != null) {
        // Play conversation audio (multi-segment)
        await _playConversationAudio();
      } else {
        // Play single audio file
        await _audioPlayer.resume();
      }
      _trackPlayEvent();
    }
  }

  /// Play conversation audio with segment coordination
  Future<void> _playConversationAudio() async {
    // This is a simplified implementation
    // In production, you'd need sophisticated audio coordination
    // For now, play first segment or continue from current position
    
    if (_conversationAudio!.segments.isNotEmpty) {
      final currentSegment = _conversationAudio!.segments[_currentSegmentIndex];
      if (currentSegment.audioPath != null) {
        await _audioPlayer.play(DeviceFileSource(currentSegment.audioPath!));
      }
    }
  }

  /// Track play event
  void _trackPlayEvent() {
    if (widget.userId != null) {
      _personalizationEngine.trackEngagement(
        widget.userId!,
        'episode_play',
      );
    }
  }

  /// Track pause event
  void _trackPauseEvent() {
    if (widget.userId != null) {
      _personalizationEngine.trackEngagement(
        widget.userId!,
        'episode_pause',
      );
    }
  }

  /// Track completion
  void _trackCompletion() {
    if (widget.userId != null) {
      _personalizationEngine.trackEngagement(
        widget.userId!,
        'episode_completed',
      );
    }
  }

  /// Estimate audio duration from text
  Duration _estimateAudioDuration(String text) {
    final wordCount = text.split(RegExp(r'\s+')).length;
    final minutes = wordCount / 155.0; // 155 words per minute average
    return Duration(seconds: (minutes * 60).round());
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Audio Generation Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: _isGenerating ? _buildGeneratingView() : _buildAudioPlayer(),
    );
  }

  /// Build generating view
  Widget _buildGeneratingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
          ),
          const SizedBox(height: 24),
          Text(
            widget.useTwoSpeakerMode 
                ? 'Generating two-speaker conversation...'
                : 'Generating audio content...',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.useTwoSpeakerMode
                ? 'Creating engaging dialogue with expert insights'
                : 'Using AI voice synthesis with compression',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Build main audio player interface
  Widget _buildAudioPlayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEpisodeHeader(),
            const SizedBox(height: 32),
            _buildAudioControls(),
            const SizedBox(height: 32),
            _buildTranscriptView(),
            const SizedBox(height: 32),
            _buildProgressSection(),
          ],
        ),
      ),
    );
  }

  /// Build episode header
  Widget _buildEpisodeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.episode.coachPersonality == 'Kai'
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
                widget.useTwoSpeakerMode ? Icons.people : Icons.person,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                widget.useTwoSpeakerMode ? 'Two-Speaker Dialogue' : 'Single Speaker',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.episode.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.episode.category,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Build audio controls
  Widget _buildAudioControls() {
    return Center(
      child: Column(
        children: [
          // Play/Pause Button
          GestureDetector(
            onTap: _togglePlayPause,
            child: AnimatedBuilder(
              animation: _playButtonController,
              builder: (context, child) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Progress Bar
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF4CAF50),
                  inactiveTrackColor: Colors.grey[800],
                  thumbColor: const Color(0xFF4CAF50),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: _duration.inSeconds > 0 
                      ? _position.inSeconds / _duration.inSeconds 
                      : 0.0,
                  onChanged: (value) {
                    final position = Duration(
                      seconds: (value * _duration.inSeconds).round(),
                    );
                    _audioPlayer.seek(position);
                  },
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build transcript view
  Widget _buildTranscriptView() {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transcript',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: _buildTranscriptContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build transcript content
  Widget _buildTranscriptContent() {
    if (_conversation != null && widget.useTwoSpeakerMode) {
      return _buildConversationTranscript();
    } else {
      return _buildSingleSpeakerTranscript();
    }
  }

  /// Build conversation transcript with speaker labels
  Widget _buildConversationTranscript() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _conversation!.exchanges.map((exchange) {
        final speaker = _conversation!.speakers.firstWhere((s) => s.id == exchange.speakerId);
        final isCurrentSegment = _conversation!.exchanges.indexOf(exchange) == _currentSegmentIndex;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                speaker.name,
                style: TextStyle(
                  color: speaker.role == SpeakerRole.host 
                      ? const Color(0xFF4CAF50) 
                      : const Color(0xFFFF9800),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                exchange.content ?? exchange.text,
                style: TextStyle(
                  color: isCurrentSegment ? Colors.white : Colors.grey[400],
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Build single speaker transcript
  Widget _buildSingleSpeakerTranscript() {
    return Text(
      _transcriptSentences.join(' '),
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
        height: 1.5,
      ),
    );
  }

  /// Build progress section
  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildProgressItem(
            'Duration',
            _formatDuration(_duration),
            Icons.timer,
          ),
          _buildProgressItem(
            'Progress',
            '${((_duration.inSeconds > 0 ? _position.inSeconds / _duration.inSeconds : 0.0) * 100).round()}%',
            Icons.analytics,
          ),
          _buildProgressItem(
            'Mode',
            widget.useTwoSpeakerMode ? '2-Speaker' : 'Single',
            widget.useTwoSpeakerMode ? Icons.people : Icons.person,
          ),
        ],
      ),
    );
  }

  /// Build progress item
  Widget _buildProgressItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF4CAF50), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Format duration for display
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
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
}
