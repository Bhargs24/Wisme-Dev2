import 'package:flutter/material.dart';
import '../navigation/main_navigation_shell.dart';

/// Initial Onboarding Flow - 3 Screens for User Setup
/// 1. Welcome & Intent - "Why are you here?" (sets general motivation)
/// 2. Category Interests - Broad learning areas of interest  
/// 3. Account Setup - Basic profile creation and preferences
/// 
/// NOTE: Learning-specific choices (style, coach, goals) happen AFTER topic selection
/// This follows proper UX: General → Specific → Contextual
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Only collect essential user setup information
  String? _selectedIntent;
  List<String> _selectedCategories = [];

  void _nextPage() {
    if (_currentPage < 2) { // Changed from 4 to 2 (3 screens total)
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // Save basic user preferences and navigate to main dashboard
    // For a proper app, this would save to database/preferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainNavigationShell(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // Back button
                  if (_currentPage > 0)
                    IconButton(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back),
                    )
                  else
                    const SizedBox(width: 48),
                  
                  // Progress bar
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / 3, // Changed from 5 to 3
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF2196F3),
                      ),
                    ),
                  ),
                  
                  // Skip button
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _IntentSelectionPage(
                    selectedIntent: _selectedIntent,
                    onIntentSelected: (intent) {
                      setState(() {
                        _selectedIntent = intent;
                      });
                    },
                  ),
                  _CategoryPreferencesPage(
                    selectedCategories: _selectedCategories,
                    onCategoriesChanged: (categories) {
                      setState(() {
                        _selectedCategories = categories;
                      });
                    },
                  ),
                  _ProfileSetupPage(
                    onProfileComplete: () {
                      // Profile setup complete
                    },
                  ),
                ],
              ),
            ),
            
            // Continue button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _canContinue() ? _nextPage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == 2 ? 'Start Learning' : 'Continue', // Changed from 4 to 2
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canContinue() {
    switch (_currentPage) {
      case 0: return _selectedIntent != null;
      case 1: return _selectedCategories.isNotEmpty;
      case 2: return true; // Profile setup is always complete
      default: return false;
    }
  }
}

// Screen 1: Intent Selection
class _IntentSelectionPage extends StatelessWidget {
  final String? selectedIntent;
  final Function(String) onIntentSelected;

  const _IntentSelectionPage({
    required this.selectedIntent,
    required this.onIntentSelected,
  });

  @override
  Widget build(BuildContext context) {
    const intents = [
      {'title': 'Upskill for Work', 'subtitle': 'Learn practical skills for career growth', 'icon': Icons.work_outline},
      {'title': 'Learn Daily', 'subtitle': 'Build a consistent learning habit', 'icon': Icons.schedule},
      {'title': 'Explore Topics', 'subtitle': 'Discover new areas of interest', 'icon': Icons.explore},
      {'title': 'Master Skills', 'subtitle': 'Deep dive into specific subjects', 'icon': Icons.school},
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why are you here?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Help us personalize your learning experience',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: intents.length,
              itemBuilder: (context, index) {
                final intent = intents[index];
                final isSelected = selectedIntent == intent['title'];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => onIntentSelected(intent['title'] as String),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2196F3) : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? const Color(0xFF2196F3).withOpacity(0.1) : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            intent['icon'] as IconData,
                            size: 32,
                            color: isSelected ? const Color(0xFF2196F3) : Colors.grey[600],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  intent['title'] as String,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? const Color(0xFF2196F3) : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  intent['subtitle'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF2196F3),
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Screen 2: Category Preferences
class _CategoryPreferencesPage extends StatelessWidget {
  final List<String> selectedCategories;
  final Function(List<String>) onCategoriesChanged;

  const _CategoryPreferencesPage({
    required this.selectedCategories,
    required this.onCategoriesChanged,
  });

  @override
  Widget build(BuildContext context) {
    const categories = [
      'Technology & AI',
      'Business & Finance',
      'Psychology & Mind',
      'Science & Nature',
      'Creativity & Design',
      'Personal Development',
      'History & Culture',
      'Skills & Tools',
      'Career & Strategy',
      'Law & Governance',
      'Geopolitics & Global Affairs',
      'Environment & Sustainability',
      'Mathematics & Logic',
      'Gaming & Interactive Media',
      'Society & Ethics',
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What interests you?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select 3-5 topics you\'d like to explore',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategories.contains(category);
                
                return InkWell(
                  onTap: () {
                    final newCategories = List<String>.from(selectedCategories);
                    if (isSelected) {
                      newCategories.remove(category);
                    } else {
                      newCategories.add(category);
                    }
                    onCategoriesChanged(newCategories);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2196F3) : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected ? const Color(0xFF2196F3).withOpacity(0.1) : null,
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? const Color(0xFF2196F3) : null,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Screen 3: Profile Setup
class _ProfileSetupPage extends StatelessWidget {
  final VoidCallback onProfileComplete;

  const _ProfileSetupPage({
    required this.onProfileComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Almost ready!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your personalized learning experience is being prepared',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 48),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 60,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Your Learning Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Based on your preferences, we\'ll personalize:\n\n• Content recommendations\n• Learning difficulty\n• Coach selection for each topic\n• Goal-specific content',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Profile setup complete!',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Learning-specific pages moved to topic selection context
// These will be presented AFTER user selects a topic to learn

// Main Dashboard implementation
class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wisme Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: Color(0xFF4CAF50),
            ),
            SizedBox(height: 16),
            Text(
              'Onboarding Complete!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your personalized learning journey starts now',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
