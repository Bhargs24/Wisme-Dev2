import 'package:flutter/material.dart';

/// Learning-specific choice screens shown AFTER user selects a topic
/// These choices are now contextual to the selected topic/subject
class LearningChoiceFlow extends StatefulWidget {
  final String selectedTopic;
  final Function(Map<String, String>) onChoicesComplete;

  const LearningChoiceFlow({
    super.key,
    required this.selectedTopic,
    required this.onChoicesComplete,
  });

  @override
  State<LearningChoiceFlow> createState() => _LearningChoiceFlowState();
}

class _LearningChoiceFlowState extends State<LearningChoiceFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  String? _selectedLearningStyle;
  String? _selectedCoach;
  String? _selectedGoal;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete the learning choices
      widget.onChoicesComplete({
        'learningStyle': _selectedLearningStyle!,
        'coach': _selectedCoach!,
        'goal': _selectedGoal!,
      });
    }
  }

  bool _canContinue() {
    switch (_currentPage) {
      case 0:
        return _selectedLearningStyle != null;
      case 1:
        return _selectedCoach != null;
      case 2:
        return _selectedGoal != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning ${widget.selectedTopic}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / 3,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${_currentPage + 1}/3',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _LearningStylePage(
                  topic: widget.selectedTopic,
                  selectedStyle: _selectedLearningStyle,
                  onStyleSelected: (style) {
                    setState(() {
                      _selectedLearningStyle = style;
                    });
                  },
                ),
                _CoachSelectionPage(
                  topic: widget.selectedTopic,
                  selectedCoach: _selectedCoach,
                  onCoachSelected: (coach) {
                    setState(() {
                      _selectedCoach = coach;
                    });
                  },
                ),
                _GoalSettingPage(
                  topic: widget.selectedTopic,
                  selectedGoal: _selectedGoal,
                  onGoalSelected: (goal) {
                    setState(() {
                      _selectedGoal = goal;
                    });
                  },
                ),
              ],
            ),
          ),

          // Continue button
          Container(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canContinue() ? _nextPage : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentPage == 2 ? 'Start Learning' : 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Learning Style selection with topic context
class _LearningStylePage extends StatelessWidget {
  final String topic;
  final String? selectedStyle;
  final Function(String) onStyleSelected;

  const _LearningStylePage({
    required this.topic,
    required this.selectedStyle,
    required this.onStyleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final styles = [
      {
        'title': 'Fundamentals',
        'subtitle': 'Start with $topic basics and core concepts',
        'icon': Icons.foundation
      },
      {
        'title': 'Case Studies',
        'subtitle': 'Learn $topic through real-world examples',
        'icon': Icons.business_center
      },
      {
        'title': 'Mixed Approach',
        'subtitle': 'Combine $topic theory with practical examples',
        'icon': Icons.shuffle
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How do you want to learn $topic?',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Choose your preferred learning approach for this topic',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: styles.length,
              itemBuilder: (context, index) {
                final style = styles[index];
                final isSelected = selectedStyle == style['title'];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => onStyleSelected(style['title'] as String),
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
                            style['icon'] as IconData,
                            size: 32,
                            color: isSelected ? const Color(0xFF2196F3) : Colors.grey[600],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  style['title'] as String,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? const Color(0xFF2196F3) : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  style['subtitle'] as String,
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

// Coach selection with topic context
class _CoachSelectionPage extends StatelessWidget {
  final String topic;
  final String? selectedCoach;
  final Function(String) onCoachSelected;

  const _CoachSelectionPage({
    required this.topic,
    required this.selectedCoach,
    required this.onCoachSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your $topic coach',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select the AI coach that best fits your learning style for $topic',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 48),
          Expanded(
            child: Column(
              children: [
                // Kai - Calm Coach
                Expanded(
                  child: InkWell(
                    onTap: () => onCoachSelected('Kai'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedCoach == 'Kai' ? const Color(0xFF2196F3) : Colors.grey[300]!,
                          width: selectedCoach == 'Kai' ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        color: selectedCoach == 'Kai' ? const Color(0xFF2196F3).withOpacity(0.1) : null,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.spa,
                              size: 40,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Kai',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: selectedCoach == 'Kai' ? const Color(0xFF2196F3) : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Calm & Thoughtful',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Perfect for deep $topic learning and contemplation. Explains complex concepts clearly.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Vee - Energetic Coach
                Expanded(
                  child: InkWell(
                    onTap: () => onCoachSelected('Vee'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedCoach == 'Vee' ? const Color(0xFF2196F3) : Colors.grey[300]!,
                          width: selectedCoach == 'Vee' ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        color: selectedCoach == 'Vee' ? const Color(0xFF2196F3).withOpacity(0.1) : null,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9800).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.bolt,
                              size: 40,
                              color: Color(0xFFFF9800),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Vee',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: selectedCoach == 'Vee' ? const Color(0xFF2196F3) : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Energetic & Motivating',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFF9800),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Makes $topic exciting and engaging. Great for staying motivated through challenging concepts.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Goal setting with topic context
class _GoalSettingPage extends StatelessWidget {
  final String topic;
  final String? selectedGoal;
  final Function(String) onGoalSelected;

  const _GoalSettingPage({
    required this.topic,
    required this.selectedGoal,
    required this.onGoalSelected,
  });

  @override
  Widget build(BuildContext context) {
    final goals = [
      {
        'title': 'Explore',
        'subtitle': 'Get an overview of $topic and key concepts',
        'icon': Icons.explore
      },
      {
        'title': 'Master',
        'subtitle': 'Become an expert in $topic fundamentals',
        'icon': Icons.military_tech
      },
      {
        'title': 'Apply',
        'subtitle': 'Learn $topic for immediate practical use',
        'icon': Icons.build
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s your $topic goal?',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This helps us customize your $topic learning path',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final isSelected = selectedGoal == goal['title'];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => onGoalSelected(goal['title'] as String),
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
                            goal['icon'] as IconData,
                            size: 32,
                            color: isSelected ? const Color(0xFF2196F3) : Colors.grey[600],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal['title'] as String,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? const Color(0xFF2196F3) : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  goal['subtitle'] as String,
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
