import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/journey_models.dart';
import '../services/placeholder_data_service.dart';
import '../core/research_metrics_provider.dart';
import 'package:provider/provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> 
    with TickerProviderStateMixin {
  late AudioPlayer _player;
  late AnimationController _waveAnimationController;
  late AnimationController _progressAnimationController;
  
  Journey? _currentJourney;
  List<Episode> _episodes = [];
  Episode? _currentEpisode;
  int _currentEpisodeIndex = 0;
  
  // Audio state
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;
  
  // Research metrics
  DateTime? _episodeStartTime;
  List<Map<String, dynamic>> _engagementEvents = [];
  bool _hasShownMicroFeedback = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _initializeAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get journey from arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Journey && _currentJourney == null) {
      _currentJourney = args;
      _loadJourneyEpisodes();
    }
  }

  void _initializePlayer() {
    _player = AudioPlayer();
    
    // Listen to duration changes
    _player.durationStream.listen((d) {
      if (d != null) setState(() => _duration = d);
    });
    
    // Listen to position changes and track engagement
    _player.positionStream.listen((p) {
      setState(() => _position = p);
      _trackEngagementEvent('position_update', additionalData: {
        'position': p.inSeconds,
        'percentage': _duration.inSeconds > 0 ? (p.inSeconds / _duration.inSeconds) : 0.0,
      });
    });
    
    // Listen to player state changes
    _player.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
      
      if (state.playing) {
        _waveAnimationController.repeat();
        _progressAnimationController.forward();
      } else {
        _waveAnimationController.stop();
        _progressAnimationController.stop();
      }
      
      _trackEngagementEvent(state.playing ? 'play' : 'pause');
    });

    // Listen for completion
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _onEpisodeCompleted();
      }
    });
  }

  void _initializeAnimations() {
    _waveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _loadJourneyEpisodes() {
    if (_currentJourney != null) {
      _episodes = PlaceholderDataService.getEpisodesForJourney(_currentJourney!.id);
      if (_episodes.isNotEmpty) {
        _loadEpisode(0);
      }
    }
  }

  void _loadEpisode(int index) {
    if (index < 0 || index >= _episodes.length) return;
    
    setState(() {
      _currentEpisodeIndex = index;
      _currentEpisode = _episodes[index];
      _hasShownMicroFeedback = false;
    });
    
    _episodeStartTime = DateTime.now();
    _engagementEvents.clear();
    
    // Load placeholder audio URL
    _player.setUrl(_currentEpisode!.audioUrl);
    
    _trackEngagementEvent('episode_start');
  }

  void _trackEngagementEvent(String action, {Map<String, dynamic>? additionalData}) {
    if (_currentEpisode == null) return;
    
    final research = Provider.of<ResearchMetricsProvider>(context, listen: false);
    research.trackAudioEngagement(
      episodeId: _currentEpisode!.id,
      action: action,
      position: _position.inSeconds,
      speed: _playbackSpeed,
      additionalData: additionalData,
    );
  }

  void _togglePlayback() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  void _seek(Duration position) {
    _player.seek(position);
    _trackEngagementEvent('seek', additionalData: {
      'seekTo': position.inSeconds,
      'seekFrom': _position.inSeconds,
    });
  }

  void _changeSpeed(double speed) {
    setState(() => _playbackSpeed = speed);
    _player.setSpeed(speed);
    _trackEngagementEvent('speed_change', additionalData: {'speed': speed});
  }

  void _onEpisodeCompleted() {
    _trackEngagementEvent('complete');
    
    // Strategic Research Point: Show contextual micro-feedback
    if (!_hasShownMicroFeedback) {
      _showMicroFeedback();
    }
  }

  void _showMicroFeedback() {
    if (!mounted) return;
    
    setState(() => _hasShownMicroFeedback = true);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildMicroFeedbackDialog(),
    );
  }

  void _nextEpisode() {
    if (_currentEpisodeIndex < _episodes.length - 1) {
      _loadEpisode(_currentEpisodeIndex + 1);
    } else {
      _completeJourney();
    }
  }

  void _previousEpisode() {
    if (_currentEpisodeIndex > 0) {
      _loadEpisode(_currentEpisodeIndex - 1);
    }
  }

  void _completeJourney() {
    if (_currentJourney == null) return;
    
    final research = Provider.of<ResearchMetricsProvider>(context, listen: false);
    final totalTime = DateTime.now().difference(_episodeStartTime ?? DateTime.now());
    
    research.captureJourneyCompletion(
      journeyId: _currentJourney!.id,
      method: 'conversational', // This demo only does conversational
      totalTime: totalTime,
      completedEpisodes: _episodes.map((e) => e.id).toList(),
      overallSatisfaction: 8.0, // Will be captured from user feedback
      skillConfidence: {}, // Will be populated from micro-feedback
    );
    
    Navigator.pushNamed(context, '/feedback_hub');
  }

  @override
  void dispose() {
    _player.dispose();
    _waveAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentEpisode == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBlue,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildAudioVisualization()),
            _buildEpisodeInfo(),
            _buildPlayerControls(),
            _buildProgressBar(),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _currentJourney?.title ?? '',
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Episode ${_currentEpisodeIndex + 1} of ${_episodes.length}',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Show episode list or journey info
            },
            icon: const Icon(Icons.list, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioVisualization() {
    return Container(
      margin: const EdgeInsets.all(40),
      child: AnimatedBuilder(
        animation: _waveAnimationController,
        builder: (context, child) {
          return Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryBlue.withOpacity(0.8),
                  AppColors.primaryBlue.withOpacity(0.4),
                  AppColors.primaryBlue.withOpacity(0.1),
                ],
                stops: [
                  0.3,
                  0.6 + (0.2 * _waveAnimationController.value),
                  0.9 + (0.1 * _waveAnimationController.value),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: _isPlaying ? 10 : 0,
                ),
              ],
            ),
            child: Icon(
              Icons.headphones,
              size: 80,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEpisodeInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            _currentEpisode?.title ?? '',
            style: AppTextStyles.heading2.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _currentEpisode?.description ?? '',
            style: AppTextStyles.caption.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (_currentEpisode?.keyPoints.isNotEmpty ?? false) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _currentEpisode!.keyPoints.take(3).map((point) {
                return Chip(
                  label: Text(point, style: const TextStyle(fontSize: 10)),
                  backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                  labelStyle: TextStyle(color: AppColors.primaryBlue),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlayerControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous episode
          IconButton(
            onPressed: _currentEpisodeIndex > 0 ? _previousEpisode : null,
            icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
          ),
          
          // Seek backward
          IconButton(
            onPressed: () => _seek(_position - const Duration(seconds: 15)),
            icon: const Icon(Icons.replay, color: Colors.white, size: 30),
          ),
          
          // Play/Pause
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: IconButton(
              onPressed: _togglePlayback,
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          
          // Seek forward
          IconButton(
            onPressed: () => _seek(_position + const Duration(seconds: 15)),
            icon: const Icon(Icons.fast_forward, color: Colors.white, size: 30),
          ),
          
          // Next episode
          IconButton(
            onPressed: _currentEpisodeIndex < _episodes.length - 1 ? _nextEpisode : null,
            icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primaryBlue,
              inactiveTrackColor: AppColors.primaryBlue.withOpacity(0.2),
              thumbColor: AppColors.primaryBlue,
              overlayColor: AppColors.primaryBlue.withOpacity(0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: _duration.inSeconds > 0 
                  ? _position.inSeconds / _duration.inSeconds 
                  : 0.0,
              onChanged: (value) {
                final position = Duration(seconds: (value * _duration.inSeconds).round());
                _seek(position);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: AppTextStyles.caption.copyWith(color: Colors.white70),
              ),
              Text(
                _formatDuration(_duration),
                style: AppTextStyles.caption.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Playback speed
          PopupMenuButton<double>(
            initialValue: _playbackSpeed,
            onSelected: _changeSpeed,
            icon: Text(
              '${_playbackSpeed}x',
              style: AppTextStyles.caption.copyWith(color: Colors.white),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 0.75, child: Text('0.75x')),
              const PopupMenuItem(value: 1.0, child: Text('1.0x')),
              const PopupMenuItem(value: 1.25, child: Text('1.25x')),
              const PopupMenuItem(value: 1.5, child: Text('1.5x')),
              const PopupMenuItem(value: 2.0, child: Text('2.0x')),
            ],
          ),
          
          // Episode list button
          IconButton(
            onPressed: () {
              _showEpisodeList();
            },
            icon: const Icon(Icons.queue_music, color: Colors.white),
          ),
          
          // Share/feedback button
          IconButton(
            onPressed: () {
              _showQuickFeedback();
            },
            icon: const Icon(Icons.favorite_border, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showEpisodeList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Episodes',
                style: AppTextStyles.heading2.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ...List.generate(_episodes.length, (index) {
                final episode = _episodes[index];
                final isCurrentEpisode = index == _currentEpisodeIndex;
                
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrentEpisode 
                          ? AppColors.primaryBlue 
                          : AppColors.primaryBlue.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    episode.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: isCurrentEpisode ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    _formatDuration(Duration(seconds: episode.duration)),
                    style: AppTextStyles.caption.copyWith(color: Colors.white70),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _loadEpisode(index);
                  },
                );
              }).take(6).toList(), // Show max 6 episodes in the list
            ],
          ),
        );
      },
    );
  }

  void _showQuickFeedback() {
    // Strategic Research Point: Quick engagement feedback
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text(
          'Quick Feedback',
          style: AppTextStyles.heading2.copyWith(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How engaging was this episode?',
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    final research = Provider.of<ResearchMetricsProvider>(context, listen: false);
                    research.captureMicroFeedback(
                      episodeId: _currentEpisode!.id,
                      trigger: 'quick_feedback',
                      feedback: {'engagement': index + 1},
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Thanks for your feedback!'),
                        backgroundColor: AppColors.primaryBlue,
                      ),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryBlue.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMicroFeedbackDialog() {
    return AlertDialog(
      backgroundColor: AppColors.backgroundCard,
      title: Text(
        'Episode Complete! 🎉',
        style: AppTextStyles.heading2.copyWith(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'How was your learning experience?',
            style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Rate your understanding (1-10)',
            style: AppTextStyles.caption.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final rating = (index + 1) * 2;
              return GestureDetector(
                onTap: () {
                  final research = Provider.of<ResearchMetricsProvider>(context, listen: false);
                  research.captureMicroFeedback(
                    episodeId: _currentEpisode!.id,
                    trigger: 'episode_completion',
                    feedback: {
                      'understanding': rating,
                      'timestamp': DateTime.now().toIso8601String(),
                    },
                  );
                  Navigator.pop(context);
                  _nextEpisode();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryBlue.withOpacity(0.2),
                    border: Border.all(color: AppColors.primaryBlue),
                  ),
                  child: Center(
                    child: Text(
                      '$rating',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
