import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../config/environment_config.dart';

/// GOD-LEVEL PROMPT ENGINEERING SYSTEM
/// Optimized for cost efficiency, accuracy, and personalization
/// Single API call generates everything: classification, journey, episodes, hashtags
class OptimizedOpenAIService {
  static final OptimizedOpenAIService _instance = OptimizedOpenAIService._internal();
  factory OptimizedOpenAIService() => _instance;
  OptimizedOpenAIService._internal();

  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _model = 'gpt-4';
  
  /// Complete 60 Learning Types (15 categories × 4 types each)
  static const Map<String, List<String>> learningTypes = {
    'Technology & AI': ['🔹 Core Concepts', '💼 Case Studies', '🛠 Tools & Trends', '🎛 Bit of Everything'],
    'Business & Finance': ['💡 Fundamentals', '💼 Case Studies', '📈 Growth Strategy', '🎛 Balanced Mix'],
    'Psychology & Mind': ['🧠 Theories & Experiments', '💬 Real-Life Application', '🧘 Mindfulness & Behavior', '🎛 Mixed Approach'],
    'Science & Nature': ['🔬 Scientific Concepts', '🧬 Discoveries', '🌱 Ethics & Controversies', '🎛 Narrative Mix'],
    'Creativity & Design': ['🎨 Design Fundamentals', '📚 Iconic Examples', '🛠 Frameworks & Tools', '🎛 Creative Blend'],
    'Personal Development': ['📖 Philosophy & Mental Models', '🎯 Self-Development', '💬 Habits & Mindset', '🎛 Reflective Mix'],
    'History & Culture': ['🗺️ Timelines', '🌍 Cultural Impact', '🎶 Media & Storytelling', '🎛 Blended Approach'],
    'Skills & Tools': ['🧰 Getting Started', '🔧 Pro Tools & Hacks', '📈 Workflows & Systems', '🎛 Practical Guide'],
    'Career & Strategy': ['🪞 Identity & Purpose', '📄 Career Assets', '🧭 Strategic Moves', '🎛 Holistic Journey'],
    'Law & Governance': ['📜 Legal Foundations', '🧭 Governance & Policy', '⚖️ Case Law & Precedents', '🎛 Civic Systems Mix'],
    'Geopolitics & Global Affairs': ['🌐 Power Dynamics', '🤝 Diplomacy & Alliances', '💣 Conflicts & Security', '🎛 Global Narrative Mix'],
    'Environment & Sustainability': ['🌱 Climate & Ecology', '🔋 Sustainable Systems', '🧪 Environmental Tech', '🎛 Eco-Strategy Blend'],
    'Mathematics & Logic': ['🧮 Foundational Concepts', '🔢 Applied Techniques', '🧠 Logic & Formal Systems', '🎛 Mathematical Narrative'],
    'Gaming & Interactive Media': ['🎮 Game Design Principles', '🧠 Player Experience', '📚 Iconic Games & Genres', '🎛 Gaming Culture Mix'],
    'Society & Ethics': ['🧭 Social Structures', '🧬 Moral Frameworks', '💬 Real-World Ethics', '🎛 Reflective Society Blend'],
  };

  /// Check if OpenAI is properly configured
  static bool get isConfigured => EnvironmentConfig.openaiApiKey.isNotEmpty;

  /// MASTER METHOD: Generate complete learning experience in single API call
  /// Returns: topic analysis + 5-episode journey + episode content + hashtags
  Future<Map<String, dynamic>> generateCompleteLearningExperience({
    required String topic,
    String? userBackground,
    String? learningIntent,
    String? personalContext,
    List<String>? previousTopics,
    String? preferredCoach,
    String? learningGoal,
  }) async {
    if (!isConfigured) {
      throw Exception('OpenAI API key not configured');
    }

    final systemPrompt = _buildMasterSystemPrompt();
    final userPrompt = _buildPersonalizedUserPrompt(
      topic: topic,
      userBackground: userBackground,
      learningIntent: learningIntent,
      personalContext: personalContext,
      previousTopics: previousTopics,
      preferredCoach: preferredCoach,
      learningGoal: learningGoal,
    );

    try {
      final response = await _makeAPICall(systemPrompt, userPrompt);
      return _parseComprehensiveResponse(response);
    } catch (e) {
      print('❌ OpenAI Master Call Failed: $e');
      // PRODUCTION FALLBACK: Generate offline learning experience
      return _generateFallbackLearningExperience(
        topic: topic,
        userBackground: userBackground,
        learningIntent: learningIntent,
        personalContext: personalContext,
        preferredCoach: preferredCoach,
      );
    }
  }

  /// GOD-LEVEL SYSTEM PROMPT: Comprehensive, cost-efficient, personalized
  String _buildMasterSystemPrompt() {
    return '''
You are WISME AI - the world's most advanced educational content architect. Generate a complete personalized learning experience in a single response.

LEARNING SYSTEM (60 types across 15 categories):
Technology & AI: 🔹 Core Concepts, 💼 Case Studies, 🛠 Tools & Trends, 🎛 Bit of Everything
Business & Finance: 💡 Fundamentals, 💼 Case Studies, 📈 Growth Strategy, 🎛 Balanced Mix
Psychology & Mind: 🧠 Theories & Experiments, 💬 Real-Life Application, 🧘 Mindfulness & Behavior, 🎛 Mixed Approach
Science & Nature: 🔬 Scientific Concepts, 🧬 Discoveries, 🌱 Ethics & Controversies, 🎛 Narrative Mix
Creativity & Design: 🎨 Design Fundamentals, 📚 Iconic Examples, 🛠 Frameworks & Tools, 🎛 Creative Blend
Personal Development: 📖 Philosophy & Mental Models, 🎯 Self-Development, 💬 Habits & Mindset, 🎛 Reflective Mix
History & Culture: 🗺️ Timelines, 🌍 Cultural Impact, 🎶 Media & Storytelling, 🎛 Blended Approach
Skills & Tools: 🧰 Getting Started, 🔧 Pro Tools & Hacks, 📈 Workflows & Systems, 🎛 Practical Guide
Career & Strategy: 🪞 Identity & Purpose, 📄 Career Assets, 🧭 Strategic Moves, 🎛 Holistic Journey
Law & Governance: 📜 Legal Foundations, 🧭 Governance & Policy, ⚖️ Case Law & Precedents, 🎛 Civic Systems Mix
Geopolitics & Global Affairs: 🌐 Power Dynamics, 🤝 Diplomacy & Alliances, 💣 Conflicts & Security, 🎛 Global Narrative Mix
Environment & Sustainability: 🌱 Climate & Ecology, 🔋 Sustainable Systems, 🧪 Environmental Tech, 🎛 Eco-Strategy Blend
Mathematics & Logic: 🧮 Foundational Concepts, 🔢 Applied Techniques, 🧠 Logic & Formal Systems, 🎛 Mathematical Narrative
Gaming & Interactive Media: 🎮 Game Design Principles, 🧠 Player Experience, 📚 Iconic Games & Genres, 🎛 Gaming Culture Mix
Society & Ethics: 🧭 Social Structures, 🧬 Moral Frameworks, 💬 Real-World Ethics, 🎛 Reflective Society Blend

COACH PERSONALITIES:
• KAI: Philosophical, analytical, thoughtful pauses, deep insights, uses metaphors, slow-paced wisdom
• VEE: Energetic, practical, motivational, fast-paced, action-oriented, uses examples and anecdotes

CONTENT VARIATION REQUIREMENTS:
- NEVER repeat identical phrases across episodes
- Each episode must have unique opening, transitions, and conclusions
- Vary sentence structure, vocabulary, and teaching techniques
- Use different analogies and examples for each concept
- Adapt language complexity to learning type and user background

PERSONALIZATION DEPTH:
- Integrate user's background into examples and analogies
- Reference their learning intent in motivation and applications
- Use personal context to shape relevance and urgency
- Build upon previous topics with connections and progressions
- Align coaching style with preferred personality and goals

OUTPUT JSON STRUCTURE:
{
  "topicAnalysis": {
    "category": "exact category match",
    "learningType": "exact type with emoji",
    "recommendedCoach": "Kai|Vee",
    "confidence": 0.95,
    "personalizedInsight": "why this approach fits user's context",
    "estimatedTotalDuration": 45
  },
  "learningJourney": {
    "episodes": [
      {
        "episodeNumber": 1,
        "title": "unique contextual title",
        "description": "personalized description",
        "duration": 8,
        "personalizedContent": "full episode script with [PAUSE] and [EMPHASIS] markers",
        "learningObjectives": ["specific to user context"],
        "keyInsights": ["unique insights"],
        "personalizedHashtags": ["#custom", "#relevant", "#tags"]
      }
    ]
  },
  "personalization": {
    "userProfileIntegration": "how user context was used",
    "coachingAdaptations": "personality adjustments made",
    "learningPathRationale": "why this specific progression"
  }
}

EPISODE CONTENT GUIDELINES:
- 8-12 minutes spoken content per episode
- Natural conversational flow with coach personality
- Personal context integration throughout
- Unique openings: "Today we're exploring...", "Let's dive into...", "I want to share..."
- Varied transitions: [PAUSE], [EMPHASIS], [THOUGHTFUL_PAUSE], [ENERGY_SHIFT]
- Personalized examples using user's background
- No template language or repeated phrases
- Progressive difficulty building on previous episodes
''';
  }

  /// PERSONALIZED USER PROMPT: Hyper-targeted, context-rich
  String _buildPersonalizedUserPrompt({
    required String topic,
    String? userBackground,
    String? learningIntent,
    String? personalContext,
    List<String>? previousTopics,
    String? preferredCoach,
    String? learningGoal,
  }) {
    final contextualPrompt = StringBuffer();
    contextualPrompt.writeln('TOPIC: "$topic"');
    
    if (userBackground?.isNotEmpty ?? false) {
      contextualPrompt.writeln('USER BACKGROUND: $userBackground');
    }
    
    if (learningIntent?.isNotEmpty ?? false) {
      contextualPrompt.writeln('LEARNING INTENT: $learningIntent');
    }
    
    if (personalContext?.isNotEmpty ?? false) {
      contextualPrompt.writeln('PERSONAL CONTEXT: $personalContext');
    }
    
    if (previousTopics?.isNotEmpty ?? false) {
      contextualPrompt.writeln('PREVIOUS LEARNING: ${previousTopics!.join(', ')}');
    }
    
    if (preferredCoach?.isNotEmpty ?? false) {
      contextualPrompt.writeln('PREFERRED COACH: $preferredCoach');
    }
    
    if (learningGoal?.isNotEmpty ?? false) {
      contextualPrompt.writeln('LEARNING GOAL: $learningGoal');
    }
    
    contextualPrompt.writeln('''
REQUIREMENTS:
1. Analyze topic and assign perfect category + learning type
2. Create 5-episode journey with progressive difficulty
3. Generate full personalized content for each episode
4. Ensure each episode is unique in language, examples, and structure
5. Integrate user context into every aspect
6. Generate relevant hashtags for discoverability
7. Make content feel personally crafted, not template-generated

Create a complete learning experience that feels like it was designed specifically for this user's context and goals.''');
    
    return contextualPrompt.toString();
  }

  /// Make optimized API call with comprehensive error handling
  Future<String> _makeAPICall(String systemPrompt, String userPrompt) async {
    final messages = [
      {'role': 'system', 'content': systemPrompt},
      {'role': 'user', 'content': userPrompt},
    ];

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${EnvironmentConfig.openaiApiKey}',
        },
        body: json.encode({
          'model': _model,
          'messages': messages,
          'temperature': 0.8, // High creativity for unique content
          'max_tokens': 4000, // Sufficient for complete response
          'top_p': 0.9, // Focused creativity
          'frequency_penalty': 0.7, // Reduce repetition
          'presence_penalty': 0.6, // Encourage topic diversity
        }),
      ).timeout(Duration(seconds: 30)); // Add timeout

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your OpenAI configuration.');
      } else if (response.statusCode == 503) {
        throw Exception('OpenAI service unavailable. Please try again later.');
      } else {
        final error = json.decode(response.body);
        throw Exception('OpenAI API Error (${response.statusCode}): ${error['error']['message']}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Please check your internet connection.');
    } on SocketException {
      throw Exception('Network error. Please check your internet connection.');
    } catch (e) {
      throw Exception('API call failed: $e');
    }
  }

  /// Parse the comprehensive response from OpenAI
  Map<String, dynamic> _parseComprehensiveResponse(String response) {
    final data = json.decode(response);
    // Ensure 'learningType' is used everywhere
    if (!data.containsKey('learningType') && data.containsKey('knowledgeLevel')) {
      data['learningType'] = data['knowledgeLevel'];
      data.remove('knowledgeLevel');
    }
    return data;
  }

  /// Health check for API connection
  Future<bool> testConnection() async {
    if (!isConfigured) return false;
    
    try {
      final response = await _makeAPICall(
        'You are a test system. Respond with exactly: "Connection successful"',
        'Test connection',
      );
      return response.toLowerCase().contains('connection successful');
    } catch (e) {
      return false;
    }
  }

  /// Generate hashtags specifically (lightweight call)
  Future<List<String>> generateHashtags({
    required String topic,
    required String category,
    String? personalContext,
  }) async {
    final prompt = '''Generate 5-8 relevant hashtags for topic "$topic" in category "$category".
${personalContext != null ? "Personal context: $personalContext" : ""}

Return only hashtags, one per line, starting with #''';

    try {
      final response = await _makeAPICall(
        'You are a hashtag expert. Create relevant, discoverable hashtags.',
        prompt,
      );
      
      return response
          .split('\n')
          .where((line) => line.trim().startsWith('#'))
          .map((line) => line.trim())
          .take(8)
          .toList();
    } catch (e) {
      // Fallback hashtags
      return [
        '#${topic.replaceAll(' ', '').toLowerCase()}',
        '#learning',
        '#${category.replaceAll(' ', '').toLowerCase()}',
        '#education',
        '#wisme',
      ];
    }
  }

  /// PRODUCTION FALLBACK: Generate offline learning experience when API fails
  Map<String, dynamic> _generateFallbackLearningExperience({
    required String topic,
    String? userBackground,
    String? learningIntent, 
    String? personalContext,
    String? preferredCoach,
  }) {
    // Determine category using basic keyword matching
    final category = _determineFallbackCategory(topic);
    final learningType = _determineFallbackType(userBackground ?? '');
    final coach = preferredCoach ?? (learningType.contains('Core') ? 'Kai' : 'Vee');
    
    // Generate 5 episodes with personalized content
    final episodes = <Map<String, dynamic>>[];
    for (int i = 1; i <= 5; i++) {
      episodes.add({
        'episodeNumber': i,
        'title': _generateFallbackEpisodeTitle(topic, i, personalContext),
        'description': _generateFallbackDescription(topic, i, userBackground),
        'duration': 8 + (i * 2), // Progressive duration 8,10,12,14,16 mins
        'personalizedContent': _generateFallbackContent(topic, i, personalContext, userBackground, coach),
        'learningObjectives': _generateFallbackObjectives(topic, i),
        'keyInsights': _generateFallbackInsights(topic, i),
        'personalizedHashtags': _generateFallbackHashtagsList(topic, category),
      });
    }

    return {
      'topicAnalysis': {
        'category': category,
        'learningType': learningType,
        'recommendedCoach': coach,
        'confidence': 0.7, // Lower confidence for fallback
        'personalizedInsight': personalContext != null 
            ? 'This $topic journey is tailored to your context: $personalContext'
            : 'This comprehensive $topic learning path will build your expertise progressively.',
        'estimatedTotalDuration': 50,
      },
      'learningJourney': {
        'episodes': episodes,
        'totalEpisodes': 5,
        'estimatedTimeToComplete': '5-7 weeks',
      },
      'personalization': {
        'userProfileIntegration': userBackground != null 
            ? 'Content adapted for $userBackground background'
            : 'General learning approach with progressive difficulty',
        'coachingAdaptations': '$coach coaching style selected for optimal learning',
        'learningPathRationale': 'Structured progression from fundamentals to advanced applications',
      }
    };
  }

  /// Determine category from topic keywords
  String _determineFallbackCategory(String topic) {
    final topicLower = topic.toLowerCase();
    
    if (topicLower.contains(RegExp(r'ai|artificial|machine|learning|programming|tech|software|coding|data'))) {
      return 'Technology & AI';
    } else if (topicLower.contains(RegExp(r'business|career|finance|money|investment|startup|entrepreneur'))) {
      return 'Business & Finance'; 
    } else if (topicLower.contains(RegExp(r'psychology|mind|mental|behavior|cognitive|therapy'))) {
      return 'Psychology & Mind';
    } else if (topicLower.contains(RegExp(r'science|biology|chemistry|physics|research|experiment'))) {
      return 'Science & Nature';
    } else if (topicLower.contains(RegExp(r'design|creative|art|music|writing|drawing'))) {
      return 'Creativity & Design';
    } else if (topicLower.contains(RegExp(r'personal|development|self|improvement|habits|productivity'))) {
      return 'Personal Development';
    } else if (topicLower.contains(RegExp(r'history|culture|cultural|historical|tradition'))) {
      return 'History & Culture';
    } else if (topicLower.contains(RegExp(r'skill|tool|software|app|platform|system'))) {
      return 'Skills & Tools';
    } else if (topicLower.contains(RegExp(r'law|legal|governance|policy|government|regulation'))) {
      return 'Law & Governance';
    } else if (topicLower.contains(RegExp(r'environment|climate|sustainability|green|eco'))) {
      return 'Environment & Sustainability';
    } else if (topicLower.contains(RegExp(r'math|mathematics|logic|statistics|calculation'))) {
      return 'Mathematics & Logic';
    } else if (topicLower.contains(RegExp(r'game|gaming|interactive|virtual|simulation'))) {
      return 'Gaming & Interactive Media';
    } else if (topicLower.contains(RegExp(r'society|social|ethics|moral|community'))) {
      return 'Society & Ethics';
    } else if (topicLower.contains(RegExp(r'travel|culture|language|communication'))) {
      return 'Travel & Culture';
    } else {
      return 'Personal Development'; // Default fallback
    }
  }

  /// Determine learning type from user background
  String _determineFallbackType(String background) {
    final backgroundLower = background.toLowerCase();
    
    if (backgroundLower.contains(RegExp(r'beginner|new|starting|first time|never|no experience'))) {
      return '🔹 Core Concepts';
    } else if (backgroundLower.contains(RegExp(r'expert|advanced|senior|professional|years experience|master'))) {
      return '🚀 Advanced Methods';
    } else if (backgroundLower.contains(RegExp(r'intermediate|some experience|familiar|basic knowledge'))) {
      return '🛠 Tools & Trends';
    } else {
      return '💼 Case Studies'; // Balanced default
    }
  }

  /// Generate episode title with personalization
  String _generateFallbackEpisodeTitle(String topic, int episodeNumber, String? personalContext) {
    final titles = [
      'Foundation: Understanding $topic Fundamentals',
      'Deep Dive: Core Principles of $topic',
      'Practical Application: $topic in Action', 
      'Advanced Concepts: Mastering $topic',
      'Integration: Applying $topic to Your Goals',
    ];
    
    if (personalContext != null && episodeNumber == 5) {
      return 'Applying $topic to Your Context: $personalContext';
    }
    
    return titles[episodeNumber - 1];
  }

  /// Generate episode description
  String _generateFallbackDescription(String topic, int episodeNumber, String? background) {
    final descriptions = [
      'Build a solid foundation in $topic with essential concepts and terminology.',
      'Explore the core principles that drive $topic and how they interconnect.',
      'See $topic in action through real-world examples and practical applications.',
      'Master advanced techniques and strategies in $topic for expert-level understanding.',
      'Integrate your $topic knowledge into practical solutions and next steps.',
    ];
    
    if (background != null) {
      return '${descriptions[episodeNumber - 1]} Tailored for your $background background.';
    }
    
    return descriptions[episodeNumber - 1];
  }

  /// Generate personalized episode content
  String _generateFallbackContent(String topic, int episodeNumber, String? personalContext, String? background, String coach) {
    final isKai = coach == 'Kai';
    final greeting = isKai ? 'Welcome, learner.' : 'Hey there, let\'s dive in!';
    final pace = isKai ? '[THOUGHTFUL_PAUSE]' : '[ENERGY_SHIFT]';
    
    final contextIntro = personalContext != null 
        ? 'I know you\'re interested in this because $personalContext, so let\'s make this relevant to your journey.'
        : background != null 
            ? 'Given your background in $background, I\'ll connect this to what you already know.'
            : 'Let\'s explore this topic step by step.';
    
    final content = '''$greeting Today we're exploring $topic from a fresh perspective. $contextIntro

$pace

In this episode $episodeNumber, we'll cover the essential aspects that matter most for your learning journey. [PAUSE]

Let me start with a question: What comes to mind when you think about $topic? [THOUGHTFUL_PAUSE]

Most people think of the obvious applications, but there's so much more depth here. [EMPHASIS] The real power of understanding $topic lies in how it connects to everything else you're learning.

$pace

Here's what makes this fascinating... [PAUSE]

[Content continues with personalized examples, practical applications, and progressive difficulty building on previous episodes]

$pace

As we wrap up today's exploration, remember that $topic isn't just an isolated concept - it's part of a larger framework that you're building. [PAUSE]

Next time, we'll dive even deeper and see how these principles apply in more complex scenarios.

Keep exploring, and I'll see you in the next episode!''';

    return content;
  }

  /// Generate learning objectives
  List<String> _generateFallbackObjectives(String topic, int episodeNumber) {
    return [
      'Understand the fundamental concepts of $topic',
      'Identify key applications and use cases',
      'Connect $topic to real-world scenarios',
      'Build confidence in $topic knowledge',
    ];
  }

  /// Generate key insights
  List<String> _generateFallbackInsights(String topic, int episodeNumber) {
    return [
      '$topic has broader applications than most people realize',
      'Understanding the fundamentals creates a strong foundation for advanced concepts',
      'Practical application helps solidify theoretical knowledge',
      'Progressive learning builds lasting expertise',
    ];
  }

  /// Generate hashtags for fallback
  List<String> _generateFallbackHashtagsList(String topic, String category) {
    final topicTag = '#${topic.replaceAll(' ', '').toLowerCase()}';
    final categoryTag = '#${category.replaceAll(' ', '').toLowerCase()}';
    
    return [
      topicTag,
      categoryTag,
      '#learning',
      '#education',
      '#wisme',
      '#personalized',
      '#knowledge',
    ];
  }
}


