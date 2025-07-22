import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/journey_models.dart';
import '../models/simple_content_block.dart';
import '../services/simple_audio_player_service.dart';
import '../services/local_audio_manager.dart';

class DemoAudioPlayerScreen extends StatefulWidget {
  const DemoAudioPlayerScreen({super.key});

  @override
  State<DemoAudioPlayerScreen> createState() => _DemoAudioPlayerScreenState();
}

class _DemoAudioPlayerScreenState extends State<DemoAudioPlayerScreen> 
    with TickerProviderStateMixin {
  late SimpleAudioPlayerService _audioService;
  late AnimationController _waveAnimationController;
  
  Journey? _currentJourney;
  List<SimpleContentBlock> _episodes = [];
  SimpleContentBlock? _currentEpisode;
  int _currentEpisodeIndex = 0;
  
  // Audio state
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;

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
    
    // Listen to position changes
    _audioService.positionStream.listen((p) {
      setState(() => _position = p);
    });
    
    // Listen to player state changes
    _audioService.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
      
      if (state.playing) {
        _waveAnimationController.repeat();
      } else {
        _waveAnimationController.stop();
      }
    });
  }

  void _initializeAnimations() {
    _waveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
  }

  void _nextEpisode() {
    if (_currentEpisodeIndex < _episodes.length - 1) {
      setState(() {
        _currentEpisodeIndex++;
        _currentEpisode = _episodes[_currentEpisodeIndex];
      });
      _playPause(); // Auto-play next episode
    }
  }

  void _previousEpisode() {
    if (_currentEpisodeIndex > 0) {
      setState(() {
        _currentEpisodeIndex--;
        _currentEpisode = _episodes[_currentEpisodeIndex];
      });
      _playPause(); // Auto-play previous episode
    }
  }

  @override
  void dispose() {
    _waveAnimationController.dispose();
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
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _currentJourney?.title ?? 'Audio Player',
                  style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                if (_currentEpisode != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${_currentEpisodeIndex + 1} of ${_episodes.length}',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
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
                    ? AppColors.accentOrange.withOpacity(0.6)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.headphones,
                size: 80,
                color: AppColors.textPrimary,
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
          style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _currentEpisode!.description,
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
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
                  color: AppColors.backgroundCard,
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
            inactiveTrackColor: AppColors.backgroundCard,
            thumbColor: AppColors.accentOrange,
            overlayColor: AppColors.accentOrange.withOpacity(0.2),
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
                ? AppColors.textPrimary 
                : AppColors.textSecondary,
          ),
        ),
        IconButton(
          onPressed: _skipBackward,
          icon: const Icon(
            Icons.fast_rewind,
            size: 32,
            color: AppColors.textPrimary,
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
              color: AppColors.textPrimary,
            ),
          ),
        ),
        IconButton(
          onPressed: _skipForward,
          icon: const Icon(
            Icons.fast_forward,
            size: 32,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: _currentEpisodeIndex < _episodes.length - 1 ? _nextEpisode : null,
          icon: Icon(
            Icons.skip_next,
            size: 40,
            color: _currentEpisodeIndex < _episodes.length - 1 
                ? AppColors.textPrimary 
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
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
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
                      : AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${speed}x',
                  style: AppTextStyles.caption.copyWith(
                    color: _playbackSpeed == speed 
                        ? AppColors.textPrimary 
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
          style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        ...(_episodes.asMap().entries.map((entry) {
          final index = entry.key;
          final episode = entry.value;
          final isActive = index == _currentEpisodeIndex;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryBlue.withOpacity(0.2) : AppColors.backgroundCard,
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
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                episode.title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
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
