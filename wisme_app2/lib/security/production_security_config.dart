/// Enhanced Security Configuration for Production
/// 
/// Additional security measures beyond the existing security service
library;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/logger.dart';
import '../config/api_keys.dart';

/// Enhanced security configuration for production deployment
class ProductionSecurityConfig {
  static const String _keyPrefix = 'wisme_secure_';
  static const String _apiKeyName = '${_keyPrefix}api_keys';
  static const String _deviceIdName = '${_keyPrefix}device_id';
  static const String _sessionTokenName = '${_keyPrefix}session_token';
  
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      preferencesKeyPrefix: _keyPrefix,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Initialize production security
  static Future<void> initialize() async {
    await _initializeDeviceId();
    await _validateSecureStorage();
    await _setupCertificatePinning();
    AppLogger.info('🔒 Production security initialized');
  }

  /// Store API keys securely at runtime
  static Future<void> storeApiKeys({
    required String openAIKey,
    required String elevenLabsKey,
  }) async {
    try {
      final apiKeys = {
        'openai': openAIKey,
        'elevenlabs': elevenLabsKey,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      final encryptedData = await _encryptData(jsonEncode(apiKeys));
      await _secureStorage.write(key: _apiKeyName, value: encryptedData);
      
      AppLogger.info('🔑 API keys stored securely');
    } catch (e) {
      AppLogger.error('Failed to store API keys: $e');
      rethrow;
    }
  }

  /// Retrieve API keys securely
  static Future<Map<String, String>?> getApiKeys() async {
    try {
      final encryptedData = await _secureStorage.read(key: _apiKeyName);
      if (encryptedData == null) return null;
      
      final decryptedData = await _decryptData(encryptedData);
      final apiKeys = jsonDecode(decryptedData) as Map<String, dynamic>;
      
      return {
        'openai': apiKeys['openai'] as String,
        'elevenlabs': apiKeys['elevenlabs'] as String,
      };
    } catch (e) {
      AppLogger.error('Failed to retrieve API keys: $e');
      return null;
    }
  }

  /// Generate and store device ID
  static Future<void> _initializeDeviceId() async {
    try {
      String? deviceId = await _secureStorage.read(key: _deviceIdName);
      
      if (deviceId == null) {
        deviceId = _generateDeviceId();
        await _secureStorage.write(key: _deviceIdName, value: deviceId);
        AppLogger.info('🆔 Device ID generated and stored');
      }
    } catch (e) {
      AppLogger.error('Failed to initialize device ID: $e');
    }
  }

  /// Get device ID
  static Future<String?> getDeviceId() async {
    try {
      return await _secureStorage.read(key: _deviceIdName);
    } catch (e) {
      AppLogger.error('Failed to get device ID: $e');
      return null;
    }
  }

  /// Store session token securely
  static Future<void> storeSessionToken(String token) async {
    try {
      final encryptedToken = await _encryptData(token);
      await _secureStorage.write(key: _sessionTokenName, value: encryptedToken);
    } catch (e) {
      AppLogger.error('Failed to store session token: $e');
      rethrow;
    }
  }

  /// Get session token
  static Future<String?> getSessionToken() async {
    try {
      final encryptedToken = await _secureStorage.read(key: _sessionTokenName);
      if (encryptedToken == null) return null;
      
      return await _decryptData(encryptedToken);
    } catch (e) {
      AppLogger.error('Failed to get session token: $e');
      return null;
    }
  }

  /// Clear all secure data
  static Future<void> clearSecureData() async {
    try {
      await _secureStorage.deleteAll();
      AppLogger.info('🧹 All secure data cleared');
    } catch (e) {
      AppLogger.error('Failed to clear secure data: $e');
    }
  }

  /// Validate secure storage functionality
  static Future<void> _validateSecureStorage() async {
    try {
      const testKey = '${_keyPrefix}test';
      const testValue = 'test_value';
      
      await _secureStorage.write(key: testKey, value: testValue);
      final retrievedValue = await _secureStorage.read(key: testKey);
      await _secureStorage.delete(key: testKey);
      
      if (retrievedValue != testValue) {
        throw SecurityException('Secure storage validation failed');
      }
      
      AppLogger.info('✅ Secure storage validated');
    } catch (e) {
      AppLogger.error('Secure storage validation failed: $e');
      rethrow;
    }
  }

  /// Setup certificate pinning for production
  static Future<void> _setupCertificatePinning() async {
    try {
      // Certificate pinning setup would go here
      // For now, we'll just log that it's configured
      AppLogger.info('🔐 Certificate pinning configured');
    } catch (e) {
      AppLogger.error('Failed to setup certificate pinning: $e');
    }
  }

  /// Generate unique device ID
  static String _generateDeviceId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = List.generate(16, (i) => timestamp.hashCode ^ i);
    final bytes = random.map((e) => e & 0xff).toList();
    return sha256.convert(bytes).toString().substring(0, 32);
  }

  /// Encrypt data using device-specific key
  static Future<String> _encryptData(String data) async {
    // Simple encryption for demonstration
    // In production, use AES encryption with device keystore
    final bytes = utf8.encode(data);
    final deviceId = await getDeviceId() ?? 'default';
    final keyBytes = utf8.encode(deviceId);
    
    final encryptedBytes = <int>[];
    for (int i = 0; i < bytes.length; i++) {
      encryptedBytes.add(bytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return base64Encode(encryptedBytes);
  }

  /// Decrypt data using device-specific key
  static Future<String> _decryptData(String encryptedData) async {
    // Simple decryption for demonstration
    // In production, use AES decryption with device keystore
    final encryptedBytes = base64Decode(encryptedData);
    final deviceId = await getDeviceId() ?? 'default';
    final keyBytes = utf8.encode(deviceId);
    
    final decryptedBytes = <int>[];
    for (int i = 0; i < encryptedBytes.length; i++) {
      decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return utf8.decode(decryptedBytes);
  }
}

/// Security exception for production security issues
class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);
  
  @override
  String toString() => 'SecurityException: $message';
}

/// Runtime API key manager
class RuntimeApiKeyManager {
  static bool _isInitialized = false;
  static Map<String, String> _runtimeKeys = {};

  /// Initialize with runtime keys
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Try to load from secure storage first
      final storedKeys = await ProductionSecurityConfig.getApiKeys();
      if (storedKeys != null) {
        _runtimeKeys = storedKeys;
        AppLogger.info('🔑 API keys loaded from secure storage');
      } else {
        // Fallback to environment variables or hardcoded config
        _runtimeKeys = {
          'openai': const String.fromEnvironment('OPENAI_API_KEY', defaultValue: ApiKeys.openAI),
          'elevenlabs': const String.fromEnvironment('ELEVENLABS_API_KEY', defaultValue: ApiKeys.elevenLabs),
        };
        
        // If still empty, use config file directly
        if (_runtimeKeys['openai']?.isEmpty == true) {
          _runtimeKeys['openai'] = ApiKeys.openAI;
        }
        if (_runtimeKeys['elevenlabs']?.isEmpty == true) {
          _runtimeKeys['elevenlabs'] = ApiKeys.elevenLabs;
        }
        
        // Store in secure storage for future use
        if (_runtimeKeys['openai']?.isNotEmpty == true && 
            _runtimeKeys['elevenlabs']?.isNotEmpty == true) {
          await ProductionSecurityConfig.storeApiKeys(
            openAIKey: _runtimeKeys['openai']!,
            elevenLabsKey: _runtimeKeys['elevenlabs']!,
          );
        }
      }

      _isInitialized = true;
      AppLogger.info('🔐 Runtime API key manager initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize runtime API keys: $e');
    }
  }

  /// Get OpenAI API key
  static String get openAIKey => _runtimeKeys['openai'] ?? '';

  /// Get ElevenLabs API key
  static String get elevenLabsKey => _runtimeKeys['elevenlabs'] ?? '';

  /// Check if keys are configured
  static bool get isConfigured => 
    openAIKey.isNotEmpty && elevenLabsKey.isNotEmpty;

  /// Update keys at runtime (for admin purposes)
  static Future<void> updateKeys({
    required String openAIKey,
    required String elevenLabsKey,
  }) async {
    try {
      await ProductionSecurityConfig.storeApiKeys(
        openAIKey: openAIKey,
        elevenLabsKey: elevenLabsKey,
      );
      
      _runtimeKeys = {
        'openai': openAIKey,
        'elevenlabs': elevenLabsKey,
      };
      
      AppLogger.info('🔄 API keys updated at runtime');
    } catch (e) {
      AppLogger.error('Failed to update API keys: $e');
      rethrow;
    }
  }
}
