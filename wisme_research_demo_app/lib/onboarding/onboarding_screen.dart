import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int? _ageRange;
  String? _educationLevel;
  String? _currentRole;
  List<String> _learningMotivations = [];

  bool _isFormComplete() {
    return _ageRange != null && _educationLevel != null && _currentRole != null && _learningMotivations.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About You')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Tell us about yourself', style: AppTextStyles.heading1.copyWith(fontSize: 24)),
            const SizedBox(height: 8),
            Text('This helps us understand different learning preferences', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            // Age range
            Align(
              alignment: Alignment.centerLeft,
              child: Text("What's your age range?", style: AppTextStyles.heading2.copyWith(fontSize: 18)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _ageRange,
              items: const [
                DropdownMenuItem(value: 1, child: Text('16-20')),
                DropdownMenuItem(value: 2, child: Text('21-30')),
                DropdownMenuItem(value: 3, child: Text('31-45')),
                DropdownMenuItem(value: 4, child: Text('46-65+')),
              ],
              onChanged: (val) => setState(() => _ageRange = val),
              decoration: const InputDecoration(hintText: 'Select age range'),
            ),
            const SizedBox(height: 24),
            // Education level
            Align(
              alignment: Alignment.centerLeft,
              child: Text("What's your education background?", style: AppTextStyles.heading2.copyWith(fontSize: 18)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _educationLevel,
              items: const [
                DropdownMenuItem(value: 'highschool', child: Text('High School')),
                DropdownMenuItem(value: 'undergraduate', child: Text('Undergraduate')),
                DropdownMenuItem(value: 'graduate', child: Text('Graduate/Masters')),
                DropdownMenuItem(value: 'phd', child: Text('PhD/Research')),
              ],
              onChanged: (val) => setState(() => _educationLevel = val),
              decoration: const InputDecoration(hintText: 'Select education background'),
            ),
            const SizedBox(height: 24),
            // Current role
            Align(
              alignment: Alignment.centerLeft,
              child: Text("What best describes your current role?", style: AppTextStyles.heading2.copyWith(fontSize: 18)),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _currentRole,
              items: const [
                DropdownMenuItem(value: 'student', child: Text('Student')),
                DropdownMenuItem(value: 'professional', child: Text('Working Professional')),
                DropdownMenuItem(value: 'entrepreneur', child: Text('Entrepreneur/Founder')),
                DropdownMenuItem(value: 'educator', child: Text('Educator/Teacher')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (val) => setState(() => _currentRole = val),
              decoration: const InputDecoration(hintText: 'Select current role'),
            ),
            const SizedBox(height: 24),
            // Learning motivations
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Why do you typically learn new things? (Select all that apply)", style: AppTextStyles.heading2.copyWith(fontSize: 18)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                'Career advancement',
                'Personal interest/hobby',
                'Academic requirements',
                'Professional upskilling',
                'Entrepreneurial goals',
                'Creative pursuits',
              ].map((motivation) => FilterChip(
                label: Text(motivation),
                selected: _learningMotivations.contains(motivation),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _learningMotivations.add(motivation);
                    } else {
                      _learningMotivations.remove(motivation);
                    }
                  });
                },
              )).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isFormComplete() ? () => Navigator.pushNamed(context, '/learning_style') : null,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('Continue to Learning Assessment', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
} 