import '../../core/exports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _topicController = TextEditingController();
  bool _isGenerating = false;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _generateLesson() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) {
      _showMessage('Please enter a topic to learn about');
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final lessonProvider = context.read<LessonProvider>();
      
      // Generate a lesson content block for the topic
      final contentBlock = await lessonProvider.generateContentBlock(
        topic: topic,
        category: 'General',
        difficulty: 'beginner',
      );
      
      if (mounted && contentBlock != null) {
        // Navigate to dashboard to see the generated lesson
        _showMessage('Lesson generated successfully!');
        _topicController.clear();
        Navigator.pushNamed(context, AppRoutes.dashboard);
      } else if (mounted) {
        _showMessage('Failed to generate lesson. Please try again.');
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Failed to generate lesson: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: const [
          Color(0xFF667EEA),
          Color(0xFF764BA2),
        ],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to Wisme',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Learn anything in 15 minutes',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.dashboard, color: Colors.white),
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.dashboard),
                        ),
                        IconButton(
                          icon: const Icon(Icons.person, color: Colors.white),
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 60),
                
                // Main Content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main Question
                      const Text(
                        'What do you want to\nlearn today?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Topic Input
                      ModernCard(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            AppTextField(
                              controller: _topicController,
                              hintText: 'Type any topic... (e.g., "Machine Learning", "Ancient Rome", "How to negotiate")',
                              prefixIcon: const Icon(Icons.search),
                              maxLines: 3,
                              enabled: !_isGenerating,
                              onSubmitted: (_) => _generateLesson(),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            AppButton(
                              text: 'Generate My Lesson',
                              onPressed: _isGenerating ? null : _generateLesson,
                              isLoading: _isGenerating,
                              icon: Icons.auto_awesome,
                              isFullWidth: true,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Quick Examples
                      const Text(
                        'Popular topics:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildTopicChip('Artificial Intelligence'),
                          _buildTopicChip('Stock Market Basics'),
                          _buildTopicChip('Psychology of Habits'),
                          _buildTopicChip('History of Bitcoin'),
                          _buildTopicChip('Public Speaking'),
                          _buildTopicChip('Climate Change'),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Bottom Info
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.headphones, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your lesson will be a personalized 10-15 minute audio experience',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return GestureDetector(
      onTap: () {
        _topicController.text = topic;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Text(
          topic,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
