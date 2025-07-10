import 'package:flutter_test/flutter_test.dart';
import 'package:wisme_app2/config/app_config.dart';

void main() {
  group('AppConfig Tests', () {
    test('should have correct default values', () {
      expect(AppConfig.maxCacheSizeMB, 500);
      expect(AppConfig.maxOfflineContentMB, 200);
      expect(AppConfig.maxContentBlocksPerSession, 10);
      expect(AppConfig.enableAnalytics, true);
      expect(AppConfig.enableCrashReporting, true);
    });

    test('should validate production readiness correctly', () {
      // In test environment, API keys will be empty by default
      expect(AppConfig.isConfiguredForProduction, false);
    });

    test('should have correct timeout values', () {
      expect(AppConfig.contentGenerationTimeout, const Duration(seconds: 45));
      expect(AppConfig.audioLoadTimeout, const Duration(seconds: 30));
      expect(AppConfig.sessionTimeout, const Duration(hours: 24));
    });

    test('should have correct security settings', () {
      expect(AppConfig.maxLoginAttempts, 5);
      expect(AppConfig.lockoutDuration, const Duration(minutes: 15));
      expect(AppConfig.requireBiometricAuth, false);
    });

    test('should have correct cache settings', () {
      expect(AppConfig.cacheExpiryDuration, const Duration(days: 7));
      expect(AppConfig.backgroundSyncInterval, const Duration(minutes: 30));
    });

    test('should have correct analytics settings', () {
      expect(AppConfig.analyticsFlushInterval, const Duration(minutes: 5));
      expect(AppConfig.maxAnalyticsEvents, 1000);
    });

    test('should have correct offline settings', () {
      expect(AppConfig.maxOfflineActions, 100);
      expect(AppConfig.offlineSyncRetryInterval, const Duration(minutes: 5));
      expect(AppConfig.maxOfflineRetryAttempts, 5);
    });

    test('should have correct content quality settings', () {
      expect(AppConfig.minContentSimilarityThreshold, 0.7);
      expect(AppConfig.maxContentReuseAge, 30);
      expect(AppConfig.contentQualityThreshold, 0.8);
    });

    test('config status should return correct information', () {
      final status = AppConfig.configStatus;
      expect(status, isA<Map<String, dynamic>>());
      expect(status.containsKey('openai_configured'), true);
      expect(status.containsKey('elevenlabs_configured'), true);
      expect(status.containsKey('is_production'), true);
      expect(status.containsKey('enable_debug_logging'), true);
    });
  });
}
