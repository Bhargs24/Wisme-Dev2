/// Quick Setup Test for API Keys and Basic Functionality
/// Use this to test your app before full Firebase setup
library;

import '../core/exports.dart';
import '../config/api_keys.dart' as config;

class QuickTestSetup {
  /// Test if API keys are configured
  static bool testApiKeysConfiguration() {
    print('🔍 Testing API Keys Configuration...');
    
    bool hasOpenAI = config.ApiKeys.isOpenAIConfigured;
    bool hasElevenLabs = config.ApiKeys.isElevenLabsConfigured;
    
    print('OpenAI API Key: ${hasOpenAI ? "✅ Configured" : "❌ Missing"}');
    print('ElevenLabs API Key: ${hasElevenLabs ? "✅ Configured" : "❌ Missing"}');
    
    if (!hasOpenAI) {
      print('⚠️  Add your OpenAI API key to lib/config/api_keys.dart');
      print('   Get one from: https://platform.openai.com/api-keys');
    }
    
    if (!hasElevenLabs) {
      print('⚠️  Add your ElevenLabs API key to lib/config/api_keys.dart');
      print('   Get one from: https://elevenlabs.io/speech-synthesis');
    }
    
    return hasOpenAI && hasElevenLabs;
  }
  
  /// Create mock content for testing without APIs
  static ContentBlock createMockLesson({String topic = "Sample Topic"}) {
    return ContentBlock(
      id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Mock Lesson: $topic',
      description: 'This is a mock lesson for testing the app interface',
      duration: const Duration(minutes: 5),
      audioUrl: '', // No audio for mock
      category: 'Technology',
      knowledgeLevel: 'beginner',
      tags: ['mock', 'test', topic.toLowerCase()],
      contentType: 'lesson',
      difficultyLevel: 1,
      coachPersonality: 'friendly',
      voiceId: 'default',
      transcript: '''
Welcome to this sample lesson about $topic.

In this lesson, we'll cover the basics and help you understand the key concepts.

This is a mock lesson created for testing purposes. Once you add your API keys, 
you'll be able to generate real lessons with AI-powered content and voice narration.

Key points:
1. Understanding the fundamentals
2. Practical applications  
3. Next steps for learning

Thank you for trying Wisme!
      ''',
      keywords: [topic.toLowerCase(), 'basics', 'introduction'],
      prerequisites: [],
      learningOutcomes: [
        'Understand $topic basics',
        'Recognize key concepts',
        'Know next learning steps'
      ],
      playCount: 0,
      averageRating: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDownloaded: false,
      fileSizeBytes: 0,
      metadata: {
        'mock': true,
        'created_for_testing': true,
      },
    );
  }
  
  /// Show setup status in console
  static void showSetupStatus() {
    print('');
    print('🚀 Wisme App Setup Status');
    print('=' * 40);
    
    // API Keys
    testApiKeysConfiguration();
    
    // Firebase
    print('');
    print('Firebase: ${config.ApiKeys.isFirebaseConfigured ? "✅ Configured" : "⚠️  Basic setup needed"}');
    if (!config.ApiKeys.isFirebaseConfigured) {
      print('   See FIREBASE_SETUP.md for complete guide');
    }
    
    // Development Mode
    print('');
    if (config.ApiKeys.isDevelopmentMode) {
      print('🛠️  Development Mode: ON');
      print('   - Mock lessons will be used');
      print('   - No real AI generation');
      print('   - Perfect for UI testing');
    } else {
      print('🌟 Production Mode: ON');
      print('   - Real AI lesson generation');
      print('   - Voice synthesis enabled');
      print('   - Full feature set available');
    }
    
    print('');
    print('📚 Next Steps:');
    if (!config.ApiKeys.isOpenAIConfigured || !config.ApiKeys.isElevenLabsConfigured) {
      print('   1. Follow API_KEYS_SETUP.md');
      print('   2. Add your API keys');
      print('   3. Restart the app');
    } else if (!config.ApiKeys.isFirebaseConfigured) {
      print('   1. Follow FIREBASE_SETUP.md');
      print('   2. Set up Firebase project');
      print('   3. Add Firebase config');
    } else {
      print('   🎉 You\'re all set! Try generating a lesson!');
    }
    print('=' * 40);
    print('');
  }
}
