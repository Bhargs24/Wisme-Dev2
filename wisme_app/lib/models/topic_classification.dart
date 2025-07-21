/// Topic Classification Models for AI-powered learning system
library;

/// Main topic classification result from AI analysis
class TopicClassification {
  final String originalTopic;
  final String category;
  final String knowledgeType;
  final double confidence;
  final List<SubtopicResult> subtopics;
  final List<String> contentHints;
  final EpisodePlan episodePlan;
  final int estimatedDuration;
  final List<String> prerequisiteTopics;
  final String? personalContext;
  final Map<String, dynamic>? completeLearningExperience; // Store full AI response

  const TopicClassification({
    required this.originalTopic,
    required this.category,
    required this.knowledgeType,
    required this.confidence,
    required this.subtopics,
    required this.contentHints,
    required this.episodePlan,
    required this.estimatedDuration,
    required this.prerequisiteTopics,
    this.personalContext,
    this.completeLearningExperience,
  });

  factory TopicClassification.fromJson(Map<String, dynamic> json) {
    return TopicClassification(
      originalTopic: json['originalTopic'] ?? '',
      category: json['category'] ?? '',
      knowledgeType: json['knowledgeType'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      subtopics: (json['subtopics'] as List? ?? [])
          .map((s) => SubtopicResult.fromJson(s))
          .toList(),
      contentHints: List<String>.from(json['contentHints'] ?? json['learningStyleHints'] ?? []),
      episodePlan: EpisodePlan.fromJson(json['episodePlan'] ?? {}),
      estimatedDuration: json['estimatedDuration'] ?? 30,
      prerequisiteTopics: List<String>.from(json['prerequisiteTopics'] ?? []),
      personalContext: json['personalContext'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalTopic': originalTopic,
      'category': category,
      'knowledgeType': knowledgeType,
      'confidence': confidence,
      'subtopics': subtopics.map((s) => s.toJson()).toList(),
      'contentHints': contentHints,
      'episodePlan': episodePlan.toJson(),
      'estimatedDuration': estimatedDuration,
      'prerequisiteTopics': prerequisiteTopics,
      if (personalContext != null) 'personalContext': personalContext,
    };
  }
}

/// Individual subtopic result within a topic classification
class SubtopicResult {
  final String title;
  final String description;
  final List<String> keyConcepts;
  final int estimatedDuration;
  final double difficultyProgression;

  const SubtopicResult({
    required this.title,
    required this.description,
    required this.keyConcepts,
    required this.estimatedDuration,
    required this.difficultyProgression,
  });

  factory SubtopicResult.fromJson(Map<String, dynamic> json) {
    return SubtopicResult(
      title: json['title'] as String,
      description: json['description'] as String,
      keyConcepts: List<String>.from(json['keyConcepts'] ?? json['key_concepts'] ?? []),
      estimatedDuration: json['estimatedDuration'] ?? json['estimated_duration'] ?? 12,
      difficultyProgression: (json['difficultyProgression'] ?? json['difficulty_progression'] ?? 0.5).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'keyConcepts': keyConcepts,
      'estimatedDuration': estimatedDuration,
      'difficultyProgression': difficultyProgression,
    };
  }
}

/// Episode plan structure for a topic
class EpisodePlan {
  final List<String> progressionPath;
  final List<String> learningObjectives;
  final int totalEpisodes;

  const EpisodePlan({
    required this.progressionPath,
    required this.learningObjectives,
    required this.totalEpisodes,
  });

  factory EpisodePlan.fromJson(Map<String, dynamic> json) {
    return EpisodePlan(
      progressionPath: List<String>.from(json['progressionPath'] ?? []),
      learningObjectives: List<String>.from(json['learningObjectives'] ?? []),
      totalEpisodes: json['totalEpisodes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'progressionPath': progressionPath,
      'learningObjectives': learningObjectives,
      'totalEpisodes': totalEpisodes,
    };
  }
}
