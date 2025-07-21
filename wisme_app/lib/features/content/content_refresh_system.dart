import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/components/modern_card.dart';
import '../../../models/episode.dart';
import '../../../models/learning_journey.dart';
import '../journey/learning_journey_screen.dart';

class ContentRefreshSystem extends StatefulWidget {
  const ContentRefreshSystem({super.key});

  @override
  State<ContentRefreshSystem> createState() => _ContentRefreshSystemState();
}

class _ContentRefreshSystemState extends State<ContentRefreshSystem> {
  bool _isRefreshing = false;
  List<Episode> _newEpisodes = [];
  List<LearningJourney> _newJourneys = [];
  String _selectedCategory = 'all';
  
  final List<String> _categories = [
    'all',
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

  @override
  void initState() {
    super.initState();
    _loadFreshContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WismeColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text('Fresh Content'),
        backgroundColor: WismeColors.surface,
        foregroundColor: WismeColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshContent,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category selector
          _buildCategorySelector(),
          
          // Content list
          Expanded(
            child: _isRefreshing
                ? _buildRefreshingState()
                : _buildContentList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateNewContent,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Generate New'),
        backgroundColor: WismeColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: WismeColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: WismeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () => _selectCategory(category),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? WismeColors.primaryBlue
                          : WismeColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category == 'all' ? 'All Categories' : category,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : WismeColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text(
            'Generating Fresh Content...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: WismeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI is crafting new learning experiences',
            style: TextStyle(
              fontSize: 14,
              color: WismeColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList() {
    if (_newEpisodes.isEmpty && _newJourneys.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New journeys section
          if (_newJourneys.isNotEmpty) ...[
            _buildSectionHeader(
              'New Learning Journeys',
              Icons.auto_stories,
              'Fresh multi-episode learning paths',
            ),
            const SizedBox(height: 12),
            ..._newJourneys.map((journey) => _buildJourneyCard(journey)),
            const SizedBox(height: 24),
          ],

          // New episodes section
          if (_newEpisodes.isNotEmpty) ...[
            _buildSectionHeader(
              'New Episodes',
              Icons.play_circle_filled,
              'Latest individual learning episodes',
            ),
            const SizedBox(height: 12),
            ..._newEpisodes.map((episode) => _buildEpisodeCard(episode)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: WismeColors.primaryBlue, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: WismeColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: WismeColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJourneyCard(LearningJourney journey) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ModernCard(
        child: InkWell(
          onTap: () => _navigateToJourney(journey),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: WismeColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: WismeColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: WismeColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'JOURNEY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: WismeColors.primaryBlue,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      journey.formattedDuration,
                      style: const TextStyle(
                        fontSize: 12,
                        color: WismeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  journey.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: WismeColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  journey.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: WismeColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(
                      journey.category,
                      Icons.category,
                      WismeColors.info,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      journey.knowledgeType.toUpperCase(),
                      Icons.school,
                      WismeColors.warning,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      '${journey.episodes.length} episodes',
                      Icons.play_circle_outline,
                      WismeColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToJourney(journey),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Journey'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WismeColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodeCard(Episode episode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ModernCard(
        child: InkWell(
          onTap: () => _playEpisode(episode),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: WismeColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: WismeColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: WismeColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'EPISODE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: WismeColors.warning,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${episode.durationMinutes} min',
                      style: const TextStyle(
                        fontSize: 12,
                        color: WismeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  episode.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: WismeColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  episode.content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: WismeColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(
                      episode.category,
                      Icons.category,
                      WismeColors.info,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      episode.knowledgeType.toUpperCase(),
                      Icons.school,
                      WismeColors.warning,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      'Coach ${episode.coachPersonality}',
                      Icons.person,
                      WismeColors.primaryBlue,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _playEpisode(episode),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play Episode'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WismeColors.warning,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: WismeColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No fresh content yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: WismeColors.textSecondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate new content to discover fresh learning opportunities',
            style: TextStyle(
              fontSize: 14,
              color: WismeColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _generateNewContent,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate New Content'),
            style: ElevatedButton.styleFrom(
              backgroundColor: WismeColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _loadFreshContent();
  }

  void _refreshContent() {
    setState(() {
      _isRefreshing = true;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      _loadFreshContent();
    });
  }

  void _generateNewContent() {
    setState(() {
      _isRefreshing = true;
    });
    
    // Simulate AI content generation
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _newEpisodes.addAll(_generateFreshEpisodes());
        _newJourneys.addAll(_generateFreshJourneys());
        _isRefreshing = false;
      });
    });
  }

  void _loadFreshContent() {
    setState(() {
      _isRefreshing = true;
    });
    
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _newEpisodes = _generateFreshEpisodes();
        _newJourneys = _generateFreshJourneys();
        _isRefreshing = false;
      });
    });
  }

  List<Episode> _generateFreshEpisodes() {
    final topics = [
      'AI Ethics and Responsibility',
      'Quantum Computing Basics',
      'Sustainable Technology',
      'Digital Minimalism',
      'Bioengineering Fundamentals',
      'Space Exploration Updates',
      'Renewable Energy Innovations',
      'Mental Health in Digital Age',
    ];

    return topics.take(4).map((topic) {
      return Episode(
        id: 'fresh_${DateTime.now().millisecondsSinceEpoch}_${topic.hashCode}',
        title: topic,
        content: 'Explore the latest developments and insights in $topic. This episode covers key concepts, real-world applications, and future implications.',
        category: _getRandomCategory(),
        knowledgeType: _getRandomLevel(),
        coachPersonality: _getRandomCoach(),
        hashtags: _generateHashtags(topic),
        durationMinutes: _getRandomDuration(),
        createdAt: DateTime.now(),
        completionPercentage: 0.0,
      );
    }).toList();
  }

  List<LearningJourney> _generateFreshJourneys() {
    final journeyTopics = [
      'Future of Work and AI',
      'Climate Change Solutions',
      'Personal Productivity Mastery',
    ];

    return journeyTopics.map((topic) {
      final episodes = _generateJourneyEpisodes(topic);
      return LearningJourney(
        id: 'fresh_journey_${DateTime.now().millisecondsSinceEpoch}_${topic.hashCode}',
        title: 'Mastering $topic',
        description: 'A comprehensive 5-episode journey to understand and master $topic from fundamentals to advanced applications.',
        category: _getRandomCategory(),
        knowledgeType: _getRandomLevel(),
        episodes: episodes,
        currentEpisodeIndex: 0,
        completionPercentage: 0.0,
        isCompleted: false,
        createdAt: DateTime.now(),
      );
    }).toList();
  }

  List<Episode> _generateJourneyEpisodes(String topic) {
    final episodeTitles = [
      'Introduction to $topic',
      'Core Concepts and Principles',
      'Practical Applications',
      'Advanced Techniques',
      'Future Outlook and Mastery',
    ];

    return episodeTitles.asMap().entries.map((entry) {
      return Episode(
        id: 'journey_ep_${entry.key}_${DateTime.now().millisecondsSinceEpoch}',
        title: entry.value,
        content: 'Episode ${entry.key + 1} of the $topic journey. ${entry.value} - diving deep into the essential aspects.',
        category: _getRandomCategory(),
        knowledgeType: _getProgressiveLevel(entry.key),
        coachPersonality: _getRandomCoach(),
        hashtags: _generateHashtags(topic),
        durationMinutes: 12 + (entry.key * 2),
        createdAt: DateTime.now(),
        completionPercentage: 0.0,
      );
    }).toList();
  }

  String _getRandomCategory() {
    if (_selectedCategory != 'all') return _selectedCategory;
    final categories = _categories.where((c) => c != 'all').toList();
    return categories[DateTime.now().millisecond % categories.length];
  }

  String _getRandomLevel() {
    final levelOptions = [
      '🔹 Core Concepts',
      '💼 Case Studies',
      '🛠 Tools & Trends',
      '🎛 Bit of Everything',
      '💡 Fundamentals',
      '📈 Growth Strategy',
      '🧠 Theories & Experiments',
      '💬 Real-Life Application',
      '🔬 Scientific Concepts',
      '🎨 Design Fundamentals',
      '📖 Philosophy & Mental Models',
      '🎯 Self-Development',
      '🗺️ Timelines',
      '🌍 Cultural Impact',
      '🧰 Getting Started',
      '🔧 Pro Tools & Hacks',
      '🪞 Identity & Purpose',
      '📄 Career Assets',
      '📜 Legal Foundations',
      '🌐 Power Dynamics',
      '🌱 Climate & Ecology',
      '🔋 Sustainable Systems',
      '🧮 Foundational Concepts',
      '🔢 Applied Techniques',
      '🎮 Game Design Principles',
      '🧠 Player Experience',
      '🧭 Social Structures',
      '🧬 Moral Frameworks',
    ];
    return levelOptions[DateTime.now().millisecond % levelOptions.length];
  }

  String _getProgressiveLevel(int episodeIndex) {
    switch (episodeIndex) {
      case 0:
        return '🔹 Core Concepts';
      case 1:
        return '💼 Case Studies';
      case 2:
        return '🛠 Tools & Trends';
      case 3:
        return '🎛 Bit of Everything';
      case 4:
        return '💡 Fundamentals';
      default:
        return '🔹 Core Concepts';
    }
  }

  String _getRandomCoach() {
    final coaches = ['Kai', 'Vee'];
    return coaches[DateTime.now().millisecond % coaches.length];
  }

  int _getRandomDuration() {
    final durations = [8, 10, 12, 15, 18, 20];
    return durations[DateTime.now().millisecond % durations.length];
  }

  List<String> _generateHashtags(String topic) {
    final words = topic.toLowerCase().split(' ');
    return words.map((word) => '#$word').toList();
  }

  void _navigateToJourney(LearningJourney journey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningJourneyScreen(
          topic: journey.title,
          category: journey.category,
        ),
      ),
    );
  }

  void _playEpisode(Episode episode) {
    // In a real app, this would navigate to the audio player
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing: ${episode.title}'),
        backgroundColor: WismeColors.success,
      ),
    );
  }
}
