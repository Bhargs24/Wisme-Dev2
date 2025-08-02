/// WISME Phase 1 Test Runner
/// Test the critical fixes for real audio generation
library;
import 'package:flutter/material.dart';
import '../../test/elevenlabs_test.dart';
import '../../core/services/enhanced_tts_service.dart';
import '../../core/audio/audio_storage.dart';

class Phase1TestRunner extends StatefulWidget {
  const Phase1TestRunner({super.key});

  @override
  State<Phase1TestRunner> createState() => _Phase1TestRunnerState();
}

class _Phase1TestRunnerState extends State<Phase1TestRunner> {
  final List<String> _testResults = [];
  bool _isRunning = false;

  void _addResult(String result) {
    setState(() {
      _testResults.add('${DateTime.now().toLocal().toString().substring(11, 19)}: $result');
    });
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isRunning = true;
      _testResults.clear();
    });

    _addResult('🚀 Starting WISME Phase 1 Tests...');

    // Test 1: ElevenLabs API Integration
    _addResult('--- Test 1: ElevenLabs API Integration ---');
    try {
      await ElevenLabsTest.testBasicIntegration();
      _addResult('✅ ElevenLabs API test completed');
    } catch (e) {
      _addResult('❌ ElevenLabs API test failed: $e');
    }

    // Test 2: Enhanced TTS Service
    _addResult('--- Test 2: Enhanced TTS Service ---');
    try {
      final ttsService = EnhancedTTSService();
      final result = await ttsService.generateSpeechWithCaching(
        text: "This is a test of the enhanced TTS service with real audio generation.",
        speakerId: "kai",
        category: "test",
      );
      
      if (result['success'] == true) {
        _addResult('✅ Enhanced TTS generated audio successfully');
        _addResult('   Audio path: ${result['audioPath']}');
        _addResult('   From cache: ${result['fromCache']}');
      } else {
        _addResult('❌ Enhanced TTS failed: ${result['error']}');
      }
    } catch (e) {
      _addResult('❌ Enhanced TTS test failed: $e');
    }

    // Test 3: Audio Storage
    _addResult('--- Test 3: Audio Storage ---');
    try {
      final storageUsed = await AudioStorage.getTotalStorageUsed();
      final episodeFiles = await AudioStorage.getEpisodeAudioFiles();
      
      _addResult('✅ Audio storage accessible');
      _addResult('   Storage used: ${(storageUsed / 1024 / 1024).toStringAsFixed(2)} MB');
      _addResult('   Episode files: ${episodeFiles.length}');
    } catch (e) {
      _addResult('❌ Audio storage test failed: $e');
    }

    // Test 4: Conversation Generation
    _addResult('--- Test 4: Conversation Generation ---');
    try {
      await ElevenLabsTest.testConversationGeneration();
      _addResult('✅ Conversation generation test completed');
    } catch (e) {
      _addResult('❌ Conversation generation test failed: $e');
    }

    _addResult('🏁 All tests completed!');
    setState(() {
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WISME Phase 1 Tests'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Phase 1: Critical Audio Generation Tests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Testing real ElevenLabs API integration and audio generation pipeline',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Run Tests Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isRunning ? null : _runAllTests,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _isRunning
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Running Tests...'),
                        ],
                      )
                    : const Text('Run All Tests'),
              ),
            ),
            const SizedBox(height: 24),

            // Test Results
            const Text(
              'Test Results:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _testResults.isEmpty
                    ? const Center(
                        child: Text(
                          'No tests run yet. Click "Run All Tests" to start.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _testResults.length,
                        itemBuilder: (context, index) {
                          final result = _testResults[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              result,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: result.contains('❌') 
                                    ? Colors.red 
                                    : result.contains('✅') 
                                        ? Colors.green 
                                        : Colors.black87,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
