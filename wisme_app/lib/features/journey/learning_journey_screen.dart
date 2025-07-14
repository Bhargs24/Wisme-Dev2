import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../shared/shared.dart';
import '../audio/audio_player_screen.dart';
import 'presentation/pages/enhanced_journey_navigator.dart';

/// Learning Journey Screen
/// Shows 5-episode learning journeys with progress tracking
class LearningJourneyScreen extends StatefulWidget {
  final String topic;
  final String? category;
  
  const LearningJourneyScreen({
    super.key,
    required this.topic,
    this.category,
  });

  @override
  State<LearningJourneyScreen> createState() => _LearningJourneyScreenState();
}

class _LearningJourneyScreenState extends State<LearningJourneyScreen> {
  late List<Episode> _journeyEpisodes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateJourney();
  }

  Future<void> _generateJourney() async {
    setState(() => _isLoading = true);
    
    // Mock journey generation (replace with real AI later)
    await Future.delayed(const Duration(seconds: 2));
    
    _journeyEpisodes = _createMockJourney();
    
    setState(() => _isLoading = false);
  }

  List<Episode> _createMockJourney() {
    return [
      Episode(
        id: '1',
        title: 'Introduction to ${widget.topic}',
        content: 'Welcome to your learning journey about ${widget.topic}! Let\'s start with the basics and build a strong foundation.',
        category: widget.category ?? '💻 Technology',
        knowledgeLevel: 'beginner',
        coachPersonality: 'Kai',
        hashtags: [widget.topic.toLowerCase().replaceAll(' ', '_')],
        durationMinutes: 8,
        createdAt: DateTime.now(),
        completionPercentage: 1.0, // Completed
      ),
      Episode(
        id: '2',
        title: 'Core Concepts of ${widget.topic}',
        content: 'Now that you understand the basics, let\'s dive deeper into the core concepts that make ${widget.topic} so important.',
        category: widget.category ?? '💻 Technology',
        knowledgeLevel: 'beginner',
        coachPersonality: 'Vee',
        hashtags: [widget.topic.toLowerCase().replaceAll(' ', '_')],
        durationMinutes: 12,
        createdAt: DateTime.now(),
        completionPercentage: 0.6, // 60% completed
      ),
      Episode(
        id: '3',
        title: 'Practical Applications of ${widget.topic}',
        content: 'Time to see ${widget.topic} in action! We\'ll explore real-world applications and examples.',
        category: widget.category ?? '💻 Technology',
        knowledgeLevel: 'intermediate',
        coachPersonality: 'Kai',
        hashtags: [widget.topic.toLowerCase().replaceAll(' ', '_')],
        durationMinutes: 15,
        createdAt: DateTime.now(),
        completionPercentage: 0.0, // Not started
      ),
      Episode(
        id: '4',
        title: 'Advanced Techniques in ${widget.topic}',
        content: 'Ready for the next level? Let\'s explore advanced concepts and techniques in ${widget.topic}.',
        category: widget.category ?? '💻 Technology',
        knowledgeLevel: 'advanced',
        coachPersonality: 'Vee',
        hashtags: [widget.topic.toLowerCase().replaceAll(' ', '_')],
        durationMinutes: 18,
        createdAt: DateTime.now(),
        completionPercentage: 0.0,
      ),
      Episode(
        id: '5',
        title: 'Mastering ${widget.topic}: Next Steps',
        content: 'Congratulations on your journey! Let\'s explore how to continue growing your expertise in ${widget.topic}.',
        category: widget.category ?? '💻 Technology',
        knowledgeLevel: 'expert',
        coachPersonality: 'Kai',
        hashtags: [widget.topic.toLowerCase().replaceAll(' ', '_')],
        durationMinutes: 10,
        createdAt: DateTime.now(),
        completionPercentage: 0.0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Creating your learning journey...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Generating 5 personalized episodes for ${widget.topic}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Learning Journey: ${widget.topic}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () => _showJourneyInfo(),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _journeyEpisodes.length,
              itemBuilder: (context, index) => _buildEpisodeCard(index),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchEnhancedNavigator,
        icon: const Icon(Icons.auto_stories),
        label: const Text('Enhanced Journey'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildProgressHeader() {
    final totalEpisodes = _journeyEpisodes.length;
    final completedEpisodes = _journeyEpisodes.where((e) => e.completionPercentage >= 1.0).length;
    final progress = completedEpisodes / totalEpisodes;

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress: $completedEpisodes/$totalEpisodes Episodes',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}% Complete',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            minHeight: 8,
          ),
          const SizedBox(height: 16),
          Text(
            'Total Duration: ${_journeyEpisodes.fold(0, (sum, episode) => sum + episode.durationMinutes)} minutes',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeCard(int index) {
    final episode = _journeyEpisodes[index];
    final isCompleted = episode.completionPercentage >= 1.0;
    final isInProgress = episode.completionPercentage > 0 && episode.completionPercentage < 1.0;
    final isLocked = index > 0 && _journeyEpisodes[index - 1].completionPercentage < 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ModernCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Episode Number & Status
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted 
                          ? const Color(0xFF4CAF50)
                          : isInProgress
                              ? const Color(0xFF2196F3)
                              : isLocked
                                  ? Colors.grey.shade300
                                  : const Color(0xFF2196F3).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: isLocked ? null : Border.all(
                        color: isCompleted 
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFF2196F3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : isInProgress
                              ? const Icon(Icons.play_arrow, color: Colors.white, size: 20)
                              : isLocked
                                  ? const Icon(Icons.lock, color: Colors.grey, size: 16)
                                  : Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2196F3),
                                      ),
                                    ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Episode Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          episode.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isLocked ? Colors.grey : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${episode.durationMinutes} min',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Coach ${episode.coachPersonality}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Action Button
                  if (!isLocked)
                    ElevatedButton(
                      onPressed: () => _startEpisode(episode),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCompleted 
                            ? Colors.grey.shade100
                            : const Color(0xFF2196F3),
                        foregroundColor: isCompleted 
                            ? Colors.grey.shade600
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        isCompleted 
                            ? 'Review'
                            : isInProgress
                                ? 'Continue'
                                : 'Start',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              
              // Progress Bar for In-Progress Episodes
              if (isInProgress) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: episode.completionPercentage,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                  minHeight: 4,
                ),
              ],
              
              // Episode Description
              const SizedBox(height: 12),
              Text(
                episode.content.length > 100
                    ? '${episode.content.substring(0, 100)}...'
                    : episode.content,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startEpisode(Episode episode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioPlayerScreen(
          episodeTitle: episode.title,
          episodeContent: episode.content,
          coachPersonality: episode.coachPersonality,
          duration: Duration(minutes: episode.durationMinutes),
        ),
      ),
    ).then((_) {
      // Update progress when returning from audio player
      setState(() {
        // Mock progress update - in real app, this would be handled by a state management system
        _journeyEpisodes = _journeyEpisodes.map((e) {
          if (e.id == episode.id && e.completionPercentage == 0) {
            return Episode(
              id: e.id,
              title: e.title,
              content: e.content,
              category: e.category,
              knowledgeLevel: e.knowledgeLevel,
              coachPersonality: e.coachPersonality,
              hashtags: e.hashtags,
              durationMinutes: e.durationMinutes,
              createdAt: e.createdAt,
              completionPercentage: 1.0,
            );
          }
          return e;
        }).toList();
      });
    });
  }

  void _showJourneyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Learning Journeys'),
        content: const Text(
          'Learning journeys are personalized 5-episode sequences designed to take you from beginner to advanced understanding of any topic.\\n\\n'
          'Each journey is crafted by AI to match your learning style and goals, with our coaches Kai and Vee guiding you through the experience.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _launchEnhancedNavigator() {
    // Create a learning journey from the current episodes
    final journey = LearningJourney(
      id: 'journey_${widget.topic.replaceAll(' ', '_').toLowerCase()}',
      title: 'Learning Journey: ${widget.topic}',
      description: 'A comprehensive 5-episode journey to master ${widget.topic}',
      category: widget.category ?? '💻 Technology',
      knowledgeLevel: 'beginner',
      episodes: _journeyEpisodes,
      currentEpisodeIndex: _getCurrentEpisodeIndex(),
      completionPercentage: _getJourneyCompletionPercentage(),
      isCompleted: _isJourneyCompleted(),
      createdAt: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedJourneyNavigator(
          journey: journey,
          onJourneyUpdate: (updatedJourney) {
            // Update the local episodes based on the journey updates
            setState(() {
              _journeyEpisodes = updatedJourney.episodes;
            });
          },
        ),
      ),
    );
  }

  int _getCurrentEpisodeIndex() {
    for (int i = 0; i < _journeyEpisodes.length; i++) {
      if (_journeyEpisodes[i].completionPercentage < 1.0) {
        return i;
      }
    }
    return _journeyEpisodes.length - 1; // All completed
  }

  double _getJourneyCompletionPercentage() {
    final completedCount = _journeyEpisodes.where((e) => e.completionPercentage >= 1.0).length;
    return completedCount / _journeyEpisodes.length;
  }

  bool _isJourneyCompleted() {
    return _journeyEpisodes.every((e) => e.completionPercentage >= 1.0);
  }
}
