import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FinalResearchSurveyScreen extends StatefulWidget {
  const FinalResearchSurveyScreen({super.key});

  @override
  State<FinalResearchSurveyScreen> createState() => _FinalResearchSurveyScreenState();
}

class _FinalResearchSurveyScreenState extends State<FinalResearchSurveyScreen> {
  int? _overallExperienceRating;
  int? _researchValueRating;
  int? _overallMethodComparison;
  int? _futureMethodPreference;
  int? _learningFrequency;
  int? _learningBudget;
  String _finalFeedback = '';
  String _researchFeedback = '';
  bool _willingForFollowUp = false;
  String _followUpContact = '';

  bool _isFinalSurveyComplete() {
    return _overallExperienceRating != null && _researchValueRating != null && _overallMethodComparison != null && _futureMethodPreference != null && _learningFrequency != null && _learningBudget != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Final Research Survey')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text('Complete Your Research Participation', style: AppTextStyles.heading1.copyWith(fontSize: 24)),
                        const SizedBox(height: 8),
                        Text('These final questions help us analyze the research results', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildFinalSurveyQuestion('How would you rate your overall experience in this research study?', _overallExperienceRating, (val) => setState(() => _overallExperienceRating = val), ['Terrible', 'Poor', 'Okay', 'Good', 'Excellent']),
                _buildFinalSurveyQuestion('How valuable was your participation in this research?', _researchValueRating, (val) => setState(() => _researchValueRating = val), ['Not valuable', 'Slightly valuable', 'Moderately valuable', 'Very valuable', 'Extremely valuable']),
                _buildFinalSurveyQuestion('Compared to your usual learning methods, the conversational approach was:', _overallMethodComparison, (val) => setState(() => _overallMethodComparison = val), ['Much worse', 'Worse', 'Same', 'Better', 'Much better']),
                _buildFinalSurveyQuestion('For future learning, you would prefer:', _futureMethodPreference, (val) => setState(() => _futureMethodPreference = val), ['Conversational method like Wisme', 'Traditional text/video methods', 'A mix of both approaches', 'Depends on the topic', 'No strong preference']),
                const SizedBox(height: 32),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFinalSurveyQuestion('Your current learning frequency:', _learningFrequency, (val) => setState(() => _learningFrequency = val), ['Learn something new daily', 'Learn something new weekly', 'Learn something new monthly', 'Learn something new occasionally', 'Rarely learn new things']),
                        _buildFinalSurveyQuestion('Your typical learning budget (monthly):', _learningBudget, (val) => setState(() => _learningBudget = val), ['₹0 (only free resources)', '₹1-500 per month', '₹500-2000 per month', '₹2000-5000 per month', '₹5000+ per month']),
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
                        Text('💭 Final Thoughts', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'What did you think about the conversational learning approach? Any suggestions or concerns?',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => setState(() => _finalFeedback = value),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Any suggestions for improving the research study itself?',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => setState(() => _researchFeedback = value),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  color: Colors.green[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📞 Follow-up Opportunity', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                        const SizedBox(height: 16),
                        CheckboxListTile(
                          value: _willingForFollowUp,
                          onChanged: (value) => setState(() => _willingForFollowUp = value ?? false),
                          title: const Text('I\'m willing to participate in follow-up research'),
                          subtitle: const Text('Occasional surveys about learning preferences and product development'),
                        ),
                        if (_willingForFollowUp) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Contact email (optional)',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => setState(() => _followUpContact = value),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isFinalSurveyComplete() ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Complete Research Study', style: TextStyle(fontSize: 18)),
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
              child: const Icon(Icons.assignment_turned_in, color: Colors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalSurveyQuestion(String question, int? selectedValue, ValueChanged<int?> onChanged, List<String> options) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
            const SizedBox(height: 16),
            ...List.generate(options.length, (index) {
              return RadioListTile<int>(
                value: index + 1,
                groupValue: selectedValue,
                onChanged: onChanged,
                title: Text(options[index]),
              );
            }),
          ],
        ),
      ),
    );
  }
} 