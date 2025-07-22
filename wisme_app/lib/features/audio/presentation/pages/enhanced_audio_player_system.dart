import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/components/modern_card.dart';

/// Enhanced Audio Player System
/// Full-featured audio player for learning episodes
class EnhancedAudioPlayerSystem extends StatefulWidget {
  final Map<String, dynamic> episode;
  final String coachName;
  final String? audioUrl;
  final Function(double)? onProgressChanged;
  final VoidCallback? onCompleted;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const EnhancedAudioPlayerSystem({
    super.key,
    required this.episode,
    required this.coachName,
    this.audioUrl,
    this.onProgressChanged,
    this.onCompleted,
    this.onNext,
    this.onPrevious,
  });

  @override
  State<EnhancedAudioPlayerSystem> createState() => _EnhancedAudioPlayerSystemState();
}

class _EnhancedAudioPlayerSystemState extends State<EnhancedAudioPlayerSystem>
    with TickerProviderStateMixin {
  
  late AudioPlayer _audioPlayer;
  late AnimationController _playPauseController;
  late AnimationController _waveController;
  
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;
  bool _showTranscript = false;
  bool _isBuffering = false;
  
  // Sleep timer
  Duration? _sleepTimer;
  DateTime? _sleepStartTime;
  
  // Playback speeds
  final List<double> _playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  
  // Simulated transcript data
  final List<Map<String, dynamic>> _transcriptSegments = [
    {
      'text': 'Welcome to this learning session. Today we\'re going to explore the fascinating world of our topic.',
      'startTime': 0,
      'endTime': 8,
    },
    {
      'text': 'Let\'s start by understanding the core concepts that will form the foundation of your knowledge.',
      'startTime': 8,
      'endTime': 16,
    },
    {
      'text': 'The first principle we need to understand is how this subject impacts our daily lives.',
      'startTime': 16,
      'endTime': 24,
    },
    {
      'text': 'Now, let me share a real-world example that perfectly illustrates this concept.',
      'startTime': 24,
      'endTime': 32,
    },
    {
      'text': 'As we continue our journey, you\'ll notice how these pieces start to connect together.',
      'startTime': 32,
      'endTime': 40,
    },
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playPauseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _initializeAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _playPauseController.dispose();
    _waveController.dispose();
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
        _isBuffering = state == PlayerState.playing && _position == Duration.zero;
      });
      
      if (state == PlayerState.playing) {
        _playPauseController.forward();
        _waveController.repeat();
      } else {
        _playPauseController.reverse();
        _waveController.stop();
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      widget.onCompleted?.call();
      _resetPlayer();
    });

    // Load episode audio
    _loadEpisodeAudio();
  }

  void _loadEpisodeAudio() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load actual audio if URL is provided
      if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
        await _audioPlayer.setSourceUrl(widget.audioUrl!);
      } else {
        // Set default duration for episodes without audio URL
        setState(() {
          _duration = Duration(minutes: widget.episode['duration'] ?? 12);
        });
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading audio: $e'),
            backgroundColor: WismeColors.error,
          ),
        );
      }
    }
  }

  void _playPause() async {
    if (_isLoading) return;
    
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
        // Play actual audio
        await _audioPlayer.resume();
      } else {
        // Load actual audio content based on episode configuration
        _simulatePlayback();
      }
    }
  }

  void _simulatePlayback() {
    if (!_isPlaying) {
      setState(() {
        _isPlaying = true;
      });
      _playPauseController.forward();
      _waveController.repeat();
      
      // Simulate progress
      _simulateProgress();
    }
  }

  void _simulateProgress() async {
    while (_isPlaying && _position < _duration) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_isPlaying) {
        setState(() {
          _position = Duration(
            milliseconds: _position.inMilliseconds + (100 * _playbackSpeed).round(),
          );
        });
        
        if (_position >= _duration) {
          widget.onCompleted?.call();
          _resetPlayer();
          break;
        }
      }
    }
  }

  void _resetPlayer() {
    setState(() {
      _isPlaying = false;
      _position = Duration.zero;
    });
    _playPauseController.reverse();
    _waveController.stop();
  }

  void _seek(Duration position) {
    setState(() {
      _position = position;
    });
    if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
      _audioPlayer.seek(position);
    }
  }

  void _changeSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
      _audioPlayer.setPlaybackRate(speed);
    }
  }

  void _skipForward() {
    final newPosition = _position + const Duration(seconds: 30);
    _seek(newPosition > _duration ? _duration : newPosition);
  }

  void _skipBackward() {
    final newPosition = _position - const Duration(seconds: 15);
    _seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _setSleepTimer(Duration? duration) {
    setState(() {
      _sleepTimer = duration;
      _sleepStartTime = duration != null ? DateTime.now() : null;
    });
  }

  Future<void> _downloadEpisode() async {
    try {
      // Show download progress
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Downloading Episode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Downloading "${widget.episode['title']}"...'),
            ],
          ),
        ),
      );

      // Simulate download process (replace with actual download logic)
      await Future.delayed(const Duration(seconds: 3));
      
      // In real implementation, download from widget.audioUrl and save to local storage
      // final file = await downloadFile(widget.audioUrl, episodeId);
      
      Navigator.of(context).pop(); // Close download dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Episode downloaded successfully!'),
          backgroundColor: WismeColors.success,
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close download dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: WismeColors.error,
        ),
      );
    }
  }

  void _bookmarkEpisode() async {
    try {
      // Save bookmark to local storage or backend
      // In real implementation: await BookmarkService.addBookmark(widget.episode);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Episode bookmarked!'),
          backgroundColor: WismeColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to bookmark: $e'),
          backgroundColor: WismeColors.error,
        ),
      );
    }
  }

  void _shareEpisode() async {
    try {
      // Share episode link
      // In real implementation: await Share.share(episodeLink);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Episode link copied to clipboard!'),
          backgroundColor: WismeColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share: $e'),
          backgroundColor: WismeColors.error,
        ),
      );
    }
  }

  void _reportIssue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What type of issue are you experiencing?'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.volume_off),
              title: const Text('Audio playback issue'),
              onTap: () {
                Navigator.pop(context);
                _submitFeedback('Audio playback issue');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('App bug'),
              onTap: () {
                Navigator.pop(context);
                _submitFeedback('App bug');
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Content feedback'),
              onTap: () {
                Navigator.pop(context);
                _submitFeedback('Content feedback');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _submitFeedback(String issueType) async {
    try {
      // Submit feedback to backend
      // In real implementation: await FeedbackService.submitFeedback(issueType, episodeId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: WismeColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit feedback: $e'),
          backgroundColor: WismeColors.error,
        ),
      );
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getCurrentTranscriptText() {
    for (final segment in _transcriptSegments) {
      if (_position.inSeconds >= segment['startTime'] && 
          _position.inSeconds < segment['endTime']) {
        return segment['text'];
      }
    }
    return _transcriptSegments.first['text'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildEpisodeInfo(),
                  const SizedBox(height: 24),
                  _buildAudioVisualizer(),
                  const SizedBox(height: 24),
                  _buildProgressBar(),
                  const SizedBox(height: 16),
                  _buildTimeDisplay(),
                  const SizedBox(height: 24),
                  _buildPlaybackControls(),
                  const SizedBox(height: 24),
                  _buildSecondaryControls(),
                  const SizedBox(height: 24),
                  if (_showTranscript) _buildTranscript(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: WismeColors.primaryBlue,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.episode['title'] ?? 'Episode',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                WismeColors.primaryBlue,
                WismeColors.primaryBlue.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () => _showOptionsMenu(),
        ),
      ],
    );
  }

  Widget _buildEpisodeInfo() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: WismeColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    '${widget.episode['number'] ?? 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: WismeColors.primaryBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.episode['title'] ?? 'Episode Title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: WismeColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'with ${widget.coachName}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: WismeColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.episode['description'] ?? 'Episode description goes here.',
            style: const TextStyle(
              fontSize: 15,
              color: WismeColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioVisualizer() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: WismeColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(20, (index) {
              final normalizedValue = (index / 20);
              final animationPhase = (_waveController.value + normalizedValue) % 1.0;
              final height = _isPlaying 
                ? 20 + (40 * (0.5 + 0.5 * (animationPhase * 2 - 1).abs()))
                : 25.0;
              
              return Container(
                width: 3,
                height: height,
                decoration: BoxDecoration(
                  color: _isPlaying 
                    ? WismeColors.primaryBlue.withOpacity(0.7)
                    : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: WismeColors.primaryBlue,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: WismeColors.primaryBlue,
            overlayColor: WismeColors.primaryBlue.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
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
              _seek(position);
            },
          ),
        ),
        if (_isBuffering)
          const LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(WismeColors.primaryBlue),
            backgroundColor: Colors.transparent,
          ),
      ],
    );
  }

  Widget _buildTimeDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDuration(_position),
          style: const TextStyle(
            fontSize: 14,
            color: WismeColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (_sleepTimer != null && _sleepStartTime != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: WismeColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.bedtime,
                  size: 14,
                  color: WismeColors.warning,
                ),
                const SizedBox(width: 4),
                Text(
                  'Sleep in ${_formatDuration(_sleepTimer!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: WismeColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        Text(
          _formatDuration(_duration),
          style: const TextStyle(
            fontSize: 14,
            color: WismeColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous episode
        IconButton(
          onPressed: widget.onPrevious,
          icon: const Icon(Icons.skip_previous),
          iconSize: 36,
          color: widget.onPrevious != null 
            ? WismeColors.textPrimary 
            : Colors.grey[400],
        ),
        
        // Skip backward
        IconButton(
          onPressed: _skipBackward,
          icon: const Icon(Icons.replay_10),
          iconSize: 32,
          color: WismeColors.textPrimary,
        ),
        
        // Play/Pause
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: WismeColors.primaryBlue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: WismeColors.primaryBlue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: _playPause,
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _playPauseController,
              color: Colors.white,
            ),
            iconSize: 32,
          ),
        ),
        
        // Skip forward
        IconButton(
          onPressed: _skipForward,
          icon: const Icon(Icons.forward_30),
          iconSize: 32,
          color: WismeColors.textPrimary,
        ),
        
        // Next episode
        IconButton(
          onPressed: widget.onNext,
          icon: const Icon(Icons.skip_next),
          iconSize: 36,
          color: widget.onNext != null 
            ? WismeColors.textPrimary 
            : Colors.grey[400],
        ),
      ],
    );
  }

  Widget _buildSecondaryControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Speed control
        GestureDetector(
          onTap: () => _showSpeedMenu(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.speed,
                  size: 16,
                  color: WismeColors.textPrimary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_playbackSpeed}x',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: WismeColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Sleep timer
        GestureDetector(
          onTap: () => _showSleepTimerMenu(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _sleepTimer != null 
                ? WismeColors.warning.withOpacity(0.1)
                : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _sleepTimer != null 
                  ? WismeColors.warning
                  : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bedtime,
                  size: 16,
                  color: _sleepTimer != null 
                    ? WismeColors.warning
                    : WismeColors.textPrimary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Sleep',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _sleepTimer != null 
                      ? WismeColors.warning
                      : WismeColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Transcript toggle
        GestureDetector(
          onTap: () {
            setState(() {
              _showTranscript = !_showTranscript;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _showTranscript 
                ? WismeColors.primaryBlue.withOpacity(0.1)
                : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _showTranscript 
                  ? WismeColors.primaryBlue
                  : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.subtitles,
                  size: 16,
                  color: _showTranscript 
                    ? WismeColors.primaryBlue
                    : WismeColors.textPrimary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Transcript',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _showTranscript 
                      ? WismeColors.primaryBlue
                      : WismeColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTranscript() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.subtitles,
                color: WismeColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Live Transcript',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: WismeColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: Text(
                _getCurrentTranscriptText(),
                style: const TextStyle(
                  fontSize: 16,
                  color: WismeColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap on text to jump to that section',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void _showSpeedMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Playback Speed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...(_playbackSpeeds.map((speed) {
              final isSelected = speed == _playbackSpeed;
              return ListTile(
                title: Text('${speed}x'),
                trailing: isSelected 
                  ? const Icon(Icons.check, color: WismeColors.primaryBlue)
                  : null,
                onTap: () {
                  _changeSpeed(speed);
                  Navigator.pop(context);
                },
              );
            }).toList()),
          ],
        ),
      ),
    );
  }

  void _showSleepTimerMenu() {
    final timerOptions = [
      {'label': 'Off', 'duration': null},
      {'label': '5 minutes', 'duration': const Duration(minutes: 5)},
      {'label': '10 minutes', 'duration': const Duration(minutes: 10)},
      {'label': '15 minutes', 'duration': const Duration(minutes: 15)},
      {'label': '30 minutes', 'duration': const Duration(minutes: 30)},
      {'label': '1 hour', 'duration': const Duration(hours: 1)},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sleep Timer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...(timerOptions.map((option) {
              final isSelected = option['duration'] == _sleepTimer;
              return ListTile(
                title: Text(option['label'] as String),
                trailing: isSelected 
                  ? const Icon(Icons.check, color: WismeColors.primaryBlue)
                  : null,
                onTap: () {
                  _setSleepTimer(option['duration'] as Duration?);
                  Navigator.pop(context);
                },
              );
            }).toList()),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bookmark_outline),
              title: const Text('Bookmark Episode'),
              onTap: () {
                Navigator.pop(context);
                _bookmarkEpisode();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Episode'),
              onTap: () {
                Navigator.pop(context);
                _shareEpisode();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download for Offline'),
              onTap: () {
                Navigator.pop(context);
                _downloadEpisode();
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Report Issue'),
              onTap: () {
                Navigator.pop(context);
                _reportIssue();
              },
            ),
          ],
        ),
      ),
    );
  }
}



