import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../shared/shared.dart';
import '../../models/phase1_models.dart';
import '../../core/services/phase1_conversation_engine.dart';
import '../../core/services/supabase_service.dart';
import '../../core/analytics/wisme_analytics.dart';

/// Phase 1 Learning Flow - Correct Implementation
/// 1. Topic Selection (AI analyzes and categorizes)
/// 2. Learning Type Selection (4 approaches per category)
/// 3. Episode Count Selection (User chooses how many episodes)
/// 4. AI Journey Generation (Calculates episode duration based on count)
class Phase1LearningFlow extends StatefulWidget {
  final String selectedTopic;
  final String? personalContext;
  final Function(Map<String, dynamic>) onJourneyCreated;

  const Phase1LearningFlow({
    super.key,
    required this.selectedTopic,
    this.personalContext,
    required this.onJourneyCreated,
  });

  @override
  State<Phase1LearningFlow> createState() => _Phase1LearningFlowState();
}

class _Phase1LearningFlowState extends State<Phase1LearningFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isAnalyzing = true;
  bool _isGenerating = false;
  
  // AI Analysis Results
  String? _detectedCategory;
  List<LearningType>? _availableTypes;
  
  // User Selections
  LearningType? _selectedLearningType;
  EpisodeCountPreference? _selectedEpisodeCount;
  
  // Generated Journey
  Map<String, dynamic>? _generatedJourney;

  @override
  void initState() {
    super.initState();
    _analyzeTopicWithAI();
  }

  /// Step 1: AI Topic Analysis
  Future<void> _analyzeTopicWithAI() async {
    try {
      // Use Phase 1 conversation engine for topic analysis
      final analysis = await Phase1ConversationEngine.analyzeTopic(
        widget.selectedTopic,
        personalContext: widget.personalContext,
      );
      
      setState(() {
        _detectedCategory = analysis['category'];
        _availableTypes = Phase1LearningTypes.getLearningTypesForCategory(_detectedCategory!);
        _isAnalyzing = false;
      });
    } catch (e) {
      // Fallback to default category
      setState(() {
        _detectedCategory = 'Personal Development';
        _availableTypes = Phase1LearningTypes.getLearningTypesForCategory(_detectedCategory!);
        _isAnalyzing = false;
      });
    }
  }

  /// Step 2: Learning Type Selection
  void _selectLearningType(LearningType type) {
    setState(() {
      _selectedLearningType = type;
    });
    WismeAnalytics.trackFeatureInteraction('learning_type_selected:${type.name}_${_detectedCategory ?? ''}');
    _nextPage();
  }

  /// Step 3: Episode Count Selection
  void _selectEpisodeCount(EpisodeCountPreference preference) {
    setState(() {
      _selectedEpisodeCount = preference;
    });
    _nextPage();
  }

  /// Step 4: Generate AI Journey
  Future<void> _generateJourney() async {
    if (_selectedLearningType == null || _selectedEpisodeCount == null) {
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      // Calculate episode duration based on count and learning approach
      final episodeCount = _selectedEpisodeCount!.getRandomEpisodeCount();
      final episodeDuration = Phase1LearningTypes.calculateEpisodeDuration(
        episodeCount, 
        _selectedLearningType!.approach
      );

      final journey = await Phase1ConversationEngine.generateLearningJourney(
        topic: widget.selectedTopic,
        category: _detectedCategory!,
        learningType: _selectedLearningType!,
        episodeCount: episodeCount,
        episodeDuration: episodeDuration,
        personalContext: widget.personalContext,
      );

      setState(() {
        _generatedJourney = journey;
        _isGenerating = false;
      });

      // Persist journey and choices to Supabase
      await SupabaseService.updateUserProfile({
        'last_learning_topic': widget.selectedTopic,
        'last_learning_category': _detectedCategory,
        'last_learning_type': _selectedLearningType?.name,
        'last_episode_count': episodeCount,
        'last_journey': journey,
        'last_journey_generated_at': DateTime.now().toIso8601String(),
      });
      WismeAnalytics.trackFeatureInteraction('journey_generated:${widget.selectedTopic}_${_detectedCategory ?? ''}_${_selectedLearningType?.name ?? ''}_$episodeCount');

      // Complete the flow
      widget.onJourneyCreated(journey);
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });
      WismeAnalytics.trackFeatureInteraction('journey_generation_error:${e.toString()}');
      // Show error and allow retry
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generation Failed'),
        content: const Text('Failed to generate your learning journey. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _generateJourney();
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _generateJourney();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAnalyzing) {
      return _buildAnalyzingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _getPageTitle(),
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
                _buildLearningTypePage(),
                _buildEpisodeCountPage(),
                _buildJourneyGenerationPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    switch (_currentPage) {
      case 0:
        return 'Choose Your Learning Approach';
      case 1:
        return 'Select Episode Count';
      case 2:
        return 'Generate Your Journey';
      default:
        return 'Learning Setup';
    }
  }

  Widget _buildAnalyzingScreen() {
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

  Widget _buildLearningTypePage() {
    if (_availableTypes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your $_detectedCategory learning approach',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select how you want to learn about this topic',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: _availableTypes!.length,
              itemBuilder: (context, index) {
                final type = _availableTypes![index];
                final isSelected = _selectedLearningType?.id == type.id;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => _selectLearningType(type),
                    child: ModernCard(
                      backgroundColor: isSelected 
                          ? WismeColors.primaryBlue.withValues(alpha: 0.1) 
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: type.id,
                                  groupValue: _selectedLearningType?.id,
                                  onChanged: (value) {
                                    final selectedType = _availableTypes!.firstWhere(
                                      (t) => t.id == value,
                                    );
                                    _selectLearningType(selectedType);
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    type.name,
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    type.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildApproachChip(type.approach),
                                ],
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

  Widget _buildEpisodeCountPage() {
    final episodeOptions = Phase1LearningTypes.episodeCountPreferences;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How many episodes do you want?',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Choose your preferred episode count - we\'ll adjust episode length accordingly',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: episodeOptions.length,
              itemBuilder: (context, index) {
                final option = episodeOptions[index];
                final isSelected = _selectedEpisodeCount?.id == option.id;
                
                // Calculate estimated episode duration for this option
                final estimatedDuration = _selectedLearningType != null 
                    ? Phase1LearningTypes.calculateEpisodeDuration(
                        option.getRandomEpisodeCount(),
                        _selectedLearningType!.approach,
                      )
                    : 12;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => _selectEpisodeCount(option),
                    child: ModernCard(
                      backgroundColor: isSelected 
                          ? WismeColors.primaryBlue.withValues(alpha: 0.1) 
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: option.id,
                              groupValue: _selectedEpisodeCount?.id,
                              onChanged: (value) => _selectEpisodeCount(option),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${option.minEpisodes}-${option.maxEpisodes} episodes',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '~$estimatedDuration minutes per episode',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
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

  Widget _buildJourneyGenerationPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why this journey?',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Based on your topic, learning approach, and episode count, we created a journey tailored to your preferences and goals. Each episode is designed to maximize your engagement and retention.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_generatedJourney != null)
                    Text(
                      'Episodes: ${_generatedJourney!['episodes']?.length ?? 0}\nEstimated duration: ${_generatedJourney!['estimatedDuration'] ?? ''} min',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (_isGenerating) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              'Generating your personalized learning journey...',
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApproachChip(String approach) {
    Color color;
    String label;
    
    switch (approach) {
      case 'fundamental':
        color = WismeColors.success;
        label = 'Fundamental';
        break;
      case 'practical':
        color = WismeColors.primaryBlue;
        label = 'Practical';
        break;
      case 'comprehensive':
        color = WismeColors.warning;
        label = 'Comprehensive';
        break;
      case 'balanced':
        color = WismeColors.info;
        label = 'Balanced';
        break;
      default:
        color = WismeColors.primaryBlue;
        label = approach;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
} 



