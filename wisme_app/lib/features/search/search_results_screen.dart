import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/components/modern_card.dart';
import '../../models/episode.dart';
import '../../models/learning_journey.dart';
import '../journey/learning_journey_screen.dart';
// import '../../audio/audio_player_screen.dart'; // TODO: Implement audio player screen

class SearchResultsScreen extends StatefulWidget {
  final String query;
  final String? category;
  
  const SearchResultsScreen({
    super.key,
    required this.query,
    this.category,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Episode> _episodes = [];
  List<LearningJourney> _journeys = [];
  bool _isLoading = false;
  String _selectedFilter = 'all';
  String _selectedCategory = 'all';
  String _selectedDuration = 'all';
  String _selectedKnowledgeType = 'all';
  
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
  
  final List<String> _durations = [
    'all',
    '1-5 minutes',
    '6-10 minutes',
    '11-15 minutes',
    '16-20 minutes',
    '20+ minutes',
  ];
  
  final List<String> _knowledgeTypes = [
    'all',
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

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WismeColors.backgroundSecondary,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search Results',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'for "${widget.query}"',
              style: const TextStyle(
                fontSize: 14,
                color: WismeColors.textSecondary,
              ),
            ),
          ],
        ),
        backgroundColor: WismeColors.surface,
        foregroundColor: WismeColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search stats and filters
          _buildSearchHeader(),
          
          // Results list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    final totalResults = _episodes.length + _journeys.length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: WismeColors.surface,
      child: Column(
        children: [
          // Results count and filter chips
          Row(
            children: [
              Text(
                '$totalResults results found',
                style: const TextStyle(
                  fontSize: 14,
                  color: WismeColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (_hasActiveFilters())
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear Filters'),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'All',
                  _selectedFilter == 'all',
                  () => _updateFilter('all'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Episodes',
                  _selectedFilter == 'episodes',
                  () => _updateFilter('episodes'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Journeys',
                  _selectedFilter == 'journeys',
                  () => _updateFilter('journeys'),
                ),
                const SizedBox(width: 8),
                if (_selectedCategory != 'all')
                  _buildFilterChip(
                    _selectedCategory,
                    true,
                    () => _updateCategory('all'),
                    isRemovable: true,
                  ),
                if (_selectedKnowledgeType != 'all')
                  _buildFilterChip(
                    _selectedKnowledgeType.toUpperCase(),
                    true,
                    () => _updateKnowledgeType('all'),
                    isRemovable: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    VoidCallback onTap, {
    bool isRemovable = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? WismeColors.primaryBlue
              : WismeColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? WismeColors.primaryBlue
                : WismeColors.surfaceVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : WismeColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isRemovable) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.close,
                size: 14,
                color: isSelected ? Colors.white : WismeColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    final filteredEpisodes = _getFilteredEpisodes();
    final filteredJourneys = _getFilteredJourneys();
    
    if (filteredEpisodes.isEmpty && filteredJourneys.isEmpty) {
      return _buildEmptyState();
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Journeys section
        if (filteredJourneys.isNotEmpty && _selectedFilter != 'episodes') ...[
          const Text(
            'Learning Journeys',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: WismeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...filteredJourneys.map((journey) => _buildJourneyCard(journey)),
          const SizedBox(height: 24),
        ],
        
        // Episodes section
        if (filteredEpisodes.isNotEmpty && _selectedFilter != 'journeys') ...[
          const Text(
            'Episodes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: WismeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...filteredEpisodes.map((episode) => _buildEpisodeCard(episode)),
        ],
      ],
    );
  }

  Widget _buildJourneyCard(LearningJourney journey) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                    fontSize: 16,
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
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      journey.knowledgeType.toUpperCase(),
                      Icons.school,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      '${journey.episodes.length} episodes',
                      Icons.play_circle_outline,
                    ),
                  ],
                ),
                if (journey.completionPercentage > 0) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: journey.completionPercentage,
                          backgroundColor: WismeColors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            journey.isCompleted
                                ? WismeColors.success
                                : WismeColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(journey.completionPercentage * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: WismeColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodeCard(Episode episode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                        'EPISODE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: WismeColors.success,
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
                    fontSize: 16,
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
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      episode.knowledgeType.toUpperCase(),
                      Icons.school,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      'Coach ${episode.coachPersonality}',
                      Icons.person,
                    ),
                  ],
                ),
                if (episode.completionPercentage > 0) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: episode.completionPercentage,
                          backgroundColor: WismeColors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            episode.isCompleted
                                ? WismeColors.success
                                : WismeColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        episode.isCompleted ? 'Completed' : 'In Progress',
                        style: TextStyle(
                          fontSize: 12,
                          color: episode.isCompleted
                              ? WismeColors.success
                              : WismeColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: WismeColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: WismeColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: WismeColors.textSecondary,
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
            Icons.search_off,
            size: 64,
            color: WismeColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: WismeColors.textSecondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms or filters',
            style: TextStyle(
              fontSize: 14,
              color: WismeColors.textSecondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _clearFilters,
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: WismeColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: WismeColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              
              // Category filter
              const Text(
                'Category',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: WismeColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  return _buildFilterChip(
                    category == 'all' ? 'All Categories' : category,
                    _selectedCategory == category,
                    () {
                      setModalState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 20),
              
              // Level filter
              const Text(
                'Knowledge Level',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: WismeColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _knowledgeTypes.map((knowledgeType) {
                  return _buildFilterChip(
                    knowledgeType == 'all' ? 'All Levels' : knowledgeType.toUpperCase(),
                    _selectedKnowledgeType == knowledgeType,
                    () {
                      setModalState(() {
                        _selectedKnowledgeType = knowledgeType;
                      });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 20),
              
              // Duration filter
              const Text(
                'Duration',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: WismeColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _durations.map((duration) {
                  return _buildFilterChip(
                    duration == 'all' ? 'Any Duration' : duration,
                    _selectedDuration == duration,
                    () {
                      setModalState(() {
                        _selectedDuration = duration;
                      });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _performSearch() {
    setState(() {
      _isLoading = true;
    });

    // Mock search implementation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _episodes = _generateMockEpisodes();
          _journeys = _generateMockJourneys();
          _isLoading = false;
        });
      }
    });
  }

  List<Episode> _generateMockEpisodes() {
    // Mock episodes based on search query
    return [
      Episode(
        id: 'ep1',
        title: 'Introduction to ${widget.query}',
        content: 'Learn the fundamentals of ${widget.query} in this comprehensive introduction.',
        category: 'Technology & AI',
        knowledgeType: '🔹 Core Concepts',
        coachPersonality: 'Kai',
        hashtags: ['#${widget.query.toLowerCase()}', '#fundamentals', '#introduction'],
        durationMinutes: 12,
        createdAt: DateTime.now(),
        completionPercentage: 0.0,
      ),
      Episode(
        id: 'ep2',
        title: 'Advanced ${widget.query} Techniques',
        content: 'Master advanced concepts and techniques in ${widget.query}.',
        category: 'Technology & AI',
        knowledgeType: '🛠 Tools & Trends',
        coachPersonality: 'Vee',
        hashtags: ['#${widget.query.toLowerCase()}', '#advanced', '#techniques'],
        durationMinutes: 18,
        createdAt: DateTime.now(),
        completionPercentage: 0.6,
      ),
      Episode(
        id: 'ep3',
        title: '${widget.query} Best Practices',
        content: 'Industry best practices and real-world applications of ${widget.query}.',
        category: 'Business & Finance',
        knowledgeType: '💼 Case Studies',
        coachPersonality: 'Kai',
        hashtags: ['#${widget.query.toLowerCase()}', '#bestpractices', '#industry'],
        durationMinutes: 15,
        createdAt: DateTime.now(),
        completionPercentage: 1.0,
      ),
    ];
  }

  List<LearningJourney> _generateMockJourneys() {
    // Mock journeys based on search query
    return [
      LearningJourney(
        id: 'journey1',
        title: 'Complete ${widget.query} Mastery',
        description: 'A comprehensive 5-episode journey to master ${widget.query} from beginner to expert.',
        category: 'Technology & AI',
        knowledgeType: '🔹 Core Concepts',
        episodes: _generateMockEpisodes(),
        currentEpisodeIndex: 0,
        completionPercentage: 0.0,
        isCompleted: false,
        createdAt: DateTime.now(),
      ),
    ];
  }

  List<Episode> _getFilteredEpisodes() {
    return _episodes.where((episode) {
      if (_selectedCategory != 'all' && episode.category != _selectedCategory) {
        return false;
      }
      if (_selectedKnowledgeType != 'all' && episode.knowledgeType != _selectedKnowledgeType) {
        return false;
      }
      if (_selectedDuration != 'all') {
        final duration = episode.durationMinutes;
        switch (_selectedDuration) {
          case '1-5 minutes':
            if (duration < 1 || duration > 5) return false;
            break;
          case '6-10 minutes':
            if (duration < 6 || duration > 10) return false;
            break;
          case '11-15 minutes':
            if (duration < 11 || duration > 15) return false;
            break;
          case '16-20 minutes':
            if (duration < 16 || duration > 20) return false;
            break;
          case '20+ minutes':
            if (duration <= 20) return false;
            break;
        }
      }
      return true;
    }).toList();
  }

  List<LearningJourney> _getFilteredJourneys() {
    return _journeys.where((journey) {
      if (_selectedCategory != 'all' && journey.category != _selectedCategory) {
        return false;
      }
      if (_selectedKnowledgeType != 'all' && journey.knowledgeType != _selectedKnowledgeType) {
        return false;
      }
      return true;
    }).toList();
  }

  bool _hasActiveFilters() {
    return _selectedCategory != 'all' ||
        _selectedKnowledgeType != 'all' ||
        _selectedDuration != 'all';
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'all';
      _selectedKnowledgeType = 'all';
      _selectedDuration = 'all';
    });
  }

  void _updateFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _updateCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _updateKnowledgeType(String knowledgeType) {
    setState(() {
      _selectedKnowledgeType = knowledgeType;
    });
  }

  void _applyFilters() {
    setState(() {
      // Filters are already applied through the getFiltered methods
    });
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
    // TODO: Implement audio player screen navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing: ${episode.title}'),
        backgroundColor: WismeColors.success,
      ),
    );
    
    /* TODO: Uncomment when AudioPlayerScreen is implemented
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
    );
    */
  }
}
