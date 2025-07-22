import 'openai_service.dart';
import '../ai/advanced_topic_classifier.dart';
import '../config/environment_config.dart';

/// Service to test and validate OpenAI API integration
class OpenAITestService {
  static final OpenAITestService _instance = OpenAITestService._internal();
  factory OpenAITestService() => _instance;
  OpenAITestService._internal();

  /// Test OpenAI connection and API functionality
  Future<Map<String, dynamic>> runFullTest() async {
    final results = <String, dynamic>{};
    
    try {
      // Test 1: Check configuration
      results['configuration'] = _testConfiguration();
      
      // Test 2: Test basic connection
      print('🔍 Testing OpenAI connection...');
      results['connection'] = await _testConnection();
      
      // Test 3: Test topic analysis
      if (results['connection'] == true) {
        print('🎯 Testing topic analysis...');
        results['topicAnalysis'] = await _testTopicAnalysis();
        
        // Test 4: Test content generation
        print('📝 Testing content generation...');
        results['contentGeneration'] = await _testContentGeneration();
      }
      
      // Summary
      results['summary'] = _generateTestSummary(results);
      
    } catch (e) {
      results['error'] = e.toString();
      print('❌ Test failed: $e');
    }
    
    return results;
  }

  /// Test configuration status
  Map<String, dynamic> _testConfiguration() {
    return {
      'hasApiKey': EnvironmentConfig.openaiApiKey.isNotEmpty,
      'isConfigured': OpenAIService.isConfigured,
      'environmentStatus': EnvironmentConfig.configurationStatus,
    };
  }

  /// Test basic OpenAI connection
  Future<bool> _testConnection() async {
    try {
      final isConnected = await OpenAIService().testConnection();
      print(isConnected ? '✅ OpenAI connection successful' : '❌ OpenAI connection failed');
      return isConnected;
    } catch (e) {
      print('❌ Connection test error: $e');
      return false;
    }
  }

  /// Test topic analysis functionality
  Future<Map<String, dynamic>> _testTopicAnalysis() async {
    try {
      final classification = await AdvancedTopicClassifier.analyzeTopicWithAI(
        'Machine Learning Fundamentals',
        personalContext: 'I am a beginner programmer interested in AI',
      );
      
      print('✅ Topic analysis successful');
      print('   Category: ${classification.category}');
      print('   Knowledge Level: ${classification.learningType}');
      print('   Recommended Coach: ${classification.recommendedCoach}');
      
      return {
        'success': true,
        'category': classification.category,
        'Learning Type': classification.learningType,
        'coach': classification.recommendedCoach,
        'confidence': classification.confidence,
      };
    } catch (e) {
      print('❌ Topic analysis failed: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Test content generation functionality
  Future<Map<String, dynamic>> _testContentGeneration() async {
    try {
      final content = await OpenAIService().generateEpisodeContent(
        topic: 'Introduction to Python Programming',
        title: 'Python Basics for Beginners',
        category: 'Technology & AI',
        knowledgeLevel: 'Beginner',
        coachPersonality: 'Kai',
        durationMinutes: 5,
      );
      
      print('✅ Content generation successful');
      print('   Content length: ${content.length} characters');
      print('   Preview: ${content.substring(0, 100)}...');
      
      return {
        'success': true,
        'contentLength': content.length,
        'hasContent': content.isNotEmpty,
        'preview': content.length > 100 ? content.substring(0, 100) : content,
      };
    } catch (e) {
      print('❌ Content generation failed: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Generate test summary
  Map<String, dynamic> _generateTestSummary(Map<String, dynamic> results) {
    final config = results['configuration'] as Map<String, dynamic>;
    final connection = results['connection'] as bool? ?? false;
    final topicAnalysis = results['topicAnalysis'] as Map<String, dynamic>?;
    final contentGeneration = results['contentGeneration'] as Map<String, dynamic>?;
    
    final isFullyWorking = config['isConfigured'] == true &&
                          connection == true &&
                          (topicAnalysis?['success'] ?? false) &&
                          (contentGeneration?['success'] ?? false);
    
    return {
      'isFullyWorking': isFullyWorking,
      'configurationOk': config['isConfigured'] == true,
      'connectionOk': connection,
      'topicAnalysisOk': topicAnalysis?['success'] ?? false,
      'contentGenerationOk': contentGeneration?['success'] ?? false,
      'status': isFullyWorking ? 'All systems operational' : 'Some issues detected',
    };
  }

  /// Print detailed test report
  void printTestReport(Map<String, dynamic> results) {
    print('\n=== 🤖 OPENAI INTEGRATION TEST REPORT ===');
    
    final summary = results['summary'] as Map<String, dynamic>;
    print('Overall Status: ${summary['status']}');
    print('Fully Working: ${summary['isFullyWorking'] ? '✅' : '❌'}');
    
    print('\n📋 Test Results:');
    print('├─ Configuration: ${summary['configurationOk'] ? '✅' : '❌'}');
    print('├─ Connection: ${summary['connectionOk'] ? '✅' : '❌'}');
    print('├─ Topic Analysis: ${summary['topicAnalysisOk'] ? '✅' : '❌'}');
    print('└─ Content Generation: ${summary['contentGenerationOk'] ? '✅' : '❌'}');
    
    if (results.containsKey('error')) {
      print('\n❌ Error: ${results['error']}');
    }
    
    print('\n==========================================\n');
  }
}
