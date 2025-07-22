import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'core/auth_provider.dart';
import 'core/research_metrics_provider.dart';
import 'theme/app_theme.dart';
import 'onboarding/research_intro_screen.dart';
import 'onboarding/auth_screen.dart';
import 'onboarding/welcome_screen.dart';
import 'features/full_app_preview_screen.dart';
import 'onboarding/consent_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'onboarding/learning_style_assessment_screen.dart';
import 'onboarding/baseline_knowledge_test_screen.dart';
import 'onboarding/onboarding_complete_screen.dart';
import 'journeys/journey_selection_screen.dart';
import 'journeys/audio_player_screen.dart';
import 'progress/learning_progress_screen.dart';
import 'feedback/feedback_navigation_screen.dart';
import 'feedback/modern_journey_comparison_screen.dart';
import 'feedback/product_interest_screen.dart';
import 'feedback/final_research_survey_screen.dart';
import 'feedback/study_completion_screen.dart';
import 'research/research_center_screen.dart';
import 'home/modern_home_screen.dart';
import 'community/topic_suggestion_screen.dart';
import 'community/community_requests_screen.dart';
import 'core/app_shell.dart';
import 'admin/admin_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Continue without Firebase for now
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ResearchMetricsProvider()),
      ],
      child: const WismeResearchDemoApp(),
    ),
  );
}

class WismeResearchDemoApp extends StatelessWidget {
  const WismeResearchDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ResearchMetricsProvider>(
      builder: (context, auth, research, _) {
        // Initialize research metrics with user ID when signed in
        if (auth.user != null && research.userId == null) {
          research.setUserId(auth.user!.uid);
        }
        
        return MaterialApp(
          title: 'Wisme Research Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          initialRoute: auth.isSignedIn ? '/home' : '/',
          routes: {
            '/': (context) => const ResearchIntroScreen(),
            '/auth': (context) => const AuthScreen(),
            '/welcome': (context) => const WelcomeScreen(),
            '/home': (context) => const ModernHomeScreen(),
            '/consent': (context) => const ConsentScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/onboarding_complete': (context) => const OnboardingCompleteScreen(),
            '/learning_style': (context) => const LearningStyleAssessmentScreen(),
            '/baseline_knowledge': (context) => const BaselineKnowledgeTestScreen(),
            '/journeys': (context) => const JourneySelectionScreen(),
            '/journey_selection': (context) => const JourneySelectionScreen(), // Added missing route
            '/app': (context) => const AppShell(),
            '/audio_player': (context) => const AudioPlayerScreen(),
            '/progress_dashboard': (context) => const LearningProgressScreen(),
            '/feedback_hub': (context) => const FeedbackNavigationScreen(),
            '/suggest_topic': (context) => const TopicSuggestionScreen(),
            '/community_requests': (context) => const CommunityRequestsScreen(),
            '/research_center': (context) => const ResearchCenterScreen(),
            '/journey_comparison': (context) => const ModernJourneyComparisonScreen(),
            '/product_interest': (context) => const ProductInterestScreen(),
            '/final_research_survey': (context) => const FinalResearchSurveyScreen(),
            '/study_completion': (context) => const StudyCompletionScreen(),
            '/thank_you': (context) => const ThankYouScreen(),
            '/admin': (context) => const AdminLoginScreen(),
            '/full_app_preview': (context) => const FullAppPreviewScreen(),
          },
        );
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
