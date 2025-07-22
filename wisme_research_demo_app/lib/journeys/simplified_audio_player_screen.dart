import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/journey_models.dart';
import '../models/simple_content_block.dart';
import '../services/simple_audio_player_service.dart';
import '../services/local_audio_manager.dart';
import '../core/research_metrics_provider.dart';
import 'package:provider/provider.dart';

class SimplifiedAudioPlayerScreen extends StatefulWidget {
  const SimplifiedAudioPlayerScreen({super.key});

  @override
  State<SimplifiedAudioPlayerScreen> createState() => _SimplifiedAudioPlayerScreenState();
}

class _SimplifiedAudioPlayerScreenState extends State<SimplifiedAudioPlayerScreen> 
    with TickerProviderStateMixin {
  late SimpleAudioPlayerService _audioService;
  late AnimationController _waveAnimationController;
  late AnimationController _progressAnimationController;
  
  Journey? _currentJourney;
  List<SimpleContentBlock> _episodes = [];
  SimpleContentBlock? _currentEpisode;
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

  void _initializePlayer() async {
    _audioService = SimpleAudioPlayerService.instance;
    await _audioService.initialize();
    
    // Listen to duration changes
    _audioService.durationStream.listen((d) {
      setState(() => _duration = d);
    });
    
    // Listen to position changes and track engagement
    _audioService.positionStream.listen((p) {
      setState(() => _position = p);
      _trackEngagementEvent('position_update', additionalData: {
        'position': p.inSeconds,
        'percentage': _duration.inSeconds > 0 ? (p.inSeconds / _duration.inSeconds) : 0.0,
      });
    });
    
    // Listen to player state changes
    _audioService.playerStateStream.listen((state) {
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

    // Listen for completion (simplified)
    _audioService.currentContentStream.listen((content) {
      if (content == null && _currentEpisode != null) {
        // Episode completed
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

  void _loadJourneyEpisodes() async {
    if (_currentJourney == null) return;

    // Load episodes using LocalAudioManager
    final episodeNumbers = await LocalAudioManager.getAvailableEpisodes(_currentJourney!.id);
    final journeyMetadata = LocalAudioManager.getJourneyMetadata(_currentJourney!.id);
    
    final episodes = <SimpleContentBlock>[];
    
    for (final episodeNum in episodeNumbers) {
      final episodeMetadata = LocalAudioManager.getEpisodeMetadata(_currentJourney!.id, episodeNum);
      
      final episode = SimpleContentBlock.fromEpisode(
        journey: _currentJourney!.id,
        episode: episodeNum,
        title: episodeMetadata['title'] ?? 'Episode $episodeNum',
        description: episodeMetadata['description'] ?? '',
        duration: _parseDuration(episodeMetadata['duration'] ?? '8 minutes'),
        category: journeyMetadata['category'] ?? 'General',
        difficulty: journeyMetadata['difficulty'] ?? 'Intermediate',
        topics: List<String>.from(episodeMetadata['topics'] ?? []),
      );
      
      episodes.add(episode);
    }

    setState(() {
      _episodes = episodes;
      if (_episodes.isNotEmpty) {
        _currentEpisode = _episodes[0];
        _currentEpisodeIndex = 0;
      }
    });

    if (_currentEpisode != null) {
      _loadCurrentEpisode();
    }
  }

  Duration _parseDuration(String durationStr) {
    // Parse "8 minutes" format
    final parts = durationStr.split(' ');
    if (parts.length >= 2) {
      final minutes = int.tryParse(parts[0]) ?? 8;
      return Duration(minutes: minutes);
    }
    return const Duration(minutes: 8);
  }

  void _loadCurrentEpisode() async {
    if (_currentEpisode == null) return;
    
    // Track episode start
    _episodeStartTime = DateTime.now();
    _engagementEvents.clear();
    _hasShownMicroFeedback = false;
    
    _trackEngagementEvent('episode_started', additionalData: {
      'episode_id': _currentEpisode!.id,
      'episode_title': _currentEpisode!.title,
    });
  }

  void _playPause() async {
    if (_currentEpisode == null) return;

    if (_isPlaying) {
      await _audioService.pause();
    } else {
      if (_audioService.currentContent?.id != _currentEpisode!.id) {
        // Load new episode
        await _audioService.play(_currentEpisode!);
      } else {
        // Resume current episode
        await _audioService.resume();
      }
    }
  }

  void _seek(Duration position) {
    _audioService.seekTo(position);
  }

  void _skipForward() {
    final newPosition = _position + const Duration(seconds: 15);
    final maxPosition = _duration;
    _seek(newPosition > maxPosition ? maxPosition : newPosition);
  }

  void _skipBackward() {
    final newPosition = _position - const Duration(seconds: 15);
    _seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _changeSpeed(double speed) {
    _playbackSpeed = speed;
    _audioService.setSpeed(speed);
    _trackEngagementEvent('speed_changed', additionalData: {'speed': speed});
  }

  void _nextEpisode() {
    if (_currentEpisodeIndex < _episodes.length - 1) {
      setState(() {
        _currentEpisodeIndex++;
        _currentEpisode = _episodes[_currentEpisodeIndex];
      });
      _loadCurrentEpisode();
      _playPause(); // Auto-play next episode
    }
  }

  void _previousEpisode() {
    if (_currentEpisodeIndex > 0) {
      setState(() {
        _currentEpisodeIndex--;
        _currentEpisode = _episodes[_currentEpisodeIndex];
      });
      _loadCurrentEpisode();
      _playPause(); // Auto-play previous episode
    }
  }

  void _onEpisodeCompleted() {
    _trackEngagementEvent('episode_completed', additionalData: {
      'completion_time': DateTime.now().difference(_episodeStartTime!).inSeconds,
      'engagement_events_count': _engagementEvents.length,
    });

    // Auto-advance to next episode
    if (_currentEpisodeIndex < _episodes.length - 1) {
      _nextEpisode();
    } else {
      // Show completion message
      _showJourneyCompletionDialog();
    }
  }

  void _showJourneyCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Journey Complete!'),
        content: Text('You\'ve completed all episodes in ${_currentJourney?.title}.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to journey list
            },
            child: const Text('Continue Learning'),
          ),
        ],
      ),
    );
  }

  void _trackEngagementEvent(String action, {Map<String, dynamic>? additionalData}) {
    final event = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': action,
      'position_seconds': _position.inSeconds,
      'duration_seconds': _duration.inSeconds,
      'episode_id': _currentEpisode?.id,
      'journey_id': _currentJourney?.id,
      ...?additionalData,
    };
    
    _engagementEvents.add(event);
    
    // Track with research metrics
    final researchMetrics = Provider.of<ResearchMetricsProvider>(context, listen: false);
    // Note: trackEvent method will be added to ResearchMetricsProvider
    // researchMetrics.trackEvent('audio_engagement', event);
  }

  @override
  void dispose() {
    _waveAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildCoverArt(),
                    const SizedBox(height: 32),
                    _buildEpisodeInfo(),
                    const SizedBox(height: 40),
                    _buildProgressBar(),
                    const SizedBox(height: 32),
                    _buildPlayerControls(),
                    const SizedBox(height: 24),
                    _buildSpeedControl(),
                    const SizedBox(height: 32),
                    _buildEpisodeList(),
                  ],
                ),
              ),
            ),
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
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _currentJourney?.title ?? 'Audio Player',
                  style: AppTextStyles.heading3.copyWith(color: AppColors.textLight),
                  textAlign: TextAlign.center,
                ),
                if (_currentEpisode != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${_currentEpisodeIndex + 1} of ${_episodes.length}',
                    style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildCoverArt() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _waveAnimationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isPlaying 
                    ? AppColors.accent.withOpacity(0.6)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.headphones,
                size: 80,
                color: AppColors.textLight,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEpisodeInfo() {
    if (_currentEpisode == null) {
      return const SizedBox();
    }

    return Column(
      children: [
        Text(
          _currentEpisode!.title,
          style: AppTextStyles.heading2.copyWith(color: AppColors.textLight),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _currentEpisode!.description,
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        if (_currentEpisode!.topics.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _currentEpisode!.topics.take(3).map((topic) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  topic,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(_position.inSeconds),
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            Text(
              _formatDuration(_duration.inSeconds),
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: AppColors.primaryBlue,
            inactiveTrackColor: AppColors.cardDark,
            thumbColor: AppColors.accent,
            overlayColor: AppColors.accent.withOpacity(0.2),
          ),
          child: Slider(
            value: _duration.inSeconds > 0 
                ? _position.inSeconds / _duration.inSeconds 
                : 0.0,
            onChanged: (value) {
              final newPosition = Duration(seconds: (_duration.inSeconds * value).round());
              _seek(newPosition);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: _currentEpisodeIndex > 0 ? _previousEpisode : null,
          icon: Icon(
            Icons.skip_previous,
            size: 40,
            color: _currentEpisodeIndex > 0 
                ? AppColors.textLight 
                : AppColors.textSecondary,
          ),
        ),
        IconButton(
          onPressed: _skipBackward,
          icon: const Icon(
            Icons.replay_15,
            size: 32,
            color: AppColors.textLight,
          ),
        ),
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: _playPause,
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 40,
              color: AppColors.textLight,
            ),
          ),
        ),
        IconButton(
          onPressed: _skipForward,
          icon: const Icon(
            Icons.forward_15,
            size: 32,
            color: AppColors.textLight,
          ),
        ),
        IconButton(
          onPressed: _currentEpisodeIndex < _episodes.length - 1 ? _nextEpisode : null,
          icon: Icon(
            Icons.skip_next,
            size: 40,
            color: _currentEpisodeIndex < _episodes.length - 1 
                ? AppColors.textLight 
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Speed: ',
          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
        ),
        ...([0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => _changeSpeed(speed),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _playbackSpeed == speed 
                      ? AppColors.primaryBlue 
                      : AppColors.cardDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${speed}x',
                  style: AppTextStyles.caption.copyWith(
                    color: _playbackSpeed == speed 
                        ? AppColors.textLight 
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        })),
      ],
    );
  }

  Widget _buildEpisodeList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Episodes',
          style: AppTextStyles.heading3.copyWith(color: AppColors.textLight),
        ),
        const SizedBox(height: 16),
        ...(_episodes.asMap().entries.map((entry) {
          final index = entry.key;
          final episode = entry.value;
          final isActive = index == _currentEpisodeIndex;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryBlue.withOpacity(0.2) : AppColors.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: isActive 
                  ? Border.all(color: AppColors.primaryBlue, width: 1)
                  : null,
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primaryBlue : AppColors.backgroundDark,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                episode.title,
                style: AppTextStyles.body1.copyWith(
                  color: isActive ? AppColors.textLight : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                episode.formattedDuration,
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
              onTap: () {
                setState(() {
                  _currentEpisodeIndex = index;
                  _currentEpisode = episode;
                });
                _loadCurrentEpisode();
                _playPause();
              },
            ),
          );
        })),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
