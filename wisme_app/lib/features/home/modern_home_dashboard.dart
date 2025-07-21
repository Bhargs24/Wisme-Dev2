/// WISME Modern Home Dashboard - Coach-Like Experience
/// 
/// This dashboard provides a personalized, adaptive home experience that:
/// - Adapts to user behavior and preferences
/// - Provides intelligent recommendations
/// - Shows learning progress and insights
/// - Offers coach-like guidance and motivation
/// - Uses modern, unique UI components

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state_manager.dart';
import '../../core/analytics/comprehensive_analytics_system.dart';
import '../../shared/components/modern_ui_components.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/design_system/wisme_typography.dart';

class ModernHomeDashboard extends StatefulWidget {
  const ModernHomeDashboard({super.key});

  @override
  State<ModernHomeDashboard> createState() => _ModernHomeDashboardState();
}

class _ModernHomeDashboardState extends State<ModernHomeDashboard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    
    // Track dashboard view
    _trackDashboardView();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _trackDashboardView() {
    final analytics = ComprehensiveAnalyticsSystem.instance;
    analytics.trackEvent(
      LearningEvent(
        action: 'dashboard_viewed',
        data: {'timestamp': DateTime.now().toIso8601String()},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WismeColors.backgroundPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Modern app bar
            _buildModernAppBar(),
            
            // Main content
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome section
                        _buildWelcomeSection(),
                        const SizedBox(height: 24),
                        
                        // Quick actions
                        _buildQuickActions(),
                        const SizedBox(height: 24),
                        
                        // Learning progress
                        _buildLearningProgress(),
                        const SizedBox(height: 24),
                        
                        // Recommended content
                        _buildRecommendedContent(),
                        const SizedBox(height: 24),
                        
                        // Coach insights
                        _buildCoachInsights(),
                        const SizedBox(height: 24),
                        
                        // Recent activity
                        _buildRecentActivity(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Modern gradient app bar
  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                WismeColors.primaryBlue,
                WismeColors.wisdomPurple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // App logo placeholder
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'WISME',
                          style: WismeTypography.h3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Your AI Learning Coach',
                          style: WismeTypography.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Notification icon placeholder
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Personalized welcome section
  Widget _buildWelcomeSection() {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        final userName = userState.displayName ?? 'Learner';
        final timeOfDay = _getTimeOfDay();
        
        return WismeGradientCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // User avatar placeholder
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          WismeColors.primaryBlue,
                          WismeColors.wisdomPurple,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good $timeOfDay, $userName!',
                          style: WismeTypography.h4.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ready to learn something amazing?',
                          style: WismeTypography.bodySmall.copyWith(
                            color: WismeColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Daily motivation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: WismeColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: WismeColors.success.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: WismeColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                                             child: Text(
                         'Today\'s focus: Building lasting knowledge through conversation',
                         style: WismeTypography.bodySmall.copyWith(
                           color: WismeColors.success,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Quick action buttons
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: WismeTypography.h5.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: WismeGradientButton(
                text: 'Start Learning',
                icon: Icons.play_arrow,
                onPressed: () => _startLearning(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WismeGradientButton(
                text: 'Continue',
                icon: Icons.refresh,
                onPressed: () => _continueLearning(),
                gradientColors: [
                  WismeColors.backgroundSecondary,
                  WismeColors.backgroundSecondary,
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: WismeGradientButton(
                text: 'Search Topics',
                icon: Icons.search,
                onPressed: () => _searchTopics(),
                gradientColors: [
                  WismeColors.wisdomPurple,
                  WismeColors.primaryBlue,
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WismeGradientButton(
                text: 'My Library',
                icon: Icons.library_books,
                onPressed: () => _openLibrary(),
                gradientColors: [
                  WismeColors.success,
                  WismeColors.info,
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Learning progress section
  Widget _buildLearningProgress() {
    return Consumer<LearningState>(
      builder: (context, learningState, child) {
        final activeJourneys = learningState.activeJourneys;
        final completedEpisodes = learningState.completedEpisodes;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Progress',
              style: WismeTypography.h5.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            WismeGradientCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildProgressStat(
                        'Active Journeys',
                        activeJourneys.length.toString(),
                        Icons.trending_up,
                        WismeColors.primaryBlue,
                      ),
                      _buildProgressStat(
                        'Episodes Completed',
                        completedEpisodes.length.toString(),
                        Icons.check_circle,
                        WismeColors.success,
                      ),
                      _buildProgressStat(
                        'Learning Streak',
                        '5 days',
                        Icons.local_fire_department,
                        WismeColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Progress bar placeholder
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: WismeColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.7,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              WismeColors.primaryBlue,
                              WismeColors.wisdomPurple,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '70% of weekly goal completed',
                    style: WismeTypography.caption.copyWith(
                      color: WismeColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Progress stat widget
  Widget _buildProgressStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: WismeTypography.h6.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: WismeTypography.caption.copyWith(
            color: WismeColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Recommended content section
  Widget _buildRecommendedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended for You',
          style: WismeTypography.h5.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: EdgeInsets.only(right: index < 4 ? 16 : 0),
                child: WismeJourneyCard(
                  title: 'The Future of AI',
                  description: 'Explore how artificial intelligence is transforming our world and what it means for the future.',
                  category: 'Technology & AI',
                  episodeCount: 8,
                  durationMinutes: 12,
                  onTap: () => _startJourney(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Coach insights section
  Widget _buildCoachInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Coach Insights',
          style: WismeTypography.h5.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        WismeGradientCard(
          gradientColors: [
            WismeColors.info.withValues(alpha: 0.1),
            WismeColors.primaryBlue.withValues(alpha: 0.1),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          WismeColors.info,
                          WismeColors.primaryBlue,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                                 Text(
                           'Your Learning Pattern',
                           style: WismeTypography.bodyMedium.copyWith(
                             fontWeight: FontWeight.w600,
                           ),
                         ),
                        Text(
                          'You learn best in the morning',
                          style: WismeTypography.caption.copyWith(
                            color: WismeColors.textSecondary,
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
                  color: WismeColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates,
                      color: WismeColors.info,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Try 15-minute sessions for better retention',
                        style: WismeTypography.caption.copyWith(
                          color: WismeColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Recent activity section
  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: WismeTypography.h5.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        WismeGradientCard(
          child: Column(
            children: [
              _buildActivityItem(
                'Completed "Introduction to Machine Learning"',
                '2 hours ago',
                Icons.check_circle,
                WismeColors.success,
              ),
              const Divider(height: 24),
              _buildActivityItem(
                'Started "Business Strategy Fundamentals"',
                'Yesterday',
                Icons.play_circle,
                WismeColors.primaryBlue,
              ),
              const Divider(height: 24),
              _buildActivityItem(
                'Achieved "5-Day Learning Streak"',
                '3 days ago',
                Icons.emoji_events,
                WismeColors.warning,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Activity item widget
  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                             Text(
                 title,
                 style: WismeTypography.bodySmall.copyWith(
                   fontWeight: FontWeight.w500,
                 ),
               ),
              Text(
                time,
                style: WismeTypography.caption.copyWith(
                  color: WismeColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper methods
  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  void _startLearning() {
    // Navigate to learning flow
    ComprehensiveAnalyticsSystem.instance.trackEvent(
      LearningEvent(
        action: 'start_learning_clicked',
        data: {'source': 'dashboard'},
      ),
    );
  }

  void _continueLearning() {
    // Continue last session
    ComprehensiveAnalyticsSystem.instance.trackEvent(
      LearningEvent(
        action: 'continue_learning_clicked',
        data: {'source': 'dashboard'},
      ),
    );
  }

  void _searchTopics() {
    // Navigate to search
    ComprehensiveAnalyticsSystem.instance.trackEvent(
      LearningEvent(
        action: 'search_topics_clicked',
        data: {'source': 'dashboard'},
      ),
    );
  }

  void _openLibrary() {
    // Navigate to library
    ComprehensiveAnalyticsSystem.instance.trackEvent(
      LearningEvent(
        action: 'library_clicked',
        data: {'source': 'dashboard'},
      ),
    );
  }

  void _startJourney(int index) {
    // Start specific journey
    ComprehensiveAnalyticsSystem.instance.trackEvent(
      LearningEvent(
        action: 'journey_started',
        data: {'journey_index': index, 'source': 'dashboard'},
      ),
    );
  }
} 