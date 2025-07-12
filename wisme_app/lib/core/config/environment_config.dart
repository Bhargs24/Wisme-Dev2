import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment Configuration Service
/// Handles all environment variables and API configurations
/// Provides secure access to sensitive configuration data
class EnvironmentConfig {
  static bool _isInitialized = false;
  
  /// Initialize environment configuration
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await dotenv.load(fileName: ".env");
      _isInitialized = true;
    } catch (e) {
      // In production, environment variables might be set differently
      print('Warning: .env file not found. Using system environment variables.');
      _isInitialized = true;
    }
  }
  
  /// Get environment variable with fallback
  static String _getEnv(String key, {String? fallback}) {
    return dotenv.env[key] ?? fallback ?? '';
  }
  
  // Supabase Configuration
  static String get supabaseUrl => _getEnv('SUPABASE_URL');
  static String get supabaseAnonKey => _getEnv('SUPABASE_ANON_KEY');
  static String get supabaseServiceRoleKey => _getEnv('SUPABASE_SERVICE_ROLE_KEY');
  
  // Authentication Services
  static String get googleClientId => _getEnv('GOOGLE_CLIENT_ID');
  static String get googleClientSecret => _getEnv('GOOGLE_CLIENT_SECRET');
  static String get appleClientId => _getEnv('APPLE_CLIENT_ID');
  static String get appleTeamId => _getEnv('APPLE_TEAM_ID');
  static String get appleKeyId => _getEnv('APPLE_KEY_ID');
  
  // AI Services
  static String get openaiApiKey => _getEnv('OPENAI_API_KEY');
  static String get claudeApiKey => _getEnv('CLAUDE_API_KEY');
  static String get playhtApiKey => _getEnv('PLAYHT_API_KEY');
  static String get playhtUserId => _getEnv('PLAYHT_USER_ID');
  static String get elevenlabsApiKey => _getEnv('ELEVENLABS_API_KEY');
  
  // Email Service
  static String get sendgridApiKey => _getEnv('SENDGRID_API_KEY');
  static String get smtpHost => _getEnv('SMTP_HOST');
  static int get smtpPort => int.tryParse(_getEnv('SMTP_PORT')) ?? 587;
  static String get smtpUsername => _getEnv('SMTP_USERNAME');
  static String get smtpPassword => _getEnv('SMTP_PASSWORD');
  
  // Analytics
  static String get firebaseApiKey => _getEnv('FIREBASE_API_KEY');
  static String get mixpanelToken => _getEnv('MIXPANEL_TOKEN');
  
  // Search Services
  static String get algoliaAppId => _getEnv('ALGOLIA_APP_ID');
  static String get algoliaApiKey => _getEnv('ALGOLIA_API_KEY');
  static String get algoliaSearchKey => _getEnv('ALGOLIA_SEARCH_KEY');
  
  // App Configuration
  static String get appName => _getEnv('APP_NAME', fallback: 'Wisme');
  static String get appVersion => _getEnv('APP_VERSION', fallback: '1.0.0');
  static String get appEnvironment => _getEnv('APP_ENVIRONMENT', fallback: 'development');
  static bool get debugMode => _getEnv('DEBUG_MODE').toLowerCase() == 'true';
  
  // Security
  static String get jwtSecret => _getEnv('JWT_SECRET');
  static String get encryptionKey => _getEnv('ENCRYPTION_KEY');
  
  // CDN and Storage
  static String get cdnBaseUrl => _getEnv('CDN_BASE_URL');
  static String get storageBucket => _getEnv('STORAGE_BUCKET');
  
  /// Check if all required environment variables are set
  static bool get isConfigured {
    final required = [
      supabaseUrl,
      supabaseAnonKey,
      openaiApiKey,
      playhtApiKey,
    ];
    
    return required.every((value) => value.isNotEmpty);
  }
  
  /// Get configuration status for debugging
  static Map<String, bool> get configurationStatus {
    return {
      'Supabase': supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty,
      'OpenAI': openaiApiKey.isNotEmpty,
      'PlayHT': playhtApiKey.isNotEmpty && playhtUserId.isNotEmpty,
      'ElevenLabs': elevenlabsApiKey.isNotEmpty,
      'Google OAuth': googleClientId.isNotEmpty,
      'Apple Sign-In': appleClientId.isNotEmpty,
      'SendGrid': sendgridApiKey.isNotEmpty,
      'Firebase': firebaseApiKey.isNotEmpty,
      'Algolia': algoliaAppId.isNotEmpty && algoliaApiKey.isNotEmpty,
    };
  }
  
  /// Print configuration status (for debugging)
  static void printConfigurationStatus() {
    print('=== Wisme Configuration Status ===');
    configurationStatus.forEach((service, isConfigured) {
      final status = isConfigured ? '✅' : '❌';
      print('$status $service: ${isConfigured ? 'Configured' : 'Missing'}');
    });
    print('================================');
  }
}
