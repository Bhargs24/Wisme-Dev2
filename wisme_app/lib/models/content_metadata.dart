/// Content Metadata Model
/// Used for AI content generation tracking and optimization
class ContentMetadata {
  final String id;
  final String episodeId;
  final String promptUsed;
  final String aiModel;
  final String voiceModel;
  final int generationTimeMs;
  final int tokensUsed;
  final double costCents;
  final Map<String, dynamic> additionalParams;
  final DateTime createdAt;

  const ContentMetadata({
    required this.id,
    required this.episodeId,
    required this.promptUsed,
    required this.aiModel,
    required this.voiceModel,
    required this.generationTimeMs,
    required this.tokensUsed,
    required this.costCents,
    this.additionalParams = const {},
    required this.createdAt,
  });

  factory ContentMetadata.fromJson(Map<String, dynamic> json) {
    return ContentMetadata(
      id: json['id'],
      episodeId: json['episode_id'],
      promptUsed: json['prompt_used'] ?? '',
      aiModel: json['ai_model'] ?? 'gpt-4',
      voiceModel: json['voice_model'] ?? 'playht',
      generationTimeMs: json['generation_time_ms'] ?? 0,
      tokensUsed: json['tokens_used'] ?? 0,
      costCents: (json['cost_cents'] ?? 0.0).toDouble(),
      additionalParams: Map<String, dynamic>.from(json['additional_params'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'episode_id': episodeId,
      'prompt_used': promptUsed,
      'ai_model': aiModel,
      'voice_model': voiceModel,
      'generation_time_ms': generationTimeMs,
      'tokens_used': tokensUsed,
      'cost_cents': costCents,
      'additional_params': additionalParams,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
