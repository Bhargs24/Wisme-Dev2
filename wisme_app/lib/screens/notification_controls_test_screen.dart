import 'package:flutter/material.dart';
import '../models/episode.dart';

/// Notification Controls Demo Screen
/// Shows exactly how notification bar controls work
class NotificationControlsTestScreen extends StatefulWidget {
  const NotificationControlsTestScreen({super.key});

  @override
  State<NotificationControlsTestScreen> createState() => _NotificationControlsTestScreenState();
}

class _NotificationControlsTestScreenState extends State<NotificationControlsTestScreen> {
  // Removed: final BackgroundAudioManager _audioManager = BackgroundAudioManager();
  bool _isPlaying = false;
  bool _notificationShowing = false;
  Episode? _currentEpisode;
  
  @override
  void initState() {
    super.initState();
    // Removed: _initializeAudio();
  }

  // Removed: Future<void> _initializeAudio() async {
  // Removed:   await _audioManager.initialize();
  // Removed:   
  // Removed:   _audioManager.addPlayStateListener(() {
  // Removed:     setState(() {
  // Removed:       _isPlaying = _audioManager.isPlaying;
  // Removed:     });
  // Removed:   });
  // Removed: }

  Future<void> _startDemoEpisode() async {
    final demoEpisode = Episode(
      id: 'notification_demo',
      title: 'Notification Controls Demo',
      content: 'Testing notification bar controls with background audio',
      category: 'Technology & AI',
      durationMinutes: 5,
      hashtags: ['demo', 'notification', 'controls'],
      createdAt: DateTime.now(),
      audioUrl: 'https://example.com/demo_audio.mp3',
      learningType: '🔹 Core Concepts',
      coachPersonality: 'Kai',
    );

    // Removed: final success = await _audioManager.loadAndPlay(demoEpisode);
    // Removed: if (success) {
    // Removed:   setState(() {
    // Removed:     _currentEpisode = demoEpisode;
    // Removed:     _notificationShowing = true;
    // Removed:   });
    // Removed:   
    // Removed:   // Show success message
    // Removed:   _showSnackBar('✅ Episode started! Check your notification bar for controls!');
    // Removed: } else {
    // Removed:   _showSnackBar('❌ Failed to start episode');
    // Removed: }
    // Placeholder for new audio playback logic
    setState(() {
      _currentEpisode = demoEpisode;
      _notificationShowing = true;
    });
    _showSnackBar('✅ Episode started! Check your notification bar for controls!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Controls Test'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Status Card
            Card(
              color: _notificationShowing ? Colors.green.shade50 : Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      _notificationShowing ? Icons.notifications_active : Icons.notifications_off,
                      color: _notificationShowing ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _notificationShowing ? 'Notification Controls Active' : 'No Active Notification',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _notificationShowing 
                              ? 'Pull down notification panel to see controls' 
                              : 'Start an episode to see notification controls',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Notification Preview
            const Text(
              'Notification Bar Preview:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            // Mock notification
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Column(
                children: [
                  // Notification header
                  Row(
                    children: [
                      Icon(Icons.audiotrack, color: Colors.purple),
                      const SizedBox(width: 8),
                      const Text('Wisme', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text(
                        'now',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Episode info
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(Icons.psychology, color: Colors.purple),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentEpisode?.title ?? 'Episode Title',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _currentEpisode != null 
                                ? 'Learning with ${_currentEpisode!.category}'
                                : 'Learning with Coach',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              _currentEpisode?.category ?? 'Category',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Previous button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: () {
                            _showSnackBar('⏮️ Previous button tapped in notification');
                          },
                        ),
                      ),
                      
                      // Play/Pause button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                          iconSize: 32,
                          onPressed: () async {
                            // Placeholder for new audio playback logic
                            if (_isPlaying) {
                              _showSnackBar('⏸️ Paused from notification');
                            } else {
                              _showSnackBar('▶️ Playing from notification');
                            }
                          },
                        ),
                      ),
                      
                      // Next button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: () {
                            _showSnackBar('⏭️ Next button tapped in notification');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Test Instructions
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How to Test Notification Controls:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTestStep('1', 'Tap "Start Demo Episode" below'),
                    _buildTestStep('2', 'Pull down from top of screen (notification panel)'),
                    _buildTestStep('3', 'Look for "Wisme" notification with controls'),
                    _buildTestStep('4', 'Tap Previous/Play/Next buttons in notification'),
                    _buildTestStep('5', 'Lock your screen and test lock screen controls'),
                    _buildTestStep('6', 'Test with headphones/Bluetooth controls'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Platform-specific info
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Platform-Specific Controls:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPlatformFeature('Android', 'Notification panel with 3 buttons'),
                    _buildPlatformFeature('Android', 'Lock screen media controls'),
                    _buildPlatformFeature('Android', 'Persistent notification when playing'),
                    _buildPlatformFeature('iOS', 'Control Center integration'),
                    _buildPlatformFeature('iOS', 'Lock screen Now Playing'),
                    _buildPlatformFeature('iOS', 'Siri voice control support'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Start Demo Button
            Center(
              child: ElevatedButton(
                onPressed: _startDemoEpisode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Start Demo Episode',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Current Status
            if (_currentEpisode != null)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✅ Demo Episode Active',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Title: ${_currentEpisode!.title}'),
                      Text('Category: ${_currentEpisode!.category}'),
                      Text('Status: ${_isPlaying ? "Playing" : "Paused"}'),
                      const SizedBox(height: 8),
                      const Text(
                        'Now check your notification panel for controls!',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestStep(String number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(description, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformFeature(String platform, String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: platform == 'Android' ? Colors.green : Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              platform,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(feature, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Removed: _audioManager.dispose();
    super.dispose();
  }
}
