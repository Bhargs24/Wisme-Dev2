import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../shared/shared.dart';
import 'package:audioplayers/audioplayers.dart';



/// Enhanced Audio Player Screen with Modern UI
/// Features: Progress tracking, speed control, transcript sync, interactive controls
class AudioPlayerScreen extends StatefulWidget {
  final String episodeTitle;
  final String episodeContent;
  final String? audioUrl;
  final Duration duration;

  const AudioPlayerScreen({
    super.key,
    required this.episodeTitle,
    required this.episodeContent,
    this.audioUrl,
    required this.duration,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _playButtonController;
  late AnimationController _waveController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _waveAnimation;

  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _playbackSpeed = 1.0;
  bool _showTranscript = false;
  List<String> _transcriptSentences = [];
  int _currentSentenceIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeAudioPlayer();
    _setupTranscript();
    
    // Set initial duration
    _totalDuration = widget.duration;
  }

  void _initializeAnimations() {
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _playButtonController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    _waveController.repeat(reverse: true);
  }

  void _initializeAudioPlayer() {
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
        _updateCurrentSentence();
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });

      if (_isPlaying) {
        _playButtonController.forward();
      } else {
        _playButtonController.reverse();
      }
    });
  }

  void _setupTranscript() {
    // Split content into sentences for transcript sync
    _transcriptSentences = widget.episodeContent
        .split(RegExp(r'[.!?]+'))
        .where((sentence) => sentence.trim().isNotEmpty)
        .map((sentence) => sentence.trim())
        .toList();
  }

  void _updateCurrentSentence() {
    if (_totalDuration.inMilliseconds > 0) {
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
      if (widget.audioUrl != null) {
        await _audioPlayer.play(UrlSource(widget.audioUrl!));
      } else {
        // Simulate playback for development
        _simulatePlayback();
      }
    }
  }

  void _simulatePlayback() {
    // Development simulation
    setState(() {
      _isPlaying = true;
      _totalDuration = widget.duration;
    });

    // Simulate progress
    _simulateProgress();
  }

  void _simulateProgress() {
    if (_isPlaying && _currentPosition < _totalDuration) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isPlaying) {
          setState(() {
            _currentPosition = Duration(
              milliseconds: (_currentPosition.inMilliseconds + 1000)
                  .clamp(0, _totalDuration.inMilliseconds),
            );
            _updateCurrentSentence();
          });
          _simulateProgress();
        }
      });
    }
  }

  Future<void> _seekTo(Duration position) async {
    await _audioPlayer.seek(position);
    setState(() {
      _currentPosition = position;
      _updateCurrentSentence();
    });
  }

  Future<void> _changePlaybackSpeed(double speed) async {
    await _audioPlayer.setPlaybackRate(speed);
    setState(() {
      _playbackSpeed = speed;
    });
  }

  void _skipBackward() {
    final newPosition = Duration(
      milliseconds: (_currentPosition.inMilliseconds - 10000).clamp(0, _totalDuration.inMilliseconds),
    );
    _seekTo(newPosition);
  }

  void _skipForward() {
    final newPosition = Duration(
      milliseconds: (_currentPosition.inMilliseconds + 10000).clamp(0, _totalDuration.inMilliseconds),
    );
    _seekTo(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              WismeColors.primaryBlue.withOpacity(0.8),
              WismeColors.wisdomPurple.withOpacity(0.8),
              WismeColors.primaryBlueDark.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildCoachAvatar(),
                      const SizedBox(height: 32),
                      _buildEpisodeInfo(),
                      const SizedBox(height: 32),
                      _buildAudioVisualizer(),
                      const SizedBox(height: 32),
                      _buildProgressBar(),
                      const SizedBox(height: 24),
                      _buildPlaybackControls(),
                      const SizedBox(height: 32),
                      _buildQuickActions(),
                      if (_showTranscript) ...[
                        const SizedBox(height: 24),
                        _buildTranscript(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Now Playing',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  widget.episodeTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showMoreOptions(),
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachAvatar() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '🧠', // Default to Kai's avatar
              style: const TextStyle(fontSize: 60),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodeInfo() {
    return ModernCard(
      backgroundColor: Colors.white.withOpacity(0.9),
      child: Column(
        children: [
          Text(
            widget.episodeTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(Icons.schedule, '${widget.duration.inMinutes} min'),
              _buildInfoItem(Icons.speed, '${_playbackSpeed}x'),
              _buildInfoItem(Icons.person, 'AI Coach'), // Simplified
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildAudioVisualizer() {
    return SizedBox(
      height: 80,
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(20, (index) {
              final height = _isPlaying 
                  ? 20 + (40 * _waveAnimation.value * (index % 3 == 0 ? 1 : index % 2 == 0 ? 0.7 : 0.4))
                  : 20.0;
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 4,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primary,
                      WismeColors.textSecondary,
                    ],
                  ),
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
        Row(
          children: [
            Text(
              _formatDuration(_currentPosition),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Slider(
                value: _totalDuration.inMilliseconds > 0
                    ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
                    : 0.0,
                onChanged: (value) {
                  final position = Duration(
                    milliseconds: (value * _totalDuration.inMilliseconds).round(),
                  );
                  _seekTo(position);
                },
                activeColor: Colors.white,
                inactiveColor: Colors.white.withOpacity(0.3),
              ),
            ),
            Text(
              _formatDuration(_totalDuration),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: Icons.replay_10,
          onTap: _skipBackward,
        ),
        _buildControlButton(
          icon: Icons.speed,
          onTap: () => _showSpeedMenu(),
        ),
        _buildMainPlayButton(),
        _buildControlButton(
          icon: Icons.bookmark_border,
          onTap: () => _bookmarkCurrentPosition(),
        ),
        _buildControlButton(
          icon: Icons.forward_10,
          onTap: _skipForward,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildMainPlayButton() {
    return GestureDetector(
      onTap: _togglePlayback,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [WismeColors.primaryBlue, WismeColors.wisdomPurple],
          ),
          boxShadow: [
            BoxShadow(
              color: WismeColors.primaryBlue.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionChip(
          icon: Icons.text_fields,
          label: 'Transcript',
          isActive: _showTranscript,
          onTap: () => setState(() => _showTranscript = !_showTranscript),
        ),
        _buildActionChip(
          icon: Icons.bookmark,
          label: 'Save',
          onTap: () => _saveEpisode(),
        ),
        _buildActionChip(
          icon: Icons.share,
          label: 'Share',
          onTap: () => _shareEpisode(),
        ),
      ],
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive 
              ? Colors.white.withOpacity(0.3) 
              : Colors.white.withOpacity(0.1),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranscript() {
    return ModernCard(
      backgroundColor: Colors.white.withOpacity(0.95),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.text_fields, color: WismeColors.primaryBlue),
              const SizedBox(width: 8),
              Text(
                'Transcript',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _transcriptSentences.asMap().entries.map((entry) {
                  final index = entry.key;
                  final sentence = entry.value;
                  final isActive = index == _currentSentenceIndex;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive 
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sentence,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isActive ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        height: 1.6,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showSpeedMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Playback Speed',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...{0.75, 1.0, 1.25, 1.5, 2.0}.map((speed) => ListTile(
              title: Text('${speed}x'),
              leading: Radio<double>(
                value: speed,
                groupValue: _playbackSpeed,
                onChanged: (value) {
                  if (value != null) {
                    _changePlaybackSpeed(value);
                    Navigator.pop(context);
                  }
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOptionItem(Icons.download, 'Download for Offline', () {}),
            _buildOptionItem(Icons.report, 'Report Issue', () {}),
            _buildOptionItem(Icons.settings, 'Audio Settings', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _bookmarkCurrentPosition() async {
    try {
      // Save bookmark to local storage or backend
      final bookmark = {
        'episode_title': widget.episodeTitle,
        'position': _currentPosition.inSeconds,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      // In real app: await BookmarkService.addBookmark(bookmark);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Position bookmarked!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to bookmark: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _saveEpisode() async {
    try {
      // Save episode to user's library
      final episodeData = {
        'title': widget.episodeTitle,
        'content': widget.episodeContent,
        'duration': widget.duration.inSeconds,
        'saved_at': DateTime.now().toIso8601String(),
      };
      
      // In real app: await LibraryService.saveEpisode(episodeData);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Episode saved to library!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save episode: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _shareEpisode() async {
    try {
      final shareText = '''
Check out this learning episode: "${widget.episodeTitle}"

Duration: ${widget.duration.inMinutes} minutes

Generated by Wisme - Your AI Learning Assistant
''';
      
      // In real app: await Share.share(shareText);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Episode shared!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share episode: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _playButtonController.dispose();
    _waveController.dispose();
    super.dispose();
  }
}
