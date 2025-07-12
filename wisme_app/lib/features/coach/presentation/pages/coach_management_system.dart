import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/components/modern_card.dart';

/// Coach Management System
/// Complete coach selection, customization, and management interface
class CoachManagementSystem extends StatefulWidget {
  final String? selectedTopic;
  final String? topicCategory;
  final Function(Map<String, dynamic>)? onCoachSelected;
  final Function(Map<String, dynamic>)? onCoachCustomized;

  const CoachManagementSystem({
    super.key,
    this.selectedTopic,
    this.topicCategory,
    this.onCoachSelected,
    this.onCoachCustomized,
  });

  @override
  State<CoachManagementSystem> createState() => _CoachManagementSystemState();
}

class _CoachManagementSystemState extends State<CoachManagementSystem>
    with TickerProviderStateMixin {
  
  late TabController _tabController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  
  int _currentPage = 0;
  Map<String, dynamic> _selectedCoach = {};
  Map<String, dynamic> _coachCustomization = {};
  
  final PageController _pageController = PageController();
  
  // Predefined coach personalities
  final List<Map<String, dynamic>> _availableCoaches = [
    {
      'id': 'kai_energetic',
      'name': 'Kai',
      'personality': 'Energetic Motivator',
      'avatar': '👨‍💻',
      'color': WismeColors.kaiPrimary,
      'description': 'High-energy, encouraging, loves making learning fun and interactive',
      'specialties': ['Technology', 'Science', 'Business', 'Creative Arts'],
      'teachingStyle': 'Interactive & Hands-on',
      'tone': 'Enthusiastic & Supportive',
      'catchphrase': '"Let\'s dive in and make this amazing!"',
      'strengths': ['Motivation', 'Practical Examples', 'Energy', 'Problem Solving'],
      'approaches': [
        'Uses real-world analogies',
        'Encourages experimentation',
        'Celebrates small wins',
        'Makes complex topics simple'
      ]
    },
    {
      'id': 'vee_calm',
      'name': 'Vee',
      'personality': 'Calm Wisdom Guide',
      'avatar': '👩‍🎓',
      'color': WismeColors.veePrimary,
      'description': 'Thoughtful, patient, focuses on deep understanding and reflection',
      'specialties': ['Philosophy', 'History', 'Literature', 'Personal Development'],
      'teachingStyle': 'Reflective & Methodical',
      'tone': 'Gentle & Insightful',
      'catchphrase': '"Let\'s explore this thoughtfully together."',
      'strengths': ['Deep Thinking', 'Patience', 'Wisdom', 'Empathy'],
      'approaches': [
        'Asks thought-provoking questions',
        'Encourages reflection',
        'Builds understanding step-by-step',
        'Connects ideas to bigger picture'
      ]
    },
  ];
  
  // Custom coach creation options
  final Map<String, List<String>> _customizationOptions = {
    'personality_traits': [
      'Enthusiastic', 'Patient', 'Humorous', 'Serious', 'Encouraging',
      'Challenging', 'Supportive', 'Direct', 'Gentle', 'Innovative'
    ],
    'teaching_styles': [
      'Visual Demonstrations', 'Storytelling', 'Step-by-Step Guidance',
      'Interactive Q&A', 'Real-world Examples', 'Analogies & Metaphors',
      'Practice-focused', 'Theory-heavy', 'Conversational', 'Structured'
    ],
    'communication_tones': [
      'Friendly & Casual', 'Professional', 'Motivational', 'Calm & Soothing',
      'Energetic', 'Thoughtful', 'Playful', 'Authoritative', 'Warm', 'Inspiring'
    ],
    'specializations': [
      'Technology & Programming', 'Business & Entrepreneurship', 'Creative Arts',
      'Science & Research', 'Personal Development', 'Health & Wellness',
      'History & Culture', 'Languages', 'Mathematics', 'Philosophy'
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildCoachSelectionPage(),
                  _buildCoachCustomizationPage(),
                  _buildCoachPreviewPage(),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: WismeColors.primaryBlue,
      title: const Text(
        'Choose Your AI Coach',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildProgressStep(0, 'Select', 'Choose coach'),
          _buildProgressLine(0),
          _buildProgressStep(1, 'Customize', 'Personalize'),
          _buildProgressLine(1),
          _buildProgressStep(2, 'Preview', 'Confirm'),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String title, String subtitle) {
    final isActive = step <= _currentPage;
    final isCompleted = step < _currentPage;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? WismeColors.success
                  : isActive
                      ? WismeColors.primaryBlue
                      : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.circle,
              color: isActive ? Colors.white : Colors.grey[600],
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: isActive ? WismeColors.primaryBlue : Colors.grey[600],
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLine(int index) {
    final isCompleted = index < _currentPage;
    
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 40),
        decoration: BoxDecoration(
          color: isCompleted ? WismeColors.success : Colors.grey[300],
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildCoachSelectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meet Your AI Coaches',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.selectedTopic != null
                ? 'Perfect coaches for "${widget.selectedTopic}"'
                : 'Choose the teaching style that resonates with you',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Filter coaches based on topic category if available
          ..._getRecommendedCoaches().map((coach) => 
            _buildCoachCard(coach, isRecommended: true)
          ).toList(),
          
          if (_getRecommendedCoaches().length < _availableCoaches.length) ...[
            const SizedBox(height: 16),
            Text(
              'Other Available Coaches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            ..._getOtherCoaches().map((coach) => 
              _buildCoachCard(coach, isRecommended: false)
            ).toList(),
          ],
          
          const SizedBox(height: 24),
          _buildCustomCoachOption(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getRecommendedCoaches() {
    if (widget.topicCategory == null) return _availableCoaches.take(2).toList();
    
    return _availableCoaches.where((coach) {
      final specialties = coach['specialties'] as List<String>;
      return specialties.any((specialty) => 
        specialty.toLowerCase().contains(widget.topicCategory!.toLowerCase())
      );
    }).toList();
  }

  List<Map<String, dynamic>> _getOtherCoaches() {
    final recommended = _getRecommendedCoaches();
    return _availableCoaches.where((coach) => 
      !recommended.contains(coach)
    ).toList();
  }

  Widget _buildCoachCard(Map<String, dynamic> coach, {required bool isRecommended}) {
    final isSelected = _selectedCoach['id'] == coach['id'];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ModernCard(
        onTap: () => setState(() => _selectedCoach = coach),
        child: Container(
          decoration: isSelected ? BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: coach['color'], width: 2),
          ) : null,
          child: Stack(
            children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: (coach['color'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: (coach['color'] as Color).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            coach['avatar'],
                            style: const TextStyle(fontSize: 28),
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
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (isRecommended) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: WismeColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'RECOMMENDED',
                                      style: TextStyle(
                                        color: WismeColors.success,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
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
                            const SizedBox(height: 4),
                            Text(
                              coach['description'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: coach['color'],
                          size: 24,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Teaching approach preview
                  Text(
                    'Teaching Style',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coach['teachingStyle'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Catchphrase
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (coach['color'] as Color).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: (coach['color'] as Color).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: coach['color'],
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            coach['catchphrase'],
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Specialties
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (coach['specialties'] as List<String>).take(3).map((specialty) =>
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          specialty,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ],      // Close Column children
              ),        // Close Column
            ),          // Close Padding  
          ],            // Close Stack children
        ),              // Close Stack
      ),                // Close Container
    ),                  // Close ModernCard
  );                    // Close Padding (return statement)
}

  Widget _buildCustomCoachOption() {
    final isSelected = _selectedCoach['id'] == 'custom';
    
    return ModernCard(
      onTap: () => setState(() => _selectedCoach = {'id': 'custom', 'name': 'Custom Coach'}),
      child: Container(
        decoration: isSelected ? BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WismeColors.wisdomPurple, width: 2),
        ) : null,
        child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: WismeColors.wisdomPurple.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: WismeColors.wisdomPurple.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.add_circle_outline,
                color: WismeColors.wisdomPurple,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Custom Coach',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Design your ideal AI teacher with personalized traits',
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
                color: WismeColors.wisdomPurple,
                size: 24,
              ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildCoachCustomizationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedCoach['id'] == 'custom' 
                ? 'Design Your Custom Coach'
                : 'Customize ${_selectedCoach['name'] ?? 'Your Coach'}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Personalize the teaching approach to match your preferences',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          if (_selectedCoach['id'] == 'custom') ...[
            _buildCustomizationSection('Coach Name', null, isTextField: true),
            const SizedBox(height: 24),
          ],
          
          _buildCustomizationSection(
            'Personality Traits',
            _customizationOptions['personality_traits']!,
            multiSelect: true,
          ),
          const SizedBox(height: 24),
          
          _buildCustomizationSection(
            'Teaching Style',
            _customizationOptions['teaching_styles']!,
            multiSelect: true,
          ),
          const SizedBox(height: 24),
          
          _buildCustomizationSection(
            'Communication Tone',
            _customizationOptions['communication_tones']!,
          ),
          const SizedBox(height: 24),
          
          _buildCustomizationSection(
            'Specialization Focus',
            _customizationOptions['specializations']!,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizationSection(
    String title,
    List<String>? options, {
    bool multiSelect = false,
    bool isTextField = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        if (isTextField)
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter your coach\'s name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _coachCustomization['name'] = value;
              });
            },
          )
        else if (options != null)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = multiSelect
                  ? (_coachCustomization[title.toLowerCase().replaceAll(' ', '_')] as List<String>?)?.contains(option) ?? false
                  : _coachCustomization[title.toLowerCase().replaceAll(' ', '_')] == option;
              
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    final key = title.toLowerCase().replaceAll(' ', '_');
                    if (multiSelect) {
                      if (_coachCustomization[key] == null) {
                        _coachCustomization[key] = <String>[];
                      }
                      final list = _coachCustomization[key] as List<String>;
                      if (selected) {
                        list.add(option);
                      } else {
                        list.remove(option);
                      }
                    } else {
                      _coachCustomization[key] = selected ? option : null;
                    }
                  });
                },
                selectedColor: WismeColors.primaryBlue.withOpacity(0.2),
                checkmarkColor: WismeColors.primaryBlue,
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildCoachPreviewPage() {
    final finalCoach = _buildFinalCoachProfile();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meet Your Personalized Coach',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Preview how your AI coach will interact with you',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Coach preview card
          ModernCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Coach avatar and basic info
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: (finalCoach['color'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: (finalCoach['color'] as Color).withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            finalCoach['avatar'],
                            style: const TextStyle(fontSize: 36),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              finalCoach['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              finalCoach['personality'],
                              style: TextStyle(
                                fontSize: 16,
                                color: finalCoach['color'],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sample interaction
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: finalCoach['color'],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Sample Interaction',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _generateSampleMessage(finalCoach),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Coach capabilities
                  _buildCapabilitiesSection(finalCoach),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Confirmation message
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: WismeColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: WismeColors.success.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: WismeColors.success,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Coach Setup Complete!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: WismeColors.success,
                        ),
                      ),
                      Text(
                        'Your personalized AI coach is ready to guide your learning journey.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilitiesSection(Map<String, dynamic> coach) {
    final capabilities = [
      'Personalized learning pace adjustment',
      'Real-time progress tracking',
      'Adaptive content difficulty',
      'Interactive Q&A sessions',
      'Practice exercise generation',
      'Progress celebration & motivation',
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Coach\'s Capabilities',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        ...capabilities.map((capability) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: coach['color'],
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  capability,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Map<String, dynamic> _buildFinalCoachProfile() {
    if (_selectedCoach['id'] == 'custom') {
      return {
        'id': 'custom_${DateTime.now().millisecondsSinceEpoch}',
        'name': _coachCustomization['name'] ?? 'Custom Coach',
        'personality': _coachCustomization['personality_traits']?.join(' & ') ?? 'Personalized',
        'avatar': '🤖',
        'color': WismeColors.wisdomPurple,
        'description': 'Your personalized AI coach designed specifically for your learning style',
        'teachingStyle': _coachCustomization['teaching_style']?.join(', ') ?? 'Adaptive',
        'tone': _coachCustomization['communication_tone'] ?? 'Friendly',
        'specializations': _coachCustomization['specialization_focus'] ?? 'General',
        'customizations': _coachCustomization,
      };
    } else {
      // Merge base coach with customizations
      return {
        ..._selectedCoach,
        'customizations': _coachCustomization,
      };
    }
  }

  String _generateSampleMessage(Map<String, dynamic> coach) {
    if (widget.selectedTopic != null) {
      return 'Hi! I\'m ${coach['name']}, and I\'m excited to help you master ${widget.selectedTopic}! Based on your learning preferences, I\'ll guide you through this topic with ${coach['teachingStyle']?.toLowerCase() ?? 'an adaptive'} approach. Let\'s start by exploring the fundamentals and building your confidence step by step. Ready to dive in?';
    }
    
    return 'Hello! I\'m ${coach['name']}, your AI learning companion. I\'m here to make your learning journey engaging and effective. I adapt my teaching style to match your pace and preferences, ensuring you get the most out of every session. What would you like to explore today?';
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Previous'),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            flex: _currentPage == 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _canProceed() ? _handleNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: WismeColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentPage == 2 ? 'Complete Setup' : 'Next',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 0:
        return _selectedCoach.isNotEmpty;
      case 1:
        return true; // Customization is optional
      case 2:
        return true; // Preview is just confirmation
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete coach setup
      final finalCoach = _buildFinalCoachProfile();
      
      if (widget.onCoachSelected != null) {
        widget.onCoachSelected!(finalCoach);
      }
      
      Navigator.pop(context, finalCoach);
    }
  }
}
