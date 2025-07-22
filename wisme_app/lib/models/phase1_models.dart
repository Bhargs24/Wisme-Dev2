/// Phase 1 Models for WISME App
/// Implements the correct Phase 1 approach with learning types and flexible episode counts

/// Learning Types (not difficulty levels) - Different approaches to learning a topic
class LearningType {
  final String id;
  final String name;
  final String description;
  final String approach; // 'fundamental', 'practical', 'comprehensive', 'balanced'

  const LearningType({
    required this.id,
    required this.name,
    required this.description,
    required this.approach,
  });

  factory LearningType.fromJson(Map<String, dynamic> json) {
    return LearningType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      approach: json['approach'] ?? 'balanced',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'approach': approach,
    };
  }
}

/// Episode Count Preference - User chooses how many episodes they want
class EpisodeCountPreference {
  final String id;
  final String name;
  final String description;
  final int minEpisodes;
  final int maxEpisodes;
  final String preferenceType; // 'few', 'moderate', 'many', 'comprehensive'

  const EpisodeCountPreference({
    required this.id,
    required this.name,
    required this.description,
    required this.minEpisodes,
    required this.maxEpisodes,
    required this.preferenceType,
  });

  factory EpisodeCountPreference.fromJson(Map<String, dynamic> json) {
    return EpisodeCountPreference(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      minEpisodes: json['minEpisodes'] ?? 3,
      maxEpisodes: json['maxEpisodes'] ?? 5,
      preferenceType: json['preferenceType'] ?? 'moderate',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'minEpisodes': minEpisodes,
      'maxEpisodes': maxEpisodes,
      'preferenceType': preferenceType,
    };
  }

  /// Get a random episode count within the range
  int getRandomEpisodeCount() {
    return minEpisodes + (DateTime.now().millisecond % (maxEpisodes - minEpisodes + 1));
  }
}

/// Complete Learning Types (15 categories × 4 types each)
class Phase1LearningTypes {
  static const Map<String, List<LearningType>> categoryTypes = {
    'Technology & AI': [
      LearningType(
        id: 'tech_core_concepts',
        name: '🔹 Core Concepts',
        description: 'Learn fundamental principles and basic understanding',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'tech_case_studies',
        name: '💼 Case Studies',
        description: 'Explore real-world applications and practical examples',
        approach: 'practical',
      ),
      LearningType(
        id: 'tech_tools_trends',
        name: '🛠 Tools & Trends',
        description: 'Discover current tools, technologies, and emerging trends',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'tech_mixed_approach',
        name: '🎛 Mixed Approach',
        description: 'Balanced overview with theory, practice, and trends',
        approach: 'balanced',
      ),
    ],
    'Business & Finance': [
      LearningType(
        id: 'business_fundamentals',
        name: '💡 Fundamentals',
        description: 'Master basic business concepts and financial literacy',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'business_case_studies',
        name: '💼 Case Studies',
        description: 'Analyze business success stories and failure lessons',
        approach: 'practical',
      ),
      LearningType(
        id: 'business_growth_strategy',
        name: '📈 Growth Strategy',
        description: 'Learn scaling strategies and advanced business tactics',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'business_balanced_mix',
        name: '🎛 Balanced Mix',
        description: 'Comprehensive business education approach',
        approach: 'balanced',
      ),
    ],
    'Psychology & Mind': [
      LearningType(
        id: 'psych_theories_experiments',
        name: '🧠 Theories & Experiments',
        description: 'Explore psychological theories and research findings',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'psych_real_life_application',
        name: '💬 Real-Life Application',
        description: 'Apply psychology to daily life situations',
        approach: 'practical',
      ),
      LearningType(
        id: 'psych_mindfulness_behavior',
        name: '🧘 Mindfulness & Behavior',
        description: 'Practice mindfulness and behavioral change techniques',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'psych_mixed_approach',
        name: '🎛 Mixed Approach',
        description: 'Comprehensive psychological learning experience',
        approach: 'balanced',
      ),
    ],
    'Science & Nature': [
      LearningType(
        id: 'science_scientific_concepts',
        name: '🔬 Scientific Concepts',
        description: 'Understand core scientific principles and discoveries',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'science_discoveries',
        name: '🧬 Discoveries',
        description: 'Explore breakthrough discoveries and innovations',
        approach: 'practical',
      ),
      LearningType(
        id: 'science_ethics_controversies',
        name: '🌱 Ethics & Controversies',
        description: 'Examine scientific ethics and controversial topics',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'science_narrative_mix',
        name: '🎛 Narrative Mix',
        description: 'Story-driven scientific exploration',
        approach: 'balanced',
      ),
    ],
    'Creativity & Design': [
      LearningType(
        id: 'creative_design_fundamentals',
        name: '🎨 Design Fundamentals',
        description: 'Learn basic design principles and creative thinking',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'creative_iconic_examples',
        name: '📚 Iconic Examples',
        description: 'Study famous designs and creative masterpieces',
        approach: 'practical',
      ),
      LearningType(
        id: 'creative_frameworks_tools',
        name: '🛠 Frameworks & Tools',
        description: 'Master design frameworks and creative methodologies',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'creative_creative_blend',
        name: '🎛 Creative Blend',
        description: 'Mixed creative approaches and techniques',
        approach: 'balanced',
      ),
    ],
    'Personal Development': [
      LearningType(
        id: 'personal_philosophy_mental_models',
        name: '📖 Philosophy & Mental Models',
        description: 'Explore philosophical frameworks and thinking models',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'personal_self_development',
        name: '🎯 Self-Development',
        description: 'Develop personal growth strategies and techniques',
        approach: 'practical',
      ),
      LearningType(
        id: 'personal_habits_mindset',
        name: '💬 Habits & Mindset',
        description: 'Build habits and transform your mindset',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'personal_reflective_mix',
        name: '🎛 Reflective Mix',
        description: 'Comprehensive personal development approach',
        approach: 'balanced',
      ),
    ],
    'History & Culture': [
      LearningType(
        id: 'history_timelines',
        name: '🗺️ Timelines',
        description: 'Explore historical timelines and major events',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'history_cultural_impact',
        name: '🌍 Cultural Impact',
        description: 'Understand cultural influences and societal changes',
        approach: 'practical',
      ),
      LearningType(
        id: 'history_media_storytelling',
        name: '🎶 Media & Storytelling',
        description: 'Discover historical narratives and media evolution',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'history_blended_approach',
        name: '🎛 Blended Approach',
        description: 'Comprehensive historical exploration',
        approach: 'balanced',
      ),
    ],
    'Skills & Tools': [
      LearningType(
        id: 'skills_getting_started',
        name: '🧰 Getting Started',
        description: 'Learn basic skills and essential tools',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'skills_pro_tools_hacks',
        name: '🔧 Pro Tools & Hacks',
        description: 'Master advanced tools and productivity hacks',
        approach: 'practical',
      ),
      LearningType(
        id: 'skills_workflows_systems',
        name: '📈 Workflows & Systems',
        description: 'Build systematic approaches and workflows',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'skills_practical_guide',
        name: '🎛 Practical Guide',
        description: 'Comprehensive practical skills approach',
        approach: 'balanced',
      ),
    ],
    'Career & Strategy': [
      LearningType(
        id: 'career_identity_purpose',
        name: '🪞 Identity & Purpose',
        description: 'Discover your career identity and purpose',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'career_career_assets',
        name: '📄 Career Assets',
        description: 'Build career assets and valuable skills',
        approach: 'practical',
      ),
      LearningType(
        id: 'career_strategic_moves',
        name: '🧭 Strategic Moves',
        description: 'Plan strategic career moves and growth',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'career_holistic_journey',
        name: '🎛 Holistic Journey',
        description: 'Comprehensive career development approach',
        approach: 'balanced',
      ),
    ],
    'Law & Governance': [
      LearningType(
        id: 'law_legal_foundations',
        name: '📜 Legal Foundations',
        description: 'Understand basic legal concepts and principles',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'law_case_law',
        name: '⚖️ Case Law',
        description: 'Study important legal cases and precedents',
        approach: 'practical',
      ),
      LearningType(
        id: 'law_legal_systems',
        name: '🏛️ Legal Systems',
        description: 'Explore legal systems and governance structures',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'law_comprehensive_approach',
        name: '🎛 Comprehensive Approach',
        description: 'Comprehensive legal education approach',
        approach: 'balanced',
      ),
    ],
    'Geopolitics & Global Affairs': [
      LearningType(
        id: 'geo_power_dynamics',
        name: '🌐 Power Dynamics',
        description: 'Understand global power structures and dynamics',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'geo_international_relations',
        name: '🤝 International Relations',
        description: 'Explore international relations and diplomacy',
        approach: 'practical',
      ),
      LearningType(
        id: 'geo_global_systems',
        name: '🌍 Global Systems',
        description: 'Analyze global systems and institutions',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'geo_comprehensive_view',
        name: '🎛 Comprehensive View',
        description: 'Comprehensive geopolitical approach',
        approach: 'balanced',
      ),
    ],
    'Environment & Sustainability': [
      LearningType(
        id: 'env_climate_ecology',
        name: '🌱 Climate & Ecology',
        description: 'Learn about climate science and ecological systems',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'env_sustainable_systems',
        name: '🔋 Sustainable Systems',
        description: 'Explore sustainable systems and solutions',
        approach: 'practical',
      ),
      LearningType(
        id: 'env_environmental_policy',
        name: '📋 Environmental Policy',
        description: 'Understand environmental policies and regulations',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'env_comprehensive_approach',
        name: '🎛 Comprehensive Approach',
        description: 'Comprehensive environmental approach',
        approach: 'balanced',
      ),
    ],
    'Mathematics & Logic': [
      LearningType(
        id: 'math_foundational_concepts',
        name: '🧮 Foundational Concepts',
        description: 'Master basic mathematical concepts and logic',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'math_applied_techniques',
        name: '🔢 Applied Techniques',
        description: 'Learn applied mathematical techniques',
        approach: 'practical',
      ),
      LearningType(
        id: 'math_advanced_theories',
        name: '📐 Advanced Theories',
        description: 'Explore advanced mathematical theories',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'math_comprehensive_approach',
        name: '🎛 Comprehensive Approach',
        description: 'Comprehensive mathematical approach',
        approach: 'balanced',
      ),
    ],
    'Gaming & Interactive Media': [
      LearningType(
        id: 'gaming_game_design_principles',
        name: '🎮 Game Design Principles',
        description: 'Learn core game design principles and concepts',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'gaming_player_experience',
        name: '🧠 Player Experience',
        description: 'Design engaging player experiences',
        approach: 'practical',
      ),
      LearningType(
        id: 'gaming_industry_trends',
        name: '📈 Industry Trends',
        description: 'Explore gaming industry trends and innovations',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'gaming_comprehensive_approach',
        name: '🎛 Comprehensive Approach',
        description: 'Comprehensive gaming industry approach',
        approach: 'balanced',
      ),
    ],
    'Society & Ethics': [
      LearningType(
        id: 'society_social_structures',
        name: '🧭 Social Structures',
        description: 'Understand social structures and institutions',
        approach: 'fundamental',
      ),
      LearningType(
        id: 'society_moral_frameworks',
        name: '🧬 Moral Frameworks',
        description: 'Explore ethical frameworks and moral philosophy',
        approach: 'practical',
      ),
      LearningType(
        id: 'society_social_issues',
        name: '🌍 Social Issues',
        description: 'Examine contemporary social issues and debates',
        approach: 'comprehensive',
      ),
      LearningType(
        id: 'society_comprehensive_approach',
        name: '🎛 Comprehensive Approach',
        description: 'Comprehensive social and ethical approach',
        approach: 'balanced',
      ),
    ],
  };

  /// Episode Count Preferences - User chooses how many episodes they want
  static const List<EpisodeCountPreference> episodeCountPreferences = [
    EpisodeCountPreference(
      id: 'few_episodes',
      name: 'Few Episodes',
      description: '3-5 episodes (longer, deeper content)',
      minEpisodes: 3,
      maxEpisodes: 5,
      preferenceType: 'few',
    ),
    EpisodeCountPreference(
      id: 'moderate_episodes',
      name: 'Moderate Episodes',
      description: '5-8 episodes (balanced length and depth)',
      minEpisodes: 5,
      maxEpisodes: 8,
      preferenceType: 'moderate',
    ),
    EpisodeCountPreference(
      id: 'many_episodes',
      name: 'Many Episodes',
      description: '8-12 episodes (shorter, focused content)',
      minEpisodes: 8,
      maxEpisodes: 12,
      preferenceType: 'many',
    ),
    EpisodeCountPreference(
      id: 'comprehensive_series',
      name: 'Comprehensive Series',
      description: '12-15 episodes (extensive coverage)',
      minEpisodes: 12,
      maxEpisodes: 15,
      preferenceType: 'comprehensive',
    ),
  ];

  /// Get all available categories
  static List<String> get availableCategories => categoryTypes.keys.toList();

  /// Get learning types for a specific category
  static List<LearningType> getLearningTypesForCategory(String category) {
    return categoryTypes[category] ?? [];
  }

  /// Get a specific learning type by ID
  static LearningType? getLearningTypeById(String id) {
    for (final types in categoryTypes.values) {
      for (final type in types) {
        if (type.id == id) return type;
      }
    }
    return null;
  }

  /// Calculate episode duration based on episode count and total estimated content
  static int calculateEpisodeDuration(int episodeCount, String approach) {
    // Base total content time (in minutes) varies by approach
    int baseTotalMinutes;
    switch (approach) {
      case 'fundamental':
        baseTotalMinutes = 45; // Shorter for fundamentals
        break;
      case 'practical':
        baseTotalMinutes = 60; // Medium for practical
        break;
      case 'comprehensive':
        baseTotalMinutes = 90; // Longer for comprehensive
        break;
      case 'balanced':
        baseTotalMinutes = 75; // Medium-long for balanced
        break;
      default:
        baseTotalMinutes = 60;
    }

    // Calculate episode duration based on count
    int episodeDuration = (baseTotalMinutes / episodeCount).round();
    
    // Ensure reasonable bounds (5-25 minutes per episode)
    episodeDuration = episodeDuration.clamp(5, 25);
    
    return episodeDuration;
  }
}

/// Phase 1 Voice Mapping System (unchanged)
class Phase1VoiceMapping {
  /// Core 6 ElevenLabs Voice IDs for Phase 1
  static const Map<String, String> voicePool = {
    'kai': 'pNInz6obpgDQGcFmaJgB',      // Adam - Versatile, thoughtful male voice
    'alex': '21m00Tcm4TlvDq8ikWAM',     // Rachel - Authoritative, clear male expert
    'maya': 'AZnzlk1XvdvUeBnXmlld',     // Domi - Energetic, engaging female host
    'david': 'EXAVITQu4vr4xnSDxMaL',    // Bella - Strategic, professional male expert
    'sara': 'ErXwobaYiN019PkySvjV',     // Antoni - Thoughtful, warm female expert
    'zoe': 'MF3mGyEYCl7XYWbV9V6O',      // Elli - Creative, dynamic female host
  };

  /// Category to Voice Pair Mapping (Phase 1 - Predetermined)
  static const Map<String, VoicePair> categoryVoiceMapping = {
    'Technology & AI': VoicePair(host: 'kai', expert: 'alex'),
    'Business & Finance': VoicePair(host: 'maya', expert: 'david'),
    'Psychology & Mind': VoicePair(host: 'kai', expert: 'sara'),
    'Science & Nature': VoicePair(host: 'maya', expert: 'alex'),
    'Creativity & Design': VoicePair(host: 'zoe', expert: 'sara'),
    'Personal Development': VoicePair(host: 'kai', expert: 'david'),
    'History & Culture': VoicePair(host: 'zoe', expert: 'alex'),
    'Skills & Tools': VoicePair(host: 'maya', expert: 'david'),
    'Career & Strategy': VoicePair(host: 'maya', expert: 'david'),
    'Law & Governance': VoicePair(host: 'kai', expert: 'david'),
    'Geopolitics & Global Affairs': VoicePair(host: 'zoe', expert: 'alex'),
    'Environment & Sustainability': VoicePair(host: 'maya', expert: 'alex'),
    'Mathematics & Logic': VoicePair(host: 'kai', expert: 'alex'),
    'Gaming & Interactive Media': VoicePair(host: 'zoe', expert: 'sara'),
    'Society & Ethics': VoicePair(host: 'kai', expert: 'sara'),
  };

  /// Get voice pair for a category
  static VoicePair getVoicePairForCategory(String category) {
    return categoryVoiceMapping[category] ?? VoicePair(host: 'kai', expert: 'alex');
  }

  /// Get voice ID for a speaker
  static String getVoiceIdForSpeaker(String speakerId) {
    return voicePool[speakerId] ?? voicePool['kai']!;
  }
}

/// Voice Pair for Two-Speaker Conversations
class VoicePair {
  final String host;
  final String expert;

  const VoicePair({
    required this.host,
    required this.expert,
  });

  /// Get host voice ID
  String get hostVoiceId => Phase1VoiceMapping.getVoiceIdForSpeaker(host);

  /// Get expert voice ID
  String get expertVoiceId => Phase1VoiceMapping.getVoiceIdForSpeaker(expert);
} 
