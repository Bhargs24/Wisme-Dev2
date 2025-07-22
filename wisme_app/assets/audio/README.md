# WISME APP - AUDIO ASSETS STRUCTURE

## 📁 Audio Folder Organization

This folder contains organized audio assets for the Wisme learning app, structured to support both local storage and Firebase fallback mechanisms.

### 🎧 Learning Journeys Structure

```
assets/audio/learning_journeys/
├── data_structures_algorithms/
│   ├── episode_1/          # "Introduction to Data Structures"
│   ├── episode_2/          # "Arrays and Linked Lists Deep Dive"
│   ├── episode_3/          # "Stacks, Queues, and Trees"
│   ├── episode_4/          # "Hash Tables and Hash Functions"
│   └── episode_5/          # "Graphs and Advanced Algorithms"
├── operating_systems/
│   ├── episode_1/          # "Operating Systems Fundamentals"
│   ├── episode_2/          # "Process Management Deep Dive"
│   ├── episode_3/          # "Memory Management Systems"
│   ├── episode_4/          # "File Systems and Storage"
│   ├── episode_5/          # "Concurrency and Synchronization"
│   └── episode_6/          # "Distributed Systems Basics"
├── database_systems/
│   ├── episode_1/          # "Database Fundamentals"
│   ├── episode_2/          # "Relational Database Design"
│   ├── episode_3/          # "SQL and Query Optimization"
│   ├── episode_4/          # "ACID Properties and Transactions"
│   ├── episode_5/          # "Database Indexing and Performance"
│   ├── episode_6/          # "NoSQL and Modern Databases"
│   └── episode_7/          # "Distributed Databases"
├── personal_finance/
│   ├── episode_1/          # "Personal Finance Fundamentals"
│   ├── episode_2/          # "Budgeting and Expense Management"
│   ├── episode_3/          # "Investment Strategies"
│   ├── episode_4/          # "Retirement Planning"
│   ├── episode_5/          # "Tax Optimization"
│   └── episode_6/          # "Advanced Financial Planning"
└── sample_files/           # Sample audio files for testing
```

## 🔄 Firebase Integration & Local Fallback

### **How Audio Loading Works:**

1. **Primary**: Firebase Storage (Cloud)
   - Audio files uploaded to Firebase Storage
   - Provides CDN delivery and scalability
   - Handles authentication and access control

2. **Fallback**: Local Assets (Offline)
   - Audio files stored in `assets/audio/` folders
   - Used when Firebase is unavailable
   - Enables offline functionality

### **Audio Provider Logic:**

```dart
// From audio_provider.dart - Line 107
try {
  // Check cache first
  File? cachedFile;
  if (_cacheService != null) {
    cachedFile = await _cacheService.getCachedAudio(
      _currentBlock!.title, 
      'default' // Use default coach voice for now
    );
  }

  if (cachedFile != null) {
    // Load from cache
    await _audioPlayer.setSource(DeviceFileSource(cachedFile.path));
    AppLogger.info('Audio loaded from cache for block: ${_currentBlock!.id}');
  } else {
    // Load from network (Firebase)
    await _audioPlayer.setSource(UrlSource(_currentBlock!.audioUrl));
    AppLogger.info('Audio loaded from network for block: ${_currentBlock!.id}');
  }
}
```

### **Firestore Service Fallback:**

```dart
// From firestore_service.dart - Line 1
class FirestoreService {
  FirebaseFirestore? _firestore;
  bool _isFirebaseAvailable = false;

  void _initializeFirestore() {
    try {
      if (Firebase.apps.isNotEmpty) {
        _firestore = FirebaseFirestore.instance;
        _isFirebaseAvailable = true;
        _logger.i('✅ FirestoreService: Firebase is available');
      } else {
        _logger.w('⚠️ FirestoreService: Firebase not initialized - Firestore features disabled');
        _isFirebaseAvailable = false;
      }
    } catch (e) {
      _logger.w('⚠️ FirestoreService: Firebase initialization check failed: $e');
      _isFirebaseAvailable = false;
    }
  }
}
```

## 📱 Audio File Naming Convention

### **File Naming Format:**
- `episode_X_YYYY-MM-DD.mp3` - Main episode audio
- `episode_X_intro.mp3` - Episode introduction
- `episode_X_summary.mp3` - Episode summary
- `episode_X_quiz.mp3` - Episode quiz audio

### **Voice Variations:**
- `maya_kai_episode_X.mp3` - DSA episodes (Maya & Kai hosts)
- `sarah_alex_episode_X.mp3` - OS episodes (Dr. Sarah & Alex hosts)
- `zara_morgan_episode_X.mp3` - Database episodes (Zara & Morgan hosts)
- `riley_alex_episode_X.mp3` - Finance episodes (Riley & Alex hosts)

## 🎵 Audio Quality Standards

- **Format**: MP3, 128 kbps VBR
- **Sample Rate**: 24 kHz (optimized for speech)
- **Duration**: 7-9 minutes per episode
- **File Size**: ~8-12 MB per episode

## 🔧 Technical Integration

### **Cache Service Integration:**
The app uses intelligent caching to optimize performance:

```dart
// From cache_service.dart - Line 30
Future<File?> getCachedAudio(String topic, String coachVoice) async {
  try {
    final cacheKey = _generateCacheKey(topic, coachVoice);
    final cacheDir = await _getCacheDirectory();
    final audioFile = File('${cacheDir.path}/$cacheKey.mp3');
    
    if (await audioFile.exists()) {
      await _updateLastAccessed(cacheKey);
      return audioFile;
    }
    
    return null;
  } catch (e) {
    _logger.e('Error checking cached audio: $e');
    return null;
  }
}
```

### **Storage Service Integration:**
Firebase Storage with hierarchical organization:

```dart
// From storage_service.dart - Line 126
final storagePath = '$_audioStoragePath/$coachVoice/$normalizedTopic/$normalizedSubtopic/$fileName';
final storageRef = _storage.ref().child(storagePath);
```

## 🚀 Usage Instructions

1. **For Development**: Place audio files in respective episode folders
2. **For Production**: Upload files to Firebase Storage
3. **For Testing**: Use sample files in `sample_files/` folder
4. **For Offline**: Ensure critical episodes are in local assets

## 📊 Performance Considerations

- **Smart Caching**: LRU cache with 500MB limit
- **Predictive Loading**: Pre-cache likely-to-be-requested content
- **Quality Adaptation**: Automatic quality adjustment based on network
- **Background Processing**: Seamless content generation while browsing

---

**Last Updated**: January 23, 2025
**Version**: 1.0
**Total Episodes**: 25 episodes across 4 learning journeys
