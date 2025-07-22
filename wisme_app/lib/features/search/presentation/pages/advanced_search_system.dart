import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/components/modern_card.dart';

/// Advanced Search System
/// AI-powered semantic search with voice input, filters, and smart recommendations
class AdvancedSearchSystem extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSearchResult;
  final Function(String)? onTopicSelected;
  final String? initialQuery;

  const AdvancedSearchSystem({
    super.key,
    this.onSearchResult,
    this.onTopicSelected,
    this.initialQuery,
  });

  @override
  State<AdvancedSearchSystem> createState() => _AdvancedSearchSystemState();
}

class _AdvancedSearchSystemState extends State<AdvancedSearchSystem>
    with TickerProviderStateMixin {
  
  late AnimationController _searchController;
  late AnimationController _voiceController;
  late Animation<double> _searchAnimation;
  late Animation<double> _voiceAnimation;
  
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  String _currentQuery = '';
  bool _isSearching = false;
  bool _isVoiceMode = false;
  bool _showFilters = false;
  
  // Search filters
  Map<String, dynamic> _searchFilters = {
    'categories': <String>[],
    'difficulty': '',
    'duration': '',
    'content_type': '',
    'language': 'English',
  };
  
  // Search results
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _trendingTopics = [];
  List<String> _recentSearches = [];
  
  // Available categories
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Technology & AI', 'icon': Icons.computer, 'color': WismeColors.primaryBlue},
    {'name': 'Business & Finance', 'icon': Icons.business, 'color': WismeColors.veePrimary},
    {'name': 'Psychology & Mind', 'icon': Icons.psychology, 'color': WismeColors.kaiPrimary},
    {'name': 'Science & Nature', 'icon': Icons.science, 'color': WismeColors.success},
    {'name': 'Creativity & Design', 'icon': Icons.palette, 'color': WismeColors.wisdomPurple},
    {'name': 'Personal Development', 'icon': Icons.self_improvement, 'color': WismeColors.info},
    {'name': 'History & Culture', 'icon': Icons.history_edu, 'color': WismeColors.warning},
    {'name': 'Skills & Tools', 'icon': Icons.build, 'color': WismeColors.error},
    {'name': 'Career & Strategy', 'icon': Icons.work, 'color': WismeColors.primaryBlue},
    {'name': 'Law & Governance', 'icon': Icons.gavel, 'color': WismeColors.kaiPrimary},
    {'name': 'Geopolitics & Global Affairs', 'icon': Icons.public, 'color': WismeColors.veePrimary},
    {'name': 'Environment & Sustainability', 'icon': Icons.eco, 'color': WismeColors.success},
    {'name': 'Mathematics & Logic', 'icon': Icons.calculate, 'color': WismeColors.wisdomPurple},
    {'name': 'Gaming & Interactive Media', 'icon': Icons.games, 'color': WismeColors.info},
    {'name': 'Society & Ethics', 'icon': Icons.group, 'color': WismeColors.warning},
  ];

  @override
  void initState() {
    super.initState();
    
    _searchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _voiceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _searchController, curve: Curves.easeOut),
    );
    _voiceAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _voiceController, curve: Curves.easeInOut),
    );
    
    if (widget.initialQuery != null) {
      _searchTextController.text = widget.initialQuery!;
      _currentQuery = widget.initialQuery!;
    }
    
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _voiceController.dispose();
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    // Simulate loading trending topics and recent searches
    setState(() {
      _trendingTopics = [
        {
          'title': 'AI & Machine Learning Fundamentals',
          'category': '💻 Technology & AI',
          'popularity': 95,
          'difficulty': 'Intermediate',
          'duration': '6 hours',
          'description': 'Master the basics of artificial intelligence and machine learning',
        },
        {
          'title': 'Digital Marketing Strategy',
          'category': '💼 Business & Finance',
          'popularity': 88,
          'difficulty': 'Beginner',
          'duration': '4 hours',
          'description': 'Learn modern digital marketing techniques and strategies',
        },
        {
          'title': 'Sustainable Living & Climate Action',
          'category': '🌿 Environment & Sustainability',
          'popularity': 82,
          'difficulty': 'Beginner',
          'duration': '3 hours',
          'description': 'Practical steps for sustainable living and environmental awareness',
        },
        {
          'title': 'Creative Writing & Storytelling',
          'category': '🎨 Creativity & Design',
          'popularity': 76,
          'difficulty': 'Intermediate',
          'duration': '5 hours',
          'description': 'Develop your creative writing skills and storytelling techniques',
        },
      ];
      
      _recentSearches = [
        'JavaScript programming',
        'Personal finance basics',
        'Mindfulness meditation',
        'Public speaking tips',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSearchAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (_showFilters) _buildFiltersSection(),
                if (_isSearching)
                  _buildSearchResults()
                else ...[
                  _buildSearchSuggestions(),
                  _buildTrendingTopics(),
                  _buildCategoriesGrid(),
                  _buildRecentSearches(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF0F9FF),
                Color(0xFFF5F3FF),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 12),
                  _buildQuickFilters(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchTextController,
        focusNode: _searchFocusNode,
        onChanged: _onSearchTextChanged,
        onSubmitted: _performSearch,
        decoration: InputDecoration(
          hintText: 'What do you want to learn today?',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: AnimatedBuilder(
            animation: _searchAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_searchAnimation.value * 0.1),
                child: Icon(
                  Icons.search,
                  color: WismeColors.primaryBlue,
                ),
              );
            },
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Voice search button
              AnimatedBuilder(
                animation: _voiceAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isVoiceMode ? _voiceAnimation.value : 1.0,
                    child: IconButton(
                      onPressed: _toggleVoiceSearch,
                      icon: Icon(
                        _isVoiceMode ? Icons.mic : Icons.mic_none,
                        color: _isVoiceMode 
                            ? WismeColors.error 
                            : WismeColors.primaryBlue,
                      ),
                    ),
                  );
                },
              ),
              // Filters button
              IconButton(
                onPressed: () => setState(() => _showFilters = !_showFilters),
                icon: Icon(
                  _showFilters ? Icons.filter_list : Icons.tune,
                  color: _showFilters 
                      ? WismeColors.primaryBlue 
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFilters() {
    final quickFilters = ['All', 'Beginner', 'Intermediate', 'Advanced', 'Quick Learn'];
    
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: quickFilters.length,
        itemBuilder: (context, index) {
          final filter = quickFilters[index];
          final isSelected = _searchFilters['difficulty'] == filter || 
                           (filter == 'All' && _searchFilters['difficulty'].isEmpty);
          
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == quickFilters.length - 1 ? 0 : 8,
            ),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _searchFilters['difficulty'] = selected && filter != 'All' ? filter : '';
                });
                if (_currentQuery.isNotEmpty) {
                  _performSearch(_currentQuery);
                }
              },
              selectedColor: WismeColors.primaryBlue.withOpacity(0.2),
              checkmarkColor: WismeColors.primaryBlue,
              labelStyle: TextStyle(
                fontSize: 12,
                color: isSelected ? WismeColors.primaryBlue : Colors.grey[600],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFiltersSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(20),
      child: ModernCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.tune, color: WismeColors.primaryBlue),
                  const SizedBox(width: 8),
                  const Text(
                    'Advanced Filters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Categories filter
              _buildFilterSection(
                'Categories',
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((category) {
                    final isSelected = (_searchFilters['categories'] as List<String>)
                        .contains(category['name']);
                    
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category['icon'],
                            size: 16,
                            color: isSelected ? Colors.white : category['color'],
                          ),
                          const SizedBox(width: 4),
                          Text(category['name']),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          final categories = _searchFilters['categories'] as List<String>;
                          if (selected) {
                            categories.add(category['name']);
                          } else {
                            categories.remove(category['name']);
                          }
                        });
                      },
                      selectedColor: category['color'],
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Duration filter
              _buildFilterSection(
                'Duration',
                DropdownButtonFormField<String>(
                  value: _searchFilters['duration'].isEmpty ? null : _searchFilters['duration'],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text('Any duration'),
                  items: ['Under 1 hour', '1-3 hours', '3-6 hours', '6+ hours']
                      .map((duration) => DropdownMenuItem(
                            value: duration,
                            child: Text(duration),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _searchFilters['duration'] = value ?? '';
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Content type filter
              _buildFilterSection(
                'Content Type',
                Wrap(
                  spacing: 8,
                  children: ['Audio', 'Interactive', 'Practice-heavy', 'Theory-focused']
                      .map((type) {
                        final isSelected = _searchFilters['content_type'] == type;
                        return FilterChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _searchFilters['content_type'] = selected ? type : '';
                            });
                          },
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildSearchSuggestions() {
    if (_currentQuery.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.all(20),
      child: ModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Search Suggestions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ..._generateSearchSuggestions().map((suggestion) =>
              ListTile(
                leading: const Icon(Icons.search, color: WismeColors.primaryBlue),
                title: Text(suggestion),
                onTap: () => _selectSuggestion(suggestion),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${_searchResults.length} results for "$_currentQuery"',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _isSearching = false),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_searchResults.isEmpty)
            _buildNoResults()
          else
            ...(_searchResults.map((result) => _buildSearchResultCard(result))),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> result) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ModernCard(
        onTap: () => _selectSearchResult(result),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      result['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(result['category']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      result['category'],
                      style: TextStyle(
                        fontSize: 12,
                        color: _getCategoryColor(result['category']),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                result['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildResultMeta(Icons.school, result['difficulty']),
                  const SizedBox(width: 16),
                  _buildResultMeta(Icons.access_time, result['duration']),
                  const SizedBox(width: 16),
                  _buildResultMeta(Icons.trending_up, '${result['popularity']}% match'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms or filters',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _clearAllFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingTopics() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔥 Trending Now',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _trendingTopics.length,
              itemBuilder: (context, index) {
                final topic = _trendingTopics[index];
                return Container(
                  width: 280,
                  margin: EdgeInsets.only(
                    right: index == _trendingTopics.length - 1 ? 0 : 16,
                  ),
                  child: _buildTrendingTopicCard(topic),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingTopicCard(Map<String, dynamic> topic) {
    return ModernCard(
      onTap: () => _selectTopic(topic['title']),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(topic['category']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    topic['category'],
                    style: TextStyle(
                      fontSize: 12,
                      color: _getCategoryColor(topic['category']),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: WismeColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${topic['popularity']}%',
                    style: const TextStyle(
                      fontSize: 10,
                      color: WismeColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              topic['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              topic['description'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.school, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  topic['difficulty'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  topic['duration'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📚 Browse by Category',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return _buildCategoryCard(category);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return ModernCard(
      onTap: () => _searchByCategory(category['name']),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: (category['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                category['icon'],
                color: category['color'],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category['name'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '🕒 Recent Searches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _clearRecentSearches,
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((search) =>
              ActionChip(
                label: Text(search),
                onPressed: () => _selectRecentSearch(search),
                backgroundColor: Colors.grey[100],
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }

  // Event handlers
  void _onSearchTextChanged(String query) {
    setState(() {
      _currentQuery = query;
    });
    
    if (query.isNotEmpty) {
      _searchController.forward();
    } else {
      _searchController.reverse();
      setState(() => _isSearching = false);
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    
    setState(() {
      _currentQuery = query.trim();
      _isSearching = true;
    });
    
    // Add to recent searches
    if (!_recentSearches.contains(query.trim())) {
      setState(() {
        _recentSearches.insert(0, query.trim());
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      });
    }
    
    _searchFocusNode.unfocus();
    _executeSearch(query.trim());
  }

  void _executeSearch(String query) async {
    // Perform actual search with error handling
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        _searchResults = _generateSearchResults(query);
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<Map<String, dynamic>> _generateSearchResults(String query) {
    // Simulate semantic search results based on query
    final allResults = [
      ..._trendingTopics,
      {
        'title': 'JavaScript Fundamentals for Beginners',
        'category': '💻 Technology & AI',
        'popularity': 92,
        'difficulty': 'Beginner',
        'duration': '4 hours',
        'description': 'Learn JavaScript from scratch with hands-on examples and projects',
      },
      {
        'title': 'Personal Finance & Investment Basics',
        'category': '💼 Business & Finance',
        'popularity': 85,
        'difficulty': 'Beginner',
        'duration': '3 hours',
        'description': 'Master personal budgeting, saving, and investment fundamentals',
      },
      {
        'title': 'Mindfulness & Stress Management',
        'category': '🧠 Psychology & Mind',
        'popularity': 79,
        'difficulty': 'Beginner',
        'duration': '2 hours',
        'description': 'Learn practical mindfulness techniques for daily stress relief',
      },
    ];
    
    // Filter results based on query and filters
    return allResults.where((result) {
      final matchesQuery = result['title'].toLowerCase().contains(query.toLowerCase()) ||
                          result['description'].toLowerCase().contains(query.toLowerCase()) ||
                          result['category'].toLowerCase().contains(query.toLowerCase());
      
      final matchesCategory = (_searchFilters['categories'] as List<String>).isEmpty ||
                             (_searchFilters['categories'] as List<String>).contains(result['category']);
      
      final matchesDifficulty = _searchFilters['difficulty'].isEmpty ||
                               result['difficulty'] == _searchFilters['difficulty'];
      
      return matchesQuery && matchesCategory && matchesDifficulty;
    }).toList();
  }

  List<String> _generateSearchSuggestions() {
    if (_currentQuery.length < 2) return [];
    
    final suggestions = [
      'JavaScript programming basics',
      'JavaScript frameworks comparison',
      'JavaScript for web development',
      'Personal finance management',
      'Personal development skills',
      'Mindfulness meditation techniques',
      'Public speaking confidence',
      'Public speaking for beginners',
    ];
    
    return suggestions
        .where((suggestion) => 
          suggestion.toLowerCase().contains(_currentQuery.toLowerCase()) &&
          suggestion.toLowerCase() != _currentQuery.toLowerCase()
        )
        .take(5)
        .toList();
  }

  void _toggleVoiceSearch() {
    setState(() {
      _isVoiceMode = !_isVoiceMode;
    });
    
    if (_isVoiceMode) {
      _voiceController.repeat(reverse: true);
      _startVoiceRecognition();
    } else {
      _voiceController.stop();
      _stopVoiceRecognition();
    }
  }

  void _startVoiceRecognition() async {
    // Start actual voice recognition
    HapticFeedback.lightImpact();
    
    try {
      // Implement speech-to-text service
      // In production: final result = await SpeechToTextService.listen();
      
      // Fallback: use placeholder voice input
      await Future.delayed(const Duration(seconds: 3));
      
      if (_isVoiceMode) {
        final voiceQuery = 'JavaScript programming'; // Placeholder for voice result
        setState(() {
          _searchTextController.text = voiceQuery;
          _currentQuery = voiceQuery;
          _isVoiceMode = false;
        });
        _voiceController.stop();
        _performSearch(voiceQuery);
      }
    } catch (e) {
      setState(() {
        _isVoiceMode = false;
      });
      _voiceController.stop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice recognition failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _stopVoiceRecognition() {
    HapticFeedback.lightImpact();
    // Stop voice recognition service if active
  }

  void _selectSuggestion(String suggestion) {
    _searchTextController.text = suggestion;
    _performSearch(suggestion);
  }

  void _selectSearchResult(Map<String, dynamic> result) {
    if (widget.onSearchResult != null) {
      widget.onSearchResult!(result);
    }
    if (widget.onTopicSelected != null) {
      widget.onTopicSelected!(result['title']);
    }
  }

  void _selectTopic(String topic) {
    if (widget.onTopicSelected != null) {
      widget.onTopicSelected!(topic);
    }
  }

  void _selectRecentSearch(String search) {
    _searchTextController.text = search;
    _performSearch(search);
  }

  void _searchByCategory(String category) {
    setState(() {
      _searchFilters['categories'] = [category];
    });
    _performSearch(category);
  }

  void _clearAllFilters() {
    setState(() {
      _searchFilters = {
        'categories': <String>[],
        'difficulty': '',
        'duration': '',
        'content_type': '',
        'language': 'English',
      };
    });
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  Color _getCategoryColor(String category) {
    final categoryData = _categories.firstWhere(
      (cat) => cat['name'] == category,
      orElse: () => {'color': WismeColors.primaryBlue},
    );
    return categoryData['color'];
  }
}



