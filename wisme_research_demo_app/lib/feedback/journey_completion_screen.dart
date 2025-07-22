import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class JourneyCompletionScreen extends StatefulWidget {
  final Map<String, dynamic> completedJourney;
  const JourneyCompletionScreen({super.key, required this.completedJourney});

  @override
  State<JourneyCompletionScreen> createState() => _JourneyCompletionScreenState();
}

class _JourneyCompletionScreenState extends State<JourneyCompletionScreen> {
  int? _engagementRating;
  double _learningAmount = 5;
  double _retentionConfidence = 5;
  int? _methodComparison;
  List<int?> _postJourneyAnswers = [null, null, null];

  bool _isQuickFeedbackComplete() {
    return _engagementRating != null && _postJourneyAnswers.every((a) => a != null);
  }

  final List<Map<String, dynamic>> _postJourneyQuestions = [
    {
      'question': "What's the time complexity of finding an element in an unsorted array?",
      'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n^2)'],
    },
    {
      'question': "Why would you choose a linked list over an array for a music playlist?",
      'options': ['Faster access', 'Dynamic size', 'Less memory', 'Easier sorting'],
    },
    {
      'question': "What is ACID in databases?",
      'options': ['A type of query', 'A transaction property', 'A storage engine', 'A programming language'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final journey = widget.completedJourney;
    return Scaffold(
      appBar: AppBar(title: const Text('Journey Complete!')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Celebration visual
                Container(
                  height: 120,
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
                  child: const Icon(Icons.celebration, size: 80, color: Colors.white),
                ),
                Text('Great job!', style: AppTextStyles.heading1.copyWith(fontSize: 28)),
                const SizedBox(height: 8),
                Text('You completed: ${journey['title'] ?? 'Journey'}', style: AppTextStyles.heading2.copyWith(fontSize: 18, color: AppColors.textSecondary), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                // Quick engagement feedback
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('How did that feel?', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    {'emoji': '😴', 'value': 1},
                    {'emoji': '😐', 'value': 2},
                    {'emoji': '🙂', 'value': 3},
                    {'emoji': '😊', 'value': 4},
                    {'emoji': '🤩', 'value': 5},
                  ].map((item) => TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: _engagementRating == (item['value'] as int) ? 1.2 : 1.0),
                    duration: const Duration(milliseconds: 150),
                    builder: (context, scale, child) {
                      return GestureDetector(
                        onTap: () => setState(() => _engagementRating = item['value'] as int),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          transform: Matrix4.identity()..scale(scale),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _engagementRating == (item['value'] as int) ? AppColors.primaryBlue : Colors.transparent,
                          ),
                          child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 32)),
                        ),
                      );
                    },
                  )).toList(),
                ),
                const SizedBox(height: 24),
                // Learning effectiveness
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('How much did you learn?', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                        ),
                        Slider(
                          value: _learningAmount,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: _learningAmount.round().toString(),
                          onChanged: (val) => setState(() => _learningAmount = val),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Nothing'),
                            Text('A lot'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('How well will you remember this tomorrow?', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                        ),
                        Slider(
                          value: _retentionConfidence,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: _retentionConfidence.round().toString(),
                          onChanged: (val) => setState(() => _retentionConfidence = val),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Won\'t remember'),
                            Text('Remember clearly'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Quick knowledge check
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Quick Knowledge Check', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(_postJourneyQuestions.length, (index) {
                          final q = _postJourneyQuestions[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Q${index + 1}: ${q['question']}', style: AppTextStyles.bodyLarge),
                              ...List.generate(q['options'].length, (optIdx) => RadioListTile<int>(
                                value: optIdx,
                                groupValue: _postJourneyAnswers[index],
                                onChanged: (val) => setState(() => _postJourneyAnswers[index] = val),
                                title: Text(q['options'][optIdx]),
                              )),
                              const SizedBox(height: 8),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isQuickFeedbackComplete() ? () => Navigator.pushNamed(context, '/progress_dashboard') : null,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                  child: const Text('Save Feedback & Continue', style: TextStyle(fontSize: 18)),
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
              child: const Icon(Icons.feedback, color: Colors.white),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }
} 