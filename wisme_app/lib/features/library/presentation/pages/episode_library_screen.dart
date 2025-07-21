import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/content_integration_service.dart';
import '../../../../shared/components/modern_card.dart';
import '../../../../models/episode.dart';
import '../../../audio/presentation/pages/enhanced_audio_player_system.dart';

class EpisodeLibraryScreen extends StatefulWidget {
  const EpisodeLibraryScreen({super.key});

  @override
  State<EpisodeLibraryScreen> createState() => _EpisodeLibraryScreenState();
}

class _EpisodeLibraryScreenState extends State<EpisodeLibraryScreen> 
    with SingleTickerProviderStateMixin {
  final ContentIntegrationService _contentService = ContentIntegrationService();
  late TabController _tabController;
  List<Episode> _episodes = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Favorites',
    'In Progress',
    'Completed',
    'Not Started',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEpisodes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEpisodes() async {
    setState(() => _isLoading = true);
    
    try {
      final episodes = await _contentService.getUserEpisodes();
      setState(() {
        _episodes = episodes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load episodes: $e'),
            backgroundColor: WismeColors.error,
          ),
        );
      }
    }
  }

  List<Episode> get _filteredEpisodes {
    switch (_selectedFilter) {
      case 'Favorites':
        return _episodes.where((e) => e.isFavorited).toList();
      case 'In Progress':
        return _episodes.where((e) => 
          e.completionPercentage > 0 && e.completionPercentage < 1.0).toList();
      case 'Completed':
        return _episodes.where((e) => e.completionPercentage >= 1.0).toList();
      case 'Not Started':
        return _episodes.where((e) => e.completionPercentage == 0).toList();
      default:
        return _episodes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WismeColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text('My Learning Library'),
        backgroundColor: WismeColors.surface,
        foregroundColor: WismeColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEpisodes,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: WismeColors.primaryBlue,
          unselectedLabelColor: WismeColors.textSecondary,
          indicatorColor: WismeColors.primaryBlue,
          tabs: const [
            Tab(
              icon: Icon(Icons.library_books),
              text: 'Episodes',
            ),
            Tab(
              icon: Icon(Icons.favorite),
              text: 'Favorites',
            ),
            Tab(
              icon: Icon(Icons.analytics),
              text: 'Stats',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEpisodesTab(),
          _buildFavoritesTab(),
          _buildStatsTab(),
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
            Icons.library_books_outlined,
            size: 64,
            color: WismeColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            _selectedFilter == 'All' 
              ? 'No episodes yet'
              : 'No $_selectedFilter episodes',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: WismeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'All'
              ? 'Generate your first learning episode from the Home tab'
              : 'Try generating more episodes or change the filter',
            style: const TextStyle(
              fontSize: 16,
              color: WismeColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeCard(Episode episode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ModernCard(
        child: InkWell(
          onTap: () => _openEpisode(episode),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            episode.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: WismeColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Category: ${episode.category}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: WismeColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Favorite Button
                    IconButton(
                      onPressed: () => _toggleFavorite(episode),
                      icon: Icon(
                        episode.isFavorited 
                          ? Icons.favorite 
                          : Icons.favorite_border,
                        color: episode.isFavorited 
                          ? WismeColors.error 
                          : WismeColors.textSecondary,
                      ),
                      tooltip: episode.isFavorited 
                        ? 'Remove from favorites' 
                        : 'Add to favorites',
                    ),
                    _buildStatusIndicator(episode.completionPercentage),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Progress Bar
                if (episode.completionPercentage > 0) ...[
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: episode.completionPercentage,
                          backgroundColor: WismeColors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            episode.completionPercentage >= 1.0
                              ? WismeColors.success
                              : WismeColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(episode.completionPercentage * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: WismeColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Metadata Row
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: WismeColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${episode.durationMinutes} min',
                      style: const TextStyle(
                        fontSize: 12,
                        color: WismeColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.school,
                      size: 16,
                      color: WismeColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      episode.knowledgeType,
                      style: const TextStyle(
                        fontSize: 12,
                        color: WismeColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(episode.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: WismeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(double completion) {
    if (completion >= 1.0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: WismeColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 16,
              color: WismeColors.success,
            ),
            const SizedBox(width: 4),
            const Text(
              'Completed',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: WismeColors.success,
              ),
            ),
          ],
        ),
      );
    } else if (completion > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: WismeColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle,
              size: 16,
              color: WismeColors.primaryBlue,
            ),
            const SizedBox(width: 4),
            const Text(
              'In Progress',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: WismeColors.primaryBlue,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: WismeColors.textSecondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'New',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: WismeColors.textSecondary,
          ),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  Future<void> _toggleFavorite(Episode episode) async {
    try {
      // Update the episode's favorite status
      final updatedEpisode = episode.copyWith(isFavorited: !episode.isFavorited);
      
      // Update the episode in the backend
      await _contentService.updateEpisode(updatedEpisode);
      
      // Update the local list
      setState(() {
        final index = _episodes.indexWhere((e) => e.id == episode.id);
        if (index != -1) {
          _episodes[index] = updatedEpisode;
        }
      });

      // Show feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              updatedEpisode.isFavorited 
                ? 'Added to favorites' 
                : 'Removed from favorites'
            ),
            backgroundColor: WismeColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update favorite: $e'),
            backgroundColor: WismeColors.error,
          ),
        );
      }
    }
  }

  void _openEpisode(Episode episode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedAudioPlayerSystem(
          episode: {
            'title': episode.title,
            'content': episode.content,
            'category': episode.category,
            'knowledgeType': episode.knowledgeType,
            'audioUrl': episode.audioUrl,
          },
          coachName: episode.coachPersonality,
        ),
      ),
    );
  }

  Widget _buildEpisodesTab() {
    return Column(
      children: [
        // Filter Options
        Container(
          padding: const EdgeInsets.all(16),
          color: WismeColors.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterOptions.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: WismeColors.surfaceVariant,
                    selectedColor: WismeColors.primaryBlue.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: isSelected 
                        ? WismeColors.primaryBlue
                        : WismeColors.textSecondary,
                      fontWeight: isSelected 
                        ? FontWeight.w600
                        : FontWeight.w400,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        
        // Episodes List
        Expanded(
          child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _filteredEpisodes.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadEpisodes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredEpisodes.length,
                    itemBuilder: (context, index) {
                      final episode = _filteredEpisodes[index];
                      return _buildEpisodeCard(episode);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    final favorites = _episodes.where((e) => e.isFavorited).toList();
    
    return _isLoading
      ? const Center(child: CircularProgressIndicator())
      : favorites.isEmpty
        ? _buildFavoritesEmptyState()
        : RefreshIndicator(
            onRefresh: _loadEpisodes,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final episode = favorites[index];
                return _buildEpisodeCard(episode);
              },
            ),
          );
  }

  Widget _buildStatsTab() {
    final completedCount = _episodes.where((e) => e.isCompleted).length;
    final favoriteCount = _episodes.where((e) => e.isFavorited).length;
    final inProgressCount = _episodes.where((e) => e.isInProgress).length;
    final totalDuration = _episodes.fold<int>(0, (sum, e) => sum + e.durationMinutes);
    final completedDuration = _episodes
        .where((e) => e.isCompleted)
        .fold<int>(0, (sum, e) => sum + e.durationMinutes);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Learning Statistics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: WismeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          
          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(
                'Total Episodes',
                _episodes.length.toString(),
                Icons.library_books,
                WismeColors.primaryBlue,
              ),
              _buildStatCard(
                'Completed',
                completedCount.toString(),
                Icons.check_circle,
                WismeColors.success,
              ),
              _buildStatCard(
                'Favorites',
                favoriteCount.toString(),
                Icons.favorite,
                WismeColors.error,
              ),
              _buildStatCard(
                'In Progress',
                inProgressCount.toString(),
                Icons.play_circle,
                WismeColors.warning,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Time Stats
          ModernCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Time Investment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: WismeColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Content'),
                      Text(
                        '${(totalDuration / 60).toStringAsFixed(1)}h',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Completed'),
                      Text(
                        '${(completedDuration / 60).toStringAsFixed(1)}h',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: WismeColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: totalDuration > 0 ? completedDuration / totalDuration : 0,
                    backgroundColor: WismeColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(WismeColors.success),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: WismeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: WismeColors.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: WismeColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the heart icon on episodes to add them to your favorites',
            style: TextStyle(
              fontSize: 16,
              color: WismeColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
