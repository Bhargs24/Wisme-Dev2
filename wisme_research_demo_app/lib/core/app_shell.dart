import 'package:flutter/material.dart';
import '../core/bottom_nav_bar.dart';
import '../home/modern_home_screen.dart';
import '../journeys/journey_selection_screen.dart';
import '../progress/learning_progress_screen.dart';
import '../gamification/profile_screen.dart';
import '../feedback/feedback_navigation_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ModernHomeScreen(),
    const JourneySelectionScreen(),
    const LearningProgressScreen(),
    const ProfileScreen(),
    const FeedbackNavigationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
} 