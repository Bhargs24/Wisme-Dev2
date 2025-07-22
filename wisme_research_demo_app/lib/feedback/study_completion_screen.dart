import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class StudyCompletionScreen extends StatelessWidget {
  const StudyCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final completedJourneys = 4;
    final totalLearningTime = 180;
    final completedSurveys = 5;
    final feedbackResponses = 12;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.accentGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.18),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.celebration, size: 100, color: Colors.white),
                  ),
                  Text('Research Study Complete!', style: AppTextStyles.heading1.copyWith(fontSize: 28)),
                  const SizedBox(height: 16),
                  Text('Thank you for your valuable contribution to learning research', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
                  const SizedBox(height: 40),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text('Your Research Contribution', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                          const SizedBox(height: 20),
                          _buildStatRow('Learning journeys completed', '$completedJourneys'),
                          _buildStatRow('Total learning time', '$totalLearningTime minutes'),
                          _buildStatRow('Surveys completed', '$completedSurveys'),
                          _buildStatRow('Feedback responses', '$feedbackResponses'),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Your data will help validate new learning methods and improve education for millions of learners!', style: TextStyle(color: Colors.green[800]), textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(Icons.card_membership, size: 50, color: AppColors.primaryBlue),
                          const SizedBox(height: 16),
                          Text('Research Participation Certificate', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                          const SizedBox(height: 8),
                          Text('Download your official certificate of participation', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download),
                            label: const Text('Download Certificate'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('What\'s Next?', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                          const SizedBox(height: 16),
                          _buildNextStepItem('📊', 'Research Analysis', 'We\'ll analyze all participant data to understand learning effectiveness'),
                          _buildNextStepItem('📝', 'Results Publication', 'Findings will be published in academic journals and conferences'),
                          _buildNextStepItem('🚀', 'Product Development', 'Your feedback will directly influence the development of Wisme'),
                          _buildNextStepItem('📧', 'Follow-up (Optional)', 'If you opted in, we may contact you for future research'),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Interested in the full Wisme app? We\'ll notify you when it launches!', style: TextStyle(color: Colors.orange[800]), textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Complete & Exit Study', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Share this research with others'),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.share, color: Colors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNextStepItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(description, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 