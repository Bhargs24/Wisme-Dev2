import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const WismeResearchDemoApp());
}

class WismeResearchDemoApp extends StatelessWidget {
  const WismeResearchDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisme Research Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/consent': (context) => const ConsentScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/journey_selection': (context) => const JourneySelectionScreen(),
        '/audio_player': (context) => const AudioPlayerScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/gamification': (context) => const GamificationScreen(),
        '/thank_you': (context) => const ThankYouScreen(),
      },
    );
  }
}

// Placeholder widgets for each major screen
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Welcome Screen', style: Theme.of(context).textTheme.headlineLarge)),
    );
  }
}

class ConsentScreen extends StatelessWidget {
  const ConsentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Consent Screen', style: Theme.of(context).textTheme.headlineLarge)),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Onboarding Screen', style: Theme.of(context).textTheme.headlineLarge)),
    );
  }
}

class JourneySelectionScreen extends StatelessWidget {
  const JourneySelectionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Journey Selection Screen', style: Theme.of(context).textTheme.headlineLarge)),
    );
  }
}

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Audio Player Screen', style: Theme.of(context).textTheme.headlineLarge)),
    );
  }
}

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Feedback Screen', style: Theme.of(context).textTheme.headlineLarge)),
    );
  }
}

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Gamification Screen', style: Theme.of(context).textTheme.headlineLarge)),
    );
  }
}

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Thank You Screen', style: Theme.of(context).textTheme.headlineLarge)),
    );
  }
}
