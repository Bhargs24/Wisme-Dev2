import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/components/modern_card.dart';

/// Complete Learning Choice Flow - Post Topic Selection
/// Handles coach selection and goal setting
class CompleteLearningChoiceFlow extends StatefulWidget {
  final String selectedTopic;
  final String topicCategory;
  final Function(Map<String, dynamic>) onChoicesComplete;
  
  const CompleteLearningChoiceFlow({
    super.key,
    required this.selectedTopic,
    required this.topicCategory,
    required this.onChoicesComplete,
  });

  @override
  State<CompleteLearningChoiceFlow> createState() => _CompleteLearningChoiceFlowState();
}

class _CompleteLearningChoiceFlowState extends State<CompleteLearningChoiceFlow> {
  final PageController _pageController = PageController();
  
  int _currentPage = 0;
  String? _selectedCoach;
  String? _selectedGoal;
  String? _customCoachName;
  
  // Coach options with personalities
  final List<Map<String, dynamic>> _coaches = [
    {
      'name': 'Kai',
      'personality': 'Thoughtful Mentor',
      'description': 'Calm, analytical, and methodical. Perfect for deep learning and reflection.',
      'avatar': '🧘',
      'color': const Color(0xFF4A90E2),
      'strengths': ['Deep Analysis', 'Structured Learning', 'Critical Thinking'],
      'bestFor': 'Complex topics requiring careful consideration',
    },
    {
      'name': 'Vee',
      'personality': 'Energetic Friend',
      'description': 'Dynamic, engaging, and inspiring. Great for motivation and quick learning.',
      'avatar': '⚡',
      'color': const Color(0xFFE74C3C),
      'strengths': ['High Energy', 'Engaging Stories', 'Motivation'],
      'bestFor': 'Action-oriented learning and skill building',
    },
  ];
  
  // Learning goals
  final List<Map<String, String>> _goals = [
    {
      'title': 'Explore',
      'description': 'Get a broad overview and discover new areas',
      'icon': '🔍',
    },
    {
      'title': 'Master',
      'description': 'Develop deep expertise and comprehensive knowledge',
      'icon': '🎓',
    },
    {
      'title': 'Apply',
      'description': 'Focus on practical skills and immediate implementation',
      'icon': '🛠️',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 1) { // Changed from 2 to 1 (removed learning style page)
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeFlow();
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

  void _completeFlow() {
    final choices = {
      'topic': widget.selectedTopic,
      'category': widget.topicCategory,
      'coach': _selectedCoach,
      'customCoachName': _customCoachName,
      'goal': _selectedGoal,
      'completedAt': DateTime.now().toIso8601String(),
    };
    
    widget.onChoicesComplete(choices);
  }

  bool get _canProceed {
    switch (_currentPage) {
      case 0:
        return _selectedCoach != null;
      case 1:
        return _selectedGoal != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Learning Setup for ${widget.selectedTopic}',
          style: const TextStyle(
            color: WismeColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: _currentPage > 0
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: WismeColors.textPrimary),
              onPressed: _previousPage,
            )
          : null,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / 2,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(WismeColors.primaryBlue),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${_currentPage + 1}/2',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: WismeColors.primaryBlue,
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
                _buildCoachSelectionPage(),
                _buildGoalSelectionPage(),
              ],
            ),
          ),
          
          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousPage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: WismeColors.primaryBlue),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 16),
                Expanded(
                  flex: _currentPage == 0 ? 1 : 2,
                  child: ElevatedButton(
                    onPressed: _canProceed ? _nextPage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WismeColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      disabledBackgroundColor: Colors.grey[400],
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Start Learning Journey' : 'Continue',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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

  Widget _buildCoachSelectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose your AI coach',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: WismeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select the coaching personality that resonates with you for ${widget.selectedTopic}',
            style: const TextStyle(
              fontSize: 16,
              color: WismeColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          
          ..._coaches.map((coach) {
            final isSelected = _selectedCoach == coach['name'];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCoach = coach['name'];
                  });
                },
                child: ModernCard(
                  backgroundColor: isSelected 
                    ? coach['color'].withOpacity(0.1)
                    : Colors.white,
                  border: isSelected 
                    ? Border.all(color: coach['color'], width: 2)
                    : Border.all(color: Colors.grey[300]!, width: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: coach['color'].withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                coach['avatar'],
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      coach['name'],
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected 
                                          ? coach['color']
                                          : WismeColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: coach['color'],
                                        size: 20,
                                      ),
                                  ],
                                ),
                                Text(
                                  coach['personality'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: coach['color'],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        coach['description'],
                        style: const TextStyle(
                          fontSize: 15,
                          color: WismeColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Strengths:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: WismeColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: (coach['strengths'] as List<String>).map((strength) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: coach['color'].withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        strength,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: coach['color'],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Best for: ${coach['bestFor']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          
          // Custom coach name input
          if (_selectedCoach != null) ...[
            const SizedBox(height: 20),
            ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.edit,
                        color: WismeColors.primaryBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Customize Your Coach (Optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: WismeColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Give your coach a custom name (or keep "$_selectedCoach")',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      _customCoachName = value.trim().isEmpty ? null : value.trim();
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalSelectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s your learning goal?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: WismeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This helps us tailor the learning journey for ${widget.selectedTopic}',
            style: const TextStyle(
              fontSize: 16,
              color: WismeColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          
          ..._goals.map((goal) {
            final isSelected = _selectedGoal == goal['title'];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGoal = goal['title'];
                  });
                },
                child: ModernCard(
                  backgroundColor: isSelected 
                    ? WismeColors.success.withOpacity(0.1)
                    : Colors.white,
                  border: isSelected 
                    ? Border.all(color: WismeColors.success, width: 2)
                    : Border.all(color: Colors.grey[300]!, width: 1),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? WismeColors.success.withOpacity(0.2)
                            : Colors.grey[100],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            goal['icon']!,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal['title']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected 
                                  ? WismeColors.success
                                  : WismeColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              goal['description']!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: WismeColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: WismeColors.success,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          
          const SizedBox(height: 32),
          
          // Summary card
          if (_selectedCoach != null && _selectedGoal != null)
            ModernCard(
              backgroundColor: WismeColors.info.withOpacity(0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.summarize,
                        color: WismeColors.info,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Your Learning Plan Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: WismeColors.info,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Topic', widget.selectedTopic),
                  _buildSummaryRow('Coach', _customCoachName ?? _selectedCoach!),
                  _buildSummaryRow('Goal', _selectedGoal!),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: WismeColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



