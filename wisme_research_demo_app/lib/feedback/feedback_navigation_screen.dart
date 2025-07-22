import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FeedbackNavigationScreen extends StatelessWidget {
  const FeedbackNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback & Surveys')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text('Your Feedback Matters', style: AppTextStyles.heading1.copyWith(fontSize: 24)),
                const SizedBox(height: 8),
                Text('Help us understand your learning experience', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 32),
                _buildFeedbackCategory(context, 'Journey Experience', 'Rate and compare your learning journeys', Icons.rate_review, AppColors.primaryBlue, () {}),
                const SizedBox(height: 16),
                _buildFeedbackCategory(context, 'Learning Methods', 'Compare traditional vs conversational learning', Icons.compare, AppColors.accentGreen, () {}),
                const SizedBox(height: 16),
                _buildFeedbackCategory(context, 'Product Interest', 'Tell us about your interest in the full Wisme app', Icons.shopping_cart, AppColors.accentOrange, () {}),
                const SizedBox(height: 16),
                _buildFeedbackCategory(context, 'Demographics & Usage', 'Update your profile and usage patterns', Icons.person, AppColors.primaryBlue, () {}),
                const SizedBox(height: 16),
                _buildFeedbackCategory(context, 'Open Feedback', 'Share any thoughts, suggestions, or concerns', Icons.message, AppColors.accentGreen, () {}),
                const SizedBox(height: 32),
                Card(
                  color: Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.assignment_turned_in, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Research Completion', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('50% complete', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        const Icon(Icons.check_circle, color: Colors.green),
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
              child: const Icon(Icons.add_comment, color: Colors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCategory(BuildContext context, String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, scale, child) {
        return GestureDetector(
          onTapDown: (_) {}, // For tap animation stub
          onTapUp: (_) {},
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(scale),
            margin: const EdgeInsets.only(bottom: 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.12), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(description, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary, fontSize: 14)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 