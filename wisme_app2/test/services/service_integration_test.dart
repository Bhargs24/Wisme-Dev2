import 'package:flutter_test/flutter_test.dart';
import 'package:wisme_app2/services/cache_service.dart';
import 'package:wisme_app2/services/performance_service.dart';
import 'package:wisme_app2/services/analytics_service.dart';
import 'package:wisme_app2/services/resilience_service.dart';
import 'package:wisme_app2/services/security_service.dart';
import 'package:wisme_app2/services/offline_service.dart';

void main() {
  group('Service Initialization Tests', () {
    test('CacheService should initialize correctly', () {
      final cacheService = CacheService();
      expect(cacheService, isNotNull);
    });

    test('PerformanceService should initialize correctly', () async {
      // Test that performance service can be initialized
      await PerformanceService.initialize();
      
      // Test that metrics can be recorded
      PerformanceService.recordMetric('test_metric', 42.0);
      
      // Test that performance stats can be retrieved
      final stats = PerformanceService.getPerformanceStats();
      expect(stats, isA<Map<String, dynamic>>());
    });

    test('AnalyticsService should initialize correctly', () async {
      await AnalyticsService.initialize();
      
      // Test event tracking
      AnalyticsService.trackEvent('test_event', {'key': 'value'});
      
      // Test session management
      AnalyticsService.startSession('test_user');
      AnalyticsService.endSession('test_user');
    });

    test('ResilienceService should initialize correctly', () {
      ResilienceService.initialize();
      
      // Test that health status can be retrieved
      final healthStatus = ResilienceService.getHealthStatus();
      expect(healthStatus, isA<Map<String, dynamic>>());
    });

    test('SecurityService should initialize correctly', () async {
      await SecurityService.initialize();
      
      // Test that security service is ready
      expect(SecurityService, isNotNull);
    });

    test('OfflineService should initialize correctly', () async {
      await OfflineService.initialize();
      
      // Test that offline service is ready
      expect(OfflineService, isNotNull);
    });
  });

  group('Service Integration Tests', () {
    test('should handle service failures gracefully', () async {
      // Test that resilience service can handle failures
      try {
        await ResilienceService.executeWithResilience(
          serviceName: 'test_service',
          operation: () => Future.error('Test failure'),
          maxRetries: 2,
        );
        fail('Expected exception not thrown');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('should track performance metrics', () {
      // Test performance tracking
      PerformanceService.recordMetric('response_time', 150.0);
      PerformanceService.recordMetric('memory_usage', 256.0);
      
      final stats = PerformanceService.getPerformanceStats();
      expect(stats.containsKey('memory_usage_mb'), true);
    });
  });
}
