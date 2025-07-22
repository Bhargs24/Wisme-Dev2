import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = 'Rahul';
    final xp = 1200;
    final xpToNext = 2000;
    final badges = [
      {'icon': Icons.emoji_events, 'label': 'DSA Master'},
      {'icon': Icons.star, 'label': 'Streak Hero'},
      {'icon': Icons.school, 'label': 'Research Pro'},
    ];
    final journeys = 4;
    final streak = 7;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {}, // Settings stub
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {}, // Edit profile stub
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.accentGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.2),
                    blurRadius: 32,
                    spreadRadius: 8,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: const CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 56, color: AppColors.primaryBlue),
              ),
            ),
            const SizedBox(height: 16),
            Text(userName, style: AppTextStyles.heading1.copyWith(fontSize: 24)),
            const SizedBox(height: 8),
            // XP bar
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('XP', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: xp / xpToNext,
                      minHeight: 12,
                      backgroundColor: AppColors.backgroundCard,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
                    ),
                    const SizedBox(height: 8),
                    Text('$xp / $xpToNext XP', style: AppTextStyles.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Badges
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Badges', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: badges.map((badge) => TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: 1.0),
                duration: const Duration(milliseconds: 200),
                builder: (context, scale, child) {
                  return GestureDetector(
                    onTapDown: (_) {}, // For tap animation stub
                    onTapUp: (_) {},
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()..scale(scale),
                      child: Chip(
                        avatar: Icon(badge['icon'] as IconData, color: AppColors.primaryBlue, size: 20),
                        label: Text(badge['label'] as String),
                        backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  );
                },
              )).toList(),
            ),
            const SizedBox(height: 24),
            // Stats
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('Journeys', journeys.toString(), Icons.map),
                    _buildStat('Streak', '$streak days', Icons.local_fire_department),
                    _buildStat('Level', '7', Icons.trending_up),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 28),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
} 