import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class ResearchMetricsProvider extends ChangeNotifier {
  String? _userId;
  Map<String, dynamic> _userProfile = {};
  Map<String, dynamic> _currentSession = {};
  List<Map<String, dynamic>> _completedJourneys = [];
  Map<String, double> _engagementScores = {};
  
  // Getters
  String? get userId => _userId;
  Map<String, dynamic> get userProfile => _userProfile;
  List<Map<String, dynamic>> get completedJourneys => _completedJourneys;

  void setUserId(String uid) {
    _userId = uid;
    _initializeSession();
    notifyListeners();
  }

  void _initializeSession() {
    _currentSession = {
      'sessionId': DateTime.now().millisecondsSinceEpoch.toString(),
      'startTime': DateTime.now().toIso8601String(),
      'interactions': [],
      'engagementEvents': [],
    };
  }

  // ============================================================================
  // STRATEGIC RESEARCH DATA COLLECTION
  // ============================================================================

  // PHASE 1: DEMOGRAPHIC & BASELINE (Non-boring, integrated into onboarding)
  void captureUserDemographics({
    required int age,
    required String education,
    required String occupation,
    required List<String> learningGoals,
    required Map<String, int> subjectFamiliarity,
  }) {
    _userProfile.addAll({
      'demographics': {
        'age': age,
        'education': education,
        'occupation': occupation,
        'learningGoals': learningGoals,
        'capturedAt': DateTime.now().toIso8601String(),
      },
      'baseline': {
        'subjectFamiliarity': subjectFamiliarity,
        'overallLearningExperience': 0, // Will be set during onboarding
      }
    });
    _saveUserProfile();
    notifyListeners();
  }

  // Journey interest tracking (called when user browses/selects journeys)
  void captureJourneyInterest({
    required String journeyId,
    required double interestLevel,
    required DateTime selectionTime,
  }) {
    final interest = {
      'timestamp': selectionTime.toIso8601String(),
      'journeyId': journeyId,
      'interestLevel': interestLevel,
      'sessionId': _currentSession['sessionId'],
    };
    
    FirebaseService.submitFeedback({
      'type': 'journey_interest',
      'userId': _userId,
      'data': interest,
    });
  }

  // PHASE 2: REAL-TIME ENGAGEMENT TRACKING (Invisible, automatic)
  void trackAudioEngagement({
    required String episodeId,
    required String action, // play, pause, seek, complete
    required int position,
    required double speed,
    Map<String, dynamic>? additionalData,
  }) {
    final engagement = {
      'timestamp': DateTime.now().toIso8601String(),
      'episodeId': episodeId,
      'action': action,
      'position': position,
      'speed': speed,
      'sessionTime': DateTime.now().difference(
        DateTime.parse(_currentSession['startTime'])
      ).inSeconds,
      ...?additionalData,
    };
    
    _currentSession['interactions'].add(engagement);
    
    // Calculate engagement score in real-time
    _updateEngagementScore(episodeId);
    
    // Auto-save every 10 interactions
    if (_currentSession['interactions'].length % 10 == 0) {
      _saveSessionData();
    }
  }

  void _updateEngagementScore(String episodeId) {
    final episodeInteractions = _currentSession['interactions']
        .where((i) => i['episodeId'] == episodeId)
        .toList();
    
    if (episodeInteractions.isEmpty) return;
    
    // Proprietary engagement algorithm for investor validation
    double score = 0.0;
    int totalTime = 0;
    int pauseCount = 0;
    int seekCount = 0;
    
    for (var interaction in episodeInteractions) {
      switch (interaction['action']) {
        case 'play':
          score += 1.0;
          break;
        case 'pause':
          pauseCount++;
          if (pauseCount > 5) score -= 0.2; // Too many pauses = distraction
          break;
        case 'seek':
          seekCount++;
          if (seekCount > 3) score -= 0.1; // Too much seeking = confusion
          break;
        case 'complete':
          score += 5.0; // Big bonus for completion
          break;
        case 'replay':
          score += 2.0; // Replay indicates high engagement
          break;
      }
      totalTime = interaction['sessionTime'];
    }
    
    // Normalize and store
    final normalizedScore = (score / (totalTime / 60)).clamp(0.0, 10.0);
    _engagementScores[episodeId] = normalizedScore;
  }

  // PHASE 3: MICRO-FEEDBACK (Smart, contextual, non-intrusive)
  void captureMicroFeedback({
    required String episodeId,
    required String trigger, // end_episode, high_engagement, confusion_detected
    required Map<String, dynamic> feedback,
  }) {
    final microFeedback = {
      'timestamp': DateTime.now().toIso8601String(),
      'episodeId': episodeId,
      'trigger': trigger,
      'feedback': feedback,
      'engagementScore': _engagementScores[episodeId] ?? 0.0,
    };
    
    FirebaseService.submitFeedback({
      'type': 'micro_feedback',
      'userId': _userId,
      'data': microFeedback,
    });
  }

  // PHASE 4: COMPARATIVE ANALYSIS (Journey-to-journey comparison)
  void captureJourneyCompletion({
    required String journeyId,
    required String method, // 'conversational' or 'traditional'
    required Duration totalTime,
    required List<String> completedEpisodes,
    required double overallSatisfaction,
    required Map<String, double> skillConfidence,
  }) {
    final journeyData = {
      'journeyId': journeyId,
      'method': method,
      'completedAt': DateTime.now().toIso8601String(),
      'totalTime': totalTime.inSeconds,
      'completedEpisodes': completedEpisodes,
      'overallSatisfaction': overallSatisfaction,
      'skillConfidence': skillConfidence,
      'engagementScores': _engagementScores.entries
          .where((e) => e.key.startsWith(journeyId))
          .map((e) => {'episodeId': e.key, 'score': e.value})
          .toList(),
    };
    
    _completedJourneys.add(journeyData);
    _saveJourneyData(journeyData);
    notifyListeners();
  }

  // PHASE 5: COMMERCIAL VALIDATION (Strategic, post-experience)
  void captureCommercialIntent({
    required double willingnessToPayMonthly,
    required double perceivedValue,
    required List<String> preferredFeatures,
    required double recommendationScore,
    required Map<String, double> competitiveComparison,
  }) {
    final commercial = {
      'timestamp': DateTime.now().toIso8601String(),
      'willingnessToPayMonthly': willingnessToPayMonthly,
      'perceivedValue': perceivedValue,
      'preferredFeatures': preferredFeatures,
      'npsScore': recommendationScore,
      'competitiveComparison': competitiveComparison,
      'totalJourneysCompleted': _completedJourneys.length,
      'avgEngagementScore': _getAverageEngagementScore(),
    };
    
    FirebaseService.submitFeedback({
      'type': 'commercial_validation',
      'userId': _userId,
      'data': commercial,
    });
  }

  // ============================================================================
  // INVESTOR-CRITICAL METRICS CALCULATION
  // ============================================================================

  double _getAverageEngagementScore() {
    if (_engagementScores.isEmpty) return 0.0;
    return _engagementScores.values.reduce((a, b) => a + b) / _engagementScores.length;
  }

  Map<String, dynamic> getInvestorMetrics() {
    return {
      'userProfile': _userProfile,
      'totalJourneys': _completedJourneys.length,
      'avgEngagementScore': _getAverageEngagementScore(),
      'completionRate': _calculateCompletionRate(),
      'retentionIndicators': _calculateRetentionIndicators(),
      'commercialViability': _calculateCommercialViability(),
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }

  double _calculateCompletionRate() {
    if (_completedJourneys.isEmpty) return 0.0;
    
    int totalEpisodes = 0;
    int completedEpisodes = 0;
    
    for (var journey in _completedJourneys) {
      final episodes = journey['completedEpisodes'] as List<String>;
      completedEpisodes += episodes.length;
      
      // Assume each journey has these episode counts based on documentation
      switch (journey['journeyId']) {
        case 'dsa': totalEpisodes += 5; break;
        case 'os': totalEpisodes += 6; break;
        case 'dbms': totalEpisodes += 7; break;
        case 'finance': totalEpisodes += 6; break;
      }
    }
    
    return totalEpisodes > 0 ? (completedEpisodes / totalEpisodes) : 0.0;
  }

  Map<String, dynamic> _calculateRetentionIndicators() {
    if (_completedJourneys.isEmpty) return {};
    
    final journeyTimes = _completedJourneys.map((j) => 
      DateTime.parse(j['completedAt'])).toList()..sort();
    
    return {
      'sessionConsistency': _calculateSessionConsistency(),
      'journeySpacing': _calculateJourneySpacing(journeyTimes),
      'engagementTrend': _calculateEngagementTrend(),
    };
  }

  double _calculateSessionConsistency() {
    // Implementation for session consistency calculation
    return 0.8; // Placeholder
  }

  double _calculateJourneySpacing(List<DateTime> times) {
    // Implementation for journey spacing analysis
    return 0.7; // Placeholder
  }

  double _calculateEngagementTrend() {
    // Implementation for engagement trend calculation
    return 0.9; // Placeholder
  }

  Map<String, dynamic> _calculateCommercialViability() {
    // This will be populated from commercial validation data
    return {
      'estimatedLTV': 0.0,
      'conversionProbability': 0.0,
      'priceAcceptance': {},
    };
  }

  // ============================================================================
  // DATA PERSISTENCE
  // ============================================================================

  void _saveUserProfile() {
    if (_userId != null) {
      FirebaseService.createOrUpdateUserProfile(_userId!, _userProfile);
    }
  }

  void _saveSessionData() {
    if (_userId != null) {
      FirebaseService.firestore
          .collection('research_sessions')
          .doc('${_userId}_${_currentSession['sessionId']}')
          .set(_currentSession, SetOptions(merge: true));
    }
  }

  void _saveJourneyData(Map<String, dynamic> journeyData) {
    if (_userId != null) {
      FirebaseService.firestore
          .collection('completed_journeys')
          .add({
        'userId': _userId,
        ...journeyData,
      });
    }
  }

  // Topic suggestion tracking for community features
  void captureTopicSuggestion({
    required String topic,
    required String category,
    String? reason,
  }) {
    final suggestionData = {
      'topic': topic,
      'category': category,
      'reason': reason,
      'userId': _userId,
      'timestamp': DateTime.now().toIso8601String(),
      'userProfile': _userProfile,
    };

    // Add to current session
    _currentSession['interactions'] = _currentSession['interactions'] ?? [];
    _currentSession['interactions'].add({
      'type': 'topic_suggestion',
      'data': suggestionData,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Save to Firebase for community feature
    _saveTopicSuggestion(suggestionData);
    _saveSessionData();
    notifyListeners();
  }

  void _saveTopicSuggestion(Map<String, dynamic> suggestionData) {
    if (_userId != null) {
      FirebaseService.firestore
          .collection('topic_suggestions')
          .add(suggestionData);
    }
  }

  // Export all research data for analysis
  Future<Map<String, dynamic>> exportResearchData() async {
    return {
      'userId': _userId,
      'userProfile': _userProfile,
      'completedJourneys': _completedJourneys,
      'engagementScores': _engagementScores,
      'currentSession': _currentSession,
      'investorMetrics': getInvestorMetrics(),
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }
}
