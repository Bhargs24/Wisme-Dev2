/// Shared Audio Models and Types
/// Common types used across audio services
library;

/// Audio quality levels for generation and playback
enum AudioQuality {
  low,
  standard,
  medium,
  high,
  premium
}

/// Audio generation statistics
class AudioGenerationStats {
  final int totalRequests;
  final int cacheHits;
  final int cacheMisses;
  final double cacheHitRate;
  final double totalCostSaved;
  final double estimatedMonthlySavings;

  const AudioGenerationStats({
    required this.totalRequests,
    required this.cacheHits,
    required this.cacheMisses,
    required this.cacheHitRate,
    required this.totalCostSaved,
    required this.estimatedMonthlySavings,
  });
}

/// TTS Service Statistics 
typedef TTSServiceStats = AudioGenerationStats;

/// Audio generation metrics
class GenerationMetrics {
  final Duration generationTime;
  final double cacheHitRate;
  final double totalCost;
  final AudioQuality qualityLevel;

  const GenerationMetrics({
    required this.generationTime,
    required this.cacheHitRate,
    required this.totalCost,
    required this.qualityLevel,
  });
}
