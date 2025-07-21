import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../audio/enhanced_audio_player_screen.dart';

/// Complete Topic to Episode Flow
/// The core user experience: Topic Input → AI Processing → Episode Generation → Enhanced Audio Player
class TopicToEpisodeFlow extends ConsumerStatefulWidget {
  const TopicToEpisodeFlow({super.key});

  @override
  ConsumerState<TopicToEpisodeFlow> createState() => _TopicToEpisodeFlowState();
}

class _TopicToEpisodeFlowState extends ConsumerState<TopicToEpisodeFlow> {
  final PageController _pageController = PageController();
  
  // Topic Input Data
  String _inputTopic = '';
  
  // Generated Episode Data
  Episode? _generatedEpisode;
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildTopicInputScreen(),
          _buildAIProcessingScreen(),
          _buildJourneyPreviewScreen(),
          if (_generatedEpisode != null) _buildAudioPlayerScreen(),
        ],
      ),
    );
  }

  /// Screen 1: Topic Input
  Widget _buildTopicInputScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Text(
                  'What do you want to learn?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Topic Input Field
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) => setState(() => _inputTopic = value),
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'I want to learn about...\n\nExample: "How machine learning works" or "Spanish conversation basics"',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            
            // Popular Topics
            const Text(
              'Popular Topics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                'Machine Learning Basics',
                'Spanish Conversation',
                'Personal Finance',
                'Cooking Fundamentals',
                'Photography Tips',
                'Public Speaking',
              ].map((topic) => _buildTopicChip(topic)).toList(),
            ),
            
            const Spacer(),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _inputTopic.trim().isEmpty ? null : _startProcessing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Generate Learning Episode',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return GestureDetector(
      onTap: () => setState(() => _inputTopic = topic),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
        ),
        child: Text(
          topic,
          style: const TextStyle(
            color: Color(0xFF2196F3),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Screen 2: AI Processing
  Widget _buildAIProcessingScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Processing Animation
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2196F3).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            
            const Text(
              'AI is analyzing your topic...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Creating a personalized learning experience just for you',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Progress Steps
            Column(
              children: [
                _buildProcessingStep('Analyzing topic complexity', true),
                _buildProcessingStep('Selecting coach personality', true),
                _buildProcessingStep('Generating episode content', _isGenerating),
                _buildProcessingStep('Preparing audio experience', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingStep(String title, bool isComplete) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isComplete ? const Color(0xFF4CAF50) : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: isComplete
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : const SizedBox(),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isComplete ? Colors.black : Colors.grey,
              fontWeight: isComplete ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Screen 3: Journey Preview
  Widget _buildJourneyPreviewScreen() {
    if (_generatedEpisode == null) return const SizedBox();
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  onPressed: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Text(
                  'Your Learning Episode',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Episode Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2196F3).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _generatedEpisode!.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${_generatedEpisode!.durationMinutes} minutes',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.person, color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Coach ${_generatedEpisode!.coachPersonality}',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Episode Content Preview
            const Text(
              'What you\'ll learn:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                '${_generatedEpisode!.content.substring(0, 
                  _generatedEpisode!.content.length > 200 
                    ? 200 
                    : _generatedEpisode!.content.length)}...',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Start Episode Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _startEpisode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Start Learning',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Screen 4: Enhanced Audio Player with Two-Speaker Support
  Widget _buildAudioPlayerScreen() {
    if (_generatedEpisode == null) return const SizedBox();
    
    return EnhancedAudioPlayerScreen(
      episodeTitle: _generatedEpisode!.title,
      episodeContent: _generatedEpisode!.content,
      duration: Duration(minutes: _generatedEpisode!.durationMinutes),
      episode: _generatedEpisode, // Pass full episode for enhanced features
      enableTwoSpeakerMode: true, // Enable new two-speaker system
    );
  }

  /// Start AI Processing
  void _startProcessing() {
    setState(() => _isGenerating = true);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    
    // Simulate AI processing
    _generateEpisode();
  }

  /// Generate Episode (Mock AI for now)
  Future<void> _generateEpisode() async {
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 3));
    
    // Create mock episode
    final episode = Episode(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Learning About: $_inputTopic',
      content: '''
Welcome to your personalized learning session about $_inputTopic!

I'm your coach, and I'm excited to guide you through this topic. We'll explore the fundamentals, break down complex concepts, and help you build practical understanding.

[PAUSE]

Let's start by understanding what makes this topic important and how it connects to your goals.

Key concepts we'll cover:
• Fundamental principles and definitions
• Real-world applications and examples  
• Practical skills you can use immediately
• Common misconceptions to avoid

[EMPHASIS] Remember, learning is a journey, and every step forward counts. Let's dive in and make this knowledge yours!

Throughout this session, I'll provide clear explanations, engaging examples, and pause moments for reflection. Don't worry if some concepts take time to sink in - that's completely normal.

By the end of this episode, you'll have a solid foundation in $_inputTopic and practical insights you can apply right away.

Ready? Let's begin your learning journey!
      ''',
      category: 'Technology & AI',
      knowledgeType: '🔹 Core Concepts',
      coachPersonality: 'Coach', // Default coach personality
      hashtags: [_inputTopic.toLowerCase().replaceAll(' ', '_')],
      durationMinutes: 12,
      createdAt: DateTime.now(),
    );
    
    setState(() {
      _generatedEpisode = episode;
      _isGenerating = false;
    });
    
    // Move to preview screen
    await Future.delayed(const Duration(seconds: 1));
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Start Episode
  void _startEpisode() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
