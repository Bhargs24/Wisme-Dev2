import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../core/firebase_service.dart';

class JourneySelectionScreen extends StatelessWidget {
  JourneySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Journey'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: FirebaseService.getJourneys(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || (snapshot.data as dynamic).docs.isEmpty) {
                return Center(
                  child: Text('No journeys available yet.', style: AppTextStyles.bodyLarge),
                );
              }
              final journeys = (snapshot.data as dynamic).docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'id': doc.id,
                  'title': data['title'] ?? '',
                  'subtitle': '${data['episodes']?.length ?? 0} episodes • ${(data['totalDuration'] ?? 0) ~/ 60} minutes',
                  'icon': Icons.code, // You can map category to icon if needed
                  'color': AppColors.primaryBlue,
                  'difficulty': data['difficulty'] ?? 'Intermediate',
                };
              }).toList();
              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: journeys.length,
                  itemBuilder: (context, index) {
                    final journey = journeys[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1.0, end: 1.0),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, scale, child) {
                        return GestureDetector(
                          onTapDown: (_) {},
                          onTapUp: (_) {},
                          onTap: () => Navigator.pushNamed(context, '/audio_player', arguments: journey),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            transform: Matrix4.identity()..scale(scale),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [journey['color'].withOpacity(0.14), Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: journey['color'].withOpacity(0.10),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  journey['icon'],
                                  size: 48,
                                  color: journey['color'],
                                ),
                                const Spacer(),
                                Text(
                                  journey['title'],
                                  style: AppTextStyles.heading2.copyWith(fontSize: 18),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  journey['subtitle'],
                                  style: AppTextStyles.caption,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: journey['color'],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    journey['difficulty'],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
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
}

class _JourneyCard extends StatelessWidget {
  final Map<String, dynamic> journey;
  const _JourneyCard({required this.journey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/audio_player', arguments: journey),
      child: Container(
        decoration: BoxDecoration(
          color: journey['color'].withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: journey['color'].withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              journey['icon'],
              size: 40,
              color: journey['color'],
            ),
            const Spacer(),
            Text(
              journey['title'],
              style: AppTextStyles.heading2.copyWith(fontSize: 18),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              journey['subtitle'],
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: journey['color'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                journey['difficulty'],
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 