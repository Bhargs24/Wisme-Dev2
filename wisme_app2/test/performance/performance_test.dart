import 'package:flutter_test/flutter_test.dart';
import 'package:wisme_app2/services/cache_service.dart';
import 'package:wisme_app2/services/performance_service.dart';
import 'dart:typed_data';

void main() {
  group('Performance Tests', () {
    test('cache service should handle large data efficiently', () async {
      final cacheService = CacheService();
      final stopwatch = Stopwatch()..start();
      
      // Test caching 100 items
      for (int i = 0; i < 100; i++) {
        await cacheService.cacheAudio(
          topic: 'test_topic_$i',
          coachVoice: 'coach_voice_1',
          audioData: Uint8List.fromList(List.generate(1000, (index) => index % 256)), // 1KB of data
          metadata: {'test': true, 'index': i},
        );
      }
      
      stopwatch.stop();
      
      // Should complete within 10 seconds (more realistic for file I/O)
      expect(stopwatch.elapsedMilliseconds, lessThan(10000));
    });

    test('performance service should track metrics efficiently', () {
      final stopwatch = Stopwatch()..start();
      
      // Record 1000 metrics
      for (int i = 0; i < 1000; i++) {
        PerformanceService.recordMetric('test_metric_$i', i.toDouble());
      }
      
      stopwatch.stop();
      
      // Should complete within 1 second
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('memory usage should stay within limits', () async {
      // Initialize performance service
      await PerformanceService.initialize();
      
      // Record initial memory
      PerformanceService.recordMetric('initial_memory', 0);
      
      // Simulate heavy operations
      final data = List.generate(10000, (i) => 'data_$i');
      final processedData = data.map((item) => item.toUpperCase()).toList();
      
      expect(processedData.length, 10000);
      
      // Memory should not exceed reasonable limits
      final stats = PerformanceService.getPerformanceStats();
      final memoryUsage = stats['memory_usage_mb'] ?? 0.0;
      expect(memoryUsage, lessThan(1000.0)); // Less than 1GB
    });

    test('concurrent operations should not degrade performance', () async {
      final futures = <Future>[];
      final stopwatch = Stopwatch()..start();
      
      // Start 50 concurrent operations
      for (int i = 0; i < 50; i++) {
        futures.add(Future.delayed(
          Duration(milliseconds: 10),
          () => PerformanceService.recordMetric('concurrent_$i', i.toDouble()),
        ));
      }
      
      await Future.wait(futures);
      stopwatch.stop();
      
      // Should complete within 2 seconds despite concurrency
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    test('large data processing should be efficient', () {
      final stopwatch = Stopwatch()..start();
      
      // Process large dataset
      final largeList = List.generate(100000, (i) => i);
      final filtered = largeList.where((x) => x % 2 == 0).toList();
      final mapped = filtered.map((x) => x * 2).toList();
      
      stopwatch.stop();
      
      expect(mapped.length, 50000);
      // Should complete within 1 second
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });

  group('Load Tests', () {
    test('should handle multiple users simulation', () async {
      final stopwatch = Stopwatch()..start();
      final futures = <Future>[];
      
      // Simulate 100 concurrent users
      for (int i = 0; i < 100; i++) {
        futures.add(_simulateUserSession(i));
      }
      
      await Future.wait(futures);
      stopwatch.stop();
      
      // Should handle 100 users within 10 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(10000));
    });

    test('should maintain performance under sustained load', () async {
      final results = <int>[];
      
      // Run 10 iterations of load testing
      for (int i = 0; i < 10; i++) {
        final stopwatch = Stopwatch()..start();
        
        // Simulate operations
        await _simulateSystemLoad();
        
        stopwatch.stop();
        results.add(stopwatch.elapsedMilliseconds);
      }
      
      // Performance should remain consistent
      final averageTime = results.reduce((a, b) => a + b) / results.length;
      final maxDeviation = results.map((time) => (time - averageTime).abs()).reduce((a, b) => a > b ? a : b);
      
      // Maximum deviation should be less than 50% of average
      expect(maxDeviation, lessThan(averageTime * 0.5));
    });
  });
}

/// Simulate a user session
Future<void> _simulateUserSession(int userId) async {
  // Simulate user actions
  await Future.delayed(Duration(milliseconds: 10));
  PerformanceService.recordMetric('user_$userId', userId.toDouble());
  await Future.delayed(Duration(milliseconds: 5));
}

/// Simulate system load
Future<void> _simulateSystemLoad() async {
  final futures = <Future>[];
  
  // Simulate various operations
  for (int i = 0; i < 20; i++) {
    futures.add(Future.delayed(
      Duration(milliseconds: 5),
      () => PerformanceService.recordMetric('load_test_$i', i.toDouble()),
    ));
  }
  
  await Future.wait(futures);
}
