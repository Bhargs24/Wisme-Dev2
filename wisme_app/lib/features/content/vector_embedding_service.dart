import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../core/services/openai_service.dart';
import '../../../core/config/environment_config.dart';
import '../../../models/episode.dart';

/// Vector Embedding Service
/// Handles semantic search and content similarity using OpenAI embeddings
class VectorEmbeddingService {
  static final VectorEmbeddingService _instance = VectorEmbeddingService._internal();
  factory VectorEmbeddingService() => _instance;
  VectorEmbeddingService._internal();

  Database? _database;
  bool _isInitialized = false;

  /// Initialize the vector database
  Future<void> initialize() async {
    if (_isInitialized) return;

    final dbPath = join(await getDatabasesPath(), 'vector_embeddings.db');
    
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE embeddings (
            id TEXT PRIMARY KEY,
            content TEXT NOT NULL,
            embedding BLOB NOT NULL,
            metadata TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');
        
        await db.execute('''
          CREATE TABLE similarity_cache (
            id1 TEXT,
            id2 TEXT,
            similarity REAL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id1, id2)
          )
        ''');
      },
    );

    _isInitialized = true;
  }

  /// Generate embedding for text content
  Future<List<double>> generateEmbedding(String text) async {
    if (!OpenAIService.isConfigured) {
      throw Exception('OpenAI API key not configured');
    }

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/embeddings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${EnvironmentConfig.openaiApiKey}',
        },
        body: json.encode({
          'model': 'text-embedding-3-small',
          'input': text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final embedding = List<double>.from(data['data'][0]['embedding']);
        return embedding;
      } else {
        throw Exception('Failed to generate embedding: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating embedding: $e');
    }
  }

  /// Store embedding in database
  Future<void> storeEmbedding({
    required String id,
    required String content,
    required List<double> embedding,
    Map<String, dynamic>? metadata,
  }) async {
    if (!_isInitialized) await initialize();

    final embeddingBytes = _encodeEmbedding(embedding);
    final metadataJson = metadata != null ? json.encode(metadata) : null;

    await _database!.insert(
      'embeddings',
      {
        'id': id,
        'content': content,
        'embedding': embeddingBytes,
        'metadata': metadataJson,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Generate and store embedding for episode
  Future<void> generateAndStoreEpisodeEmbedding(Episode episode) async {
    if (episode.id == null) return;

    final combinedContent = '''
    Title: ${episode.title}
    Content: ${episode.content}
    Category: ${episode.category}
    Learning Type: ${episode.learningType}
    Coach: ${episode.coachPersonality}
    Hashtags: ${episode.hashtags.join(', ')}
    ''';

    final embedding = await generateEmbedding(combinedContent);
    
    await storeEmbedding(
      id: episode.id!,
      content: combinedContent,
      embedding: embedding,
      metadata: {
        'type': 'episode',
        'title': episode.title,
        'category': episode.category,
        'knowledge_level': episode.learningType,
        'coach_personality': episode.coachPersonality,
        'duration_minutes': episode.durationMinutes,
        'hashtags': episode.hashtags,
      },
    );
  }

  /// Find similar content using vector similarity
  Future<List<SimilarityResult>> findSimilarContent({
    required String queryText,
    int limit = 10,
    double threshold = 0.7,
    List<String>? categories,
    String? learningType,
  }) async {
    if (!_isInitialized) await initialize();

    // Generate embedding for query
    final queryEmbedding = await generateEmbedding(queryText);

    // Get all embeddings from database
    final embeddings = await _database!.query('embeddings');
    
    final results = <SimilarityResult>[];

    for (final row in embeddings) {
      final id = row['id'] as String;
      final content = row['content'] as String;
      final embeddingBytes = row['embedding'] as List<int>;
      final embedding = _decodeEmbedding(embeddingBytes);
      
      final metadata = row['metadata'] as String?;
      final metadataMap = metadata != null 
        ? Map<String, dynamic>.from(json.decode(metadata))
        : <String, dynamic>{};

      // Apply filters
      if (categories != null && 
          !categories.contains(metadataMap['category'])) {
        continue;
      }
      
      if (learningType != null && 
          metadataMap['knowledge_level'] != learningType) {
        continue;
      }

      // Calculate similarity
      final similarity = _calculateCosineSimilarity(queryEmbedding, embedding);
      
      if (similarity >= threshold) {
        results.add(SimilarityResult(
          id: id,
          content: content,
          similarity: similarity,
          metadata: metadataMap,
        ));
      }
    }

    // Sort by similarity and limit results
    results.sort((a, b) => b.similarity.compareTo(a.similarity));
    return results.take(limit).toList();
  }

  /// Find episodes similar to a given episode
  Future<List<SimilarityResult>> findSimilarEpisodes({
    required String episodeId,
    int limit = 5,
    double threshold = 0.6,
  }) async {
    if (!_isInitialized) await initialize();

    // Get the source episode embedding
    final sourceEmbedding = await _getEmbeddingById(episodeId);
    if (sourceEmbedding == null) {
      throw Exception('Episode embedding not found');
    }

    // Check similarity cache first
    final cachedResults = await _getCachedSimilarities(episodeId);
    if (cachedResults.isNotEmpty) {
      return cachedResults.take(limit).toList();
    }

    // Get all episode embeddings
    final embeddings = await _database!.query(
      'embeddings',
      where: 'id != ? AND metadata LIKE ?',
      whereArgs: [episodeId, '%"type":"episode"%'],
    );

    final results = <SimilarityResult>[];

    for (final row in embeddings) {
      final id = row['id'] as String;
      final content = row['content'] as String;
      final embeddingBytes = row['embedding'] as List<int>;
      final embedding = _decodeEmbedding(embeddingBytes);
      
      final metadata = row['metadata'] as String?;
      final metadataMap = metadata != null 
        ? Map<String, dynamic>.from(json.decode(metadata))
        : <String, dynamic>{};

      final similarity = _calculateCosineSimilarity(sourceEmbedding, embedding);
      
      if (similarity >= threshold) {
        results.add(SimilarityResult(
          id: id,
          content: content,
          similarity: similarity,
          metadata: metadataMap,
        ));

        // Cache the similarity
        await _cacheSimilarity(episodeId, id, similarity);
      }
    }

    results.sort((a, b) => b.similarity.compareTo(a.similarity));
    return results.take(limit).toList();
  }

  /// Semantic search across all content
  Future<List<SimilarityResult>> semanticSearch({
    required String query,
    int limit = 20,
    double threshold = 0.5,
    Map<String, dynamic>? filters,
  }) async {
    return await findSimilarContent(
      queryText: query,
      limit: limit,
      threshold: threshold,
      categories: filters?['categories'],
      learningType: filters?['knowledge_level'],
    );
  }

  /// Get content recommendations for user
  Future<List<SimilarityResult>> getRecommendations({
    required List<String> userInterests,
    required List<String> completedEpisodeIds,
    int limit = 10,
    double threshold = 0.6,
  }) async {
    // Create query from user interests
    final queryText = userInterests.join(' ');
    
    // Find similar content
    final results = await findSimilarContent(
      queryText: queryText,
      limit: limit * 2, // Get more results to filter
      threshold: threshold,
    );

    // Filter out completed episodes
    final filtered = results.where((result) => 
      !completedEpisodeIds.contains(result.id)
    ).toList();

    return filtered.take(limit).toList();
  }

  /// Batch process episodes for embedding generation
  Future<void> batchProcessEpisodes(
    List<Episode> episodes, {
    Function(int, int)? onProgress,
  }) async {
    for (int i = 0; i < episodes.length; i++) {
      try {
        await generateAndStoreEpisodeEmbedding(episodes[i]);
        onProgress?.call(i + 1, episodes.length);
      } catch (e) {
        print('Error processing episode ${episodes[i].id}: $e');
      }
    }
  }

  /// Get embedding statistics
  Future<EmbeddingStats> getEmbeddingStats() async {
    if (!_isInitialized) await initialize();

    final totalCount = Sqflite.firstIntValue(
      await _database!.rawQuery('SELECT COUNT(*) FROM embeddings')
    ) ?? 0;

    final episodeCount = Sqflite.firstIntValue(
      await _database!.rawQuery(
        'SELECT COUNT(*) FROM embeddings WHERE metadata LIKE ?',
        ['%"type":"episode"%']
      )
    ) ?? 0;

    final cacheCount = Sqflite.firstIntValue(
      await _database!.rawQuery('SELECT COUNT(*) FROM similarity_cache')
    ) ?? 0;

    return EmbeddingStats(
      totalEmbeddings: totalCount,
      episodeEmbeddings: episodeCount,
      cachedSimilarities: cacheCount,
    );
  }

  /// Clear all embeddings
  Future<void> clearEmbeddings() async {
    if (!_isInitialized) await initialize();

    await _database!.delete('embeddings');
    await _database!.delete('similarity_cache');
  }

  /// Private helper methods
  List<int> _encodeEmbedding(List<double> embedding) {
    // Simple encoding - in production, use more efficient encoding
    final jsonString = json.encode(embedding);
    return utf8.encode(jsonString);
  }

  List<double> _decodeEmbedding(List<int> bytes) {
    final jsonString = utf8.decode(bytes);
    return List<double>.from(json.decode(jsonString));
  }

  double _calculateCosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) return 0.0;

    double dotProduct = 0.0;
    double magnitudeA = 0.0;
    double magnitudeB = 0.0;

    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      magnitudeA += a[i] * a[i];
      magnitudeB += b[i] * b[i];
    }

    magnitudeA = sqrt(magnitudeA);
    magnitudeB = sqrt(magnitudeB);

    if (magnitudeA == 0.0 || magnitudeB == 0.0) return 0.0;

    return dotProduct / (magnitudeA * magnitudeB);
  }

  Future<List<double>?> _getEmbeddingById(String id) async {
    final result = await _database!.query(
      'embeddings',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    final embeddingBytes = result.first['embedding'] as List<int>;
    return _decodeEmbedding(embeddingBytes);
  }

  Future<List<SimilarityResult>> _getCachedSimilarities(String episodeId) async {
    final results = await _database!.query(
      'similarity_cache',
      where: 'id1 = ?',
      whereArgs: [episodeId],
      orderBy: 'similarity DESC',
    );

    final similarities = <SimilarityResult>[];
    for (final row in results) {
      final id2 = row['id2'] as String;
      final similarity = row['similarity'] as double;
      
      // Get the content for this ID
      final embeddingResult = await _database!.query(
        'embeddings',
        where: 'id = ?',
        whereArgs: [id2],
        limit: 1,
      );
      
      if (embeddingResult.isNotEmpty) {
        final content = embeddingResult.first['content'] as String;
        final metadata = embeddingResult.first['metadata'] as String?;
        final metadataMap = metadata != null 
          ? Map<String, dynamic>.from(json.decode(metadata))
          : <String, dynamic>{};

        similarities.add(SimilarityResult(
          id: id2,
          content: content,
          similarity: similarity,
          metadata: metadataMap,
        ));
      }
    }

    return similarities;
  }

  Future<void> _cacheSimilarity(String id1, String id2, double similarity) async {
    await _database!.insert(
      'similarity_cache',
      {
        'id1': id1,
        'id2': id2,
        'similarity': similarity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

/// Data models
class SimilarityResult {
  final String id;
  final String content;
  final double similarity;
  final Map<String, dynamic> metadata;

  SimilarityResult({
    required this.id,
    required this.content,
    required this.similarity,
    required this.metadata,
  });

  String get title => metadata['title'] ?? '';
  String get category => metadata['category'] ?? '';
  String get learningType => metadata['knowledge_level'] ?? '';
  String get coachPersonality => metadata['coach_personality'] ?? '';
  int get durationMinutes => metadata['duration_minutes'] ?? 0;
  List<String> get hashtags => List<String>.from(metadata['hashtags'] ?? []);
}

class EmbeddingStats {
  final int totalEmbeddings;
  final int episodeEmbeddings;
  final int cachedSimilarities;

  EmbeddingStats({
    required this.totalEmbeddings,
    required this.episodeEmbeddings,
    required this.cachedSimilarities,
  });
}
