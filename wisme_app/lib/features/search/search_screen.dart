import 'package:flutter/material.dart';



import '../../core/core.dart';
import '../../shared/shared.dart';
import '../../models/models.dart';
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
}
