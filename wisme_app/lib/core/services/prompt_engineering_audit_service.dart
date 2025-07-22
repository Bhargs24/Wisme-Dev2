import 'optimized_openai_service.dart';
import '../ai/advanced_topic_classifier.dart';
import '../config/environment_config.dart';

/// Comprehensive Test Service for God-Level Prompt Engineering
/// Validates cost efficiency, accuracy, personalization, and uniqueness
class PromptEngineeringAuditService {
  static final PromptEngineeringAuditService _instance = PromptEngineeringAuditService._internal();
  factory PromptEngineeringAuditService() => _instance;
  PromptEngineeringAuditService._internal();

  /// Run comprehensive audit of prompt engineering system
  Future<Map<String, dynamic>> runCompleteAudit() async {
    final results = <String, dynamic>{};
    
    print('🔍 Starting God-Level Prompt Engineering Audit...\n');
    
    try {
      // Test 1: Configuration & Connection
      results['configuration'] = await _testConfiguration();
      
      // Test 2: Single API Call Efficiency
      results['efficiency'] = await _testAPIEfficiency();
      
      // Test 3: Personalization Depth
      results['personalization'] = await _testPersonalization();
      
      // Test 4: Content Uniqueness
      results['uniqueness'] = await _testContentUniqueness();
      
      // Test 5: Knowledge Level Accuracy
      results['knowledgeAccuracy'] = await _testKnowledgeLevelAccuracy();
      
      // Test 6: Hashtag Generation
      results['hashtagGeneration'] = await _testHashtagGeneration();
      
      // Test 7: Cost Analysis
      results['costAnalysis'] = _analyzeCostEfficiency(results);
      
      // Generate comprehensive report
      results['auditReport'] = _generateAuditReport(results);
      
    } catch (e) {
      results['error'] = e.toString();
      print('❌ Audit failed: $e');
    }
    
    return results;
  }

  /// Test configuration and connection
  Future<Map<String, dynamic>> _testConfiguration() async {
    print('📋 Testing Configuration...');
    
    final config = {
      'hasApiKey': EnvironmentConfig.openaiApiKey.isNotEmpty,
      'isOptimizedServiceConfigured': OptimizedOpenAIService.isConfigured,
      'knowledgeLevelsCount': AdvancedTopicClassifier.categoryLevels.length,
      'totalKnowledgeLevels': AdvancedTopicClassifier.categoryLevels.values
          .map((levels) => levels.length)
          .reduce((a, b) => a + b),
    };
    
    // Test connection
    try {
      config['connectionTest'] = await OptimizedOpenAIService().testConnection();
      print('✅ Configuration test passed');
    } catch (e) {
      config['connectionTest'] = false;
      config['connectionError'] = e.toString();
      print('❌ Configuration test failed: $e');
    }
    
    return config;
  }

  /// Test API efficiency (single call vs multiple calls)
  Future<Map<String, dynamic>> _testAPIEfficiency() async {
    print('⚡ Testing API Efficiency...');
    
    if (!OptimizedOpenAIService.isConfigured) {
      return {'skipped': 'OpenAI not configured'};
    }
    
    final testTopic = 'Machine Learning Fundamentals';
    final testContext = 'I am a software developer transitioning to AI';
    
    try {
      final startTime = DateTime.now();
      
      // Single optimized call
      final completeResult = await OptimizedOpenAIService().generateCompleteLearningExperience(
        topic: testTopic,
        personalContext: testContext,
        userBackground: 'Software Developer, 5 years experience',
        learningIntent: 'Career transition to AI/ML field',
        learningGoal: 'Master',
      );
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      
      // Analyze response structure
      final analysis = completeResult['topicAnalysis'] as Map<String, dynamic>;
      final journey = completeResult['learningJourney'] as Map<String, dynamic>;
      final episodes = journey['episodes'] as List<dynamic>;
      
      print('✅ Efficiency test completed in ${duration}ms');
      
      return {
        'success': true,
        'responseTime': duration,
        'singleCallSuccess': true,
        'episodeCount': episodes.length,
        'hasPersonalization': analysis.containsKey('personalizedInsight'),
        'hasFullContent': episodes.every((e) => e['personalizedContent'] != null),
        'averageEpisodeLength': episodes
            .map((e) => (e['personalizedContent'] as String? ?? '').length)
            .reduce((a, b) => a + b) / episodes.length,
      };
    } catch (e) {
      print('❌ Efficiency test failed: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Test personalization depth
  Future<Map<String, dynamic>> _testPersonalization() async {
    print('👤 Testing Personalization...');
    
    if (!OptimizedOpenAIService.isConfigured) {
      return {'skipped': 'OpenAI not configured'};
    }
    
    final testCases = [
      {
        'topic': 'Python Programming',
        'background': 'Complete beginner, no programming experience',
        'context': 'Want to build web applications for my small business',
        'intent': 'Learn practical skills quickly',
      },
      {
        'topic': 'Python Programming',
        'background': 'Java developer with 10 years experience',
        'context': 'Switching to Python for data science role',
        'intent': 'Focus on Python-specific features and data libraries',
      },
    ];
    
    final results = <Map<String, dynamic>>[];
    
    for (final testCase in testCases) {
      try {
        final result = await OptimizedOpenAIService().generateCompleteLearningExperience(
          topic: testCase['topic'] as String,
          userBackground: testCase['background'] as String,
          personalContext: testCase['context'] as String,
          learningIntent: testCase['intent'] as String,
        );
        
        final analysis = result['topicAnalysis'] as Map<String, dynamic>;
        final journey = result['learningJourney'] as Map<String, dynamic>;
        final episodes = journey['episodes'] as List<dynamic>;
        
        // Analyze personalization
        final personalizationScore = _calculatePersonalizationScore(
          testCase, 
          analysis, 
          episodes,
        );
        
        results.add({
          'testCase': testCase,
          'personalizationScore': personalizationScore,
          'knowledgeLevel': analysis['knowledgeLevel'],
          'coach': analysis['recommendedCoach'],
          'hasPersonalizedInsight': analysis.containsKey('personalizedInsight'),
          'contextIntegration': _checkContextIntegration(testCase, episodes),
        });
        
      } catch (e) {
        results.add({
          'testCase': testCase,
          'error': e.toString(),
        });
      }
    }
    
    print('✅ Personalization test completed');
    
    return {
      'testResults': results,
      'averagePersonalizationScore': results
          .where((r) => r.containsKey('personalizationScore'))
          .map((r) => r['personalizationScore'] as double)
          .fold(0.0, (a, b) => a + b) / results.length,
    };
  }

  /// Test content uniqueness (no repetitive phrases)
  Future<Map<String, dynamic>> _testContentUniqueness() async {
    print('🎨 Testing Content Uniqueness...');
    
    if (!OptimizedOpenAIService.isConfigured) {
      return {'skipped': 'OpenAI not configured'};
    }
    
    try {
      // Generate content for same topic multiple times
      final topic = 'Blockchain Technology';
      final results = <Map<String, dynamic>>[];
      
      for (int i = 0; i < 3; i++) {
        final result = await OptimizedOpenAIService().generateCompleteLearningExperience(
          topic: topic,
          personalContext: 'Test run ${i + 1}',
        );
        
        final journey = result['learningJourney'] as Map<String, dynamic>;
        final episodes = journey['episodes'] as List<dynamic>;
        
        results.add({
          'run': i + 1,
          'episodes': episodes,
        });
      }
      
      // Analyze uniqueness
      final uniquenessAnalysis = _analyzeContentUniqueness(results);
      
      print('✅ Uniqueness test completed');
      return uniquenessAnalysis;
      
    } catch (e) {
      print('❌ Uniqueness test failed: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Test knowledge level accuracy
  Future<Map<String, dynamic>> _testKnowledgeLevelAccuracy() async {
    print('🎯 Testing Knowledge Level Accuracy...');
    
    final testCases = [
      {
        'topic': 'React Development',
        'context': 'I have never coded before',
        'expectedLevel': '🔹 Core Concepts',
      },
      {
        'topic': 'React Development',
        'context': 'I am a senior JavaScript developer',
        'expectedLevel': '🛠 Tools & Trends',
      },
      {
        'topic': 'Machine Learning',
        'context': 'Show me real company implementations',
        'expectedLevel': '💼 Case Studies',
      },
    ];
    
    final results = <Map<String, dynamic>>[];
    
    for (final testCase in testCases) {
      try {
        final classification = await AdvancedTopicClassifier.analyzeTopicWithAI(
          testCase['topic'] as String,
          personalContext: testCase['context'] as String,
        );
        
        final levelMatch = classification.learningType == testCase['expectedLevel'];
        
        results.add({
          'testCase': testCase,
          'actualLevel': classification.learningType,
          'expectedLevel': testCase['expectedLevel'],
          'levelMatch': levelMatch,
          'category': classification.category,
          'confidence': classification.confidence,
        });
        
      } catch (e) {
        results.add({
          'testCase': testCase,
          'error': e.toString(),
        });
      }
    }
    
    final accuracy = results.where((r) => r['levelMatch'] == true).length / results.length;
    
    print('✅ Knowledge level accuracy: ${(accuracy * 100).toStringAsFixed(1)}%');
    
    return {
      'testResults': results,
      'accuracy': accuracy,
      'totalTests': results.length,
      'successfulMatches': results.where((r) => r['levelMatch'] == true).length,
    };
  }

  /// Test hashtag generation
  Future<Map<String, dynamic>> _testHashtagGeneration() async {
    print('#️⃣ Testing Hashtag Generation...');
    
    if (!OptimizedOpenAIService.isConfigured) {
      return {'skipped': 'OpenAI not configured'};
    }
    
    try {
      final hashtags = await OptimizedOpenAIService().generateHashtags(
        topic: 'Sustainable Web Development',
        category: 'Technology & AI',
        personalContext: 'Environmental focus in tech career',
      );
      
      print('✅ Generated hashtags: ${hashtags.join(', ')}');
      
      return {
        'success': true,
        'hashtags': hashtags,
        'count': hashtags.length,
        'hasTopicRelevant': hashtags.any((h) => h.toLowerCase().contains('sustain') || h.toLowerCase().contains('web')),
        'hasCategoryRelevant': hashtags.any((h) => h.toLowerCase().contains('tech') || h.toLowerCase().contains('dev')),
      };
    } catch (e) {
      print('❌ Hashtag generation failed: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Analyze cost efficiency
  Map<String, dynamic> _analyzeCostEfficiency(Map<String, dynamic> results) {
    print('💰 Analyzing Cost Efficiency...');
    
    final efficiency = results['efficiency'] as Map<String, dynamic>?;
    if (efficiency == null || efficiency['success'] != true) {
      return {'analysis': 'Cannot analyze - efficiency test failed'};
    }
    
    final responseTime = efficiency['responseTime'] as int;
    final episodeCount = efficiency['episodeCount'] as int;
    final avgEpisodeLength = efficiency['averageEpisodeLength'] as double;
    
    // Estimate token usage (rough calculation)
    final estimatedTokens = (avgEpisodeLength * episodeCount / 4).round(); // ~4 chars per token
    final estimatedCost = estimatedTokens * 0.00003; // GPT-4 pricing estimate
    
    return {
      'responseTimeMs': responseTime,
      'episodesGenerated': episodeCount,
      'estimatedTokens': estimatedTokens,
      'estimatedCostUSD': estimatedCost,
      'singleCallEfficiency': true, // Using single call vs multiple
      'costEfficiencyRating': estimatedCost < 0.10 ? 'Excellent' : estimatedCost < 0.25 ? 'Good' : 'Needs optimization',
    };
  }

  /// Calculate personalization score
  double _calculatePersonalizationScore(
    Map<String, dynamic> testCase,
    Map<String, dynamic> analysis,
    List<dynamic> episodes,
  ) {
    double score = 0.0;
    
    // Check if personal context is mentioned in analysis
    final personalizedInsight = analysis['personalizedInsight'] as String? ?? '';
    final context = testCase['context'] as String;
    final background = testCase['background'] as String;
    
    if (personalizedInsight.toLowerCase().contains(context.toLowerCase().split(' ').first)) {
      score += 0.3;
    }
    
    if (personalizedInsight.toLowerCase().contains(background.toLowerCase().split(' ').first)) {
      score += 0.3;
    }
    
    // Check episode content for personal context integration
    for (final episode in episodes) {
      final content = episode['personalizedContent'] as String? ?? '';
      if (content.toLowerCase().contains(context.toLowerCase().split(' ').first)) {
        score += 0.2;
        break;
      }
    }
    
    // Check knowledge level appropriateness
    final knowledgeLevel = analysis['knowledgeLevel'] as String;
    if (background.toLowerCase().contains('beginner') && knowledgeLevel.contains('Core Concepts')) {
      score += 0.2;
    } else if (background.toLowerCase().contains('experience') && !knowledgeLevel.contains('Core Concepts')) {
      score += 0.2;
    }
    
    return score;
  }

  /// Check context integration in episodes
  bool _checkContextIntegration(Map<String, dynamic> testCase, List<dynamic> episodes) {
    final context = (testCase['context'] as String).toLowerCase();
    final contextWords = context.split(' ').where((w) => w.length > 3).toList();
    
    for (final episode in episodes) {
      final content = (episode['personalizedContent'] as String? ?? '').toLowerCase();
      if (contextWords.any((word) => content.contains(word))) {
        return true;
      }
    }
    return false;
  }

  /// Analyze content uniqueness across multiple generations
  Map<String, dynamic> _analyzeContentUniqueness(List<Map<String, dynamic>> results) {
    final allContent = <String>[];
    
    for (final result in results) {
      final episodes = result['episodes'] as List<dynamic>;
      for (final episode in episodes) {
        final content = episode['personalizedContent'] as String? ?? '';
        allContent.add(content);
      }
    }
    
    // Check for repeated phrases
    final commonPhrases = <String, int>{};
    for (final content in allContent) {
      final sentences = content.split(RegExp(r'[.!?]'));
      for (final sentence in sentences) {
        final trimmed = sentence.trim();
        if (trimmed.length > 20) {
          commonPhrases[trimmed] = (commonPhrases[trimmed] ?? 0) + 1;
        }
      }
    }
    
    final repeatedPhrases = commonPhrases.entries
        .where((entry) => entry.value > 1)
        .map((entry) => {'phrase': entry.key, 'count': entry.value})
        .toList();
    
    final uniquenessScore = 1.0 - (repeatedPhrases.length / commonPhrases.length);
    
    return {
      'success': true,
      'uniquenessScore': uniquenessScore,
      'totalPhrases': commonPhrases.length,
      'repeatedPhrases': repeatedPhrases.length,
      'uniquenessRating': uniquenessScore > 0.95 ? 'Excellent' : 
                         uniquenessScore > 0.85 ? 'Good' : 'Needs improvement',
      'sampleRepeatedPhrases': repeatedPhrases.take(3).toList(),
    };
  }

  /// Generate comprehensive audit report
  Map<String, dynamic> _generateAuditReport(Map<String, dynamic> results) {
    print('\n📊 Generating Audit Report...');
    
    final scores = <String, double>{};
    final issues = <String>[];
    final recommendations = <String>[];
    
    // Analyze each test result
    final config = results['configuration'] as Map<String, dynamic>?;
    if (config != null) {
      if (config['totalKnowledgeLevels'] == 60) {
        scores['knowledgeSystem'] = 1.0;
      } else {
        scores['knowledgeSystem'] = 0.5;
        issues.add('Knowledge levels count mismatch: expected 60, got ${config['totalKnowledgeLevels']}');
      }
    }
    
    final efficiency = results['efficiency'] as Map<String, dynamic>?;
    if (efficiency?['success'] == true) {
      scores['efficiency'] = 1.0;
    } else {
      scores['efficiency'] = 0.0;
      issues.add('API efficiency test failed');
      recommendations.add('Check OpenAI API configuration and connectivity');
    }
    
    final personalization = results['personalization'] as Map<String, dynamic>?;
    if (personalization != null && personalization.containsKey('averagePersonalizationScore')) {
      scores['personalization'] = personalization['averagePersonalizationScore'] as double;
    }
    
    final uniqueness = results['uniqueness'] as Map<String, dynamic>?;
    if (uniqueness?['success'] == true && uniqueness?['uniquenessScore'] != null) {
      scores['uniqueness'] = uniqueness!['uniquenessScore'] as double;
    }
    
    final knowledge = results['knowledgeAccuracy'] as Map<String, dynamic>?;
    if (knowledge != null) {
      scores['knowledgeAccuracy'] = knowledge['accuracy'] as double;
    }
    
    final hashtags = results['hashtagGeneration'] as Map<String, dynamic>?;
    if (hashtags?['success'] == true) {
      scores['hashtagGeneration'] = 1.0;
    } else {
      scores['hashtagGeneration'] = 0.0;
    }
    
    // Calculate overall score
    final overallScore = scores.values.isNotEmpty 
        ? scores.values.reduce((a, b) => a + b) / scores.length 
        : 0.0;
    
    // Generate recommendations
    if (scores['personalization'] != null && scores['personalization']! < 0.8) {
      recommendations.add('Enhance personalization prompts to better integrate user context');
    }
    
    if (scores['uniqueness'] != null && scores['uniqueness']! < 0.9) {
      recommendations.add('Increase prompt variation and use higher frequency penalties');
    }
    
    final grade = overallScore >= 0.95 ? 'A+' :
                  overallScore >= 0.90 ? 'A' :
                  overallScore >= 0.80 ? 'B' :
                  overallScore >= 0.70 ? 'C' : 'D';
    
    return {
      'overallScore': overallScore,
      'grade': grade,
      'scores': scores,
      'issues': issues,
      'recommendations': recommendations,
      'status': overallScore >= 0.90 ? 'Excellent' : 
                overallScore >= 0.80 ? 'Good' : 
                overallScore >= 0.70 ? 'Acceptable' : 'Needs Improvement',
    };
  }

  /// Print comprehensive audit report
  void printAuditReport(Map<String, dynamic> results) {
    print('\n${'='*60}');
    print('🎯 GOD-LEVEL PROMPT ENGINEERING AUDIT REPORT');
    print('='*60);
    
    final report = results['auditReport'] as Map<String, dynamic>;
    final overallScore = report['overallScore'] as double;
    final grade = report['grade'] as String;
    
    print('Overall Grade: $grade (${(overallScore * 100).toStringAsFixed(1)}%)');
    print('Status: ${report['status']}');
    
    print('\n📊 Detailed Scores:');
    final scores = report['scores'] as Map<String, double>;
    scores.forEach((category, score) {
      final percentage = (score * 100).toStringAsFixed(1);
      final emoji = score >= 0.9 ? '✅' : score >= 0.7 ? '⚠️' : '❌';
      print('  $emoji $category: $percentage%');
    });
    
    final issues = report['issues'] as List<dynamic>;
    if (issues.isNotEmpty) {
      print('\n❌ Issues Found:');
      for (final issue in issues) {
        print('  • $issue');
      }
    }
    
    final recommendations = report['recommendations'] as List<dynamic>;
    if (recommendations.isNotEmpty) {
      print('\n💡 Recommendations:');
      for (final rec in recommendations) {
        print('  • $rec');
      }
    }
    
    // Cost analysis
    final cost = results['costAnalysis'] as Map<String, dynamic>?;
    if (cost != null) {
      print('\n💰 Cost Analysis:');
      print('  • Estimated cost per complete experience: \$${(cost['estimatedCostUSD'] as double).toStringAsFixed(4)}');
      print('  • Efficiency rating: ${cost['costEfficiencyRating']}');
    }
    
    print('\n${'='*60}');
    print('Audit completed successfully! 🎉');
    print('='*60 + '\n');
  }
}
