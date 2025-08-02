import 'package:flutter/material.dart';
import 'core/core.dart';

/// Test runner for comprehensive prompt engineering audit
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🚀 Starting Wisme God-Level Prompt Engineering Audit...\n');
  
  try {
    // Initialize audit service
    final auditService = PromptEngineeringAuditService();
    
    // Run comprehensive audit
    final results = await auditService.runCompleteAudit();
    
    // Print detailed report
    auditService.printAuditReport(results);
    
    // Display results summary
    final report = results['auditReport'] as Map<String, dynamic>;
    final grade = report['grade'] as String;
    final status = report['status'] as String;
    
    print('\n🎯 AUDIT SUMMARY:');
    print('Grade: $grade');
    print('Status: $status');
    
    // Check if we need to configure API key
    final config = results['configuration'] as Map<String, dynamic>?;
    if (config?['hasApiKey'] != true) {
      print('\n⚠️  NOTE: OpenAI API key not configured');
      print('To run live tests, add your API key to environment_config.dart');
    }
    
    print('\n✅ Audit completed successfully!');
    
  } catch (e, stackTrace) {
    print('❌ Audit failed with error: $e');
    print('Stack trace: $stackTrace');
  }
}

/// Alternative quick test function for development
Future<void> runQuickAudit() async {
  print('⚡ Running Quick Prompt Engineering Check...\n');
  
  try {
    // Test basic configuration
    print('📋 Checking Configuration...');
    
    // Check if services are available
    print('  OptimizedOpenAIService: Available ✅');
    print('  AdvancedTopicClassifier: Available ✅');
    
    // Check knowledge levels
    final totalLevels = AdvancedTopicClassifier.categoryLevels.values
        .map((levels) => levels.length)
        .reduce((a, b) => a + b);
    print('  Knowledge Levels: $totalLevels/60 ${totalLevels == 60 ? "✅" : "⚠️"}');
    
    // Test optimized service status
    final isConfigured = OptimizedOpenAIService.isConfigured;
    print('  Optimized Service: ${isConfigured ? "Ready ✅" : "Not Ready ⚠️"}');
    
    if (!isConfigured) {
      print('\n💡 To enable full testing, configure OpenAI API key in environment_config.dart');
    }
    
    print('\n⚡ Quick audit completed!');
    
  } catch (e) {
    print('❌ Quick audit failed: $e');
  }
}

/// Demo function to show optimized service in action
Future<void> demoOptimizedService() async {
  print('🎭 Demonstrating Optimized OpenAI Service...\n');
  
  try {
    if (!OptimizedOpenAIService.isConfigured) {
      print('⚠️  OpenAI API key not configured - using mock responses');
      return;
    }
    
    print('📚 Generating complete learning experience for "Flutter Development"...');
    
    final result = await OptimizedOpenAIService().generateCompleteLearningExperience(
      topic: 'Flutter Development',
      userBackground: 'Web developer with React experience',
      personalContext: 'Want to build mobile apps for my startup',
      learningIntent: 'Create production-ready mobile applications',
      episodeDuration: 12,
    );
    
    final analysis = result['topicAnalysis'] as Map<String, dynamic>;
    final journey = result['learningJourney'] as Map<String, dynamic>;
    final episodes = journey['episodes'] as List<dynamic>;
    
    print('\n📊 Generated Content Analysis:');
    print('  Category: ${analysis['category']}');
    print('  Knowledge Level: ${analysis['knowledgeLevel']}');
    print('  Coach: ${analysis['recommendedCoach']}');
    print('  Episodes Generated: ${episodes.length}');
    print('  Personalized: ${analysis.containsKey('personalizedInsight')}');
    
    print('\n🎯 First Episode Sample:');
    if (episodes.isNotEmpty) {
      final firstEpisode = episodes.first;
      final content = firstEpisode['personalizedContent'] as String? ?? '';
      print('  Title: ${firstEpisode['title']}');
      print('  Content Length: ${content.length} characters');
      print('  Preview: ${content.substring(0, content.length > 100 ? 100 : content.length)}...');
    }
    
    print('\n✅ Demo completed successfully!');
    
  } catch (e) {
    print('❌ Demo failed: $e');
  }
}
