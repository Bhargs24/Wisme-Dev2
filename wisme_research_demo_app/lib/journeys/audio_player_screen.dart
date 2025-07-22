import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../core/firebase_service.dart';
import 'package:provider/provider.dart';
import '../core/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  Duration _duration = const Duration(seconds: 300);
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    // Placeholder: No real audio loaded yet
    // _player.setUrl('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    _player.durationStream.listen((d) {
      if (d != null) setState(() => _duration = d);
    });
    _player.positionStream.listen((p) {
      setState(() => _position = p);
    });
    _player.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlayback() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  void _skipForward() async {
    final newPos = _position + const Duration(seconds: 10);
    await _player.seek(newPos < _duration ? newPos : _duration);
  }

  void _skipBackward() async {
    final newPos = _position - const Duration(seconds: 10);
    await _player.seek(newPos > Duration.zero ? newPos : Duration.zero);
  }

  void _setPlaybackSpeed(double speed) async {
    setState(() => _playbackSpeed = speed);
    await _player.setSpeed(speed);
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final journey = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          FutureBuilder(
            future: FirebaseService.getEpisodes(journey?['id'] ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || (snapshot.data as dynamic).docs.isEmpty) {
                return Center(
                  child: Text('No episodes available yet.', style: AppTextStyles.bodyLarge),
                );
              }
              final episodes = (snapshot.data as dynamic).docs;
              final episode = episodes[0].data() as Map<String, dynamic>; // For demo, play first episode
              final audioUrl = episode['audioUrl'] ?? '';
              _player.setUrl(audioUrl);
              _player.playerStateStream.listen((state) {
                if (state.playing) {
                  FirebaseService.logEvent('audio_play', {
                    'user_id': user?.uid,
                    'journey_id': journey?['id'],
                    'episode_id': episode['episodeId'],
                  });
                } else {
                  FirebaseService.logEvent('audio_pause', {
                    'user_id': user?.uid,
                    'journey_id': journey?['id'],
                    'episode_id': episode['episodeId'],
                  });
                }
              });
              _player.positionStream.listen((position) {
                FirebaseService.updateUserProgress(
                  '${user?.uid}_${journey?['id']}',
                  {
                    'userId': user?.uid,
                    'journeyId': journey?['id'],
                    'currentEpisodeId': episode['episodeId'],
                    'progressPercentage': (_position.inSeconds / (_duration.inSeconds == 0 ? 1 : _duration.inSeconds)) * 100,
                    'totalListeningTime': _position.inSeconds,
                  },
                );
              });
              // On episode complete:
              _player.processingStateStream.listen((state) {
                if (state == ProcessingState.completed) {
                  FirebaseService.updateUserProgress(
                    '${user?.uid}_${journey?['id']}',
                    {
                      'completedEpisodes': FieldValue.arrayUnion([episode['episodeId']]),
                      'completedAt': Timestamp.now(),
                    },
                  );
                  FirebaseService.logEvent('audio_complete', {
                    'user_id': user?.uid,
                    'journey_id': journey?['id'],
                    'episode_id': episode['episodeId'],
                  });
                }
              });
              return SafeArea(
                child: Column(
                  children: [
                    // Header with episode info
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primaryBlue, AppColors.primaryDark],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withOpacity(0.18),
                                  blurRadius: 32,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.headphones,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            episode['title'],
                            style: AppTextStyles.heading2.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            episode['description'],
                            style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Progress bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.primaryBlue,
                              inactiveTrackColor: Colors.white24,
                              thumbColor: AppColors.primaryBlue,
                              overlayColor: AppColors.primaryBlue.withAlpha(32),
                            ),
                            child: Slider(
                              min: 0.0,
                              max: _duration.inSeconds.toDouble(),
                              value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
                              onChanged: (value) async {
                                final position = Duration(seconds: value.toInt());
                                await _player.seek(position);
                                // Track user interaction (stub)
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(_position), style: const TextStyle(color: Colors.white70)),
                              Text(_formatDuration(_duration), style: const TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Playback controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: _skipBackward,
                          icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1.0, end: _isPlaying ? 1.1 : 1.0),
                          duration: const Duration(milliseconds: 200),
                          builder: (context, scale, child) {
                            return GestureDetector(
                              onTap: _togglePlayback,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 90 * scale,
                                width: 90 * scale,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          onPressed: _skipForward,
                          icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Speed control
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Speed: ', style: TextStyle(color: Colors.white70)),
                          DropdownButton<double>(
                            value: _playbackSpeed,
                            dropdownColor: AppColors.backgroundDark,
                            style: const TextStyle(color: Colors.white),
                            items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                                .map((speed) => DropdownMenuItem(
                                      value: speed,
                                      child: Text('${speed}x'),
                                    ))
                                .toList(),
                            onChanged: (speed) => _setPlaybackSpeed(speed!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Complete episode button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/feedback', arguments: journey),
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                        child: const Text('Complete Episode & Give Feedback', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.feedback, color: Colors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }
} 