import 'package:flutter/material.dart';
import '../models/episode.dart';

/// Background Audio Demo Screen
/// Demonstrates how the background audio system works like Spotify
class BackgroundAudioDemoScreen extends StatefulWidget {
  const BackgroundAudioDemoScreen({super.key});

  @override
  State<BackgroundAudioDemoScreen> createState() => _BackgroundAudioDemoScreenState();
}

class _BackgroundAudioDemoScreenState extends State<BackgroundAudioDemoScreen> {
  // Removed: final BackgroundAudioManager _audioManager = BackgroundAudioManager();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;
  Episode? _currentEpisode;
  
  @override
  void initState() {
    super.initState();
    // Removed: _initializeAudio();
  }

  // Removed: Future<void> _initializeAudio() async {
  // Removed:   await _audioManager.initialize();
  // Removed:   
  // Removed:   // Listen to audio state changes
  // Removed:   _audioManager.addPlayStateListener(() {
  // Removed:     setState(() {
  // Removed:       _isPlaying = _audioManager.isPlaying;
  // Removed:     });
  // Removed:   });
  // Removed:   
  // Removed:   _audioManager.addPositionListener((position) {
  // Removed:     setState(() {
  // Removed:       _currentPosition = position;
  // Removed:     });
  // Removed:   });
  // Removed:   
  // Removed:   setState(() {
  // Removed:     _currentEpisode = _audioManager.currentEpisode;
  // Removed:     _duration = _audioManager.duration;
  // Removed:   });
  // Removed: }

  Future<void> _loadSampleEpisode() async {
    final sampleEpisode = Episode(
      id: 'demo_episode',
      title: 'Background Audio Demo',
      content: 'This is a demo episode to test background audio functionality',
      category: 'Technology & AI',
      durationMinutes: 10,
      hashtags: ['demo', 'audio', 'background'],
      createdAt: DateTime.now(),
      audioUrl: 'https://example.com/demo_audio.mp3', // Replace with actual audio URL
      knowledgeType: '🔹 Core Concepts',
      coachPersonality: 'Kai',
    );

    // Removed: final success = await _audioManager.loadAndPlay(sampleEpisode);
    // Removed: if (success) {
    setState(() {
      _currentEpisode = sampleEpisode;
    });
    // Removed: }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Audio Demo'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Background Audio Info Card
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text(
                          'Background Audio Enabled',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Audio will continue playing when:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    _buildFeatureItem('📱 Screen is turned off (like Spotify)'),
                    _buildFeatureItem('🏠 App is minimized'),
                    _buildFeatureItem('🔄 You switch to other apps'),
                    _buildFeatureItem('🎵 Control from lock screen'),
                    _buildFeatureItem('🎛️ Control from notification panel'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Current Episode Display
            if (_currentEpisode != null) ...[
              const Text(
                'Now Playing:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentEpisode!.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Removed: Text(
                      // Removed:   'Coach: ${_currentEpisode!.coachPersonality}',
                      // Removed:   style: const TextStyle(fontSize: 14),
                      // Removed: );
                      Text(
                        'Category: ${_currentEpisode!.category}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Progress Bar
                      LinearProgressIndicator(
                        value: _duration.inMilliseconds > 0
                            ? _currentPosition.inMilliseconds / _duration.inMilliseconds
                            : 0.0,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Time Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(_currentPosition)),
                          Text(_formatDuration(_duration)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Audio Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous Button
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 48,
                  onPressed: () {
                    // Handle previous episode
                  },
                ),
                
                // Play/Pause Button
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 64,
                  onPressed: _currentEpisode != null
                      ? () async {
                          // Removed: if (_isPlaying) {
                          // Removed:   await _audioManager.pause();
                          // Removed: } else {
                          // Removed:   await _audioManager.play();
                          // Removed: }
                        }
                      : null,
                ),
                
                // Next Button
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 48,
                  onPressed: () {
                    // Handle next episode
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Load Demo Button
            Center(
              child: ElevatedButton(
                onPressed: _loadSampleEpisode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Load Demo Episode'),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Instructions
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Background Audio:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Tap "Load Demo Episode" to start audio'),
                    const Text('2. Press play to begin playback'),
                    const Text('3. Turn off your screen - audio continues!'),
                    const Text('4. Use lock screen controls to pause/play'),
                    const Text('5. Open other apps - audio keeps playing'),
                    const Text('6. Pull down notification panel for controls'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 2),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    // Removed: _audioManager.dispose();
    super.dispose();
  }
}
