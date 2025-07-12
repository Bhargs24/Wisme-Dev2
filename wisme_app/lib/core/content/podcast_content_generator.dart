import 'package:http/http.dart' as http;
import 'dart:convert';
import '../ai/advanced_topic_classifier.dart';
import '../config/api_config.dart';

/// Podcast-Style Content Generation Engine
/// Creates engaging, personality-driven audio learning content
class PodcastContentGenerator {

  /// Generate episode script with personalization
  Future<String> generateEpisodeScript(
    String topic,
    String episodeTitle,
    String episodeContent,
    String coachPersonality,
    String knowledgeLevel, {
    String? personalContext,
    String? openAiApiKey,
  }) async {
    final apiKey = openAiApiKey ?? ApiConfig.openAiApiKey;
    
    if (!ApiConfig.isOpenAiConfigured && openAiApiKey == null) {
      throw Exception('OpenAI API key not configured. Please set up ApiConfig or provide openAiApiKey parameter.');
    }

    try {
      return await _generatePersonalizedPodcastScript(
        topic,
        episodeTitle,
        episodeContent,
        coachPersonality,
        knowledgeLevel,
        apiKey,
        personalContext: personalContext,
      );
    } catch (e) {
      return _generateFallbackScript(topic, episodeTitle, coachPersonality, personalContext);
    }
  }

  /// Optimized AI-powered podcast script generation with personalization
  Future<String> _generatePersonalizedPodcastScript(
    String topic,
    String episodeTitle,
    String episodeContent,
    String coachPersonality,
    String knowledgeLevel,
    String apiKey, {
    String? personalContext,
  }) async {
    final personalityPrompt = coachPersonality == 'Kai' 
        ? 'Kai: analytical, methodical. Uses logical frameworks, research data, step-by-step analysis.'
        : 'Vee: energetic, creative. Uses storytelling, analogies, real-world examples, inspiring action.';

    // Optimized prompt for cost efficiency
    final systemPrompt = '''$personalityPrompt

Create 3-5min podcast script. Include [PAUSE] for rhythm, [EMPHASIS] for key points.
${personalContext != null ? 'PERSONALIZE for: $personalContext' : ''}
Natural conversational tone, educational + engaging.''';

    final userPrompt = '''Topic: $topic
Episode: $episodeTitle
Level: $knowledgeLevel
Content: $episodeContent

${personalContext != null ? 'Personal situation: $personalContext' : ''}

Generate engaging podcast script as Coach $coachPersonality.''';

    final response = await http.post(
      Uri.parse(ApiConfig.openAiBaseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': ApiConfig.gptModel,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userPrompt},
        ],
        'max_tokens': 800, // Reduced for cost efficiency
        'temperature': 0.8,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
    }

    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'] as String;
  }

  /// Fallback script with personalization when API is unavailable
  String _generateFallbackScript(String topic, String episodeTitle, String coachPersonality, String? personalContext) {
    final greeting = coachPersonality == 'Kai' 
        ? "Welcome back to your learning journey. I'm Kai, and today we're going to systematically explore"
        : "Hey there, amazing learner! Vee here, and I'm absolutely excited to dive into";

    final personalNote = personalContext != null 
        ? "\n\n[PAUSE]\n\nI know you mentioned that $personalContext - so I'll make sure to connect today's insights directly to your specific situation."
        : "";

    return '''
$greeting $topic.

[PAUSE]

In this episode, "$episodeTitle," we're going to break this down into clear, actionable insights that you can immediately understand and apply.$personalNote

[PAUSE]

$topic is more fascinating than most people realize. Let me walk you through the key concepts step by step.

[PAUSE]

First, let's establish the foundation. [EMPHASIS] The core principle here is understanding how these concepts connect to real-world applications. [EMPHASIS]

[PAUSE]

As we progress through this topic, you'll start to see patterns emerging. These patterns are crucial because they help you transfer this knowledge to new situations.

[PAUSE]

Now, here's where it gets really interesting. The practical applications of $topic extend far beyond what you might initially think.

${personalContext != null ? '''
[PAUSE]

Given your specific situation with $personalContext, you can apply these insights by focusing on the aspects that directly relate to your goals.

[PAUSE]
''' : ''}

To wrap up, remember that learning is a journey. Today's episode on $episodeTitle gives you the building blocks to continue exploring this fascinating subject.

[PAUSE]

Thanks for learning with me today. Keep questioning, keep exploring, and I'll see you in the next episode!
''';
  }

  /// Category-Specific Content Prompts
  static String _getCategorySpecificPrompt(
    String category, 
    String level, 
    String topic,
    String coach,
  ) {
    final coachStyle = _getCoachStyle(coach);
    
    switch (category) {
      case 'Technology & AI':
        return _getTechPrompt(level, topic, coachStyle);
      case 'Business & Finance':
        return _getBusinessPrompt(level, topic, coachStyle);
      case 'Psychology & Mind':
        return _getPsychologyPrompt(level, topic, coachStyle);
      case 'Science & Nature':
        return _getSciencePrompt(level, topic, coachStyle);
      case 'Creativity & Design':
        return _getDesignPrompt(level, topic, coachStyle);
      case 'Personal Development':
        return _getPersonalDevPrompt(level, topic, coachStyle);
      case 'History & Culture':
        return _getHistoryPrompt(level, topic, coachStyle);
      case 'Skills & Tools':
        return _getSkillsPrompt(level, topic, coachStyle);
      case 'Career & Strategy':
        return _getCareerPrompt(level, topic, coachStyle);
      case 'Law & Governance':
        return _getLawPrompt(level, topic, coachStyle);
      case 'Geopolitics & Global Affairs':
        return _getGeopoliticsPrompt(level, topic, coachStyle);
      case 'Environment & Sustainability':
        return _getEnvironmentPrompt(level, topic, coachStyle);
      case 'Mathematics & Logic':
        return _getMathPrompt(level, topic, coachStyle);
      case 'Gaming & Interactive Media':
        return _getGamingPrompt(level, topic, coachStyle);
      case 'Society & Ethics':
        return _getSocietyPrompt(level, topic, coachStyle);
      default:
        return _getGeneralPrompt(level, topic, coachStyle);
    }
  }

  /// Technology & AI Prompts
  static String _getTechPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🔹 Core Concepts':
        return '''
You're ${style.introduction} creating a podcast episode about $topic for someone new to technology.

Make complex tech concepts accessible by:
- Using everyday analogies (compare AI to familiar things)
- Explaining "why this matters" for regular people
- Avoiding jargon, or explaining it simply
- Including brief history/context
- Showing real-world impact

Structure: Definition → Why it matters → How it works (simple) → Real examples → Future implications

${style.toneInstructions}
${style.speechPatterns}

Make it feel like a smart friend explaining something fascinating over coffee.
''';

      case '💼 Case Studies':
        return '''
Tell the fascinating story of $topic as a compelling case study.

Focus on:
- The human drama behind the technology
- Key decisions and turning points  
- What went right/wrong and why
- Lessons for other companies/individuals
- Surprising details most people don't know

Make it feel like a documentary narrative with insights.

${style.toneInstructions}
${style.speechPatterns}

Structure like a thriller: Setup → Challenge → Breakthrough → Results → Lessons
''';

      case '🛠 Tools & Trends':
        return '''
Create an exciting "Tech Radar" episode about $topic - what's hot, what's coming, what matters.

Cover:
- What's happening now that's interesting
- New tools/platforms people should know about
- How this trend affects different industries
- Practical ways listeners can engage
- What to watch for in the next 6-12 months

${style.toneInstructions}
${style.speechPatterns}

Keep it current, practical, and forward-looking.
''';

      default:
        return _getGeneralTechPrompt(topic, style);
    }
  }

  /// Business & Finance Prompts
  static String _getBusinessPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '💡 Fundamentals':
        return '''
Explain $topic as core business knowledge everyone should understand.

Approach:
- Start with why this concept exists
- Use relatable business examples
- Explain the underlying logic
- Show how it applies to different business sizes
- Connect to personal finance when relevant

${style.toneInstructions}
${style.speechPatterns}

Make dry business concepts fascinating and relevant.
''';

      case '💼 Case Studies':
        return '''
Tell the business story of $topic with all the drama and strategy.

Elements:
- The business challenge or opportunity
- Key players and their decisions
- Strategic thinking and execution
- Results and consequences
- Lessons for other businesses

${style.toneInstructions}
${style.speechPatterns}

Make it feel like a business thriller with insights.
''';

      case '📈 Growth Strategy':
        return '''
Create a strategic deep-dive into $topic focusing on growth and scaling.

Cover:
- Strategic frameworks and thinking
- Growth tactics and execution
- Scaling challenges and solutions
- Metrics and measurement
- Future growth opportunities

${style.toneInstructions}
${style.speechPatterns}

Focus on actionable strategy insights.
''';

      default:
        return _getGeneralBusinessPrompt(topic, style);
    }
  }

  /// Psychology & Mind Prompts
  static String _getPsychologyPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🧠 Theories & Experiments':
        return '''
Present $topic as fascinating psychological research with immediate relevance.

Scientific Storytelling:
- How this psychological insight was discovered
- Key studies explained in an engaging way
- How this actually works in our minds
- Where you see this in everyday life
- How to use this knowledge personally

${style.toneInstructions}
${style.speechPatterns}

Make psychology research feel like uncovering secrets of human nature.
''';

      case '💬 Real-Life Application':
        return '''
Transform $topic into practical psychology people can immediately use.

Practical Structure:
- The psychological principle explained simply
- Where this shows up in normal life
- Specific ways to apply this knowledge
- Common mistakes or misapplications
- Ways to develop this psychological skill
- What changes when you master this

${style.toneInstructions}
${style.speechPatterns}

Make applied psychology feel like gaining superpowers.
''';

      default:
        return _getGeneralPsychologyPrompt(topic, style);
    }
  }

  /// Science & Nature Prompts
  static String _getSciencePrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🔬 Scientific Concepts':
        return '''
Explain $topic as mind-blowing science that reveals how amazing our world is.

Wonder-Driven Approach:
- What mystery does this science solve?
- How scientists figured this out
- The mechanism explained with perfect analogies
- How this affects everything around us
- The most amazing aspects
- Latest research and future implications

${style.toneInstructions}
${style.speechPatterns}

Make scientific concepts feel like discovering hidden magic in reality.
''';

      default:
        return _getGeneralSciencePrompt(topic, style);
    }
  }

  /// Design & Creativity Prompts
  static String _getDesignPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🎨 Design Fundamentals':
        return '''
Teach $topic as essential creative knowledge that enhances how people see the world.

Visual Thinking Approach:
- How this design principle changes perception
- Core concept explained with visual examples
- Iconic designs that use this principle
- How to apply this in everyday work/life
- What happens when this principle is ignored
- Advanced techniques and creative possibilities

${style.toneInstructions}
${style.speechPatterns}

Make design principles feel like learning to see beauty and function everywhere.
''';

      default:
        return _getGeneralDesignPrompt(topic, style);
    }
  }

  /// Personal Development Prompts
  static String _getPersonalDevPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '📖 Philosophy & Mental Models':
        return '''
You're ${style.introduction} creating a philosophical exploration of $topic.

Focus on timeless wisdom and thinking frameworks:
- Core philosophical principles and mental models
- Ancient wisdom meets modern insights
- Practical philosophy for daily life
- How great thinkers approached similar challenges

${style.toneInstructions}
${style.speechPatterns}

Make it contemplative yet practical.''';

      case '🎯 Self-Development':
        return '''
You're ${style.introduction} guiding practical self-improvement in $topic.

Create actionable personal growth content:
- Clear, achievable development strategies
- Scientific backing for growth techniques
- Personal transformation stories and examples
- Immediate steps listeners can take today

${style.toneInstructions}
${style.speechPatterns}

Focus on sustainable change.''';

      case '💬 Habits & Mindset':
        return '''
You're ${style.introduction} exploring the psychology of $topic.

Dive deep into behavioral change:
- Habit formation and breaking cycles
- Mindset shifts and limiting beliefs
- Cognitive biases and mental traps
- Sustainable behavior change techniques

${style.toneInstructions}
${style.speechPatterns}

Make psychology accessible.''';

      case '🎛 Reflective Mix':
        return '''
You're ${style.introduction} creating a thoughtful blend of philosophy, practical development, and mindset work around $topic.

${style.toneInstructions}
${style.speechPatterns}

Weave together wisdom and action.''';

      default:
        return _getGeneralPrompt(level, topic, style);
    }
  }

  /// History & Culture Prompts
  static String _getHistoryPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🗺️ Timelines':
        return '''
You're ${style.introduction} taking listeners on a chronological journey through $topic.

Create compelling historical narrative:
- Clear timeline with key dates and events
- Cause-and-effect relationships across time
- How past events shape our present
- Multiple perspectives on historical events

${style.toneInstructions}
${style.speechPatterns}

Make history come alive.''';

      case '🌍 Cultural Impact':
        return '''
You're ${style.introduction} exploring how $topic shaped and was shaped by culture.

Focus on cultural dynamics:
- Social movements and cultural shifts
- Cross-cultural perspectives and differences
- How ideas spread across societies
- Cultural evolution and adaptation

${style.toneInstructions}
${style.speechPatterns}

Show cultural connections.''';

      case '🎶 Media & Storytelling':
        return '''
You're ${style.introduction} examining $topic through the lens of art, literature, and media.

Explore cultural expression:
- How art and media reflected the topic
- Storytelling traditions and narratives
- Creative works that defined eras
- The power of cultural storytelling

${style.toneInstructions}
${style.speechPatterns}

Tell the cultural story.''';

      case '🎛 Blended Approach':
        return '''
You're ${style.introduction} weaving together timeline, culture, and storytelling elements of $topic.

${style.toneInstructions}
${style.speechPatterns}

Create rich historical tapestry.''';

      default:
        return _getGeneralPrompt(level, topic, style);
    }
  }

  /// Skills & Tools Prompts
  static String _getSkillsPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🧰 Getting Started':
        return '''
You're ${style.introduction} helping complete beginners start their journey with $topic.

Focus on first steps and foundations:
- Essential tools and basic equipment
- Fundamental techniques and principles
- Common beginner mistakes to avoid
- Building confidence and early wins

${style.toneInstructions}
${style.speechPatterns}

Make it beginner-friendly.''';

      case '🔧 Pro Tools & Hacks':
        return '''
You're ${style.introduction} sharing advanced tools and professional secrets for $topic.

Dive into expert-level content:
- Professional-grade tools and software
- Advanced techniques and shortcuts
- Industry insider tips and hacks
- Efficiency optimizations and workflows

${style.toneInstructions}
${style.speechPatterns}

Share professional insights.''';

      case '📈 Workflows & Systems':
        return '''
You're ${style.introduction} teaching systematic approaches to mastering $topic.

Focus on process and methodology:
- Structured learning and practice systems
- Workflow optimization and automation
- Quality control and improvement processes
- Scaling and advanced applications

${style.toneInstructions}
${style.speechPatterns}

Build systematic mastery.''';

      case '🎛 Practical Guide':
        return '''
You're ${style.introduction} creating a comprehensive practical guide to $topic.

${style.toneInstructions}
${style.speechPatterns}

Balance theory with hands-on application.''';

      default:
        return _getGeneralPrompt(level, topic, style);
    }
  }

  /// Career & Strategy Prompts
  static String _getCareerPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🪞 Identity & Purpose':
        return '''
You're ${style.introduction} helping listeners discover their authentic career path in $topic.

Focus on self-discovery and alignment:
- Values clarification and purpose finding
- Strengths assessment and development
- Career identity and personal brand
- Authentic professional development

${style.toneInstructions}
${style.speechPatterns}

Guide authentic career development.''';

      case '📄 Career Assets':
        return '''
You're ${style.introduction} building tangible career assets around $topic.

Create practical career tools:
- Resume and portfolio optimization
- Network building and relationship management
- Skill certification and credentials
- Professional visibility and reputation

${style.toneInstructions}
${style.speechPatterns}

Build career capital.''';

      case '🧭 Strategic Moves':
        return '''
You're ${style.introduction} planning strategic career advancement in $topic.

Focus on strategic thinking:
- Industry analysis and trend forecasting
- Strategic positioning and differentiation
- Career pivots and transition planning
- Leadership development and influence

${style.toneInstructions}
${style.speechPatterns}

Think strategically about careers.''';

      case '🎛 Holistic Journey':
        return '''
You're ${style.introduction} creating a comprehensive career development approach to $topic.

${style.toneInstructions}
${style.speechPatterns}

Integrate identity, assets, and strategy.''';

      default:
        return _getGeneralPrompt(level, topic, style);
    }
  }

  /// Law & Governance Prompts
  static String _getLawPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '📜 Legal Foundations':
        return '''
You're ${style.introduction} explaining the fundamental legal principles of $topic.

Focus on core legal concepts:
- Constitutional and statutory foundations
- Key legal principles and doctrines
- Rights, responsibilities, and obligations
- Legal reasoning and interpretation

${style.toneInstructions}
${style.speechPatterns}

Make law accessible to everyone.''';

      case '🧭 Governance & Policy':
        return '''
You're ${style.introduction} exploring how $topic relates to governance and policy-making.

Examine institutional dynamics:
- Policy development and implementation
- Regulatory frameworks and oversight
- Democratic processes and participation
- Public administration and bureaucracy

${style.toneInstructions}
${style.speechPatterns}

Show how governance works in practice.''';

      case '⚖️ Case Law & Precedents':
        return '''
You're ${style.introduction} analyzing landmark cases and legal precedents in $topic.

Dive into case analysis:
- Landmark cases and their impact
- Legal precedents and their evolution
- Judicial reasoning and decision-making
- Real-world legal applications

${style.toneInstructions}
${style.speechPatterns}

Bring legal cases to life.''';

      case '🎛 Civic Systems Mix':
        return '''
You're ${style.introduction} creating a comprehensive understanding of how $topic functions in our civic system.

${style.toneInstructions}
${style.speechPatterns}

Integrate law, governance, and real cases.''';

      default:
        return _getGeneralPrompt(level, topic, style);
    }
  }

  /// Geopolitics & Global Affairs Prompts  
  static String _getGeopoliticsPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🌐 Power Dynamics':
        return '''
You're ${style.introduction} analyzing global power structures and dynamics around $topic.

Focus on power analysis:
- Nation-state power and influence
- Economic leverage and dependencies
- Military capabilities and alliances
- Soft power and cultural influence

${style.toneInstructions}
${style.speechPatterns}

Decode global power games.''';

      case '🤝 Diplomacy & Alliances':
        return '''
You're ${style.introduction} exploring diplomatic relations and international cooperation regarding $topic.

Examine diplomatic mechanisms:
- Bilateral and multilateral relations
- International organizations and treaties
- Diplomatic negotiations and agreements
- Alliance structures and partnerships

${style.toneInstructions}
${style.speechPatterns}

Show diplomacy in action.''';

      case '💣 Conflicts & Security':
        return '''
You're ${style.introduction} analyzing conflicts and security challenges related to $topic.

Focus on security dynamics:
- Conflict origins and escalation
- Security threats and responses
- Military strategy and tactics
- Peace-building and conflict resolution

${style.toneInstructions}
${style.speechPatterns}

Understand security challenges.''';

      case '🎛 Global Narrative Mix':
        return '''
You're ${style.introduction} weaving together power, diplomacy, and security aspects of $topic.

${style.toneInstructions}
${style.speechPatterns}

Create comprehensive global understanding.''';

      default:
        return _getGeneralPrompt(level, topic, style);
    }
  }

  /// Environment & Sustainability Prompts
  static String _getEnvironmentPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🌱 Climate & Ecology':
        return '''
You're ${style.introduction} exploring the environmental science and ecology behind $topic.

Focus on natural systems:
- Ecosystem dynamics and interactions
- Climate science and environmental impact
- Biodiversity and conservation
- Natural resource management

${style.toneInstructions}
${style.speechPatterns}

Connect science to environmental action.''';

      case '🔋 Sustainable Systems':
        return '''
You're ${style.introduction} examining sustainable solutions and systems for $topic.

Explore sustainability approaches:
- Renewable energy and clean technology
- Circular economy and waste reduction
- Sustainable agriculture and food systems
- Green infrastructure and urban planning

${style.toneInstructions}
${style.speechPatterns}

Show practical sustainability.''';

      case '🧪 Environmental Tech':
        return '''
You're ${style.introduction} diving into cutting-edge environmental technology for $topic.

Focus on innovation:
- Clean technology and green innovation
- Environmental monitoring and data
- Biotechnology and environmental solutions
- Carbon capture and climate technology

${style.toneInstructions}
${style.speechPatterns}

Highlight technological solutions.''';

      case '🎛 Eco-Strategy Blend':
        return '''
You're ${style.introduction} creating a comprehensive environmental approach to $topic.

${style.toneInstructions}
${style.speechPatterns}

Integrate science, systems, and technology.''';

      default:
        return _getGeneralPrompt(level, topic, style);
    }
  }

  /// Mathematics & Logic Prompts
  static String _getMathPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🧮 Foundational Concepts':
        return '''
You're ${style.introduction} building strong mathematical foundations for $topic.

Focus on core concepts:
- Fundamental mathematical principles
- Number theory and basic operations
- Logical reasoning and proof techniques
- Mathematical notation and language

${style.toneInstructions}
${style.speechPatterns}

Make math intuitive and accessible.''';

      case '🔢 Applied Techniques':
        return '''
You're ${style.introduction} showing practical mathematical applications of $topic.

Explore real-world math:
- Problem-solving techniques and strategies
- Mathematical modeling and analysis
- Statistical methods and data interpretation
- Computational approaches and algorithms

${style.toneInstructions}
${style.speechPatterns}

Show math in action.''';

      case '🧠 Logic & Formal Systems':
        return '''
You're ${style.introduction} exploring logical reasoning and formal mathematical systems in $topic.

Dive into logical structures:
- Formal logic and proof systems
- Set theory and mathematical structures
- Abstract algebra and category theory
- Mathematical philosophy and foundations

${style.toneInstructions}
${style.speechPatterns}

Explore mathematical beauty.''';

      case '🎛 Mathematical Narrative':
        return '''
You're ${style.introduction} weaving together foundations, applications, and formal systems of $topic.

${style.toneInstructions}
${style.speechPatterns}

Tell the complete mathematical story.''';

      default:
        return _getGeneralPrompt(level, topic, style);
    }
  }

  /// Gaming & Interactive Media Prompts
  static String _getGamingPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🎮 Game Design Principles':
        return '''
You're ${style.introduction} exploring the fundamental design principles behind $topic.

Focus on design foundations:
- Core gameplay mechanics and systems
- User experience and interface design
- Narrative design and storytelling
- Balance, progression, and difficulty curves

${style.toneInstructions}
${style.speechPatterns}

Decode what makes games work.''';

      case '🧠 Player Experience':
        return '''
You're ${style.introduction} analyzing player psychology and experience design in $topic.

Examine player engagement:
- Player motivation and behavioral psychology
- Flow states and engagement mechanics
- Social dynamics and community building
- Accessibility and inclusive design

${style.toneInstructions}
${style.speechPatterns}

Understand player psychology.''';

      case '📚 Iconic Games & Genres':
        return '''
You're ${style.introduction} exploring landmark games and genre evolution in $topic.

Study gaming history:
- Influential games and their innovations
- Genre evolution and hybrid forms
- Cultural impact and industry trends
- Design patterns and successful formulas

${style.toneInstructions}
${style.speechPatterns}

Celebrate gaming heritage.''';

      case '🎛 Gaming Culture Mix':
        return '''
You're ${style.introduction} creating a comprehensive exploration of $topic in gaming culture.

${style.toneInstructions}
${style.speechPatterns}

Blend design, psychology, and culture.''';

      default:
        return _getGeneralPrompt(level, topic, style);
    }
  }

  /// Society & Ethics Prompts
  static String _getSocietyPrompt(String level, String topic, CoachStyle style) {
    switch (level) {
      case '🧭 Social Structures':
        return '''
You're ${style.introduction} examining the social institutions and structures around $topic.

Analyze social systems:
- Social institutions and their functions
- Power structures and social hierarchies
- Community organization and networks
- Social change and transformation

${style.toneInstructions}
${style.speechPatterns}

Understand how society works.''';

      case '🧬 Moral Frameworks':
        return '''
You're ${style.introduction} exploring ethical theories and moral reasoning about $topic.

Dive into ethical analysis:
- Major ethical frameworks and theories
- Moral reasoning and decision-making
- Rights, duties, and consequences
- Cultural and contextual ethics

${style.toneInstructions}
${style.speechPatterns}

Navigate ethical complexity.''';

      case '💬 Real-World Ethics':
        return '''
You're ${style.introduction} applying ethical principles to real-world situations involving $topic.

Focus on practical ethics:
- Case studies and ethical dilemmas
- Professional and applied ethics
- Moral conflicts and resolutions
- Ethical leadership and responsibility

${style.toneInstructions}
${style.speechPatterns}

Apply ethics to real situations.''';

      case '🎛 Reflective Society Blend':
        return '''
You're ${style.introduction} creating a thoughtful exploration of social structures, moral frameworks, and real-world ethics around $topic.

${style.toneInstructions}
${style.speechPatterns}

Integrate society and ethics.''';

      default:
        return _getGeneralPrompt(level, topic, style);
    }
  }

  /// Coach Personality Styles
  static CoachStyle _getCoachStyle(String coach) {
    switch (coach) {
      case 'Kai':
        return CoachStyle(
          introduction: 'the thoughtful, wise mentor',
          toneInstructions: '''
Tone: Calm, thoughtful, philosophical
Pace: Measured, reflective
Energy: Steady, grounding
Personality: Wise mentor who helps you think deeply
''',
          speechPatterns: '''
Use these Kai speech patterns:
- Openings: "Let's explore...", "Consider this...", "Here's something fascinating..."
- Transitions: "Now, think about this...", "This connects to...", "Here's why this matters..."
- Emphasis: "This is key:", "Remember:", "The crucial point is:"
- Closings: "Take a moment to reflect...", "Until next time...", "Let this settle in..."
''',
        );

      case 'Vee':
        return CoachStyle(
          introduction: 'the energetic, enthusiastic friend',
          toneInstructions: '''
Tone: Energetic, enthusiastic, engaging
Pace: Dynamic, varied, exciting
Energy: High, motivating, inspiring
Personality: Enthusiastic friend who makes everything exciting
''',
          speechPatterns: '''
Use these Vee speech patterns:
- Openings: "Hey there!", "Ready for this?", "This is going to blow your mind!"
- Transitions: "But wait, there's more!", "Check this out!", "And here's the cool part!"
- Emphasis: "This is huge!", "Pay attention!", "You won't believe this!"
- Closings: "You've got this!", "Can't wait for next time!", "Go make it happen!"
''',
        );

      default:
        return _getDefaultCoachStyle();
    }
  }

  /// Episode Section Generators
  static Future<String> _generateIntro(
    String topic, 
    SubtopicResult subtopic, 
    String coach,
    int episodeNumber,
  ) async {
    final style = _getCoachStyle(coach);
    
    final prompt = '''
Create an engaging 30-45 second podcast-style intro for episode $episodeNumber about "${subtopic.title}".

${style.toneInstructions}

Include:
1. Attention-grabbing hook (surprising fact, question, or scenario)
2. Brief preview of what's coming without spoilers
3. Personal greeting from $coach
4. Set expectation for what listener will gain

Make it feel like the start of a compelling podcast episode.

${style.speechPatterns}

Return only the intro script, ready for voice synthesis.
''';

    return await _callOpenAI(prompt);
  }

  static Future<String> _generateCoreContent(
    String contentPrompt,
    String topic,
    SubtopicResult subtopic,
  ) async {
    final fullPrompt = '''
$contentPrompt

Specific topic: $topic
Episode focus: ${subtopic.title}
Key concepts to cover: ${subtopic.keyConcepts.join(', ')}

Create 8-12 minutes of core content following the structure and style guidelines above.

Return only the main content script, ready for voice synthesis.
''';

    return await _callOpenAI(fullPrompt);
  }

  static Future<String> _generateTLDRSummary(String coreContent, String coach) async {
    final style = _getCoachStyle(coach);
    
    final prompt = '''
Create a concise, memorable 60-90 second TL;DR summary based on this content:

$coreContent

Include:
1. 3 key takeaways in bullet points
2. One memorable quote or principle
3. Why this matters in real life

${style.toneInstructions}
${style.speechPatterns}

Make it quotable and shareable. Keep it under 90 seconds when spoken aloud.

Return only the TL;DR script, ready for voice synthesis.
''';

    return await _callOpenAI(prompt);
  }

  static Future<String> _generateDailyAction(
    String topic,
    SubtopicResult subtopic,
    String coach,
  ) async {
    final style = _getCoachStyle(coach);
    
    final prompt = '''
Create a specific, actionable 30-45 second daily challenge related to "${subtopic.title}".

Requirements:
1. Takes 5-15 minutes to complete
2. Directly applies the episode content
3. Produces tangible results
4. Easy to start today

Format:
- Clear action step
- Brief implementation tip
- Motivational close from $coach

${style.toneInstructions}
${style.speechPatterns}

Make it feel achievable and exciting.

Return only the daily action script, ready for voice synthesis.
''';

    return await _callOpenAI(prompt);
  }

  /// Helper Methods
  static Future<String> _callOpenAI(String prompt) async {
    if (!ApiConfig.isOpenAiConfigured) {
      throw Exception('OpenAI API not configured. Please set up API keys.');
    }

    final response = await http.post(
      Uri.parse('${ApiConfig.openAiBaseUrl}/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConfig.openAiApiKey}',
      },
      body: jsonEncode({
        'model': ApiConfig.gptModel,
        'messages': [
          {
            'role': 'system',
            'content': 'You are an expert educational content creator for the Wisme learning platform.'
          },
          {
            'role': 'user',
            'content': prompt
          }
        ],
        'max_tokens': 2000,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
    }
  }

  static String _generateMockContent(String prompt) {
    if (prompt.contains('intro')) {
      return '''
Hey there! Ready to dive into something absolutely fascinating? 

Today we're exploring the incredible world of artificial intelligence, and I promise you - this is going to change how you think about technology forever. 

I'm Vee, and I'm genuinely excited to take this journey with you. By the end of our time together, you'll understand not just what AI is, but why it's reshaping everything around us.

Let's jump in!
''';
    } else if (prompt.contains('TL;DR')) {
      return '''
Alright, let's wrap this up with the key takeaways:

• First: AI isn't magic - it's pattern recognition at an incredible scale
• Second: It's already in your daily life more than you realize  
• Third: The real power comes from human-AI collaboration, not replacement

Here's the quote to remember: "AI doesn't replace human creativity - it amplifies it."

Why does this matter? Because understanding AI today is like understanding the internet in 1995. You're getting ahead of the curve.

Keep exploring, keep learning, and keep that curiosity alive!
''';
    } else if (prompt.contains('daily challenge')) {
      return '''
Here's your daily action challenge:

Spend 10 minutes today identifying three AI tools you already use without thinking about it. Your phone's keyboard predictions, Netflix recommendations, even your email spam filter.

Implementation tip: Open your phone's settings and look for features with words like "smart," "auto," or "suggested."

You've got this! Once you start noticing AI everywhere, you'll never see technology the same way again. 

Go make it happen!
''';
    } else {
      return '''
Artificial intelligence might seem like science fiction, but it's actually all around us right now. Let me tell you why this matters and how it works.

Think of AI like a incredibly pattern-obsessed friend. You know that person who notices everything - what you wear, how you talk, your habits? AI is like that, but for millions of data points at once.

The fascinating part is how simple the core concept really is. AI looks at tons of examples, finds patterns, and then makes predictions based on those patterns. It's like how you learned to recognize faces as a baby - seeing thousands of faces until you could instantly tell Mom from Dad.

But here's where it gets really interesting. Modern AI doesn't just recognize patterns - it creates new things based on what it's learned. It's like having that pattern-obsessed friend become incredibly creative too.

The real magic happens when humans and AI work together. AI handles the heavy lifting of processing information, while humans provide creativity, judgment, and ethical guidance.

This is just the beginning of how AI is transforming everything from how we work to how we create to how we solve humanity's biggest challenges.
''';
    }
  }

  static int _calculateDuration(String intro, String core, String tldr, String action) {
    // Rough calculation: 150 words per minute average speaking pace
    final totalWords = _countWords(intro) + _countWords(core) + _countWords(tldr) + _countWords(action);
    return (totalWords / 150 * 60).round(); // Convert to seconds
  }

  static int _countWords(String text) {
    return text.split(RegExp(r'\s+')).length;
  }

  // Fallback prompt generators
  static String _getGeneralPrompt(String level, String topic, CoachStyle style) {
    return '''
Create engaging educational content about $topic at $level level.

${style.toneInstructions}
${style.speechPatterns}

Make it informative, engaging, and practical.
''';
  }

  static String _getGeneralTechPrompt(String topic, CoachStyle style) => _getGeneralPrompt('intermediate', topic, style);
  static String _getGeneralBusinessPrompt(String topic, CoachStyle style) => _getGeneralPrompt('intermediate', topic, style);
  static String _getGeneralPsychologyPrompt(String topic, CoachStyle style) => _getGeneralPrompt('intermediate', topic, style);
  static String _getGeneralSciencePrompt(String topic, CoachStyle style) => _getGeneralPrompt('intermediate', topic, style);
  static String _getGeneralDesignPrompt(String topic, CoachStyle style) => _getGeneralPrompt('intermediate', topic, style);

  static CoachStyle _getDefaultCoachStyle() {
    return CoachStyle(
      introduction: 'the friendly educator',
      toneInstructions: 'Tone: Friendly, clear, engaging',
      speechPatterns: 'Use clear, conversational language',
    );
  }
}

/// Data Models
class EpisodeContent {
  final String title;
  final String intro;
  final String coreContent;
  final String tldrSummary;
  final String dailyAction;
  final int totalDuration; // in seconds
  final String coachPersonality;
  final int episodeNumber;
  final int totalEpisodes;

  EpisodeContent({
    required this.title,
    required this.intro,
    required this.coreContent,
    required this.tldrSummary,
    required this.dailyAction,
    required this.totalDuration,
    required this.coachPersonality,
    required this.episodeNumber,
    required this.totalEpisodes,
  });

  String get fullScript => '''
$intro

$coreContent

$tldrSummary

$dailyAction
''';

  String get formattedDuration {
    final minutes = totalDuration ~/ 60;
    final seconds = totalDuration % 60;
    return '${minutes}m ${seconds}s';
  }
}

class CoachStyle {
  final String introduction;
  final String toneInstructions;
  final String speechPatterns;

  CoachStyle({
    required this.introduction,
    required this.toneInstructions,
    required this.speechPatterns,
  });
}
