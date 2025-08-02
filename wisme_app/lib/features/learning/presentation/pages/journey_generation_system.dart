import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/components/modern_card.dart';

/// Journey Generation System - Creates personalized learning journeys
/// Based on user topic, coach, and goals
class JourneyGenerationSystem extends StatefulWidget {
  final Map<String, dynamic> learningChoices;
  final Function(Map<String, dynamic>) onJourneyGenerated;
  
  const JourneyGenerationSystem({
    super.key,
    required this.learningChoices,
    required this.onJourneyGenerated,
  });

  @override
  State<JourneyGenerationSystem> createState() => _JourneyGenerationSystemState();
}

class _JourneyGenerationSystemState extends State<JourneyGenerationSystem>
    with TickerProviderStateMixin {
  
  bool _isGenerating = false;
  Map<String, dynamic>? _generatedJourney;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  // Generation steps
  final List<String> _generationSteps = [
    'Analyzing your learning preferences...',
    'Creating personalized curriculum...',
    'Designing episode structure...',
    'Optimizing for your goals...',
    'Finalizing your journey...',
  ];
  
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Start generation automatically
    _startJourneyGeneration();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startJourneyGeneration() async {
    setState(() {
      _isGenerating = true;
      _currentStep = 0;
    });

    _animationController.forward();

    // Simulate AI journey generation with steps
    for (int i = 0; i < _generationSteps.length; i++) {
      setState(() {
        _currentStep = i;
      });
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    // Generate the actual journey
    final journey = await _generateJourney();

    setState(() {
      _isGenerating = false;
      _generatedJourney = journey;
    });

    _animationController.stop();
  }

  Future<Map<String, dynamic>> _generateJourney() async {
    final choices = widget.learningChoices;
    final topic = choices['topic'] as String;
    final coach = choices['coach'] as String;
    final learningType = choices['learningType'] as String;
    final category = choices['category'] as String;
    final episodeCount = choices['episodeCount'] as int? ?? 5; // Default to 5 episodes
    
    // Generate episode titles and descriptions based on learning choices
    final episodes = _generateEpisodes(topic, learningType, episodeCount);
    
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _generateJourneyTitle(topic, learningType),
      'description': _generateJourneyDescription(topic, learningType),
      'topic': topic,
      'category': category,
      'coach': coach,
      'customCoachName': choices['customCoachName'],
      'learningType': learningType,
      'episodes': episodes,
      'estimatedDuration': episodes.length * 12, // 12 minutes per episode
      'totalEpisodes': episodes.length,
      'difficulty': _getDifficultyLevel(topic),
      'tags': _generateTags(topic),
      'createdAt': DateTime.now().toIso8601String(),
      'status': 'ready',
    };
  }

  List<Map<String, dynamic>> _generateEpisodes(String topic, String learningType, int episodeCount) {
    final episodes = <Map<String, dynamic>>[];
    
    // Episode structure based on user's episode count preference and learning type
    for (int i = 1; i <= episodeCount; i++) {
      final episodeTitle = _generateEpisodeTitle(topic, learningType, i, episodeCount);
      final episodeDescription = _generateEpisodeDescription(learningType, i, episodeCount);
      final episodeType = _getEpisodeType(i, episodeCount);
      
      episodes.add(_createEpisode(i, episodeTitle, episodeDescription, episodeType));
    }

    return episodes;
  }

  String _getEpisodeType(int episodeNumber, int totalEpisodes) {
    if (episodeNumber == 1) return 'intro';
    if (episodeNumber == totalEpisodes) return 'conclusion';
    if (episodeNumber <= totalEpisodes ~/ 2) return 'foundation';
    return 'advanced';
  }

  String _generateEpisodeTitle(String topic, String learningType, int episodeNumber, int totalEpisodes) {
    // Generate episode titles based on the actual learning type approach
    if (learningType.contains('Core Concepts') || learningType.contains('Fundamentals')) {
      switch (episodeNumber) {
        case 1: return 'Introduction to $topic';
        case 2: return 'Core Principles of $topic';
        default: return 'Advanced $topic Concepts ${episodeNumber - 2}';
      }
    } else if (learningType.contains('Case Studies') || learningType.contains('Real-Life Application')) {
      switch (episodeNumber) {
        case 1: return '$topic in Action';
        case 2: return 'Success Stories: $topic';
        default: return '$topic Case Study ${episodeNumber - 2}';
      }
    } else if (learningType.contains('Tools') || learningType.contains('Getting Started')) {
      switch (episodeNumber) {
        case 1: return 'Getting Started with $topic';
        case 2: return 'Essential $topic Tools';
        default: return 'Advanced $topic Techniques ${episodeNumber - 2}';
      }
    } else { // Mixed/Balanced approaches
      switch (episodeNumber) {
        case 1: return 'Understanding $topic';
        case 2: return '$topic in Practice';
        default: return 'Exploring $topic ${episodeNumber - 2}';
      }
    }
  }

  String _generateEpisodeDescription(String learningType, int episodeNumber, int totalEpisodes) {
    if (episodeNumber == 1) {
      return 'Foundation and overview to get you started';
    } else if (episodeNumber == totalEpisodes) {
      return 'Advanced insights and next steps';
    } else {
      return 'Building deeper understanding and practical knowledge';
    }
  }

  Map<String, dynamic> _createEpisode(int number, String title, String description, String type) {
    return {
      'number': number,
      'title': title,
      'description': description,
      'type': type,
      'duration': 12, // minutes
      'status': 'not_started',
      'keyPoints': _generateKeyPoints(title, type),
      'difficulty': number <= 2 ? 'beginner' : number <= 5 ? 'intermediate' : 'advanced',
    };
  }

  List<String> _generateKeyPoints(String title, String type) {
    switch (type) {
      case 'intro':
        return ['Overview and importance', 'Key terminology', 'Learning objectives'];
      case 'concepts':
        return ['Core principles', 'How it works', 'Why it matters'];
      case 'applications':
        return ['Real-world examples', 'Use cases', 'Success stories'];
      case 'tools':
        return ['Essential tools', 'Setup guide', 'Configuration tips'];
      case 'first_project':
        return ['Step-by-step guide', 'Common mistakes', 'Testing approach'];
      default:
        return ['Key insights', 'Practical tips', 'Actionable takeaways'];
    }
  }

  String _generateJourneyTitle(String topic, String learningType) {
    if (learningType.contains('Core Concepts') || learningType.contains('Fundamentals')) {
      return '$topic: Core Concepts & Fundamentals';
    } else if (learningType.contains('Case Studies')) {
      return '$topic: Real-World Case Studies';
    } else if (learningType.contains('Tools') || learningType.contains('Getting Started')) {
      return '$topic: Tools & Practical Guide';
    } else {
      return '$topic: Comprehensive Overview';
    }
  }

  String _generateJourneyDescription(String topic, String learningType) {
    return 'A comprehensive podcast-style learning journey focused on $learningType approach to $topic. '
           'Each episode is carefully crafted to build upon previous knowledge and provide practical insights.';
  }

  String _getDifficultyLevel(String topic) {
    // Default to intermediate for podcast-style learning
    return 'Intermediate';
  }

  List<String> _generateTags(String topic) {
    final tags = <String>[
      topic.toLowerCase(),
      'podcast',
      'audio_learning',
    ];
    
    // Add topic-specific tags
    final lowerTopic = topic.toLowerCase();
    if (lowerTopic.contains('programming') || lowerTopic.contains('development')) {
      tags.addAll(['coding', 'software', 'development']);
    } else if (lowerTopic.contains('business') || lowerTopic.contains('marketing')) {
      tags.addAll(['business', 'strategy', 'growth']);
    } else if (lowerTopic.contains('design')) {
      tags.addAll(['design', 'creative', 'visual']);
    }
    
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Creating Your Learning Journey',
          style: TextStyle(
            color: WismeColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isGenerating ? _buildGeneratingView() : _buildJourneyPreview(),
    );
  }

  Widget _buildGeneratingView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AI Brain Animation
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        WismeColors.primaryBlue,
                        WismeColors.primaryBlue.withOpacity(0.3),
                      ],
                      stops: [_progressAnimation.value, 1.0],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.psychology,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'AI is crafting your personalized journey...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: WismeColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            ModernCard(
              backgroundColor: Colors.white,
              child: Column(
                children: [
                  ...List.generate(_generationSteps.length, (index) {
                    final isCompleted = index < _currentStep;
                    final isCurrent = index == _currentStep;
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted 
                                ? WismeColors.success
                                : isCurrent 
                                  ? WismeColors.primaryBlue
                                  : Colors.grey[300],
                            ),
                            child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : isCurrent
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _generationSteps[index],
                              style: TextStyle(
                                fontSize: 14,
                                color: isCompleted || isCurrent 
                                  ? WismeColors.textPrimary
                                  : WismeColors.textSecondary,
                                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyPreview() {
    if (_generatedJourney == null) return const SizedBox();

    final journey = _generatedJourney!;
    final episodes = journey['episodes'] as List<Map<String, dynamic>>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Journey header
          ModernCard(
            backgroundColor: WismeColors.primaryBlue.withOpacity(0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: WismeColors.primaryBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: WismeColors.primaryBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Your Journey is Ready!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: WismeColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  journey['title'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: WismeColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  journey['description'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: WismeColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.schedule,
                      '${journey['estimatedDuration']} min total',
                      WismeColors.info,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      Icons.play_circle,
                      '${episodes.length} episodes',
                      WismeColors.success,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      Icons.trending_up,
                      journey['difficulty'],
                      WismeColors.warning,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Episodes list
          const Text(
            'Episode Breakdown',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: WismeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          ...episodes.map((episode) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: ModernCard(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: WismeColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          '${episode['number']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: WismeColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            episode['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: WismeColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            episode['description'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: WismeColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${episode['duration']} min',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(episode['difficulty']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  episode['difficulty'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: _getDifficultyColor(episode['difficulty']),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.play_circle_outline,
                      color: WismeColors.primaryBlue,
                      size: 28,
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 32),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onJourneyGenerated(_generatedJourney!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WismeColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Start Learning Journey',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  _startJourneyGeneration(); // Regenerate
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  side: const BorderSide(color: WismeColors.primaryBlue),
                ),
                child: const Icon(
                  Icons.refresh,
                  color: WismeColors.primaryBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return WismeColors.success;
      case 'intermediate':
        return WismeColors.warning;
      case 'advanced':
        return WismeColors.error;
      default:
        return WismeColors.textSecondary;
    }
  }
}



