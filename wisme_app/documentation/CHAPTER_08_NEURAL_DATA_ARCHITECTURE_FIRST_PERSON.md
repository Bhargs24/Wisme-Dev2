# Chapter 8: My Neural Data Architecture
## How I Store, Process, and Serve Knowledge

Data is the soul of any intelligent application, but in Wisme, it's the foundation of personalization itself. When I designed the data architecture, I wasn't just thinking about storing information—I was architecting a neural network of knowledge that could learn, adapt, and serve millions of users simultaneously. This chapter reveals how I built a multi-database ecosystem that combines the reliability of traditional databases with the intelligence of modern AI systems.

Every data decision I made was driven by one core principle: the architecture must be intelligent enough to serve personalized experiences while being robust enough to scale to millions of users without compromising performance or reliability.

### My Data Philosophy

Traditional applications treat data as static information to be stored and retrieved. In Wisme, data is living, breathing intelligence that continuously evolves based on user interactions. Every piece of content, every user preference, every learning outcome becomes part of a vast neural network that makes the entire platform smarter.

I believe data architecture should be invisible to users but transformative to their experience. Users shouldn't know or care that their learning recommendations are powered by sophisticated vector embeddings, real-time analytics, and predictive modeling. They should only experience the magic of perfectly personalized learning that seems to understand their needs before they do.

My approach combines multiple database technologies, each optimized for specific use cases. Supabase handles structured data and real-time features. SQLite manages local storage and offline capabilities. Hive provides lightning-fast caching. Vector databases power semantic search and AI recommendations. This multi-database strategy might seem complex, but it provides the perfect balance of performance, reliability, and intelligence.

### The Multi-Database Strategy

The heart of Wisme's data architecture is what I call the Neural Data Mesh—a sophisticated network of interconnected databases that work together to provide seamless data access while maintaining consistency and performance. Each database serves specific purposes and excels in particular scenarios.

```dart
// My data architecture coordinator
class NeuralDataMesh {
  final SupabaseDataLayer _supabaseLayer;
  final SQLiteDataLayer _sqliteLayer;
  final HiveDataLayer _hiveLayer;
  final VectorDataLayer _vectorLayer;
  final SyncEngine _syncEngine;
  final DataConsistencyManager _consistencyManager;
  final PerformanceOptimizer _performanceOptimizer;
  
  NeuralDataMesh({
    required SupabaseDataLayer supabaseLayer,
    required SQLiteDataLayer sqliteLayer,
    required HiveDataLayer hiveLayer,
    required VectorDataLayer vectorLayer,
    required SyncEngine syncEngine,
    required DataConsistencyManager consistencyManager,
    required PerformanceOptimizer performanceOptimizer,
  }) : _supabaseLayer = supabaseLayer,
       _sqliteLayer = sqliteLayer,
       _hiveLayer = hiveLayer,
       _vectorLayer = vectorLayer,
       _syncEngine = syncEngine,
       _consistencyManager = consistencyManager,
       _performanceOptimizer = performanceOptimizer;
  
  Future<T> intelligentDataRetrieval<T>({
    required DataQuery<T> query,
    required DataContext context,
  }) async {
    // Determine optimal data source based on query characteristics
    final strategy = await _determineOptimalStrategy(query, context);
    
    switch (strategy.primarySource) {
      case DataSource.cache:
        return await _retrieveFromCache(query, strategy);
        
      case DataSource.local:
        return await _retrieveFromLocal(query, strategy);
        
      case DataSource.cloud:
        return await _retrieveFromCloud(query, strategy);
        
      case DataSource.vector:
        return await _retrieveFromVector(query, strategy);
        
      case DataSource.hybrid:
        return await _retrieveFromHybrid(query, strategy);
    }
  }
  
  Future<DataStrategy> _determineOptimalStrategy(
    DataQuery query,
    DataContext context,
  ) async {
    final factors = DataStrategyFactors(
      queryType: query.type,
      dataFreshness: query.freshnessRequirement,
      userLocation: context.userLocation,
      networkCondition: context.networkCondition,
      deviceCapabilities: context.deviceCapabilities,
      userBehaviorPattern: await _getUserBehaviorPattern(context.userId),
      historicalPerformance: await _getHistoricalPerformance(query.type),
    );
    
    // Use ML model to predict optimal strategy
    final predictedStrategy = await _performanceOptimizer.predictOptimalStrategy(factors);
    
    // Validate strategy against current system state
    final validatedStrategy = await _validateStrategy(predictedStrategy, context);
    
    return validatedStrategy;
  }
  
  Future<T> _retrieveFromHybrid<T>(
    DataQuery<T> query,
    DataStrategy strategy,
  ) async {
    final results = await Future.wait([
      _retrieveFromCache(query, strategy).catchError((_) => null),
      _retrieveFromLocal(query, strategy).catchError((_) => null),
      if (strategy.includeCloud) _retrieveFromCloud(query, strategy).catchError((_) => null),
    ]);
    
    // Intelligent result merging and conflict resolution
    final mergedResult = await _mergeResults(results, query);
    
    // Update cache with merged result
    await _updateCache(query, mergedResult);
    
    return mergedResult;
  }
}
```

The data mesh automatically routes queries to the most appropriate data source based on multiple factors including data freshness requirements, network conditions, user behavior patterns, and historical performance metrics. This intelligent routing ensures optimal performance while maintaining data consistency.

### Supabase: My Cloud Data Powerhouse

Supabase serves as the primary cloud database for Wisme, handling user accounts, learning content, progress tracking, and real-time features. I chose Supabase because it provides the power of PostgreSQL with modern developer experience and built-in real-time capabilities that are essential for collaborative learning features.

My Supabase schema is designed for both performance and flexibility. The database supports complex queries for personalization while maintaining fast response times through careful indexing and query optimization. Real-time subscriptions enable live collaboration features, instant progress updates, and dynamic content recommendations.

```dart
// My Supabase data layer implementation
class SupabaseDataLayer {
  final SupabaseClient _client;
  final QueryOptimizer _queryOptimizer;
  final RealTimeManager _realTimeManager;
  final SchemaEvolution _schemaEvolution;
  
  Future<List<LearningContent>> getPersonalizedContent({
    required String userId,
    required PersonalizationContext context,
    int limit = 20,
  }) async {
    final optimizedQuery = await _queryOptimizer.optimizePersonalizationQuery(
      userId: userId,
      context: context,
      limit: limit,
    );
    
    final response = await _client
        .from('learning_content')
        .select('''
          *,
          content_metadata (*),
          user_interactions!inner (
            interaction_type,
            engagement_score,
            completion_rate
          ),
          content_similarities (
            similar_content_id,
            similarity_score
          ),
          learning_objectives (
            objective_text,
            difficulty_level,
            estimated_time
          )
        ''')
        .or(optimizedQuery.contentFilters)
        .order('personalization_score', ascending: false)
        .order('created_at', ascending: false)
        .limit(limit);
    
    final content = response.map((json) => LearningContent.fromJson(json)).toList();
    
    // Enhance with real-time engagement data
    final enhancedContent = await _enhanceWithRealTimeData(content, userId);
    
    return enhancedContent;
  }
  
  Future<UserLearningProfile> buildComprehensiveLearningProfile({
    required String userId,
  }) async {
    // Execute multiple parallel queries for efficiency
    final results = await Future.wait([
      _getUserBasicProfile(userId),
      _getUserLearningHistory(userId),
      _getUserPreferences(userId),
      _getUserSkillAssessments(userId),
      _getUserSocialConnections(userId),
      _getUserEngagementPatterns(userId),
    ]);
    
    final profile = UserLearningProfile(
      basicProfile: results[0] as UserBasicProfile,
      learningHistory: results[1] as LearningHistory,
      preferences: results[2] as UserPreferences,
      skillAssessments: results[3] as List<SkillAssessment>,
      socialConnections: results[4] as List<SocialConnection>,
      engagementPatterns: results[5] as EngagementPatterns,
    );
    
    // Use ML to generate insights from profile data
    final insights = await _generateProfileInsights(profile);
    profile.insights = insights;
    
    return profile;
  }
  
  Stream<LearningProgress> watchUserProgress(String userId) {
    return _client
        .from('learning_progress')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('updated_at', ascending: false)
        .map((data) => data.map((json) => LearningProgress.fromJson(json)).toList())
        .map((progressList) => progressList.first);
  }
  
  Future<void> updateLearningProgress({
    required String userId,
    required String contentId,
    required ProgressUpdate update,
  }) async {
    final progressRecord = LearningProgressRecord(
      userId: userId,
      contentId: contentId,
      progressPercentage: update.progressPercentage,
      timeSpent: update.timeSpent,
      comprehensionScore: update.comprehensionScore,
      engagementMetrics: update.engagementMetrics,
      lastAccessedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // Use upsert for atomic progress updates
    await _client
        .from('learning_progress')
        .upsert(progressRecord.toJson(), onConflict: 'user_id,content_id');
    
    // Trigger real-time notifications for achievements
    if (update.achievements.isNotEmpty) {
      await _notifyAchievements(userId, update.achievements);
    }
    
    // Update user's learning streak
    await _updateLearningStreak(userId, update.sessionData);
    
    // Refresh personalization model with new data
    await _refreshPersonalizationModel(userId);
  }
}
```

The Supabase layer includes sophisticated query optimization that analyzes query patterns and automatically generates optimal queries for common use cases. The system learns from query performance and adjusts strategies to maintain fast response times as the database grows.

### SQLite: My Local Storage Champion

SQLite serves as the local database for offline functionality, caching frequently accessed data, and providing instant response times for critical user interactions. My SQLite implementation is designed to work seamlessly with the cloud database, providing a smooth transition between online and offline modes.

The local database schema mirrors critical parts of the cloud schema but is optimized for mobile device constraints. I use intelligent data selection to ensure that the most relevant content is always available offline while managing storage space efficiently.

```dart
// My SQLite local storage implementation
class SQLiteDataLayer {
  late Database _database;
  final DatabaseMigrationManager _migrationManager;
  final QueryCache _queryCache;
  final StorageOptimizer _storageOptimizer;
  
  Future<void> initialize() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'wisme_local.db');
    
    _database = await openDatabase(
      path,
      version: await _migrationManager.getCurrentVersion(),
      onCreate: _createTables,
      onUpgrade: _migrationManager.upgradeDatabase,
      onOpen: _optimizeDatabase,
    );
    
    // Enable WAL mode for better performance
    await _database.execute('PRAGMA journal_mode=WAL');
    await _database.execute('PRAGMA synchronous=NORMAL');
    await _database.execute('PRAGMA cache_size=10000');
    await _database.execute('PRAGMA temp_store=MEMORY');
  }
  
  Future<List<LearningContent>> getOfflineContent({
    required String userId,
    required OfflineContentCriteria criteria,
  }) async {
    final query = '''
      SELECT 
        lc.*,
        lcm.metadata,
        lp.progress_percentage,
        lp.last_accessed_at
      FROM learning_content lc
      LEFT JOIN learning_content_metadata lcm ON lc.id = lcm.content_id
      LEFT JOIN learning_progress lp ON lc.id = lp.content_id AND lp.user_id = ?
      WHERE lc.user_id = ? 
        AND lc.is_downloaded = 1
        AND lc.download_expiry > ?
        AND (lc.content_size_mb <= ? OR lc.is_priority = 1)
      ORDER BY 
        lc.is_priority DESC,
        lp.last_accessed_at DESC,
        lc.download_date DESC
      LIMIT ?
    ''';
    
    final results = await _database.rawQuery(query, [
      userId,
      userId,
      DateTime.now().millisecondsSinceEpoch,
      criteria.maxContentSizeMB,
      criteria.limit,
    ]);
    
    return results.map((row) => LearningContent.fromSQLiteRow(row)).toList();
  }
  
  Future<void> syncWithCloud({
    required List<CloudDataChange> changes,
    required ConflictResolution conflictResolution,
  }) async {
    final batch = _database.batch();
    
    for (final change in changes) {
      switch (change.operation) {
        case DataOperation.insert:
          batch.insert(
            change.tableName,
            change.data,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          break;
          
        case DataOperation.update:
          final existingRecord = await _getExistingRecord(
            change.tableName,
            change.primaryKey,
          );
          
          if (existingRecord != null) {
            final resolvedData = await conflictResolution.resolve(
              cloudData: change.data,
              localData: existingRecord,
              conflictType: ConflictType.update,
            );
            
            batch.update(
              change.tableName,
              resolvedData,
              where: '${change.primaryKeyColumn} = ?',
              whereArgs: [change.primaryKey],
            );
          }
          break;
          
        case DataOperation.delete:
          batch.delete(
            change.tableName,
            where: '${change.primaryKeyColumn} = ?',
            whereArgs: [change.primaryKey],
          );
          break;
      }
    }
    
    await batch.commit(noResult: true);
    
    // Optimize database after sync
    await _optimizeAfterSync();
  }
  
  Future<void> intelligentStorageManagement() async {
    final storageInfo = await _storageOptimizer.analyzeStorage();
    
    if (storageInfo.usagePercentage > 0.8) {
      // Clean up old cached data
      await _cleanupOldCache();
      
      // Remove least accessed content
      await _removeLeastAccessedContent();
      
      // Compress large files
      await _compressLargeFiles();
      
      // Update content priorities
      await _updateContentPriorities();
    }
    
    // Preload high-priority content
    await _preloadHighPriorityContent();
  }
}
```

The SQLite layer includes intelligent storage management that automatically cleans up old data, manages download priorities, and optimizes storage space based on user behavior patterns. The system ensures that users always have access to their most important content even when offline.

### Hive: My Lightning-Fast Cache

Hive provides ultra-fast key-value storage for frequently accessed data, user preferences, and session information. I chose Hive because of its exceptional performance on mobile devices and its ability to handle complex data types without the overhead of traditional databases.

My Hive implementation uses intelligent caching strategies that predict what data users will need and preload it for instant access. The system automatically manages cache size and expiration to provide optimal performance without consuming excessive storage.

```dart
// My Hive caching layer implementation
class HiveDataLayer {
  final Map<String, Box> _boxes = {};
  final CacheStrategy _cacheStrategy;
  final PreloadingEngine _preloadingEngine;
  final CacheAnalytics _cacheAnalytics;
  
  Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register custom adapters
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(LearningContentAdapter());
    Hive.registerAdapter(LearningProgressAdapter());
    Hive.registerAdapter(UserPreferencesAdapter());
    Hive.registerAdapter(CachedSearchResultAdapter());
    
    // Open frequently used boxes
    await _openBox<UserProfile>('user_profiles');
    await _openBox<LearningContent>('content_cache');
    await _openBox<LearningProgress>('progress_cache');
    await _openBox<UserPreferences>('user_preferences');
    await _openBox<CachedSearchResult>('search_cache');
    
    // Start background optimization
    _startBackgroundOptimization();
  }
  
  Future<T?> getCached<T>({
    required String key,
    required String boxName,
    Duration? maxAge,
  }) async {
    final box = _boxes[boxName] as Box<T>?;
    if (box == null) return null;
    
    final cachedItem = box.get(key);
    if (cachedItem == null) return null;
    
    // Check cache age if specified
    if (maxAge != null) {
      final cacheTime = await _getCacheTime(boxName, key);
      if (cacheTime != null && 
          DateTime.now().difference(cacheTime) > maxAge) {
        await box.delete(key);
        return null;
      }
    }
    
    // Update access statistics
    await _cacheAnalytics.recordAccess(boxName, key);
    
    return cachedItem;
  }
  
  Future<void> putCached<T>({
    required String key,
    required T value,
    required String boxName,
    Duration? ttl,
    CachePriority priority = CachePriority.normal,
  }) async {
    final box = _boxes[boxName] as Box<T>?;
    if (box == null) return;
    
    // Check cache capacity
    if (await _isCapacityExceeded(boxName)) {
      await _evictLeastUsed(boxName, priority);
    }
    
    await box.put(key, value);
    
    // Store cache metadata
    await _storeCacheMetadata(
      boxName: boxName,
      key: key,
      cachedAt: DateTime.now(),
      ttl: ttl,
      priority: priority,
    );
    
    // Update analytics
    await _cacheAnalytics.recordWrite(boxName, key, priority);
  }
  
  Future<void> preloadUserData({
    required String userId,
    required UserBehaviorPattern behaviorPattern,
  }) async {
    final preloadTasks = await _preloadingEngine.generatePreloadTasks(
      userId: userId,
      behaviorPattern: behaviorPattern,
    );
    
    for (final task in preloadTasks) {
      await _executePreloadTask(task);
    }
  }
  
  Future<void> _executePreloadTask(PreloadTask task) async {
    try {
      switch (task.type) {
        case PreloadType.userProgress:
          final progress = await _fetchUserProgress(task.parameters);
          await putCached(
            key: task.cacheKey,
            value: progress,
            boxName: 'progress_cache',
            priority: task.priority,
          );
          break;
          
        case PreloadType.contentRecommendations:
          final recommendations = await _fetchRecommendations(task.parameters);
          await putCached(
            key: task.cacheKey,
            value: recommendations,
            boxName: 'content_cache',
            priority: task.priority,
          );
          break;
          
        case PreloadType.searchResults:
          final searchResults = await _fetchSearchResults(task.parameters);
          await putCached(
            key: task.cacheKey,
            value: searchResults,
            boxName: 'search_cache',
            priority: task.priority,
          );
          break;
      }
    } catch (e) {
      // Log preload failures but don't block user experience
      await _cacheAnalytics.recordPreloadFailure(task, e);
    }
  }
  
  void _startBackgroundOptimization() {
    Timer.periodic(Duration(hours: 6), (timer) async {
      await _optimizeCacheSize();
      await _cleanupExpiredEntries();
      await _updateCacheStatistics();
      await _rebalanceCachePriorities();
    });
  }
}
```

The Hive layer includes predictive preloading that analyzes user behavior patterns to cache data before it's needed. This provides instant response times for common user actions and creates a seamless experience even when network conditions are poor.

### Vector Database: My AI Memory

Vector embeddings are the secret sauce that makes Wisme's AI-powered recommendations so effective. I use a specialized vector database to store and query high-dimensional embeddings that capture the semantic meaning of learning content, user preferences, and behavioral patterns.

The vector database enables sophisticated similarity searches that go far beyond keyword matching. Content recommendations are based on deep semantic understanding, allowing the system to suggest relevant material even when there are no obvious keyword connections.

```dart
// My vector database implementation
class VectorDataLayer {
  final VectorDatabaseClient _vectorClient;
  final EmbeddingGenerator _embeddingGenerator;
  final SimilarityEngine _similarityEngine;
  final VectorIndexOptimizer _indexOptimizer;
  
  Future<void> indexContent({
    required LearningContent content,
    required ContentEmbeddingContext context,
  }) async {
    // Generate multiple embeddings for different aspects
    final titleEmbedding = await _embeddingGenerator.generateEmbedding(
      text: content.title,
      type: EmbeddingType.title,
    );
    
    final contentEmbedding = await _embeddingGenerator.generateEmbedding(
      text: content.fullText,
      type: EmbeddingType.content,
    );
    
    final skillsEmbedding = await _embeddingGenerator.generateEmbedding(
      text: content.skillsRequired.join(' '),
      type: EmbeddingType.skills,
    );
    
    final objectivesEmbedding = await _embeddingGenerator.generateEmbedding(
      text: content.learningObjectives.join(' '),
      type: EmbeddingType.objectives,
    );
    
    // Create composite embedding
    final compositeEmbedding = await _createCompositeEmbedding([
      WeightedEmbedding(titleEmbedding, weight: 0.3),
      WeightedEmbedding(contentEmbedding, weight: 0.4),
      WeightedEmbedding(skillsEmbedding, weight: 0.2),
      WeightedEmbedding(objectivesEmbedding, weight: 0.1),
    ]);
    
    // Store in vector database with metadata
    await _vectorClient.upsert(
      id: content.id,
      embedding: compositeEmbedding,
      metadata: {
        'content_type': content.type.name,
        'difficulty_level': content.difficultyLevel,
        'estimated_duration': content.estimatedDuration.inMinutes,
        'topics': content.topics,
        'skills': content.skillsRequired,
        'created_at': content.createdAt.toIso8601String(),
        'engagement_score': content.averageEngagementScore,
        'completion_rate': content.averageCompletionRate,
      },
    );
    
    // Update vector index for optimal search performance
    await _indexOptimizer.updateIndex(content.id, compositeEmbedding);
  }
  
  Future<List<ContentRecommendation>> findSimilarContent({
    required String userId,
    required UserInteractionHistory interactionHistory,
    required List<String> currentInterests,
    int limit = 20,
  }) async {
    // Generate user preference embedding
    final userPreferenceEmbedding = await _generateUserPreferenceEmbedding(
      interactionHistory: interactionHistory,
      currentInterests: currentInterests,
    );
    
    // Perform similarity search
    final similarityResults = await _vectorClient.similaritySearch(
      queryEmbedding: userPreferenceEmbedding,
      limit: limit * 2, // Get more results for filtering
      minSimilarity: 0.6,
      filters: {
        'user_id': userId, // Exclude content user has already seen
      },
    );
    
    // Apply business logic filters and ranking
    final filteredResults = await _applyContentFilters(
      results: similarityResults,
      userId: userId,
      userContext: await _getUserContext(userId),
    );
    
    // Convert to content recommendations with explanations
    final recommendations = <ContentRecommendation>[];
    for (final result in filteredResults.take(limit)) {
      final explanation = await _generateRecommendationExplanation(
        result: result,
        userPreferences: userPreferenceEmbedding,
      );
      
      recommendations.add(ContentRecommendation(
        contentId: result.id,
        similarityScore: result.similarity,
        explanation: explanation,
        confidence: result.confidence,
        recommendationReason: await _determineRecommendationReason(result),
      ));
    }
    
    return recommendations;
  }
  
  Future<List<double>> _generateUserPreferenceEmbedding({
    required UserInteractionHistory interactionHistory,
    required List<String> currentInterests,
  }) async {
    final interactionEmbeddings = <WeightedEmbedding>[];
    
    // Weight embeddings based on interaction type and recency
    for (final interaction in interactionHistory.interactions) {
      final contentEmbedding = await _vectorClient.getEmbedding(interaction.contentId);
      if (contentEmbedding != null) {
        final weight = _calculateInteractionWeight(interaction);
        interactionEmbeddings.add(WeightedEmbedding(contentEmbedding, weight: weight));
      }
    }
    
    // Add current interests embedding
    final interestsText = currentInterests.join(' ');
    final interestsEmbedding = await _embeddingGenerator.generateEmbedding(
      text: interestsText,
      type: EmbeddingType.interests,
    );
    interactionEmbeddings.add(WeightedEmbedding(interestsEmbedding, weight: 0.3));
    
    // Create composite user preference embedding
    return await _createCompositeEmbedding(interactionEmbeddings);
  }
  
  double _calculateInteractionWeight(UserInteraction interaction) {
    final recencyWeight = _calculateRecencyWeight(interaction.timestamp);
    final engagementWeight = _calculateEngagementWeight(interaction.engagementScore);
    final typeWeight = _getInteractionTypeWeight(interaction.type);
    
    return recencyWeight * engagementWeight * typeWeight;
  }
}
```

The vector database includes sophisticated ranking algorithms that consider not just semantic similarity but also user behavior patterns, content quality metrics, and learning objectives. This multi-dimensional approach ensures that recommendations are both relevant and effective for learning outcomes.

### Real-Time Data Synchronization

One of the most challenging aspects of a multi-database architecture is maintaining consistency across all data sources. I built a sophisticated synchronization engine that ensures data remains consistent while providing optimal performance for different use cases.

The sync engine operates continuously in the background, intelligently merging changes from different sources and resolving conflicts when they occur. It prioritizes user experience by ensuring that local data is always available while seamlessly synchronizing with cloud sources when connectivity allows.

```dart
// My real-time synchronization engine
class RealTimeSyncEngine {
  final CloudSyncManager _cloudSync;
  final LocalSyncManager _localSync;
  final ConflictResolver _conflictResolver;
  final SyncPriorityManager _priorityManager;
  final NetworkMonitor _networkMonitor;
  final SyncAnalytics _syncAnalytics;
  
  void startSynchronization() {
    // Listen for network changes
    _networkMonitor.connectionStream.listen(_handleConnectionChange);
    
    // Start periodic sync for low-priority data
    Timer.periodic(Duration(minutes: 15), (_) => _syncLowPriorityData());
    
    // Start real-time sync for high-priority data
    _startRealTimeSync();
    
    // Monitor sync queue and performance
    _monitorSyncPerformance();
  }
  
  Future<void> _handleConnectionChange(NetworkConnection connection) async {
    if (connection.isConnected) {
      await _onConnectionRestored();
    } else {
      await _onConnectionLost();
    }
  }
  
  Future<void> _onConnectionRestored() async {
    // Sync high-priority pending changes immediately
    await _syncHighPriorityChanges();
    
    // Queue medium and low-priority changes
    await _queueMediumPriorityChanges();
    await _queueLowPriorityChanges();
    
    // Resume real-time subscriptions
    await _resumeRealTimeSubscriptions();
  }
  
  Future<void> _syncHighPriorityChanges() async {
    final pendingChanges = await _localSync.getPendingChanges(
      priority: SyncPriority.high,
    );
    
    for (final change in pendingChanges) {
      try {
        await _processSyncChange(change);
        await _localSync.markChangeSynced(change.id);
      } catch (e) {
        await _handleSyncError(change, e);
      }
    }
  }
  
  Future<void> _processSyncChange(SyncChange change) async {
    switch (change.operation) {
      case SyncOperation.create:
        await _handleCreateSync(change);
        break;
        
      case SyncOperation.update:
        await _handleUpdateSync(change);
        break;
        
      case SyncOperation.delete:
        await _handleDeleteSync(change);
        break;
        
      case SyncOperation.conflict:
        await _handleConflictSync(change);
        break;
    }
  }
  
  Future<void> _handleUpdateSync(SyncChange change) async {
    // Check for conflicts
    final cloudData = await _cloudSync.fetchLatestData(change.entityId);
    final localData = change.data;
    
    if (_hasConflict(cloudData, localData)) {
      final resolution = await _conflictResolver.resolve(
        cloudData: cloudData,
        localData: localData,
        changeMetadata: change.metadata,
      );
      
      switch (resolution.strategy) {
        case ConflictResolutionStrategy.useCloud:
          await _localSync.updateLocalData(change.entityId, cloudData);
          break;
          
        case ConflictResolutionStrategy.useLocal:
          await _cloudSync.updateCloudData(change.entityId, localData);
          break;
          
        case ConflictResolutionStrategy.merge:
          final mergedData = resolution.mergedData!;
          await _localSync.updateLocalData(change.entityId, mergedData);
          await _cloudSync.updateCloudData(change.entityId, mergedData);
          break;
          
        case ConflictResolutionStrategy.userChoice:
          await _requestUserConflictResolution(change, cloudData, localData);
          break;
      }
    } else {
      // No conflict, proceed with normal sync
      await _cloudSync.updateCloudData(change.entityId, localData);
    }
  }
  
  bool _hasConflict(Map<String, dynamic> cloudData, Map<String, dynamic> localData) {
    final cloudTimestamp = DateTime.parse(cloudData['updated_at']);
    final localTimestamp = DateTime.parse(localData['updated_at']);
    
    // Consider it a conflict if both were modified after the last sync
    final lastSync = _syncAnalytics.getLastSyncTime(cloudData['id']);
    
    return cloudTimestamp.isAfter(lastSync) && localTimestamp.isAfter(lastSync);
  }
  
  void _startRealTimeSync() {
    // Subscribe to high-priority real-time updates
    _cloudSync.subscribeToUserProgress().listen((progress) {
      _localSync.updateLocalProgress(progress);
    });
    
    _cloudSync.subscribeToContentUpdates().listen((content) {
      _localSync.updateLocalContent(content);
    });
    
    _cloudSync.subscribeToUserPreferences().listen((preferences) {
      _localSync.updateLocalPreferences(preferences);
    });
  }
}
```

The synchronization engine includes intelligent conflict resolution that considers the context of changes, user intent, and data importance. Most conflicts are resolved automatically using smart merging algorithms, but users are consulted when manual intervention is needed.

### Data Analytics and Intelligence

The data architecture includes sophisticated analytics capabilities that provide insights into user behavior, content effectiveness, and system performance. These analytics power the personalization engine and help me continuously improve the learning experience.

The analytics system processes data in real-time to provide immediate insights while also performing batch analysis for deeper patterns and trends. Privacy is maintained through differential privacy techniques and data anonymization.

```dart
// My data analytics engine
class DataAnalyticsEngine {
  final RealTimeAnalytics _realTimeAnalytics;
  final BatchAnalytics _batchAnalytics;
  final PersonalizationAnalytics _personalizationAnalytics;
  final PrivacyPreservingAnalytics _privacyAnalytics;
  final PredictiveAnalytics _predictiveAnalytics;
  
  Future<LearningInsights> generateLearningInsights({
    required String userId,
    required DateRange period,
  }) async {
    final insights = LearningInsights();
    
    // Real-time engagement analysis
    insights.engagementMetrics = await _realTimeAnalytics.getEngagementMetrics(
      userId: userId,
      period: period,
    );
    
    // Learning progress analysis
    insights.progressAnalysis = await _batchAnalytics.analyzeProgressPatterns(
      userId: userId,
      period: period,
    );
    
    // Skill development tracking
    insights.skillDevelopment = await _analyzeSkillDevelopment(userId, period);
    
    // Content effectiveness analysis
    insights.contentEffectiveness = await _analyzeContentEffectiveness(userId, period);
    
    // Personalization performance
    insights.personalizationEffectiveness = await _personalizationAnalytics
        .analyzePersonalizationEffectiveness(userId, period);
    
    // Predictive insights
    insights.predictiveInsights = await _predictiveAnalytics.generatePredictions(
      userId: userId,
      historicalData: insights,
    );
    
    return insights;
  }
  
  Future<GlobalAnalytics> generateGlobalAnalytics({
    required DateRange period,
    required AnalyticsGranularity granularity,
  }) async {
    // Use privacy-preserving techniques for global analytics
    final anonymizedData = await _privacyAnalytics.anonymizeUserData(period);
    
    final globalAnalytics = GlobalAnalytics();
    
    // Platform usage patterns
    globalAnalytics.usagePatterns = await _analyzeGlobalUsagePatterns(
      anonymizedData,
      granularity,
    );
    
    // Content popularity and effectiveness
    globalAnalytics.contentAnalytics = await _analyzeGlobalContentMetrics(
      anonymizedData,
      period,
    );
    
    // Learning outcome trends
    globalAnalytics.learningOutcomes = await _analyzeGlobalLearningOutcomes(
      anonymizedData,
      period,
    );
    
    // Feature adoption and usage
    globalAnalytics.featureAdoption = await _analyzeFeatureAdoption(
      anonymizedData,
      period,
    );
    
    // Performance benchmarks
    globalAnalytics.performanceBenchmarks = await _generatePerformanceBenchmarks(
      anonymizedData,
      period,
    );
    
    return globalAnalytics;
  }
  
  Future<PersonalizationOptimization> optimizePersonalization({
    required String userId,
    required UserInteractionHistory history,
  }) async {
    // Analyze current personalization effectiveness
    final currentEffectiveness = await _personalizationAnalytics
        .analyzeCurrentEffectiveness(userId);
    
    // Identify optimization opportunities
    final opportunities = await _identifyOptimizationOpportunities(
      userId,
      history,
      currentEffectiveness,
    );
    
    // Generate optimization recommendations
    final recommendations = <PersonalizationRecommendation>[];
    
    for (final opportunity in opportunities) {
      final recommendation = await _generateOptimizationRecommendation(
        opportunity,
        userId,
      );
      recommendations.add(recommendation);
    }
    
    // A/B testing recommendations
    final abTestRecommendations = await _generateABTestRecommendations(
      userId,
      recommendations,
    );
    
    return PersonalizationOptimization(
      currentEffectiveness: currentEffectiveness,
      opportunities: opportunities,
      recommendations: recommendations,
      abTestRecommendations: abTestRecommendations,
    );
  }
}
```

The analytics engine provides both real-time insights for immediate personalization adjustments and deep analysis for long-term optimization. The system continuously learns from user interactions to improve the effectiveness of recommendations and learning paths.

This neural data architecture creates a foundation that's both technically sophisticated and user-focused. Every component works together to provide the intelligent, personalized learning experience that makes Wisme revolutionary. The architecture scales seamlessly from individual users to millions of learners while maintaining the performance and reliability that users expect from a world-class learning platform.
