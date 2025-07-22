import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../core/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityRequestsScreen extends StatefulWidget {
  const CommunityRequestsScreen({super.key});

  @override
  State<CommunityRequestsScreen> createState() => _CommunityRequestsScreenState();
}

class _CommunityRequestsScreenState extends State<CommunityRequestsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _staggerController;
  late Animation<double> _fadeAnimation;
  
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Technical', 'Business', 'Creative', 'Life Skills', 'Science', 'Languages', 'Other'];
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    
    _fadeController.forward();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildCategoryFilter(),
                    const SizedBox(height: 24),
                    _buildRequestsList(),
                    const SizedBox(height: 100), // Bottom padding
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.backgroundDark,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.backgroundCard.withOpacity(0.8),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Community Requests',
          style: AppTextStyles.heading2.copyWith(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.accentGreen.withOpacity(0.3),
                AppColors.backgroundDark,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentGreen.withOpacity(0.1),
            AppColors.primaryBlue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.accentGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accentGreen, AppColors.primaryBlue],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.people_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What\'s Trending',
                      style: AppTextStyles.heading2.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'See what topics the community wants most',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primaryBlue,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Demo data - In the full app, this will show real community requests in real-time',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryBlue,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Category',
          style: AppTextStyles.heading2.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == _selectedCategory;
              
              return Padding(
                padding: EdgeInsets.only(right: index == _categories.length - 1 ? 0 : 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [AppColors.accentGreen, AppColors.primaryBlue],
                            )
                          : null,
                      color: isSelected ? null : AppColors.backgroundCard.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppColors.accentGreen.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getRequestsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }
        
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildDemoData();
        }
        
        final requests = snapshot.data!.docs;
        return Column(
          children: requests.asMap().entries.map((entry) {
            final index = entry.key;
            final doc = entry.value;
            final data = doc.data() as Map<String, dynamic>;
            
            return AnimatedBuilder(
              animation: _staggerController,
              builder: (context, child) {
                final animationValue = Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _staggerController,
                    curve: Interval(
                      (index * 0.1).clamp(0.0, 1.0),
                      ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                      curve: Curves.easeOut,
                    ),
                  ),
                );
                
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - animationValue.value)),
                  child: Opacity(
                    opacity: animationValue.value,
                    child: _buildRequestCard(data, index),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  Stream<QuerySnapshot> _getRequestsStream() {
    Query query = FirebaseService.firestore.collection('topic_suggestions');
    
    if (_selectedCategory != 'All') {
      query = query.where('category', isEqualTo: _selectedCategory);
    }
    
    return query
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.backgroundCard.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.accentGreen,
                strokeWidth: 2,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDemoData() {
    final demoRequests = [
      {
        'topic': 'Machine Learning Fundamentals',
        'category': 'Technical',
        'reason': 'Want to understand AI basics for career transition',
        'requestCount': 24,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'topic': 'Public Speaking Confidence',
        'category': 'Life Skills',
        'reason': 'Need help with presentations at work',
        'requestCount': 18,
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      },
      {
        'topic': 'Blockchain Technology',
        'category': 'Technical',
        'reason': 'Curious about cryptocurrency and Web3',
        'requestCount': 15,
        'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      },
      {
        'topic': 'Digital Marketing Strategy',
        'category': 'Business',
        'reason': 'Starting my own business',
        'requestCount': 12,
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'topic': 'Photography Basics',
        'category': 'Creative',
        'reason': 'Want to improve Instagram posts',
        'requestCount': 9,
        'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      },
      {
        'topic': 'Investment Fundamentals',
        'category': 'Business',
        'reason': 'Need to start saving for retirement',
        'requestCount': 21,
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      },
    ];

    final filteredRequests = _selectedCategory == 'All' 
        ? demoRequests 
        : demoRequests.where((r) => r['category'] == _selectedCategory).toList();

    return Column(
      children: filteredRequests.asMap().entries.map((entry) {
        final index = entry.key;
        final request = entry.value;
        
        return AnimatedBuilder(
          animation: _staggerController,
          builder: (context, child) {
            final animationValue = Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _staggerController,
                curve: Interval(
                  (index * 0.1).clamp(0.0, 1.0),
                  ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                  curve: Curves.easeOut,
                ),
              ),
            );
            
            return Transform.translate(
              offset: Offset(0, 50 * (1 - animationValue.value)),
              child: Opacity(
                opacity: animationValue.value,
                child: _buildRequestCard(request, index),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request, int index) {
    final timestamp = request['timestamp'] is DateTime 
        ? request['timestamp'] as DateTime
        : DateTime.parse(request['timestamp'] as String);
    
    final timeAgo = _getTimeAgo(timestamp);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.backgroundCard.withOpacity(0.4),
            AppColors.backgroundCard.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request['topic'] as String,
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: AppColors.accentGreen,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${request['requestCount'] ?? 1}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.accentGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    request['category'] as String,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  timeAgo,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white38,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            if (request['reason'] != null && (request['reason'] as String).isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_quote,
                      color: Colors.white38,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        request['reason'] as String,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, '/suggest_topic'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.accentGreen],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Suggest Topic',
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
