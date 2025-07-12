import 'package:flutter/material.dart';




import '../../core/core.dart';
import '../../shared/shared.dart';
import '../../models/models.dart';
/// Smart Learning Choice Flow with AI-Powered Category Detection
/// Uses domain-adaptive knowledge levels instead of generic difficulty
class SmartLearningChoiceFlow extends StatefulWidget {
  final String selectedTopic;
  final String? personalContext;
  final Function(Map<String, dynamic>) onChoicesComplete;

  const SmartLearningChoiceFlow({
    super.key,
    required this.selectedTopic,
    this.personalContext,
    required this.onChoicesComplete,
  });

  @override
  State<SmartLearningChoiceFlow> createState() => _SmartLearningChoiceFlowState();
}

class _SmartLearningChoiceFlowState extends State<SmartLearningChoiceFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isAnalyzing = true;
  
  // AI Classification Results
  TopicClassification? _classification;
  String? _selectedKnowledgeLevel;
  String? _selectedCoach;
  String? _selectedGoal;

  @override
  void initState() {
    super.initState();
    _analyzeTopicWithAI();
  }

  Future<void> _analyzeTopicWithAI() async {
    try {
      final classification = await AdvancedTopicClassifier.analyzeTopicWithAI(
        widget.selectedTopic,
        personalContext: widget.personalContext,
      );
      
      setState(() {
        _classification = classification;
        _isAnalyzing = false;
      });
    } catch (e) {
      // Fallback to generic classification
      setState(() {
        _classification = _createFallbackClassification();
        _isAnalyzing = false;
      });
    }
  }

  TopicClassification _createFallbackClassification() {
    return TopicClassification(
      originalTopic: widget.selectedTopic,
      category: 'Personal Development',
      knowledgeLevel: '🎯 Self-Development',
      confidence: 0.7,
      subtopics: [],
      learningStyleHints: ['practical'],
      episodePlan: EpisodePlan(
        progressionPath: ['Introduction', 'Core Concepts', 'Application'],
        learningObjectives: ['Understand basics', 'Apply knowledge'],
        totalEpisodes: 3,
      ),
      recommendedCoach: 'Vee',
      estimatedDuration: 30,
      prerequisiteTopics: [],
      personalContext: widget.personalContext,
    );
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeChoices();
    }
  }

  void _completeChoices() {
    final choices = {
      'topic': widget.selectedTopic,
      'category': _classification!.category,
      'knowledgeLevel': _selectedKnowledgeLevel!,
      'coach': _selectedCoach!,
      'goal': _selectedGoal!,
      'personalContext': widget.personalContext,
      'classification': _classification!,
    };
    
    widget.onChoicesComplete(choices);
  }

  @override
  Widget build(BuildContext context) {
    if (_isAnalyzing) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Analyzing "${widget.selectedTopic}"...',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Determining the best learning approach for you',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Customize Your ${_classification!.category} Learning',
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentPage + 1) / 3,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(WismeColors.primaryBlue),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                _buildKnowledgeLevelPage(),
                _buildCoachSelectionPage(),
                _buildGoalSettingPage(),
              ],
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildKnowledgeLevelPage() {
    final levels = AdvancedTopicClassifier.categoryLevels[_classification!.category] ?? [];
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your ${_classification!.category} approach',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Each approach is designed specifically for ${_classification!.category} learning',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                final isSelected = _selectedKnowledgeLevel == level;
                final description = _getLevelDescription(_classification!.category, level);
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => setState(() => _selectedKnowledgeLevel = level),
                    child: ModernCard(
                      backgroundColor: isSelected 
                          ? WismeColors.primaryBlue.withOpacity(0.1) 
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: level,
                                  groupValue: _selectedKnowledgeLevel,
                                  onChanged: (value) => setState(() => _selectedKnowledgeLevel = value),
                                ),
                                Expanded(
                                  child: Text(
                                    level,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 48),
                              child: Text(
                                description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildCoachSelectionPage() {
    final coaches = [
      {
        'name': 'Kai',
        'personality': 'Calm & Thoughtful',
        'description': 'Deep, reflective learning with philosophical insights',
        'icon': Icons.psychology,
        'color': WismeColors.kaiPrimary,
      },
      {
        'name': 'Vee',
        'personality': 'Energetic & Practical',
        'description': 'Dynamic, action-oriented learning with real-world focus',
        'icon': Icons.bolt,
        'color': WismeColors.veePrimary,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your learning coach for ${widget.selectedTopic}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your coach will guide your ${_classification!.category} journey',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: coaches.length,
              itemBuilder: (context, index) {
                final coach = coaches[index];
                final isSelected = _selectedCoach == coach['name'];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => setState(() => _selectedCoach = coach['name'] as String),
                    child: ModernCard(
                      backgroundColor: isSelected 
                          ? (coach['color'] as Color).withOpacity(0.1) 
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: (coach['color'] as Color).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                coach['icon'] as IconData,
                                color: coach['color'] as Color,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${coach['name']} - ${coach['personality']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    coach['description'] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Radio<String>(
                              value: coach['name'] as String,
                              groupValue: _selectedCoach,
                              onChanged: (value) => setState(() => _selectedCoach = value),
                            ),
                          ],
                        ),
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

  Widget _buildGoalSettingPage() {
    final goals = [
      {
        'title': 'Explore',
        'subtitle': 'Get a comprehensive overview and understand key concepts',
        'icon': Icons.explore,
      },
      {
        'title': 'Master',
        'subtitle': 'Develop deep expertise and comprehensive understanding',
        'icon': Icons.military_tech,
      },
      {
        'title': 'Apply',
        'subtitle': 'Focus on practical implementation and real-world use',
        'icon': Icons.build,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s your goal with ${widget.selectedTopic}?',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This shapes your ${_classification!.category} learning journey',
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
                final isSelected = _selectedGoal == goal['title'];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => setState(() => _selectedGoal = goal['title'] as String),
                    child: ModernCard(
                      backgroundColor: isSelected 
                          ? WismeColors.primaryBlue.withOpacity(0.1) 
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(
                              goal['icon'] as IconData,
                              size: 32,
                              color: isSelected ? WismeColors.primaryBlue : Colors.grey[600],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
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
                            Radio<String>(
                              value: goal['title'] as String,
                              groupValue: _selectedGoal,
                              onChanged: (value) => setState(() => _selectedGoal = value),
                            ),
                          ],
                        ),
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

  Widget _buildBottomButton() {
    bool canContinue = false;
    String buttonText = 'Continue';
    
    switch (_currentPage) {
      case 0:
        canContinue = _selectedKnowledgeLevel != null;
        break;
      case 1:
        canContinue = _selectedCoach != null;
        break;
      case 2:
        canContinue = _selectedGoal != null;
        buttonText = 'Start Learning Journey';
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: canContinue ? _nextPage : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: WismeColors.primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _getLevelDescription(String category, String level) {
    final descriptions = {
      'Technology & AI': {
        '🔹 Core Concepts': 'Fundamentals, definitions, and basic principles',
        '💼 Case Studies': 'Real implementations, company examples, success stories',
        '🛠 Tools & Trends': 'Latest tools, frameworks, emerging technologies',
        '🎛 Bit of Everything': 'Balanced mix of theory, practice, and trends',
      },
      'Business & Finance': {
        '💡 Fundamentals': 'Basic principles, core theories, essential concepts',
        '💼 Case Studies': 'Company strategies, market analysis, business stories',
        '📈 Growth Strategy': 'Scaling tactics, market penetration, expansion methods',
        '🎛 Balanced Mix': 'Theory + real examples + actionable strategies',
      },
      // Add more categories as needed...
    };
    
    return descriptions[category]?[level] ?? 'Specialized approach for this topic';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
