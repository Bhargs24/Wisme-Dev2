import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'onboarding/welcome_screen.dart';
import 'onboarding/consent_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'onboarding/learning_style_assessment_screen.dart';
import 'onboarding/baseline_knowledge_test_screen.dart';
import 'journeys/audio_player_screen.dart';
import 'progress/learning_progress_screen.dart';
import 'feedback/feedback_navigation_screen.dart';
import 'core/app_shell.dart';

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
        '/learning_style': (context) => const LearningStyleAssessmentScreen(),
        '/baseline_knowledge': (context) => const BaselineKnowledgeTestScreen(),
        '/app': (context) => const AppShell(),
        '/audio_player': (context) => const AudioPlayerScreen(),
        '/progress_dashboard': (context) => const LearningProgressScreen(),
        '/feedback_hub': (context) => const FeedbackNavigationScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/gamification': (context) => const GamificationScreen(),
        '/thank_you': (context) => const ThankYouScreen(),
      },
    );
  }
}

// Placeholder widgets for each major screen
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
