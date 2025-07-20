/// Audio Service Registry
/// Central registry for managing audio services and providers
library;

import '../services/hybrid_tts_service.dart';
import '../services/two_speaker_audio_system.dart';
import '../config/api_config.dart';

/// Service status enum
enum ServiceStatus {
  uninitialized,
  initializing,
  ready,
  error,
  offline
}

/// Audio service info
class AudioServiceInfo {
  final String name;
  final ServiceStatus status;
  final String version;
  final Map<String, dynamic> capabilities;
  final String? errorMessage;

  const AudioServiceInfo({
    required this.name,
    required this.status,
    required this.version,
    this.capabilities = const {},
    this.errorMessage,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'status': status.name,
    'version': version,
    'capabilities': capabilities,
    'errorMessage': errorMessage,
  };
}

/// Central registry for audio services
class AudioServiceRegistry {
  static AudioServiceRegistry? _instance;
  static final Map<String, AudioServiceInfo> _services = {};
  static bool _initialized = false;

  // Private constructor
  AudioServiceRegistry._();

  /// Get singleton instance
  static AudioServiceRegistry get instance {
    _instance ??= AudioServiceRegistry._();
    return _instance!;
  }

  /// Initialize all audio services
  static Future<void> initialize() async {
    if (_initialized) return;

    print('🎵 Initializing Audio Service Registry...');
    
    try {
      // Initialize Hybrid TTS Service
      print('🔧 Initializing Hybrid TTS Service...');
      _services['hybrid_tts'] = const AudioServiceInfo(
        name: 'Hybrid TTS Service',
        status: ServiceStatus.initializing,
        version: '1.0.0',
      );
      
      await HybridTTSService.initialize();
      print('✅ Hybrid TTS Service initialized');
      
      _services['hybrid_tts'] = AudioServiceInfo(
        name: 'Hybrid TTS Service',
        status: ServiceStatus.ready,
        version: '1.0.0',
        capabilities: {
          'providers': HybridTTSService.availableProviders,
          'configured': HybridTTSService.isConfigured,
        },
      );

      // Register Two Speaker Audio System
      print('🔧 Initializing Two Speaker Audio System...');
      _services['two_speaker'] = const AudioServiceInfo(
        name: 'Two Speaker Audio System',
        status: ServiceStatus.initializing,
        version: '1.0.0',
      );

      print('✅ Two Speaker Audio System ready');
      _services['two_speaker'] = AudioServiceInfo(
        name: 'Two Speaker Audio System',
        status: ServiceStatus.ready,
        version: '1.0.0',
        capabilities: {
          'voices': TwoSpeakerAudioSystem.availableVoices.keys.toList(),
          'configured': TwoSpeakerAudioSystem.isConfigured,
        },
      );

      print('✅ Audio Service Registry initialized successfully');
      _initialized = true;

    } catch (e) {
      print('❌ Failed to initialize Audio Service Registry: $e');
      
      // Mark failed services
      for (final key in _services.keys) {
        _services[key] = AudioServiceInfo(
          name: _services[key]!.name,
          status: ServiceStatus.error,
          version: _services[key]!.version,
          errorMessage: e.toString(),
        );
      }
      
      rethrow;
    }
  }

  /// Get service information
  static AudioServiceInfo? getServiceInfo(String serviceName) {
    return _services[serviceName];
  }

  /// Get all registered services
  static Map<String, AudioServiceInfo> getAllServices() {
    return Map.from(_services);
  }

  /// Check if a specific service is ready
  static bool isServiceReady(String serviceName) {
    final service = _services[serviceName];
    return service?.status == ServiceStatus.ready;
  }

  /// Check if all services are ready
  static bool get allServicesReady {
    return _services.values.every(
      (service) => service.status == ServiceStatus.ready,
    );
  }

  /// Get registry status summary
  static Map<String, dynamic> getStatusSummary() {
    final readyCount = _services.values
        .where((service) => service.status == ServiceStatus.ready)
        .length;
    
    final errorCount = _services.values
        .where((service) => service.status == ServiceStatus.error)
        .length;

    return {
      'initialized': _initialized,
      'totalServices': _services.length,
      'readyServices': readyCount,
      'errorServices': errorCount,
      'allReady': allServicesReady,
      'services': _services.map((key, service) => MapEntry(key, service.toJson())),
    };
  }

  /// Health check for all services
  static Future<Map<String, bool>> performHealthCheck() async {
    final results = <String, bool>{};
    
    print('🔍 Performing audio services health check...');
    
    // Check Hybrid TTS Service
    try {
      results['hybrid_tts'] = HybridTTSService.isConfigured;
      print('✅ Hybrid TTS Service health check passed');
    } catch (e) {
      results['hybrid_tts'] = false;
      print('❌ Hybrid TTS Service health check failed: $e');
    }

    // Check Two Speaker Audio System  
    try {
      results['two_speaker'] = TwoSpeakerAudioSystem.isConfigured;
      print('✅ Two Speaker Audio System health check passed');
    } catch (e) {
      results['two_speaker'] = false;
      print('❌ Two Speaker Audio System health check failed: $e');
    }

    print('🔍 Health check completed');
    print('🔍 Results: $results');
    return results;
  }

  /// Reset the registry (for testing)
  static void reset() {
    _services.clear();
    _initialized = false;
  }

  /// Get service statistics
  static Future<Map<String, dynamic>> getServiceStatistics() async {
    final stats = <String, dynamic>{};
    
    // Get TTS service stats
    if (isServiceReady('hybrid_tts')) {
      try {
        stats['hybrid_tts'] = HybridTTSService.getStats();
      } catch (e) {
        print('Failed to get Hybrid TTS stats: $e');
      }
    }

    return stats;
  }

  /// Check API configuration status
  static Map<String, bool> getApiConfigurationStatus() {
    return {
      'openai': ApiConfig.isOpenAiConfigured,
      'claude': ApiConfig.isClaudeConfigured,
      'playht': ApiConfig.isPlayHtConfigured,
      'elevenlabs': ApiConfig.isElevenlabsConfigured,
    };
  }

  /// Initialize services (instance method)
  Future<void> initializeServices() async {
    await AudioServiceRegistry.initialize();
  }

  /// Get service status (instance method)
  Map<String, dynamic> getServiceStatus() {
    return {
      'initialized': _initialized,
      'services': _services.map((key, value) => MapEntry(key, value.toJson())),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
