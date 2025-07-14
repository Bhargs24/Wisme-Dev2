import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core.dart';
import '../../../../shared/components/modern_card.dart';

/// Topic Classification Result
class TopicClassificationResult {
  final String primaryCategory;
  final String difficultyLevel;
  final int estimatedSessions;
  final List<String> suggestedTags;
  final double confidenceScore;

  const TopicClassificationResult({
    required this.primaryCategory,
    required this.difficultyLevel,
    required this.estimatedSessions,
    required this.suggestedTags,
    required this.confidenceScore,
  });
}

/// Topic Input System - AI-Powered Learning Topic Analysis
/// Core entry point for personalized learning journey creation
class TopicInputSystem extends ConsumerStatefulWidget {
  final Function(String topic, String? language) onTopicSubmitted;
  final String? initialTopic;
  
  const TopicInputSystem({
    super.key,
    required this.onTopicSubmitted,
    this.initialTopic,
  });

  @override
  ConsumerState<TopicInputSystem> createState() => _TopicInputSystemState();
}

class _TopicInputSystemState extends ConsumerState<TopicInputSystem> {
  final TextEditingController _topicController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  bool _isAnalyzing = false;
  String? _selectedLanguage;
  List<String> _suggestions = [];
  TopicClassificationResult? _classification;
  
  // Popular topic suggestions
  final List<String> _popularTopics = [
    'Machine Learning Fundamentals',
    'React Development',
    'Digital Marketing Strategy',
    'Personal Finance Management',
    'Leadership Skills',
    'Data Science with Python',
    'UI/UX Design Principles',
    'Blockchain Technology',
    'Public Speaking',
    'Mindfulness and Meditation',
    'Entrepreneurship Basics',
    'Cloud Computing with AWS',
  ];
  
  // Language options
  final Map<String, String> _languages = {
    'English': '🇺🇸',
    'Spanish': '🇪🇸',
    'French': '🇫🇷',
    'German': '🇩🇪',
    'Italian': '🇮🇹',
    'Portuguese': '🇵🇹',
    'Japanese': '🇯🇵',
    'Korean': '🇰🇷',
    'Chinese': '🇨🇳',
    'Hindi': '🇮🇳',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialTopic != null) {
      _topicController.text = widget.initialTopic!;
    }
    _selectedLanguage = 'English';
    _updateSuggestions();
  }

  @override
  void dispose() {
    _topicController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateSuggestions() {
    final query = _topicController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _suggestions = _popularTopics;
      } else {
        _suggestions = _popularTopics
            .where((topic) => topic.toLowerCase().contains(query))
            .toList();
        
        // Add exact match if not in suggestions
        if (!_suggestions.any((s) => s.toLowerCase() == query)) {
          _suggestions.insert(0, _topicController.text);
        }
      }
    });
  }

  /// Simple topic classification (to be replaced with AI integration)
  TopicClassificationResult _classifyTopicFallback(String topic) {
    final lowerTopic = topic.toLowerCase();
    
    // Simple keyword-based classification
    String category = 'Personal Development';
    List<String> tags = [];
    
    if (lowerTopic.contains('react') || lowerTopic.contains('javascript') || 
        lowerTopic.contains('programming') || lowerTopic.contains('coding')) {
      category = 'Technology & AI';
      tags = ['programming', 'web development', 'frontend'];
    } else if (lowerTopic.contains('business') || lowerTopic.contains('marketing') || 
               lowerTopic.contains('finance') || lowerTopic.contains('entrepreneur')) {
      category = 'Business & Finance';
      tags = ['business', 'strategy', 'growth'];
    } else if (lowerTopic.contains('design') || lowerTopic.contains('ui') || 
               lowerTopic.contains('ux') || lowerTopic.contains('creative')) {
      category = 'Creativity & Design';
      tags = ['design', 'user experience', 'visual'];
    } else if (lowerTopic.contains('leadership') || lowerTopic.contains('management') || 
               lowerTopic.contains('communication')) {
      category = 'Personal Development';
      tags = ['leadership', 'soft skills', 'communication'];
    } else if (lowerTopic.contains('science') || lowerTopic.contains('physics') || 
               lowerTopic.contains('biology') || lowerTopic.contains('chemistry')) {
      category = 'Science & Nature';
      tags = ['science', 'research', 'discovery'];
    } else if (lowerTopic.contains('psychology') || lowerTopic.contains('mental') || 
               lowerTopic.contains('mindfulness') || lowerTopic.contains('meditation')) {
      category = 'Psychology & Mind';
      tags = ['psychology', 'mental health', 'wellness'];
    }
    
    // Estimate difficulty and sessions based on topic complexity
    String difficulty = 'Beginner';
    int sessions = 5;
    
    if (lowerTopic.contains('advanced') || lowerTopic.contains('expert') || 
        lowerTopic.contains('master')) {
      difficulty = 'Advanced';
      sessions = 8;
    } else if (lowerTopic.contains('intermediate') || lowerTopic.length > 50) {
      difficulty = 'Intermediate';
      sessions = 6;
    }
    
    return TopicClassificationResult(
      primaryCategory: category,
      difficultyLevel: difficulty,
      estimatedSessions: sessions,
      suggestedTags: tags,
      confidenceScore: 0.85,
    );
  }

  Future<void> _analyzeTopic(String topic) async {
    if (topic.trim().isEmpty) return;
    
    setState(() {
      _isAnalyzing = true;
      _classification = null;
    });

    try {
      // Use real AI topic classification
      final aiClassification = await AdvancedTopicClassifier.analyzeTopicWithAI(
        topic,
        userBackground: 'General learner', // Could be personalized later
        learningIntent: 'Learn fundamentals and apply knowledge',
      );
      
      // Convert AI classification to UI classification
      final result = TopicClassificationResult(
        primaryCategory: aiClassification.category,
        difficultyLevel: aiClassification.knowledgeLevel,
        estimatedSessions: aiClassification.episodePlan.totalEpisodes,
        suggestedTags: aiClassification.subtopics.map((s) => s.title).toList(),
        confidenceScore: aiClassification.confidence,
      );
      
      setState(() {
        _classification = result;
        _isAnalyzing = false;
      });
      
    } catch (e) {
      // Fallback to simple classification if AI fails
      final result = _classifyTopicFallback(topic);
      
      setState(() {
        _classification = result;
        _isAnalyzing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Using basic classification. AI service: ${e.toString()}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _submitTopic() {
    final topic = _topicController.text.trim();
    if (topic.isNotEmpty) {
      widget.onTopicSubmitted(topic, _selectedLanguage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'What do you want to learn?',
          style: TextStyle(
            color: WismeColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopicInputCard(),
            const SizedBox(height: 20),
            _buildLanguageSelection(),
            const SizedBox(height: 20),
            if (_isAnalyzing) _buildAnalyzingCard(),
            if (_classification != null) _buildClassificationResult(),
            const SizedBox(height: 20),
            _buildSuggestions(),
            const SizedBox(height: 100), // Space for floating button
          ],
        ),
      ),
      floatingActionButton: _buildSubmitButton(),
    );
  }

  Widget _buildTopicInputCard() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WismeColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: WismeColors.primaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Describe your learning goal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: WismeColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Be as specific or general as you like',
                      style: TextStyle(
                        fontSize: 14,
                        color: WismeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _topicController,
            focusNode: _focusNode,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'e.g., "I want to learn React for building web apps" or "Improve my public speaking skills"',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: WismeColors.primaryBlue, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: WismeColors.textPrimary,
            ),
            onChanged: (value) {
              _updateSuggestions();
              if (value.length > 10) {
                _analyzeTopic(value);
              }
            },
            onSubmitted: (value) => _submitTopic(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelection() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: WismeColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.language,
                  color: WismeColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Learning Language',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: WismeColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _languages.entries.map((entry) {
              final isSelected = _selectedLanguage == entry.key;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLanguage = entry.key;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? WismeColors.primaryBlue : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? WismeColors.primaryBlue : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        entry.value,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        entry.key,
                        style: TextStyle(
                          color: isSelected ? Colors.white : WismeColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingCard() {
    return ModernCard(
      backgroundColor: WismeColors.info.withOpacity(0.05),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(WismeColors.info),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Analyzing your topic with AI...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: WismeColors.info,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Our AI is categorizing your topic and determining the best learning approach.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassificationResult() {
    if (_classification == null) return const SizedBox();
    
    return ModernCard(
      backgroundColor: WismeColors.success.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: WismeColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: WismeColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Topic Analysis Complete',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: WismeColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildClassificationDetail(
            'Category',
            _classification!.primaryCategory,
            Icons.category,
          ),
          const SizedBox(height: 8),
          _buildClassificationDetail(
            'Difficulty Level',
            _classification!.difficultyLevel,
            Icons.trending_up,
          ),
          const SizedBox(height: 8),
          _buildClassificationDetail(
            'Estimated Sessions',
            '${_classification!.estimatedSessions} episodes',
            Icons.play_circle,
          ),
          if (_classification!.suggestedTags.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Key Topics:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: WismeColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _classification!.suggestedTags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: WismeColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 12,
                      color: WismeColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClassificationDetail(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: WismeColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.lightbulb_outline,
              color: WismeColors.warning,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Popular Topics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: WismeColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestions.take(8).map((suggestion) {
            return GestureDetector(
              onTap: () {
                _topicController.text = suggestion;
                _updateSuggestions();
                _analyzeTopic(suggestion);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  suggestion,
                  style: const TextStyle(
                    fontSize: 14,
                    color: WismeColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final hasText = _topicController.text.trim().isNotEmpty;
    
    return FloatingActionButton.extended(
      onPressed: hasText ? _submitTopic : null,
      backgroundColor: hasText ? WismeColors.primaryBlue : Colors.grey[400],
      foregroundColor: Colors.white,
      icon: _isAnalyzing 
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : const Icon(Icons.arrow_forward),
      label: Text(
        _isAnalyzing ? 'Analyzing...' : 'Start Learning',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
