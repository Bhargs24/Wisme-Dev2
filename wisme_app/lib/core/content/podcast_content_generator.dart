import '../services/optimized_openai_service.dart';

/// Podcast-Style Content Generation Engine - Real OpenAI Integration
/// Creates engaging, personality-driven audio learning content using OpenAIService
class PodcastContentGenerator {

  /// Generate episode script with real OpenAI integration
  Future<String> generateEpisodeScript(
    String topic,
    String episodeTitle,
    String episodeContent,
    String coachPersonality,
    String knowledgeLevel, {
    String? personalContext,
    String? openAiApiKey,
  }) async {
    try {
      // Use OptimizedOpenAIService for real content generation
      final openAIService = OptimizedOpenAIService();
      final learningExperience = await openAIService.generateCompleteLearningExperience(
        topic: topic,
        userBackground: 'Learning about: $episodeTitle',
        learningIntent: 'Generate episode content',
        personalContext: personalContext,
        preferredCoach: coachPersonality,
        learningGoal: 'Complete understanding of $topic at $knowledgeLevel level',
      );

      // Extract the first episode's personalized content as the script
      if (learningExperience.containsKey('learningJourney') && 
          learningExperience['learningJourney'] != null &&
          learningExperience['learningJourney']['episodes'] != null &&
          (learningExperience['learningJourney']['episodes'] as List).isNotEmpty) {
        
        final firstEpisode = (learningExperience['learningJourney']['episodes'] as List)[0];
        if (firstEpisode['personalizedContent'] != null) {
          return firstEpisode['personalizedContent'] as String;
        }
      }
      
      // If no personalized content found, use fallback
      return _generateFallbackScript(topic, episodeTitle, coachPersonality, personalContext);
      
    } catch (e) {
      print('⚠️ OpenAI episode generation failed, using fallback: $e');
      return _generateFallbackScript(topic, episodeTitle, coachPersonality, personalContext);
    }
  }

  /// Generate complete episode content with intro, core content, summary, and action
  Future<EpisodeContent> generateCompleteEpisode({
    required String topic,
    required String episodeTitle,
    required String knowledgeLevel,
    required String coachPersonality,
    String? personalContext,
    int episodeNumber = 1,
    int totalEpisodes = 5,
  }) async {
    try {
      // Use OptimizedOpenAIService for complete learning experience
      final openAIService = OptimizedOpenAIService();
      final learningExperience = await openAIService.generateCompleteLearningExperience(
        topic: topic,
        userBackground: 'Learning about: $episodeTitle',
        learningIntent: 'Generate comprehensive episode content',
        personalContext: personalContext,
        preferredCoach: coachPersonality,
        learningGoal: 'Complete understanding of $topic at $knowledgeLevel level',
      );

      // Extract episode data from learning experience
      if (learningExperience.containsKey('learningJourney') && 
          learningExperience['learningJourney'] != null &&
          learningExperience['learningJourney']['episodes'] != null &&
          (learningExperience['learningJourney']['episodes'] as List).isNotEmpty) {
        
        final episodes = learningExperience['learningJourney']['episodes'] as List;
        final targetEpisode = episodes.length >= episodeNumber ? episodes[episodeNumber - 1] : episodes[0];
        
        final personalizedContent = targetEpisode['personalizedContent'] as String? ?? '';
        final duration = targetEpisode['duration'] as int? ?? _estimateDuration(knowledgeLevel);
        
        // Split the content into sections or generate them individually
        final sections = _parseContentSections(personalizedContent);
        
        return EpisodeContent(
          title: episodeTitle,
          intro: sections['intro'] ?? _generateFallbackIntro(episodeTitle, coachPersonality),
          coreContent: sections['coreContent'] ?? _generateFallbackCore(topic, episodeTitle, coachPersonality, personalContext),
          tldrSummary: sections['tldr'] ?? _generateFallbackSummary(topic, coachPersonality),
          dailyAction: sections['action'] ?? _generateFallbackAction(topic, coachPersonality),
          totalDuration: duration * 60, // Convert minutes to seconds
          coachPersonality: coachPersonality,
          episodeNumber: episodeNumber,
          totalEpisodes: totalEpisodes,
        );
      }
      
      // Fallback to generating sections individually
      return _generateFallbackEpisode(
        topic: topic,
        episodeTitle: episodeTitle,
        coachPersonality: coachPersonality,
        personalContext: personalContext,
        episodeNumber: episodeNumber,
        totalEpisodes: totalEpisodes,
        knowledgeLevel: knowledgeLevel,
      );
      
    } catch (e) {
      print('⚠️ Complete episode generation failed, using fallback: $e');
      return _generateFallbackEpisode(
        topic: topic,
        episodeTitle: episodeTitle,
        coachPersonality: coachPersonality,
        personalContext: personalContext,
        episodeNumber: episodeNumber,
        totalEpisodes: totalEpisodes,
        knowledgeLevel: knowledgeLevel,
      );
    }
  }

  /// Parse content sections from personalized content
  Map<String, String> _parseContentSections(String personalizedContent) {
    final sections = <String, String>{};
    
    // Simple parsing - you could make this more sophisticated
    final lines = personalizedContent.split('\n');
    String currentSection = 'coreContent';
    final contentBuffer = StringBuffer();
    
    for (final line in lines) {
      final lowerLine = line.toLowerCase().trim();
      
      if (lowerLine.contains('introduction') || lowerLine.contains('hello') || lowerLine.contains('welcome')) {
        if (contentBuffer.isNotEmpty && currentSection == 'intro') {
          sections[currentSection] = contentBuffer.toString().trim();
          contentBuffer.clear();
        }
        currentSection = 'intro';
      } else if (lowerLine.contains('summary') || lowerLine.contains('tl;dr') || lowerLine.contains('recap')) {
        if (contentBuffer.isNotEmpty) {
          sections[currentSection] = contentBuffer.toString().trim();
          contentBuffer.clear();
        }
        currentSection = 'tldr';
      } else if (lowerLine.contains('action') || lowerLine.contains('challenge') || lowerLine.contains('practice')) {
        if (contentBuffer.isNotEmpty) {
          sections[currentSection] = contentBuffer.toString().trim();
          contentBuffer.clear();
        }
        currentSection = 'action';
      } else {
        contentBuffer.writeln(line);
      }
    }
    
    // Add the final section
    if (contentBuffer.isNotEmpty) {
      sections[currentSection] = contentBuffer.toString().trim();
    }
    
    return sections;
  }

  /// Generate fallback episode when OpenAI fails
  EpisodeContent _generateFallbackEpisode({
    required String topic,
    required String episodeTitle,
    required String coachPersonality,
    String? personalContext,
    required int episodeNumber,
    required int totalEpisodes,
    required String knowledgeLevel,
  }) {
    final intro = _generateFallbackIntro(episodeTitle, coachPersonality);
    final core = _generateFallbackCore(topic, episodeTitle, coachPersonality, personalContext);
    final tldr = _generateFallbackSummary(topic, coachPersonality);
    final action = _generateFallbackAction(topic, coachPersonality);
    final duration = _calculateDuration(intro, core, tldr, action);

    return EpisodeContent(
      title: episodeTitle,
      intro: intro,
      coreContent: core,
      tldrSummary: tldr,
      dailyAction: action,
      totalDuration: duration,
      coachPersonality: coachPersonality,
      episodeNumber: episodeNumber,
      totalEpisodes: totalEpisodes,
    );
  }

  /// Generate fallback intro
  String _generateFallbackIntro(String episodeTitle, String coachPersonality) {
    final greeting = coachPersonality == 'Kai' 
        ? "Welcome back to your learning journey. I'm Kai, and today we're exploring"
        : "Hey there! I'm Vee, and I'm absolutely excited to dive into";

    return '''
$greeting "$episodeTitle."

[PAUSE]

This is going to be fascinating, and I can't wait to share some incredible insights with you. Let's jump right in!
''';
  }

  /// Generate fallback core content
  String _generateFallbackCore(String topic, String episodeTitle, String coachPersonality, String? personalContext) {
    final personalNote = personalContext != null 
        ? "\n\n[PAUSE]\n\nI know you mentioned that $personalContext - so I'll make sure to connect today's insights directly to your specific situation."
        : "";

    return '''
In this episode, we're breaking down $topic in a way that's both fascinating and immediately practical.$personalNote

[PAUSE]

Let me start with the foundation. The key principle here is understanding how $topic connects to real-world applications that matter to you.

[PAUSE]

Here's what makes this particularly interesting: most people think about $topic in one way, but there's actually a much deeper layer that changes everything.

[EMPHASIS] This deeper understanding is what separates those who truly grasp the concept from those who just scratch the surface. [EMPHASIS]

[PAUSE]

Now, let's explore the practical applications. You can immediately apply this knowledge by recognizing the patterns we're discussing in your daily life.

[PAUSE]

The fascinating part is how this knowledge builds on itself. Each insight we cover today creates a foundation for understanding even more complex concepts in the future.

${personalContext != null ? '''
[PAUSE]

Given your specific situation with $personalContext, you can start applying these insights right away by focusing on the aspects that directly relate to your goals.

[PAUSE]
''' : ''}

This is just the beginning of a deeper understanding that will serve you well as you continue exploring this fascinating subject.
''';
  }

  /// Generate fallback summary
  String _generateFallbackSummary(String topic, String coachPersonality) {
    final closing = coachPersonality == 'Kai' 
        ? "Take a moment to let these insights settle in."
        : "You've got this! These insights are going to serve you well.";

    return '''
Let's wrap up with the key takeaways from our exploration of $topic:

[PAUSE]

• First: Understanding the foundational principles gives you a framework for deeper learning
• Second: Real-world applications help you immediately put knowledge into practice  
• Third: Building on these insights creates a foundation for advanced understanding

[EMPHASIS] Remember: True learning happens when you can connect new concepts to what you already know. [EMPHASIS]

[PAUSE]

$closing

Until next time, keep questioning, keep exploring, and keep that curiosity alive!
''';
  }

  /// Generate fallback action
  String _generateFallbackAction(String topic, String coachPersonality) {
    final encouragement = coachPersonality == 'Kai' 
        ? "Reflect on how this applies to your current situation."
        : "Go out there and make it happen!";

    return '''
Here's your daily challenge:

Spend 10 minutes today identifying one way you can immediately apply what we discussed about $topic. Look for connections to your work, relationships, or personal goals.

[PAUSE]

Implementation tip: Write down your observation or take a quick note on your phone. The act of documenting helps solidify the learning.

[PAUSE]

$encouragement You're building knowledge that will compound over time.
''';
  }

  /// Estimate duration based on knowledge level
  int _estimateDuration(String knowledgeLevel) {
    if (knowledgeLevel.contains('Core Concepts')) return 8;
    if (knowledgeLevel.contains('Case Studies')) return 12;
    if (knowledgeLevel.contains('Tools & Trends')) return 10;
    return 10; // Default
  }

  /// Calculate total duration from all sections
  int _calculateDuration(String intro, String core, String tldr, String action) {
    // Rough calculation: 150 words per minute average speaking pace
    final totalWords = _countWords(intro) + _countWords(core) + _countWords(tldr) + _countWords(action);
    return (totalWords / 150 * 60).round(); // Convert to seconds
  }

  /// Count words in text
  int _countWords(String text) {
    return text.split(RegExp(r'\s+')).length;
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
