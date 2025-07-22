/// WISME App State Manager - Modular, Scalable State Management
/// 
/// This system provides a unified approach to state management across
/// all features while maintaining modularity and scalability.
/// 
/// FEATURES:
/// - Centralized state management
/// - Feature-specific state isolation
/// - Real-time state synchronization
/// - Offline state persistence
/// - State analytics and debugging
/// - Performance optimization

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

// ===== CORE STATE INTERFACES =====

/// Base interface for all state classes
abstract class AppState {
  Map<String, dynamic> toJson();
  void fromJson(Map<String, dynamic> json);
  AppState copyWith();
}

/// State change event for analytics and debugging
class StateChangeEvent {
  final String feature;
  final String action;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String? userId;

  const StateChangeEvent({
    required this.feature,
    required this.action,
    required this.data,
    required this.timestamp,
    this.userId,
  });

  Map<String, dynamic> toJson() => {
    'feature': feature,
    'action': action,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'userId': userId,
  };
}

// ===== USER STATE =====

/// Comprehensive user state management
class UserState extends ChangeNotifier implements AppState {
  String? _userId;
  String? _email;
  String? _displayName;
  String? _avatarUrl;
  Map<String, dynamic> _preferences;
  Map<String, dynamic> _profile;
  List<String> _interests;
  Map<String, dynamic> _learningProgress;
  DateTime? _lastActive;
  bool _isPremium;
  Map<String, dynamic> _subscription;
  List<String> _achievements;
  Map<String, dynamic> _analytics;

  // Getters
  String? get userId => _userId;
  String? get email => _email;
  String? get displayName => _displayName;
  String? get avatarUrl => _avatarUrl;
  Map<String, dynamic> get preferences => _preferences;
  Map<String, dynamic> get profile => _profile;
  List<String> get interests => _interests;
  Map<String, dynamic> get learningProgress => _learningProgress;
  DateTime? get lastActive => _lastActive;
  bool get isPremium => _isPremium;
  Map<String, dynamic> get subscription => _subscription;
  List<String> get achievements => _achievements;
  Map<String, dynamic> get analytics => _analytics;

  UserState() : 
    _preferences = {},
    _profile = {},
    _interests = [],
    _learningProgress = {},
    _isPremium = false,
    _subscription = {},
    _achievements = [],
    _analytics = {};

  @override
  Map<String, dynamic> toJson() => {
    'userId': _userId,
    'email': _email,
    'displayName': _displayName,
    'avatarUrl': _avatarUrl,
    'preferences': _preferences,
    'profile': _profile,
    'interests': _interests,
    'learningProgress': _learningProgress,
    'lastActive': _lastActive?.toIso8601String(),
    'isPremium': _isPremium,
    'subscription': _subscription,
    'achievements': _achievements,
    'analytics': _analytics,
  };

  @override
  void fromJson(Map<String, dynamic> json) {
    _userId = json['userId'];
    _email = json['email'];
    _displayName = json['displayName'];
    _avatarUrl = json['avatarUrl'];
    _preferences = Map<String, dynamic>.from(json['preferences'] ?? {});
    _profile = Map<String, dynamic>.from(json['profile'] ?? {});
    _interests = List<String>.from(json['interests'] ?? []);
    _learningProgress = Map<String, dynamic>.from(json['learningProgress'] ?? {});
    _lastActive = json['lastActive'] != null ? DateTime.parse(json['lastActive']) : null;
    _isPremium = json['isPremium'] ?? false;
    _subscription = Map<String, dynamic>.from(json['subscription'] ?? {});
    _achievements = List<String>.from(json['achievements'] ?? []);
    _analytics = Map<String, dynamic>.from(json['analytics'] ?? {});
    notifyListeners();
  }

  @override
  UserState copyWith() {
    final newState = UserState();
    newState.fromJson(toJson());
    return newState;
  }

  // State update methods
  void updateUser({
    String? userId,
    String? email,
    String? displayName,
    String? avatarUrl,
  }) {
    _userId = userId ?? _userId;
    _email = email ?? _email;
    _displayName = displayName ?? _displayName;
    _avatarUrl = avatarUrl ?? _avatarUrl;
    _lastActive = DateTime.now();
    notifyListeners();
  }

  void updatePreferences(Map<String, dynamic> newPreferences) {
    _preferences.addAll(newPreferences);
    notifyListeners();
  }

  void updateLearningProgress(String topic, Map<String, dynamic> progress) {
    _learningProgress[topic] = progress;
    notifyListeners();
  }

  void addInterest(String interest) {
    if (!_interests.contains(interest)) {
      _interests.add(interest);
      notifyListeners();
    }
  }

  void addAchievement(String achievement) {
    if (!_achievements.contains(achievement)) {
      _achievements.add(achievement);
      notifyListeners();
    }
  }
}

// ===== LEARNING STATE =====

/// Learning journey and progress state
class LearningState extends ChangeNotifier implements AppState {
  List<Map<String, dynamic>> _activeJourneys;
  Map<String, dynamic> _currentJourney;
  Map<String, dynamic> _learningPreferences;
  List<Map<String, dynamic>> _completedEpisodes;
  Map<String, dynamic> _learningAnalytics;
  List<String> _favoriteTopics;
  Map<String, dynamic> _knowledgeAssessment;

  // Getters
  List<Map<String, dynamic>> get activeJourneys => _activeJourneys;
  Map<String, dynamic> get currentJourney => _currentJourney;
  Map<String, dynamic> get learningPreferences => _learningPreferences;
  List<Map<String, dynamic>> get completedEpisodes => _completedEpisodes;
  Map<String, dynamic> get learningAnalytics => _learningAnalytics;
  List<String> get favoriteTopics => _favoriteTopics;
  Map<String, dynamic> get knowledgeAssessment => _knowledgeAssessment;

  LearningState() :
    _activeJourneys = [],
    _currentJourney = {},
    _learningPreferences = {},
    _completedEpisodes = [],
    _learningAnalytics = {},
    _favoriteTopics = [],
    _knowledgeAssessment = {};

  @override
  Map<String, dynamic> toJson() => {
    'activeJourneys': _activeJourneys,
    'currentJourney': _currentJourney,
    'learningPreferences': _learningPreferences,
    'completedEpisodes': _completedEpisodes,
    'learningAnalytics': _learningAnalytics,
    'favoriteTopics': _favoriteTopics,
    'knowledgeAssessment': _knowledgeAssessment,
  };

  @override
  void fromJson(Map<String, dynamic> json) {
    _activeJourneys = List<Map<String, dynamic>>.from(json['activeJourneys'] ?? []);
    _currentJourney = Map<String, dynamic>.from(json['currentJourney'] ?? {});
    _learningPreferences = Map<String, dynamic>.from(json['learningPreferences'] ?? {});
    _completedEpisodes = List<Map<String, dynamic>>.from(json['completedEpisodes'] ?? []);
    _learningAnalytics = Map<String, dynamic>.from(json['learningAnalytics'] ?? {});
    _favoriteTopics = List<String>.from(json['favoriteTopics'] ?? []);
    _knowledgeAssessment = Map<String, dynamic>.from(json['knowledgeAssessment'] ?? {});
    notifyListeners();
  }

  @override
  LearningState copyWith() {
    final newState = LearningState();
    newState.fromJson(toJson());
    return newState;
  }

  // State update methods
  void setCurrentJourney(Map<String, dynamic> journey) {
    _currentJourney = journey;
    notifyListeners();
  }

  void addActiveJourney(Map<String, dynamic> journey) {
    _activeJourneys.add(journey);
    notifyListeners();
  }

  void completeEpisode(Map<String, dynamic> episode) {
    _completedEpisodes.add(episode);
    notifyListeners();
  }

  void updateLearningPreferences(Map<String, dynamic> preferences) {
    _learningPreferences.addAll(preferences);
    notifyListeners();
  }
}

// ===== AUDIO STATE =====

/// Audio playback and management state
class AudioState extends ChangeNotifier implements AppState {
  Map<String, dynamic>? _currentEpisode;
  bool _isPlaying;
  Duration _position;
  Duration _duration;
  double _playbackSpeed;
  bool _isMuted;
  double _volume;
  List<Map<String, dynamic>> _playlist;
  Map<String, dynamic> _audioPreferences;
  bool _isBuffering;
  String? _error;

  // Getters
  Map<String, dynamic>? get currentEpisode => _currentEpisode;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  double get playbackSpeed => _playbackSpeed;
  bool get isMuted => _isMuted;
  double get volume => _volume;
  List<Map<String, dynamic>> get playlist => _playlist;
  Map<String, dynamic> get audioPreferences => _audioPreferences;
  bool get isBuffering => _isBuffering;
  String? get error => _error;

  AudioState() :
    _isPlaying = false,
    _position = Duration.zero,
    _duration = Duration.zero,
    _playbackSpeed = 1.0,
    _isMuted = false,
    _volume = 1.0,
    _playlist = [],
    _audioPreferences = {},
    _isBuffering = false;

  @override
  Map<String, dynamic> toJson() => {
    'currentEpisode': _currentEpisode,
    'isPlaying': _isPlaying,
    'position': _position.inMilliseconds,
    'duration': _duration.inMilliseconds,
    'playbackSpeed': _playbackSpeed,
    'isMuted': _isMuted,
    'volume': _volume,
    'playlist': _playlist,
    'audioPreferences': _audioPreferences,
    'isBuffering': _isBuffering,
    'error': _error,
  };

  @override
  void fromJson(Map<String, dynamic> json) {
    _currentEpisode = json['currentEpisode'];
    _isPlaying = json['isPlaying'] ?? false;
    _position = Duration(milliseconds: json['position'] ?? 0);
    _duration = Duration(milliseconds: json['duration'] ?? 0);
    _playbackSpeed = json['playbackSpeed'] ?? 1.0;
    _isMuted = json['isMuted'] ?? false;
    _volume = json['volume'] ?? 1.0;
    _playlist = List<Map<String, dynamic>>.from(json['playlist'] ?? []);
    _audioPreferences = Map<String, dynamic>.from(json['audioPreferences'] ?? {});
    _isBuffering = json['isBuffering'] ?? false;
    _error = json['error'];
    notifyListeners();
  }

  @override
  AudioState copyWith() {
    final newState = AudioState();
    newState.fromJson(toJson());
    return newState;
  }

  // State update methods
  void setCurrentEpisode(Map<String, dynamic> episode) {
    _currentEpisode = episode;
    _position = Duration.zero;
    notifyListeners();
  }

  void setPlaying(bool playing) {
    _isPlaying = playing;
    notifyListeners();
  }

  void updatePosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  void setPlaybackSpeed(double speed) {
    _playbackSpeed = speed;
    notifyListeners();
  }

  void setVolume(double volume) {
    _volume = volume;
    notifyListeners();
  }
}

// ===== COACH STATE =====

/// AI coach personality and interaction state
class CoachState extends ChangeNotifier implements AppState {
  String _coachPersonality;
  Map<String, dynamic> _coachPreferences;
  List<Map<String, dynamic>> _conversationHistory;
  Map<String, dynamic> _coachAnalytics;
  String _currentMood;
  Map<String, dynamic> _motivationalData;
  List<String> _coachingStrategies;

  // Getters
  String get coachPersonality => _coachPersonality;
  Map<String, dynamic> get coachPreferences => _coachPreferences;
  List<Map<String, dynamic>> get conversationHistory => _conversationHistory;
  Map<String, dynamic> get coachAnalytics => _coachAnalytics;
  String get currentMood => _currentMood;
  Map<String, dynamic> get motivationalData => _motivationalData;
  List<String> get coachingStrategies => _coachingStrategies;

  CoachState() :
    _coachPersonality = 'encouraging',
    _coachPreferences = {},
    _conversationHistory = [],
    _coachAnalytics = {},
    _currentMood = 'neutral',
    _motivationalData = {},
    _coachingStrategies = [];

  @override
  Map<String, dynamic> toJson() => {
    'coachPersonality': _coachPersonality,
    'coachPreferences': _coachPreferences,
    'conversationHistory': _conversationHistory,
    'coachAnalytics': _coachAnalytics,
    'currentMood': _currentMood,
    'motivationalData': _motivationalData,
    'coachingStrategies': _coachingStrategies,
  };

  @override
  void fromJson(Map<String, dynamic> json) {
    _coachPersonality = json['coachPersonality'] ?? 'encouraging';
    _coachPreferences = Map<String, dynamic>.from(json['coachPreferences'] ?? {});
    _conversationHistory = List<Map<String, dynamic>>.from(json['conversationHistory'] ?? []);
    _coachAnalytics = Map<String, dynamic>.from(json['coachAnalytics'] ?? {});
    _currentMood = json['currentMood'] ?? 'neutral';
    _motivationalData = Map<String, dynamic>.from(json['motivationalData'] ?? {});
    _coachingStrategies = List<String>.from(json['coachingStrategies'] ?? []);
    notifyListeners();
  }

  @override
  CoachState copyWith() {
    final newState = CoachState();
    newState.fromJson(toJson());
    return newState;
  }

  // State update methods
  void setCoachPersonality(String personality) {
    _coachPersonality = personality;
    notifyListeners();
  }

  void addConversation(Map<String, dynamic> conversation) {
    _conversationHistory.add(conversation);
    notifyListeners();
  }

  void updateMood(String mood) {
    _currentMood = mood;
    notifyListeners();
  }
}

// ===== MAIN STATE MANAGER =====

/// Central state manager that coordinates all feature states
class AppStateManager extends ChangeNotifier {
  static final AppStateManager _instance = AppStateManager._internal();
  static AppStateManager get instance => _instance;
  
  AppStateManager._internal();

  // Feature states
  late UserState userState;
  late LearningState learningState;
  late AudioState audioState;
  late CoachState coachState;

  // State management
  final List<StateChangeEvent> _stateHistory = [];
  final StreamController<StateChangeEvent> _stateChangeController = StreamController<StateChangeEvent>.broadcast();
  bool _isInitialized = false;

  // Getters
  bool get isInitialized => _isInitialized;
  Stream<StateChangeEvent> get stateChanges => _stateChangeController.stream;
  List<StateChangeEvent> get stateHistory => List.unmodifiable(_stateHistory);

  /// Initialize the state manager
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize feature states
    userState = UserState();
    learningState = LearningState();
    audioState = AudioState();
    coachState = CoachState();

    // Listen to state changes for analytics
    userState.addListener(() => _onStateChange('user', 'update', userState.toJson()));
    learningState.addListener(() => _onStateChange('learning', 'update', learningState.toJson()));
    audioState.addListener(() => _onStateChange('audio', 'update', audioState.toJson()));
    coachState.addListener(() => _onStateChange('coach', 'update', coachState.toJson()));

    _isInitialized = true;
  }

  /// Handle state change events
  void _onStateChange(String feature, String action, Map<String, dynamic> data) {
    final event = StateChangeEvent(
      feature: feature,
      action: action,
      data: data,
      timestamp: DateTime.now(),
      userId: userState.userId,
    );

    _stateHistory.add(event);
    _stateChangeController.add(event);

    // Keep history manageable
    if (_stateHistory.length > 1000) {
      _stateHistory.removeRange(0, 100);
    }
  }

  /// Get all state as JSON for persistence
  Map<String, dynamic> getAllState() => {
    'user': userState.toJson(),
    'learning': learningState.toJson(),
    'audio': audioState.toJson(),
    'coach': coachState.toJson(),
    'timestamp': DateTime.now().toIso8601String(),
  };

  /// Restore all state from JSON
  void restoreAllState(Map<String, dynamic> state) {
    if (state['user'] != null) userState.fromJson(state['user']);
    if (state['learning'] != null) learningState.fromJson(state['learning']);
    if (state['audio'] != null) audioState.fromJson(state['audio']);
    if (state['coach'] != null) coachState.fromJson(state['coach']);
  }

  /// Clear all state (for logout)
  void clearAllState() {
    userState = UserState();
    learningState = LearningState();
    audioState = AudioState();
    coachState = CoachState();
    _stateHistory.clear();
    notifyListeners();
  }

  /// Dispose resources
  @override
  void dispose() {
    _stateChangeController.close();
    super.dispose();
  }
}

// ===== PROVIDER SETUP =====

/// Provider setup for dependency injection
class AppProviders {
  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider<UserState>(
      create: (_) => AppStateManager.instance.userState,
    ),
    ChangeNotifierProvider<LearningState>(
      create: (_) => AppStateManager.instance.learningState,
    ),
    ChangeNotifierProvider<AudioState>(
      create: (_) => AppStateManager.instance.audioState,
    ),
    ChangeNotifierProvider<CoachState>(
      create: (_) => AppStateManager.instance.coachState,
    ),
  ];
} 
