import 'package:flutter/material.dart';



import '../../core/core.dart';
import '../../shared/shared.dart';
import '../../models/models.dart';
import '../journey/learning_journey_screen.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            if (!_isSearching) ...[
              _buildFeelingCurious(),
              const SizedBox(height: 24),
              _buildTrendingTopics(),
              const SizedBox(height: 24),
              _buildCategories(),
              const SizedBox(height: 24),
              _buildRecommended(),
            ] else ...[
              _buildSearchResults(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'What would you like to learn?',
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
          });
        },
      ),
    );
  }

  Widget _buildTrendingTopics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trending Topics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildTrendingCard('AI & Machine Learning', 'Hot topic', WismeColors.primaryBlue),
              _buildTrendingCard('Cryptocurrency', 'Rising interest', WismeColors.wisdomPurple),
              _buildTrendingCard('Remote Work', 'Popular', WismeColors.kaiPrimary),
              _buildTrendingCard('Climate Change', 'Important', WismeColors.veePrimary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCard(String title, String subtitle, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: ModernCard(
        backgroundColor: color.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      ('💻', 'Technology & AI', '156 episodes'),
      ('💼', 'Business & Finance', '143 episodes'),
      ('🧠', 'Psychology & Mind', '98 episodes'),
      ('🔬', 'Science & Nature', '87 episodes'),
      ('🎨', 'Creativity & Design', '76 episodes'),
      ('📚', 'Personal Development', '134 episodes'),
      ('🌍', 'History & Culture', '65 episodes'),
      ('🛠️', 'Skills & Tools', '89 episodes'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ModernCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.$1,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.$2,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      category.$3,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecommended() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended for You',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildRecommendedItem(
          'Advanced JavaScript Patterns',
          'Based on your recent learning',
          'Kai',
          WismeColors.kaiPrimary,
        ),
        const SizedBox(height: 12),
        _buildRecommendedItem(
          'Product Design Thinking',
          'Popular in your interests',
          'Vee',
          WismeColors.veePrimary,
        ),
        const SizedBox(height: 12),
        _buildRecommendedItem(
          'Behavioral Psychology',
          'Trending topic',
          'Kai',
          WismeColors.kaiPrimary,
        ),
      ],
    );
  }

  Widget _buildRecommendedItem(String title, String reason, String coach, Color coachColor) {
    return ModernCard(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: coachColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            coach == 'Kai' ? Icons.self_improvement : Icons.bolt,
            color: coachColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text('$reason • with $coach'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Results for "${_searchController.text}"',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildSearchResultItem(
          'JavaScript ES6 Features',
          'Learn modern JavaScript syntax and features',
          'Kai',
          WismeColors.kaiPrimary,
        ),
        const SizedBox(height: 12),
        _buildSearchResultItem(
          'JavaScript for Beginners',
          'Start your programming journey',
          'Vee',
          WismeColors.veePrimary,
        ),
        const SizedBox(height: 12),
        _buildSearchResultItem(
          'Node.js Development',
          'Server-side JavaScript programming',
          'Kai',
          WismeColors.kaiPrimary,
        ),
      ],
    );
  }

  Widget _buildSearchResultItem(String title, String description, String coach, Color coachColor) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: coachColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'with $coach',
                  style: TextStyle(
                    color: coachColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.play_arrow,
                  color: coachColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Start Learning',
                  style: TextStyle(
                    color: coachColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeelingCurious() {
    // Curated list of curiosity-sparking content suggestions
    final curiousTopics = [
      {
        'title': 'Why do we dream?',
        'description': 'Explore the fascinating world of sleep science',
        'category': '🧠 Neuroscience',
        'difficulty': 'Beginner',
        'duration': '8 min',
        'gradient': [WismeColors.primaryBlue, WismeColors.wisdomPurple],
      },
      {
        'title': 'How Bitcoin actually works',
        'description': 'Demystify cryptocurrency in simple terms',
        'category': '💰 Technology',
        'difficulty': 'Intermediate',
        'duration': '12 min',
        'gradient': [WismeColors.kaiPrimary, WismeColors.primaryBlue],
      },
      {
        'title': 'The psychology of procrastination',
        'description': 'Understanding why we delay and how to overcome it',
        'category': '🧠 Psychology',
        'difficulty': 'Beginner',
        'duration': '10 min',
        'gradient': [WismeColors.veePrimary, WismeColors.kaiPrimary],
      },
      {
        'title': 'Why octopuses are aliens',
        'description': 'The incredible intelligence of cephalopods',
        'category': '🌊 Marine Biology',
        'difficulty': 'Beginner',
        'duration': '7 min',
        'gradient': [WismeColors.wisdomPurple, WismeColors.veePrimary],
      },
      {
        'title': 'The science of happiness',
        'description': 'What research tells us about joy and well-being',
        'category': '😊 Psychology',
        'difficulty': 'Beginner',
        'duration': '11 min',
        'gradient': [WismeColors.success, WismeColors.primaryBlue],
      },
      {
        'title': 'How music affects your brain',
        'description': 'The neuroscience behind melodies and emotions',
        'category': '🎵 Neuroscience',
        'difficulty': 'Intermediate',
        'duration': '9 min',
        'gradient': [WismeColors.primaryBlue, WismeColors.kaiPrimary],
      },
    ];

    // Get a random topic for curiosity
    final randomTopic = (curiousTopics..shuffle()).first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '🤔 Feeling Curious?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  // This will regenerate with a new random topic
                });
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Surprise me'),
              style: TextButton.styleFrom(
                foregroundColor: WismeColors.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: randomTopic['gradient'] as List<Color>,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (randomTopic['gradient'] as List<Color>)[0].withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Navigate to topic generation with this curious topic
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LearningJourneyScreen(
                      topic: randomTopic['title'] as String,
                      category: randomTopic['category'] as String,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            randomTopic['category'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.schedule,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                randomTopic['duration'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      randomTopic['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      randomTopic['description'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_arrow,
                                color: (randomTopic['gradient'] as List<Color>)[0],
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Start Learning',
                                style: TextStyle(
                                  color: (randomTopic['gradient'] as List<Color>)[0],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            randomTopic['difficulty'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
