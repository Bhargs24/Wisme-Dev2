import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class JourneyComparisonScreen extends StatefulWidget {
  const JourneyComparisonScreen({super.key});

  @override
  State<JourneyComparisonScreen> createState() => _JourneyComparisonScreenState();
}

class _JourneyComparisonScreenState extends State<JourneyComparisonScreen> {
  int? _effectivenessComparison;
  int? _engagementComparison;
  int? _futurePreference;
  String _comparisonFeedback = '';
  final Map<String, double> _conversationalRatings = {};
  final Map<String, double> _traditionalRatings = {};
  final List<String> _attributes = [
    'Easy to follow',
    'Helped me understand concepts',
    'Kept my attention',
    'Made learning enjoyable',
    'Helped me remember information',
    'Felt personalized to me',
    'Made complex topics simple',
    'Motivated me to continue learning',
  ];

  bool _isComplete() {
    return _effectivenessComparison != null && _engagementComparison != null && _futurePreference != null && _comparisonFeedback.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Your Journeys')),
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
                        Text('Learning Method Comparison', style: AppTextStyles.heading1.copyWith(fontSize: 24)),
                        const SizedBox(height: 8),
                        Text('Help us understand which methods work better for you', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
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
                      children: [
                        _buildComparisonQuestion('Overall, which learning method felt more effective?', _effectivenessComparison, (val) => setState(() => _effectivenessComparison = val)),
                        _buildComparisonQuestion('Which method kept you more engaged?', _engagementComparison, (val) => setState(() => _engagementComparison = val)),
                        _buildComparisonQuestion('Which method would you choose for future learning?', _futurePreference, (val) => setState(() => _futurePreference = val)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildAttributeComparison(),
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
                        Text('Tell us more about your experience', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'What made one method better than the other? Any specific moments that stood out?',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => setState(() => _comparisonFeedback = value),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isComplete() ? () {} : null,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                  child: const Text('Submit Comparison', style: TextStyle(fontSize: 18)),
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
              child: const Icon(Icons.compare, color: Colors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonQuestion(String question, int? selectedValue, ValueChanged<int?> onChanged) {
    final options = [
      'Conversational much better',
      'Conversational slightly better',
      'Both equally effective',
      'Traditional slightly better',
      'Traditional much better',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
        ...List.generate(options.length, (i) => RadioListTile<int>(
          value: i + 1,
          groupValue: selectedValue,
          onChanged: onChanged,
          title: Text(options[i]),
        )),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAttributeComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rate each method on specific aspects', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        ..._attributes.map((attribute) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Conversational', style: TextStyle(fontSize: 12, color: AppColors.primaryBlue)),
                      Slider(
                        value: _conversationalRatings[attribute] ?? 5.0,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        activeColor: AppColors.primaryBlue,
                        onChanged: (value) => setState(() => _conversationalRatings[attribute] = value),
                      ),
                      Text('${(_conversationalRatings[attribute] ?? 5.0).round()}/10', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Text('Traditional', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Slider(
                        value: _traditionalRatings[attribute] ?? 5.0,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        activeColor: AppColors.textSecondary,
                        onChanged: (value) => setState(() => _traditionalRatings[attribute] = value),
                      ),
                      Text('${(_traditionalRatings[attribute] ?? 5.0).round()}/10', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
} 