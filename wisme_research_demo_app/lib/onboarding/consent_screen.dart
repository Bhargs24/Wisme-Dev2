import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _consentGiven = false;

  Widget _buildConsentSection(String title, String body, {bool isImportant = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 18, color: isImportant ? AppColors.accentOrange : AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(body, style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Research Participation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Research Study Consent', style: AppTextStyles.heading1.copyWith(fontSize: 24)),
            const SizedBox(height: 24),
            _buildConsentSection('Study Purpose', 'This research compares different learning methods to understand effectiveness and user preferences. Your participation helps validate new educational approaches.'),
            _buildConsentSection('What You\'ll Do', '• Complete a baseline assessment (5 minutes)\n• Experience 2-3 learning journeys (15-20 minutes each)\n• Answer feedback questions after each journey\n• Complete a final comparison survey'),
            _buildConsentSection('Time Commitment', 'Total time: 60-90 minutes over 1-2 weeks\nYou can pause and resume anytime'),
            _buildConsentSection('Privacy & Data', 'All data is anonymized and encrypted\nUsed only for research purposes\nYou can withdraw at any time'),
            _buildConsentSection('Important Note', 'This is a RESEARCH demo, not the full Wisme product\nThe complete app will have more features, content, and capabilities', isImportant: true),
            const SizedBox(height: 32),
            CheckboxListTile(
              value: _consentGiven,
              onChanged: (bool? value) => setState(() => _consentGiven = value ?? false),
              title: const Text('I consent to participate in this research study'),
              subtitle: const Text('I understand this is for research purposes only'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _consentGiven ? () => Navigator.pushNamed(context, '/onboarding') : null,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('Continue to Demographics', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
} 