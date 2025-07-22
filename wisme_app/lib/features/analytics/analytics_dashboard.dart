import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/components/modern_card.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  // Learning statistics
  final int _totalEpisodesCompleted = 142;
  final int _totalLearningHours = 47;
  final int _currentStreak = 12;
  final int _longestStreak = 23;
  final double _averageCompletionRate = 0.84;
  
  // Weekly progress data
  final List<double> _weeklyProgress = [5.5, 7.2, 4.8, 8.1, 6.3, 9.0, 7.8];
  final List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  
  // Category distribution
  final Map<String, double> _categoryDistribution = {
    'Technology': 35,
    'Business': 25,
    'Science': 20,
    'Health': 12,
    'Creative': 8,
  };
  
  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WismeColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text('Learning Analytics'),
        backgroundColor: WismeColors.surface,
        foregroundColor: WismeColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            _buildOverviewCards(),
            
            const SizedBox(height: 24),
            
            // Weekly Progress Chart
            _buildWeeklyProgressChart(),
            
            const SizedBox(height: 24),
            
            // Category Distribution
            _buildCategoryDistribution(),
            
            const SizedBox(height: 24),
            
            // Learning Insights
            _buildLearningInsights(),
            
            const SizedBox(height: 24),
            
            // Recent Activity
            _buildRecentActivity(),
            
            const SizedBox(height: 24),
            
            // Achievement Badges
            _buildAchievementBadges(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Episodes Completed',
            value: _totalEpisodesCompleted.toString(),
            icon: Icons.play_circle_filled,
            color: WismeColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Learning Hours',
            value: _totalLearningHours.toString(),
            icon: Icons.schedule,
            color: WismeColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: WismeColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgressChart() {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Learning Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WismeColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Hours spent learning this week',
              style: TextStyle(
                fontSize: 14,
                color: WismeColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => WismeColors.surface,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${_weekDays[group.x.toInt()]}\n${rod.toY.toStringAsFixed(1)} hours',
                          const TextStyle(
                            color: WismeColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _weekDays[value.toInt()],
                            style: const TextStyle(
                              color: WismeColors.textSecondary,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}h',
                            style: const TextStyle(
                              color: WismeColors.textSecondary,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: _weeklyProgress.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: WismeColors.primaryBlue,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDistribution() {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WismeColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Distribution of topics you\'ve explored',
              style: TextStyle(
                fontSize: 14,
                color: WismeColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: _categoryDistribution.entries.map((entry) {
                    final colors = [
                      WismeColors.primaryBlue,
                      WismeColors.success,
                      WismeColors.warning,
                      WismeColors.error,
                      WismeColors.info,
                    ];
                    final colorIndex = _categoryDistribution.keys.toList().indexOf(entry.key);
                    
                    return PieChartSectionData(
                      color: colors[colorIndex % colors.length],
                      value: entry.value,
                      title: '${entry.value.toInt()}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: _categoryDistribution.entries.map((entry) {
                final colors = [
                  WismeColors.primaryBlue,
                  WismeColors.success,
                  WismeColors.warning,
                  WismeColors.error,
                  WismeColors.info,
                ];
                final colorIndex = _categoryDistribution.keys.toList().indexOf(entry.key);
                
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colors[colorIndex % colors.length],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 12,
                        color: WismeColors.textSecondary,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningInsights() {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WismeColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightRow(
              'Current Streak',
              '$_currentStreak days',
              Icons.local_fire_department,
              WismeColors.warning,
            ),
            const SizedBox(height: 12),
            _buildInsightRow(
              'Longest Streak',
              '$_longestStreak days',
              Icons.emoji_events,
              WismeColors.success,
            ),
            const SizedBox(height: 12),
            _buildInsightRow(
              'Completion Rate',
              '${(_averageCompletionRate * 100).toInt()}%',
              Icons.trending_up,
              WismeColors.primaryBlue,
            ),
            const SizedBox(height: 12),
            _buildInsightRow(
              'Favorite Time',
              '7:00 PM - 9:00 PM',
              Icons.schedule,
              WismeColors.info,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: WismeColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WismeColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              'Completed "Machine Learning Basics"',
              '2 hours ago',
              Icons.check_circle,
              WismeColors.success,
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              'Started "Quantum Computing Journey"',
              '1 day ago',
              Icons.play_arrow,
              WismeColors.primaryBlue,
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              'Earned "AI Explorer" badge',
              '3 days ago',
              Icons.emoji_events,
              WismeColors.warning,
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              'Completed "Data Science Fundamentals"',
              '5 days ago',
              Icons.check_circle,
              WismeColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: WismeColors.textPrimary,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: WismeColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementBadges() {
    final badges = [
      {'name': 'Early Bird', 'icon': Icons.wb_sunny, 'color': WismeColors.warning},
      {'name': 'Streak Master', 'icon': Icons.local_fire_department, 'color': WismeColors.error},
      {'name': 'AI Explorer', 'icon': Icons.psychology, 'color': WismeColors.primaryBlue},
      {'name': 'Knowledge Seeker', 'icon': Icons.search, 'color': WismeColors.success},
      {'name': 'Journey Completer', 'icon': Icons.flag, 'color': WismeColors.info},
    ];

    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Achievement Badges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WismeColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: badges.map((badge) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (badge['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (badge['color'] as Color).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        badge['icon'] as IconData,
                        color: badge['color'] as Color,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        badge['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: badge['color'] as Color,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _refreshData() {
    setState(() {
      // Refresh analytics data
      _loadAnalyticsData();
    });
  }

  void _loadAnalyticsData() {
    // Mock implementation - in production, this would fetch from backend
    // This method would load user analytics data from Supabase
  }
}



