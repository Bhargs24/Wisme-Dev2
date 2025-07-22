import 'package:flutter/material.dart';

// Placeholder widgets for each demo screen
class DemoAppFlow extends StatefulWidget {
  const DemoAppFlow({super.key});

  @override
  State<DemoAppFlow> createState() => _DemoAppFlowState();
}

class _DemoAppFlowState extends State<DemoAppFlow> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = const [
    _WelcomeDemoScreen(),
    _WhyThisDemoScreen(),
    _VisionMeetCoachScreen(),
    _VisionPersonalizedLearningScreen(),
    _VisionGamifiedFeedbackScreen(),
    _VisionSmartAnalyticsScreen(),
    _OnboardingDemoScreen(),
    _DemoExperienceScreen(),
    _ThankYouScreen(),
  ];

  void _nextPage() {
    if (_currentPage < _screens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _screens,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 0)
              ElevatedButton(
                onPressed: _previousPage,
                child: const Text('Back'),
              )
            else
              const SizedBox(width: 80),
            ElevatedButton(
              onPressed: _nextPage,
              child: Text(_currentPage == _screens.length - 1 ? 'Finish' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Placeholder Screens ---
class _WelcomeDemoScreen extends StatelessWidget {
  const _WelcomeDemoScreen();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF10131A),
            Color(0xFF1A2233),
            Color(0xFF232B3E),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Placeholder for logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
            child: const Center(
              child: Icon(Icons.rocket_launch, size: 72, color: Colors.white),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Welcome to the Wisme Research Demo!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'This is a special prototype to help us validate new learning methods. The real Wisme app will be your personal AI coach—smarter, more adaptive, and packed with features. Your feedback here helps us build the future of learning.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              elevation: 8,
            ),
            onPressed: () {
              // Advance to next page
              final parent = context.findAncestorStateOfType<_DemoAppFlowState>();
              parent?._nextPage();
            },
            child: const Text("See What’s Next"),
          ),
        ],
      ),
    );
  }
}

class _WhyThisDemoScreen extends StatelessWidget {
  const _WhyThisDemoScreen();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF181C24),
            Color(0xFF232B3E),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.question_answer, size: 72, color: Color(0xFF00BCD4)),
          const SizedBox(height: 24),
          const Text(
            'Why are we doing this?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _BulletPoint(
                  icon: Icons.science,
                  text: 'We’re testing a revolutionary conversational learning method.',
                ),
                SizedBox(height: 12),
                _BulletPoint(
                  icon: Icons.people,
                  text: 'This demo helps us collect data to prove its effectiveness.',
                ),
                SizedBox(height: 12),
                _BulletPoint(
                  icon: Icons.handshake,
                  text: 'You’re not just a user—you’re a co-creator!',
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BCD4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              elevation: 8,
            ),
            onPressed: () {
              // Advance to next page
              final parent = context.findAncestorStateOfType<_DemoAppFlowState>();
              parent?._nextPage();
            },
            child: const Text("Preview the Full Vision"),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BulletPoint({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Color(0xFF2196F3), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _VisionMeetCoachScreen extends StatelessWidget {
  const _VisionMeetCoachScreen();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF181C24),
            Color(0xFF232B3E),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animated avatar placeholder
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.10),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.2),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.smart_toy, size: 80, color: Color(0xFF00BCD4)),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Meet Your AI Coach',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Dynamic animation of an evolving AI avatar. Personalized greeting and progress summary.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          // Progress summary placeholder
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.trending_up, color: Color(0xFF2196F3), size: 28),
                SizedBox(width: 12),
                Text(
                  'Progress: 3 journeys started',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              elevation: 8,
            ),
            onPressed: () {
              // Advance to next page
              final parent = context.findAncestorStateOfType<_DemoAppFlowState>();
              parent?._nextPage();
            },
            child: const Text("Next"),
          ),
          const SizedBox(height: 16),
          const Text(
            'Full App Vision – Coming Soon',
            style: TextStyle(color: Colors.white54, fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class _VisionPersonalizedLearningScreen extends StatelessWidget {
  const _VisionPersonalizedLearningScreen();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.auto_awesome, size: 80, color: Colors.white),
          SizedBox(height: 24),
          Text('Personalized Learning', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Visuals showing adaptive content, smart recommendations.', style: TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _VisionGamifiedFeedbackScreen extends StatelessWidget {
  const _VisionGamifiedFeedbackScreen();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.emoji_events, size: 80, color: Colors.white),
          SizedBox(height: 24),
          Text('Gamified Feedback', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Demo of interactive, fun feedback (emoji sliders, drag-and-drop, etc.)', style: TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _VisionSmartAnalyticsScreen extends StatelessWidget {
  const _VisionSmartAnalyticsScreen();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.analytics, size: 80, color: Colors.white),
          SizedBox(height: 24),
          Text('Smart Analytics', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('How the app learns from you to improve your journey.', style: TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _OnboardingDemoScreen extends StatelessWidget {
  const _OnboardingDemoScreen();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.person_add, size: 80, color: Colors.white),
          SizedBox(height: 24),
          Text('Onboarding', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Collect essential user info for research and personalization.', style: TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _DemoExperienceScreen extends StatelessWidget {
  const _DemoExperienceScreen();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.play_circle_fill, size: 80, color: Colors.white),
          SizedBox(height: 24),
          Text('Demo Experience', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Try the conversational learning flow and give feedback.', style: TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ThankYouScreen extends StatelessWidget {
  const _ThankYouScreen();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.celebration, size: 80, color: Colors.white),
          SizedBox(height: 24),
          Text('Thank You!', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('You’re a Wisme Pioneer! Your feedback is building the next generation of learning.', style: TextStyle(color: Colors.white70, fontSize: 18), textAlign: TextAlign.center),
        ],
      ),
    );
  }
} 
