import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Anonymous sign-in for demo/research
  static Future<User?> signInAnonymously() async {
    final result = await auth.signInAnonymously();
    return result.user;
  }

  // User profile CRUD
  static Future<void> createOrUpdateUserProfile(String uid, Map<String, dynamic> data) async {
    await firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }
  static Future<DocumentSnapshot> getUserProfile(String uid) async {
    return firestore.collection('users').doc(uid).get();
  }

  // Fetch journeys/episodes
  static Future<QuerySnapshot> getJourneys() async {
    return firestore.collection('journeys').where('isActive', isEqualTo: true).get();
  }
  static Future<QuerySnapshot> getEpisodes(String journeyId) async {
    return firestore.collection('episodes').where('journeyId', isEqualTo: journeyId).get();
  }

  // Progress update
  static Future<void> updateUserProgress(String userJourneyId, Map<String, dynamic> data) async {
    await firestore.collection('user_progress').doc(userJourneyId).set(data, SetOptions(merge: true));
  }

  // Feedback submission
  static Future<void> submitFeedback(Map<String, dynamic> data) async {
    await firestore.collection('feedback').add(data);
  }

  // Analytics event logging
  static Future<void> logEvent(String name, Map<String, dynamic> params) async {
    await analytics.logEvent(name: name, parameters: params);
  }
} 