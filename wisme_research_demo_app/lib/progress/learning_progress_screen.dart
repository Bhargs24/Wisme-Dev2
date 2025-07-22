import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class LearningProgressScreen extends StatelessWidget {
  const LearningProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final completedJourneys = 2;
    final totalJourneys = 4;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Learning Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {}, // Placeholder for analytics
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: completedJourneys / totalJourneys),
                          duration: const Duration(seconds: 1),
                          builder: (context, value, child) {
                            return SizedBox(
                              height: 80,
                              width: 80,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CircularProgressIndicator(
                                    value: value,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                                    strokeWidth: 8,
                                  ),
                                  Center(
                                    child: Text('${(value * 100).round()}%', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text('$completedJourneys of $totalJourneys journeys completed', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                        const SizedBox(height: 8),
                        Text('You\'re doing great! Keep going to complete the study', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildInsightCard('Your Learning Pattern', 'You prefer audio-heavy, short sessions.', Icons.insights, AppColors.primaryBlue),
                _buildInsightCard('Knowledge Growth', 'Your knowledge score improved by 30%.', Icons.trending_up, AppColors.accentGreen),
                _buildInsightCard('Learning Preferences', 'You engage most with DSA and Finance.', Icons.favorite, AppColors.accentOrange),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('What\'s Next?', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.play_circle_fill, color: AppColors.primaryBlue),
                          title: const Text('Continue Learning'),
                          subtitle: const Text('Try: Operating Systems'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {}, // Placeholder for journey start
                        ),
                        ListTile(
                          leading: const Icon(Icons.assignment, color: AppColors.accentOrange),
                          title: const Text('Share More Feedback'),
                          subtitle: const Text('Help us understand your experience better'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => Navigator.pushNamed(context, '/feedback_hub'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.play_arrow, color: Colors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
        subtitle: Text(value, style: AppTextStyles.bodyLarge),
      ),
    );
  }
} 