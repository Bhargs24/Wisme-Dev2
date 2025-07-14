import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/environment_config.dart';
import '../../models/models.dart';

/// Supabase Service - Backend integration for Wisme
/// Handles authentication, data storage, and real-time features
class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;
  static User? get currentUser => client.auth.currentUser;

  /// Initialize Supabase with environment configuration
  static Future<void> initialize() async {
    await EnvironmentConfig.initialize();
    
    final supabaseUrl = EnvironmentConfig.supabaseUrl;
    final supabaseKey = EnvironmentConfig.supabaseAnonKey;
    
    if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
      throw Exception(
        'Supabase configuration missing. Please set SUPABASE_URL and SUPABASE_ANON_KEY in your environment variables.'
      );
    }
    
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }

  /// Authentication Methods
  static Future<AuthResponse> signUpWithEmail(String email, String password, String name) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
    
    // Create user profile after signup
    if (response.user != null) {
      await _createUserProfile(response.user!, name);
    }
    
    return response;
  }

  static Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<bool> signInWithGoogle() async {
    return await client.auth.signInWithOAuth(OAuthProvider.google);
  }

  static Future<bool> signInWithApple() async {
    return await client.auth.signInWithOAuth(OAuthProvider.apple);
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// User Profile Management
  static Future<void> _createUserProfile(User user, String name) async {
    await client.from('user_profiles').insert({
      'user_id': user.id,
      'email': user.email,
      'name': name,
      'created_at': DateTime.now().toIso8601String(),
      'learning_streak': 0,
      'total_episodes_completed': 0,
      'preferred_coach': 'Kai',
      'learning_style': 'Balanced',
    });
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser == null) return null;

    final response = await client
        .from('user_profiles')
        .select()
        .eq('user_id', currentUser!.id)
        .single();

    return response;
  }

  static Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    if (currentUser == null) return;

    await client
        .from('user_profiles')
        .update(updates)
        .eq('user_id', currentUser!.id);
  }

  /// Episode Management
  static Future<String> saveEpisode(Episode episode) async {
    final response = await client.from('episodes').insert({
      'user_id': currentUser?.id,
      'title': episode.title,
      'content': episode.content, // Use content instead of script
      'category': episode.category,
      'knowledge_level': episode.knowledgeLevel,
      'coach_personality': episode.coachPersonality,
      'duration_minutes': episode.durationMinutes, // Use durationMinutes
      'hashtags': episode.hashtags,
      'created_at': DateTime.now().toIso8601String(),
      'is_completed': false,
      'completion_percentage': 0.0,
    }).select().single();

    return response['id'];
  }

  static Future<List<Episode>> getUserEpisodes() async {
    if (currentUser == null) return [];

    final response = await client
        .from('episodes')
        .select()
        .eq('user_id', currentUser!.id)
        .order('created_at', ascending: false);

    return response.map<Episode>((data) => Episode.fromJson(data)).toList();
  }

  static Future<void> updateEpisodeProgress(String episodeId, double progressPercentage, bool isCompleted) async {
    await client.from('episodes').update({
      'completion_percentage': progressPercentage,
      'is_completed': isCompleted,
      'last_played_at': DateTime.now().toIso8601String(),
    }).eq('id', episodeId);

    // Update user stats if episode completed
    if (isCompleted) {
      await _incrementUserStats();
    }
  }

  static Future<void> updateEpisode(Episode episode) async {
    if (episode.id == null) return;
    
    await client.from('episodes').update(episode.toJson()).eq('id', episode.id!);
  }

  static Future<void> _incrementUserStats() async {
    if (currentUser == null) return;

    await client.rpc('increment_user_stats', params: {
      'user_id_param': currentUser!.id,
    });
  }

  /// Content Discovery & Search
  static Future<List<Episode>> searchEpisodes(String query) async {
    final response = await client
        .from('episodes')
        .select()
        .textSearch('title,content', "'$query'")
        .limit(20);

    return response.map<Episode>((data) => Episode.fromJson(data)).toList();
  }

  static Future<List<Episode>> getEpisodesByCategory(String category) async {
    final response = await client
        .from('episodes')
        .select()
        .eq('category', category)
        .order('created_at', ascending: false)
        .limit(10);

    return response.map<Episode>((data) => Episode.fromJson(data)).toList();
  }

  static Future<List<Episode>> getRecommendedEpisodes() async {
    if (currentUser == null) return [];

    // Get user's preferred categories and learning style
    final profile = await getUserProfile();
    final preferredCoach = profile?['preferred_coach'] ?? 'Kai';

    final response = await client
        .from('episodes')
        .select()
        .eq('coach_personality', preferredCoach)
        .eq('is_completed', false)
        .order('created_at', ascending: false)
        .limit(5);

    return response.map<Episode>((data) => Episode.fromJson(data)).toList();
  }

  /// Learning Analytics
  static Future<Map<String, dynamic>> getLearningStats() async {
    if (currentUser == null) return {};

    final response = await client
        .from('user_learning_stats')
        .select()
        .eq('user_id', currentUser!.id)
        .single();

    return response;
  }

  static Future<void> trackLearningSession(String episodeId, int durationSeconds) async {
    if (currentUser == null) return;

    await client.from('learning_sessions').insert({
      'user_id': currentUser!.id,
      'episode_id': episodeId,
      'duration_seconds': durationSeconds,
      'session_date': DateTime.now().toIso8601String(),
    });
  }

  /// Real-time Features
  static Stream<List<Episode>> watchUserEpisodes() {
    if (currentUser == null) return Stream.empty();

    return client
        .from('episodes')
        .stream(primaryKey: ['id'])
        .eq('user_id', currentUser!.id)
        .order('created_at', ascending: false)
        .map((data) => data.map<Episode>((item) => Episode.fromJson(item)).toList());
  }

  /// Offline Support
  static Future<void> syncOfflineData() async {
    // Sync offline data when connection is restored
    // Handles uploading locally stored episodes and progress
    try {
      // In production: implement actual sync logic
      // 1. Check for offline data
      // 2. Upload to Supabase
      // 3. Update local state
    } catch (e) {
      print('Sync failed: $e');
    }
  }
}
