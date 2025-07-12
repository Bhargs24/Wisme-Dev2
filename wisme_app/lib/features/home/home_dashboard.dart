import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../shared/shared.dart';
import '../features.dart';


class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF0F9FF),
              Color(0xFFF5F3FF),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildStreakCard(),
                const SizedBox(height: 24),
                _buildContinueLearning(),
                const SizedBox(height: 24),
                _buildTodaysPlan(context),
                const SizedBox(height: 24),
                _buildFeelingCurious(context),
                const SizedBox(height: 24),
                _buildQuickStats(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: WismeColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.psychology,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good morning!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const Text(
                'Ready to learn?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LearningAnalyticsDashboard(),
              ),
            );
          },
          icon: const Icon(Icons.notifications_outlined),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
          icon: const Icon(Icons.person_outline),
        ),
      ],
    );
  }

  Widget _buildStreakCard() {
    return ModernCard(
      backgroundColor: WismeColors.primaryBlue.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: WismeColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: WismeColors.primaryBlue,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '7-Day Streak! 🔥',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Keep the momentum going',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: WismeColors.primaryBlue,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueLearning() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Continue Learning',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        ModernCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: WismeColors.kaiPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'with Kai',
                      style: TextStyle(
                        color: WismeColors.kaiPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'JavaScript Advanced Concepts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Episode 3: Closures and Scope Chain',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(WismeColors.kaiPrimary),
                ),
                const SizedBox(height: 8),
                const Text(
                  '6 minutes remaining',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysPlan(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Today\'s Plan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LibraryScreen(),
                  ),
                );
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildPlanItem('Machine Learning Basics', 'Introduction to Neural Networks', 'Kai', 15, false),
        const SizedBox(height: 8),
        _buildPlanItem('UI/UX Design', 'Color Theory in Practice', 'Vee', 12, true),
      ],
    );
  }

  Widget _buildPlanItem(String topic, String episode, String coach, int minutes, bool isCompleted) {
    return ModernCard(
      backgroundColor: isCompleted ? WismeColors.success.withOpacity(0.05) : null,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted 
                ? WismeColors.success.withOpacity(0.1)
                : (coach == 'Kai' ? WismeColors.kaiPrimary : WismeColors.veePrimary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.play_arrow,
            color: isCompleted 
                ? WismeColors.success
                : (coach == 'Kai' ? WismeColors.kaiPrimary : WismeColors.veePrimary),
          ),
        ),
        title: Text(
          topic,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          '$episode • $minutes min with $coach',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: isCompleted 
            ? const Icon(Icons.check_circle, color: WismeColors.success)
            : const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildFeelingCurious(BuildContext context) {
    return ModernCard(
      backgroundColor: WismeColors.wisdomPurple.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: WismeColors.wisdomPurple,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Feeling Curious?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Explore something new today',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TopicInputSystem(
                        onTopicSubmitted: (topic, personalContext) async {
                          // Show loading dialog while generating episode
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Creating your personalized learning episode...'),
                                ],
                              ),
                            ),
                          );

                          try {
                            // Use ContentIntegrationService to generate complete episode
                            final contentService = ContentIntegrationService();
                            final episode = await contentService.generateEpisodeFromTopic(
                              topic,
                              personalContext: personalContext,
                            );

                            if (context.mounted) {
                              Navigator.of(context).pop(); // Close loading dialog
                              Navigator.of(context).pop(); // Close topic input screen
                              
                              // Navigate directly to audio player with generated episode
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EnhancedAudioPlayerSystem(
                                    episode: {
                                      'id': episode.id,
                                      'title': episode.title,
                                      'content': episode.content,
                                      'category': episode.category,
                                      'knowledgeLevel': episode.knowledgeLevel,
                                      'durationMinutes': episode.durationMinutes,
                                      'hashtags': episode.hashtags,
                                    },
                                    coachName: episode.coachPersonality,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.of(context).pop(); // Close loading dialog
                              
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error creating episode: ${e.toString()}'),
                                  backgroundColor: Colors.red.shade600,
                                  action: SnackBarAction(
                                    label: 'Retry',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      // Could retry here
                                    },
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: WismeColors.wisdomPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Discover Topics'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Total Learning', '24 hours', Icons.schedule),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Topics Explored', '12 topics', Icons.explore),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Completion Rate', '85%', Icons.trending_up),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: WismeColors.primaryBlue,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: WismeColors.primaryBlue,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (index) {
        String feature = '';
        Widget? screen;
        
        switch (index) {
          case 0:
            // Already on home - no action needed
            return;
          case 1:
            feature = 'Explore';
            screen = const SearchScreen();
            break;
          case 2:
            feature = 'Library';
            screen = const LibraryScreen();
            break;
          case 3:
            feature = 'Analytics';
            screen = const LearningAnalyticsDashboard();
            break;
          case 4:
            feature = 'Profile';
            screen = const ProfileScreen();
            break;
        }
        
        if (screen != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => screen!),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$feature coming soon!')),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
