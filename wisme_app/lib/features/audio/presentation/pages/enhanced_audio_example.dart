/// Example Integration for Enhanced Audio with Caching
/// Shows how to use the new services in your existing app
/// Product Focus: Easy integration with immediate benefits

import 'package:flutter/material.dart';
import '../../../../core/services/phase1_conversation_engine.dart';
import '../../../../core/services/enhanced_tts_service.dart';

class EnhancedAudioExample extends StatefulWidget {
  const EnhancedAudioExample({Key? key}) : super(key: key);

  @override
  State<EnhancedAudioExample> createState() => _EnhancedAudioExampleState();
}

class _EnhancedAudioExampleState extends State<EnhancedAudioExample> {
  final EnhancedTTSService _ttsService = EnhancedTTSService();
  bool _isGenerating = false;
  Map<String, dynamic>? _lastResult;
  Map<String, dynamic>? _cacheStats;

  @override
  void initState() {
    super.initState();
    _loadCacheStats();
  }

  Future<void> _loadCacheStats() async {
    final stats = await _ttsService.getCachePerformanceStats();
    setState(() {
      _cacheStats = stats;
    });
  }

  Future<void> _generateEpisodeWithCaching() async {
    setState(() {
      _isGenerating = true;
      _lastResult = null;
    });

    try {
      // Generate episode using the enhanced conversation engine
      final result = await Phase1ConversationEngine.generateEpisodeWithCaching(
        topic: 'Personal Finance Basics',
        episodeTitle: 'Understanding Credit Scores',
        category: 'Business & Finance',
        targetDurationMinutes: 5,
        episodeNumber: 1,
        personalContext: 'Beginner level, interested in practical tips',
      );

      setState(() {
        _lastResult = result;
        _isGenerating = false;
      });

      // Update cache stats
      await _loadCacheStats();
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _lastResult = {
          'error': e.toString(),
          'status': 'failed',
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Audio with Caching'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cache Statistics Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fragment Cache Status',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (_cacheStats != null) ...[
                      Text('Total Fragments: ${_cacheStats!['fragmentCache']['totalFragments']}'),
                      Text('Cache Size: ${_cacheStats!['fragmentCache']['totalSizeMB']} MB'),
                      Text('Status: ${_cacheStats!['serviceStatus']}'),
                      Text('Expected Savings: ${_cacheStats!['costSavingsEstimate']}'),
                    ] else
                      const Text('Loading cache stats...'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Generation Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generateEpisodeWithCaching,
                child: _isGenerating
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Generating Episode...'),
                        ],
                      )
                    : const Text('Generate Episode with Smart Caching'),
              ),
            ),
            const SizedBox(height: 16),

            // Results Display
            if (_lastResult != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generation Results',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (_lastResult!['status'] == 'success_with_caching') ...[
                        Text('✅ Episode generated successfully!'),
                        const SizedBox(height: 8),
                        Text('Episode: ${_lastResult!['title'] ?? 'Unknown'}'),
                        if (_lastResult!['cacheMetrics'] != null) ...[
                          const SizedBox(height: 8),
                          Text('🎯 Cache Performance:'),
                          Text('  • Total Segments: ${_lastResult!['cacheMetrics']['totalFragments']}'),
                          Text('  • Cache Hits: ${_lastResult!['cacheMetrics']['cacheHits']}'),
                          Text('  • Hit Rate: ${(_lastResult!['cacheMetrics']['cacheHitRate'] * 100).toStringAsFixed(1)}%'),
                          Text('  • Cost Saved: \$${_lastResult!['cacheMetrics']['estimatedCostSaving'].toStringAsFixed(3)}'),
                        ],
                      ] else if (_lastResult!['error'] != null) ...[
                        Text('❌ Error: ${_lastResult!['error']}'),
                      ] else ...[
                        Text('⚠️ Fallback generation used'),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            const Spacer(),

            // Info Section
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How This Works',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Generate conversation script with AI'),
                    const Text('2. Check cache for existing audio fragments'),
                    const Text('3. Reuse cached audio where possible'),
                    const Text('4. Generate only missing fragments'),
                    const Text('5. Assemble smooth conversation with smart transitions'),
                    const SizedBox(height: 8),
                    Text(
                      'Target: 30-50% cost reduction through intelligent reuse',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



