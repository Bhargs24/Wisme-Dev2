import 'package:flutter_test/flutter_test.dart';
import 'package:wisme_app2/config/app_config.dart';

void main() {
  group('EnvironmentConfig Tests', () {
    test('should have correct default environment', () {
      expect(EnvironmentConfig.environment, 'development');
      expect(EnvironmentConfig.isDevelopment, true);
      expect(EnvironmentConfig.isStaging, false);
      expect(EnvironmentConfig.isProduction, false);
    });

    test('should return correct API base URL for development', () {
      expect(EnvironmentConfig.apiBaseUrl, 'https://dev-api.wisme.com');
    });

    test('should have correct headers', () {
      final headers = EnvironmentConfig.headers;
      expect(headers['Content-Type'], 'application/json');
      expect(headers['User-Agent'], 'Wisme-App/${AppVersion.version}');
      expect(headers['Environment'], 'development');
    });
  });

  group('AppVersion Tests', () {
    test('should have correct version information', () {
      expect(AppVersion.version, '1.0.0');
      expect(AppVersion.buildNumber, '1'); // Default value
      expect(AppVersion.gitCommit, 'unknown'); // Default value
      expect(AppVersion.buildDate, 'unknown'); // Default value
    });

    test('should return correct full version', () {
      expect(AppVersion.fullVersion, '1.0.0+1');
    });

    test('should return build info map', () {
      final buildInfo = AppVersion.buildInfo;
      expect(buildInfo, isA<Map<String, String>>());
      expect(buildInfo['version'], '1.0.0');
      expect(buildInfo['build_number'], '1');
      expect(buildInfo['environment'], 'development');
    });
  });
}
