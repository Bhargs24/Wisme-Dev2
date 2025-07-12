// Example of how to navigate to the Enhanced Audio Player

import 'package:flutter/material.dart';
import '../features/audio/audio_player_screen.dart';

class AudioPlayerExample {
  static void navigateToAudioPlayer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AudioPlayerScreen(
          episodeTitle: 'Learning Session',
          episodeContent: 'Welcome to your learning session. Today we will explore new concepts together. Let\'s begin this journey of discovery.',
          coachPersonality: 'Kai', // or 'Vee'
          audioUrl: 'https://example.com/audio.mp3', // Replace with actual audio URL
          duration: Duration(minutes: 5), // Replace with actual duration
        ),
      ),
    );
  }
}

// Usage example:
// AudioPlayerExample.navigateToAudioPlayer(context);
