import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../navigation/main_navigation_shell.dart';

class AccountSetupScreen extends StatefulWidget {
  final User user;
  final String name;
  final int age;

  const AccountSetupScreen({
    super.key,
    required this.user,
    required this.name,
    required this.age,
  });

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  
  int _currentPage = 0;
  bool _isLoading = false;
  
  // Learning preferences
  final List<String> _selectedInterests = [];
  String? _selectedCoach;
  int _dailyGoalMinutes = 30;
  String? _preferredTimeOfDay;
  
  // Age-based content filtering (Critical for AI Moderation)
  bool get _isMinor => widget.age < 18;
  bool get _isTeenager => widget.age >= 13 && widget.age < 18;
  bool get _isYoungAdult => widget.age >= 18 && widget.age < 25;
  
  final List<String> _interests = [
    'Technology & AI',
    'Business & Finance',
    'Health & Fitness',
    'Arts & Creativity',
    'Science & Discovery',
    'History & Culture',
    'Language & Communication',
    'Personal Development',
    'Sports & Recreation',
    'Travel & Adventure',
    'Music & Entertainment',
    'Environment & Nature',
  ];
  
  final List<String> _timeSlots = [
    'Early Morning (6-9 AM)',
    'Morning (9-12 PM)',
    'Afternoon (12-5 PM)',
    'Evening (5-8 PM)',
    'Night (8-11 PM)',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Create user profile with age-based content filtering
      final profileData = {
        'user_id': widget.user.id,
        'name': widget.name,
        'age': widget.age,
        'is_minor': _isMinor,
        'is_teenager': _isTeenager,
        'is_young_adult': _isYoungAdult,
        'interests': _selectedInterests,
        'preferred_coach': _selectedCoach,
        'daily_goal_minutes': _dailyGoalMinutes,
        'preferred_time_of_day': _preferredTimeOfDay,
        'content_filter_level': _getContentFilterLevel(),
        'parental_controls_enabled': _isMinor,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      // Save to Supabase
      await Supabase.instance.client
          .from('user_profiles')
          .insert(profileData);
      
      // Update user metadata
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'profile_completed': true,
            'age': widget.age,
            'content_filter_level': _getContentFilterLevel(),
          },
        ),
      );
      
      if (mounted) {
        // Navigate to main app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigationShell(),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Setup failed: $error'),
            backgroundColor: WismeColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  String _getContentFilterLevel() {
    if (widget.age < 13) return 'strict';
    if (widget.age < 16) return 'moderate';
    if (widget.age < 18) return 'teen';
    return 'adult';
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _canContinue() {
    switch (_currentPage) {
      case 0:
        return _selectedInterests.isNotEmpty;
      case 1:
        return _selectedCoach != null && _preferredTimeOfDay != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WismeColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: WismeColors.textPrimary),
                onPressed: _previousPage,
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Setup',
              style: TextStyle(
                color: WismeColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Step ${_currentPage + 1} of 2',
              style: TextStyle(
                color: WismeColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            margin: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / 2,
              backgroundColor: WismeColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(WismeColors.primaryBlue),
            ),
          ),
          
          // Age-based content notice
          if (_isMinor)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: WismeColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: WismeColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: WismeColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Age-appropriate content filtering is enabled for your safety',
                      style: TextStyle(
                        color: WismeColors.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Page Content
          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildInterestsPage(),
                  _buildPreferencesPage(),
                ],
              ),
            ),
          ),
          
          // Continue Button
          Container(
            padding: const EdgeInsets.all(16),
            child: WismeButton(
              text: _currentPage == 1 ? 'Complete Setup' : 'Continue',
              onPressed: _canContinue() && !_isLoading ? _nextPage : null,
              variant: WismeButtonVariant.primary,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          Text(
            'What interests you?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: WismeColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Select topics you\'d like to explore (choose at least 3)',
            style: TextStyle(
              color: WismeColors.textSecondary,
              fontSize: 16,
            ),
          ),
          
          const SizedBox(height: 32),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _interests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedInterests.remove(interest);
                    } else {
                      _selectedInterests.add(interest);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? WismeColors.primaryBlue
                        : WismeColors.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? WismeColors.primaryBlue
                          : WismeColors.border,
                    ),
                  ),
                  child: Text(
                    interest,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : WismeColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          Text(
            'Learning Preferences',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: WismeColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Help us customize your experience',
            style: TextStyle(
              color: WismeColors.textSecondary,
              fontSize: 16,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Coach Selection
          Text(
            'Preferred AI Coach',
            style: TextStyle(
              color: WismeColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildCoachCard(
                  'Kai',
                  'Calm & Thoughtful',
                  'Perfect for deep learning',
                  Icons.psychology_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCoachCard(
                  'Vee',
                  'Energetic & Fun',
                  'Great for motivation',
                  Icons.emoji_emotions_outlined,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Daily Goal
          Text(
            'Daily Learning Goal',
            style: TextStyle(
              color: WismeColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: WismeColors.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '$_dailyGoalMinutes minutes per day',
                  style: TextStyle(
                    color: WismeColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _dailyGoalMinutes.toDouble(),
                  min: 10,
                  max: 120,
                  divisions: 11,
                  activeColor: WismeColors.primaryBlue,
                  onChanged: (value) {
                    setState(() {
                      _dailyGoalMinutes = value.toInt();
                    });
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Preferred Time
          Text(
            'Preferred Learning Time',
            style: TextStyle(
              color: WismeColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Column(
            children: _timeSlots.map((time) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<String>(
                  title: Text(
                    time,
                    style: TextStyle(
                      color: WismeColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: time,
                  groupValue: _preferredTimeOfDay,
                  onChanged: (value) {
                    setState(() {
                      _preferredTimeOfDay = value;
                    });
                  },
                  activeColor: WismeColors.primaryBlue,
                  tileColor: WismeColors.surfaceVariant.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachCard(String name, String subtitle, String description, IconData icon) {
    final isSelected = _selectedCoach == name;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCoach = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? WismeColors.primaryBlue.withOpacity(0.1)
              : WismeColors.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? WismeColors.primaryBlue
                : WismeColors.border,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? WismeColors.primaryBlue
                    : WismeColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : WismeColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? WismeColors.primaryBlue : WismeColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: WismeColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: WismeColors.textSecondary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
