import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseService {
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static FirebaseStorage? _storage;
  static FirebaseAnalytics? _analytics;
  
  static FirebaseAuth get auth {
    _auth ??= FirebaseAuth.instance;
    return _auth!;
  }
  
  static FirebaseFirestore get firestore {
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!;
  }
  
  static FirebaseStorage get storage {
    _storage ??= FirebaseStorage.instance;
    return _storage!;
  }
  
  static FirebaseAnalytics get analytics {
    _analytics ??= FirebaseAnalytics.instance;
    return _analytics!;
  }

  // Google Sign-In for research participants
  static Future<User?> signInWithGoogle() async {
    try {
      // Note: You'll need to add google_sign_in package for full implementation
      // For now, this is a placeholder that would integrate with GoogleSignIn
      print('Google Sign-In would be implemented here');
      return null;
    } catch (e) {
      print('Google sign-in failed: $e');
      return null;
    }
  }

  // Email/Password Authentication
  static Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Email sign-in failed: $e');
      rethrow;
    }
  }

  static Future<User?> registerWithEmail(String email, String password) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Send verification email
      await result.user?.sendEmailVerification();
      return result.user;
    } catch (e) {
      print('Email registration failed: $e');
      rethrow;
    }
  }

  // Phone Authentication for better verification
  static Future<User?> signInWithPhone(String phoneNumber) async {
    try {
      // This would implement phone number verification
      // Requires additional setup in Firebase console
      print('Phone authentication would be implemented here');
      return null;
    } catch (e) {
      print('Phone sign-in failed: $e');
      rethrow;
    }
  }

  // Anonymous sign-in for demo/research
  static Future<User?> signInAnonymously() async {
    final result = await auth.signInAnonymously();
    return result.user;
  }

  // User profile CRUD
  static Future<void> createOrUpdateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      print('Failed to update user profile: $e');
    }
  }
  
  static Future<DocumentSnapshot?> getUserProfile(String uid) async {
    try {
      return await firestore.collection('users').doc(uid).get();
    } catch (e) {
      print('Failed to get user profile: $e');
      return null;
    }
  }

  // Fetch journeys/episodes
  static Future<QuerySnapshot?> getJourneys() async {
    try {
      return await firestore.collection('journeys').where('isActive', isEqualTo: true).get();
    } catch (e) {
      print('Failed to get journeys: $e');
      return null;
    }
  }
  static Future<QuerySnapshot?> getEpisodes(String journeyId) async {
    try {
      return await firestore.collection('episodes').where('journeyId', isEqualTo: journeyId).get();
    } catch (e) {
      print('Failed to get episodes: $e');
      return null;
    }
  }

  // Progress update
  static Future<void> updateUserProgress(String userJourneyId, Map<String, dynamic> data) async {
    try {
      await firestore.collection('user_progress').doc(userJourneyId).set(data, SetOptions(merge: true));
    } catch (e) {
      print('Failed to update progress: $e');
    }
  }

  // Feedback submission
  static Future<void> submitFeedback(Map<String, dynamic> data) async {
    try {
      await firestore.collection('feedback').add(data);
    } catch (e) {
      print('Failed to submit feedback: $e');
    }
  }

  // Analytics event logging
  static Future<void> logEvent(String name, Map<String, dynamic> params) async {
    try {
      // Convert dynamic values to supported types for Firebase Analytics
      final convertedParams = <String, Object>{};
      params.forEach((key, value) {
        if (value is String || value is int || value is double || value is bool) {
          convertedParams[key] = value;
        } else {
          convertedParams[key] = value.toString();
        }
      });
      await analytics.logEvent(name: name, parameters: convertedParams);
    } catch (e) {
      print('Failed to log analytics event: $e');
    }
  }

  // Data Validation & Anti-Fraud Methods
  static Future<void> submitValidatedFeedback(Map<String, dynamic> data, String userId) async {
    try {
      // Add validation metadata
      final validatedData = {
        ...data,
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
        'sessionId': _generateSessionId(),
        'deviceFingerprint': await _getDeviceFingerprint(),
        'timeSpentMs': data['timeSpentMs'] ?? 0,
        'validated': true,
      };

      // Check for suspicious patterns
      if (_isDataSuspicious(validatedData)) {
        validatedData['flagged'] = true;
        validatedData['flagReason'] = 'Suspicious timing or patterns';
      }

      await firestore.collection('validated_feedback').add(validatedData);
    } catch (e) {
      print('Failed to submit validated feedback: $e');
    }
  }

  static Future<void> logUserActivity(String userId, String activity, Map<String, dynamic> context) async {
    try {
      await firestore.collection('user_activity_log').add({
        'userId': userId,
        'activity': activity,
        'context': context,
        'timestamp': DateTime.now().toIso8601String(),
        'sessionId': _getCurrentSessionId(),
        'deviceInfo': await _getDeviceFingerprint(),
      });
    } catch (e) {
      print('Failed to log user activity: $e');
    }
  }

  // Anti-fraud validation
  static bool _isDataSuspicious(Map<String, dynamic> data) {
    // Check for impossibly fast completion
    final timeSpent = data['timeSpentMs'] as int? ?? 0;
    final minExpectedTime = 30000; // 30 seconds minimum
    if (timeSpent < minExpectedTime) return true;

    // Check for pattern matching (all same answers)
    final answers = data['answers'] as List<dynamic>? ?? [];
    if (answers.length > 3 && answers.every((a) => a == answers.first)) return true;

    return false;
  }

  static String _generateSessionId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String _getCurrentSessionId() {
    // This would track the current session
    return _generateSessionId();
  }

  static Future<Map<String, dynamic>> _getDeviceFingerprint() async {
    return {
      'userAgent': 'browser_user_agent', // Would be detected
      'screenSize': '1920x1080', // Would be detected
      'timezone': DateTime.now().timeZoneName,
      'language': 'en', // Would be detected
    };
  }

  // Analytics Dashboard Data
  static Future<Map<String, dynamic>> getDashboardAnalytics() async {
    try {
      // Get user metrics
      final userSnapshot = await firestore.collection('users').get();
      final feedbackSnapshot = await firestore.collection('user_feedback').get();
      final activitiesSnapshot = await firestore.collection('user_activities').get();

      // Calculate metrics
      int totalUsers = userSnapshot.docs.length;
      int totalFeedback = feedbackSnapshot.docs.length;
      int totalActivities = activitiesSnapshot.docs.length;

      // Calculate engagement metrics
      Map<String, int> dailyActivity = {};
      for (var doc in activitiesSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = data['timestamp'] as Timestamp?;
        if (timestamp != null) {
          final date = timestamp.toDate();
          final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          dailyActivity[dateKey] = (dailyActivity[dateKey] ?? 0) + 1;
        }
      }

      // Calculate retention rates
      Map<String, double> retentionRates = {
        'Week 1': _calculateRetentionRate(userSnapshot.docs, 7),
        'Week 2': _calculateRetentionRate(userSnapshot.docs, 14),
        'Week 3': _calculateRetentionRate(userSnapshot.docs, 21),
        'Month 1': _calculateRetentionRate(userSnapshot.docs, 30),
      };

      // Calculate user demographics
      Map<String, int> demographics = {};
      for (var doc in userSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final journey = data['user_journey'] ?? 'Unknown';
        demographics[journey] = (demographics[journey] ?? 0) + 1;
      }

      return {
        'totalUsers': totalUsers,
        'totalFeedback': totalFeedback,
        'totalActivities': totalActivities,
        'dailyActivity': dailyActivity,
        'retentionRates': retentionRates,
        'demographics': demographics,
        'avgSessionDuration': _calculateAverageSessionDuration(activitiesSnapshot.docs),
        'conversionRate': totalFeedback > 0 ? (totalUsers / totalFeedback * 100).round() : 0,
        'monthlyRevenue': _calculateMonthlyRevenue(),
        'userGrowth': _calculateUserGrowth(userSnapshot.docs),
      };
    } catch (e) {
      print('Error getting dashboard analytics: $e');
      return {
        'totalUsers': 0,
        'totalFeedback': 0,
        'totalActivities': 0,
        'dailyActivity': <String, int>{},
        'retentionRates': <String, double>{},
        'demographics': <String, int>{},
        'avgSessionDuration': 0.0,
        'conversionRate': 0,
        'monthlyRevenue': <String, double>{},
        'userGrowth': <String, int>{},
      };
    }
  }

  static double _calculateRetentionRate(List<QueryDocumentSnapshot> users, int days) {
    if (users.isEmpty) return 0.0;
    
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    int retainedUsers = 0;
    
    for (var doc in users) {
      final data = doc.data() as Map<String, dynamic>;
      final lastActivity = data['last_activity'] as Timestamp?;
      if (lastActivity != null && lastActivity.toDate().isAfter(cutoffDate)) {
        retainedUsers++;
      }
    }
    
    return (retainedUsers / users.length) * 100;
  }

  static double _calculateAverageSessionDuration(List<QueryDocumentSnapshot> activities) {
    if (activities.isEmpty) return 0.0;
    
    double totalDuration = 0;
    int sessionCount = 0;
    
    for (var doc in activities) {
      final data = doc.data() as Map<String, dynamic>;
      final duration = data['session_duration'] as double?;
      if (duration != null) {
        totalDuration += duration;
        sessionCount++;
      }
    }
    
    return sessionCount > 0 ? totalDuration / sessionCount : 0.0;
  }

  static Map<String, double> _calculateMonthlyRevenue() {
    // Simulated revenue data - replace with actual revenue calculations
    final now = DateTime.now();
    Map<String, double> revenue = {};
    
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      revenue[monthKey] = (1000 + (i * 500) + (date.hashCode % 1000)).toDouble();
    }
    
    return revenue;
  }

  static Map<String, int> _calculateUserGrowth(List<QueryDocumentSnapshot> users) {
    Map<String, int> growth = {};
    
    for (var doc in users) {
      final data = doc.data() as Map<String, dynamic>;
      final createdAt = data['created_at'] as Timestamp?;
      if (createdAt != null) {
        final date = createdAt.toDate();
        final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
        growth[monthKey] = (growth[monthKey] ?? 0) + 1;
      }
    }
    
    return growth;
  }
} 