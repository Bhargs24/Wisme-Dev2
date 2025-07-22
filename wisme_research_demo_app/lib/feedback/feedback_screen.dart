import 'package:flutter/material.dart';
import 'journey_completion_screen.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final journey = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    return JourneyCompletionScreen(completedJourney: journey);
  }
} 