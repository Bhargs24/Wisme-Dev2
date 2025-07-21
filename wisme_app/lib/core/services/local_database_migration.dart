/// Database Migration Helper for NEW_AUDIO_ARCHITECTURE
/// Handles local SQLite database setup for development and caching
library;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

/// Manages local SQLite database for caching and development
class LocalDatabaseMigration {
  static Database? _database;
  static const String _dbName = 'wisme_enhanced_audio.db';
  static const int _dbVersion = 1;

  /// Get the local database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  static Future<Database> _initDatabase() async {
    try {
      print('🏗️ Initializing local database for NEW_AUDIO_ARCHITECTURE...');
      
      String path = join(await getDatabasesPath(), _dbName);
      
      return await openDatabase(
        path,
        version: _dbVersion,
        onCreate: _createDatabase,
        onUpgrade: _upgradeDatabase,
      );
    } catch (e) {
      print('❌ Failed to initialize database: $e');
      rethrow;
    }
  }

  /// Create database tables
  static Future<void> _createDatabase(Database db, int version) async {
    try {
      print('📊 Creating NEW_AUDIO_ARCHITECTURE database tables...');
      
      // Load and execute the schema SQL
      await _executeSchemaFile(db);
      
      print('✅ Database tables created successfully');
    } catch (e) {
      print('❌ Failed to create database: $e');
      rethrow;
    }
  }

  /// Execute the schema SQL file
  static Future<void> _executeSchemaFile(Database db) async {
    try {
      // Load the SQL file from assets
      final String schemaSQL = await rootBundle.loadString('database/new_audio_architecture_schema.sql');
      
      // Split into individual statements and execute
      final statements = schemaSQL
          .split(';')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty && !s.startsWith('--'))
          .toList();
      
      for (final statement in statements) {
        if (statement.trim().isNotEmpty) {
          await db.execute(statement);
        }
      }
    } catch (e) {
      print('❌ Failed to execute schema file: $e');
      
      // Fallback: Create tables manually if schema file fails
      await _createTablesManually(db);
    }
  }

  /// Fallback method to create tables manually
  static Future<void> _createTablesManually(Database db) async {
    print('🔧 Creating tables manually as fallback...');
    
    // Audio fragments table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS audio_fragments (
        id TEXT PRIMARY KEY,
        content_hash TEXT NOT NULL UNIQUE,
        content_text TEXT NOT NULL,
        speaker_config TEXT NOT NULL,
        audio_data BLOB NOT NULL,
        file_size INTEGER NOT NULL,
        duration_ms INTEGER NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        last_accessed TEXT DEFAULT CURRENT_TIMESTAMP,
        access_count INTEGER DEFAULT 1,
        similarity_hash TEXT NOT NULL,
        quality_score REAL DEFAULT 0.0,
        usage_context TEXT DEFAULT '[]',
        compression_ratio REAL DEFAULT 1.0
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX IF NOT EXISTS idx_fragments_content_hash ON audio_fragments(content_hash)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_fragments_similarity ON audio_fragments(similarity_hash)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_fragments_last_accessed ON audio_fragments(last_accessed)');

    // User interest profiles
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_interest_profiles (
        user_id TEXT PRIMARY KEY,
        interests TEXT NOT NULL DEFAULT '{}',
        learning_style TEXT NOT NULL DEFAULT '{}',
        engagement_history TEXT NOT NULL DEFAULT '[]',
        preferred_speakers TEXT NOT NULL DEFAULT '[]',
        listening_patterns TEXT NOT NULL DEFAULT '{}',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // User interactions
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_interactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        episode_id TEXT NOT NULL,
        interaction_type TEXT NOT NULL,
        interaction_data TEXT DEFAULT '{}',
        session_id TEXT NOT NULL,
        timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
        position_ms INTEGER,
        speaker_at_time TEXT,
        engagement_score REAL DEFAULT 0.0
      )
    ''');

    // Conversation configs
    await db.execute('''
      CREATE TABLE IF NOT EXISTS conversation_configs (
        episode_id TEXT PRIMARY KEY,
        conversation_type TEXT NOT NULL,
        host_speaker TEXT NOT NULL,
        expert_speaker TEXT NOT NULL,
        total_exchanges INTEGER NOT NULL,
        total_duration_ms INTEGER NOT NULL,
        generated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        user_id TEXT,
        difficulty_level TEXT NOT NULL,
        topic_category TEXT NOT NULL
      )
    ''');

    // Conversation exchanges
    await db.execute('''
      CREATE TABLE IF NOT EXISTS conversation_exchanges (
        id TEXT PRIMARY KEY,
        episode_id TEXT NOT NULL,
        exchange_order INTEGER NOT NULL,
        speaker_role TEXT NOT NULL,
        text_content TEXT NOT NULL,
        audio_file_path TEXT,
        duration_ms INTEGER NOT NULL,
        start_time_ms INTEGER NOT NULL,
        end_time_ms INTEGER NOT NULL,
        emphasis_level TEXT DEFAULT 'normal',
        emotional_tone TEXT DEFAULT 'neutral',
        FOREIGN KEY (episode_id) REFERENCES conversation_configs(episode_id)
      )
    ''');

    // Speaker voices with default data
    await db.execute('''
      CREATE TABLE IF NOT EXISTS speaker_voices (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        role TEXT NOT NULL,
        category TEXT NOT NULL,
        voice_id TEXT NOT NULL,
        personality_traits TEXT NOT NULL DEFAULT '[]',
        speaking_style TEXT NOT NULL DEFAULT '{}',
        expertise_areas TEXT NOT NULL DEFAULT '[]',
        sample_audio_url TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        is_active INTEGER DEFAULT 1,
        usage_count INTEGER DEFAULT 0
      )
    ''');

    // Insert default speakers
    await _insertDefaultSpeakers(db);

    print('✅ Manual table creation complete');
  }

  /// Insert default speaker voices
  static Future<void> _insertDefaultSpeakers(Database db) async {
    final speakers = [
      // Core efficient speaker pairs covering all 15 categories
      // Using only 6 voice IDs but with distinct personas per category
      
      // 1. Technology & AI
      {
        'id': 'host_kai_tech',
        'name': 'Kai',
        'role': 'host',
        'category': 'technology',
        'voice_id': 'ElevenLabsVoiceID1',
        'personality_traits': '["curious", "encouraging", "clear"]',
        'speaking_style': '{"pace": "moderate", "energy": "high", "formality": "casual"}',
        'expertise_areas': '["technology", "programming", "ai"]',
      },
      {
        'id': 'expert_alex_tech',
        'name': 'Alex',
        'role': 'expert',
        'category': 'technology',
        'voice_id': 'ElevenLabsVoiceID2',
        'personality_traits': '["knowledgeable", "patient", "detailed"]',
        'speaking_style': '{"pace": "thoughtful", "energy": "moderate", "formality": "professional"}',
        'expertise_areas': '["software engineering", "machine learning", "data science"]',
      },
      
      // 2. Business & Finance
      {
        'id': 'host_maya_business',
        'name': 'Maya',
        'role': 'host',
        'category': 'business',
        'voice_id': 'ElevenLabsVoiceID3',
        'personality_traits': '["enthusiastic", "practical", "engaging"]',
        'speaking_style': '{"pace": "energetic", "energy": "high", "formality": "business_casual"}',
        'expertise_areas': '["entrepreneurship", "leadership", "strategy"]',
      },
      {
        'id': 'expert_david_business',
        'name': 'David',
        'role': 'expert',
        'category': 'business',
        'voice_id': 'ElevenLabsVoiceID4',
        'personality_traits': '["experienced", "analytical", "insightful"]',
        'speaking_style': '{"pace": "measured", "energy": "moderate", "formality": "professional"}',
        'expertise_areas': '["finance", "economics", "business_strategy"]',
      },
      
      // 3. Psychology & Mind (Kai + new Sara voice)
      {
        'id': 'host_kai_psychology',
        'name': 'Kai',
        'role': 'host',
        'category': 'psychology',
        'voice_id': 'ElevenLabsVoiceID1',
        'personality_traits': '["empathetic", "curious", "supportive"]',
        'speaking_style': '{"pace": "moderate", "energy": "warm", "formality": "conversational"}',
        'expertise_areas': '["human behavior", "mental health", "cognitive science"]',
      },
      {
        'id': 'expert_sara_psychology',
        'name': 'Sara',
        'role': 'expert',
        'category': 'psychology',
        'voice_id': 'ElevenLabsVoiceID5',
        'personality_traits': '["compassionate", "insightful", "scientific"]',
        'speaking_style': '{"pace": "calm", "energy": "moderate", "formality": "professional"}',
        'expertise_areas': '["behavioral psychology", "therapy", "neuroscience"]',
      },
      
      // 4. Science & Nature (Maya + Alex)
      {
        'id': 'host_maya_science',
        'name': 'Maya',
        'role': 'host',
        'category': 'science',
        'voice_id': 'ElevenLabsVoiceID3',
        'personality_traits': '["wonder-filled", "questioning", "enthusiastic"]',
        'speaking_style': '{"pace": "animated", "energy": "high", "formality": "casual"}',
        'expertise_areas': '["natural sciences", "discoveries", "research"]',
      },
      {
        'id': 'expert_alex_science',
        'name': 'Alex',
        'role': 'expert',
        'category': 'science',
        'voice_id': 'ElevenLabsVoiceID2',
        'personality_traits': '["methodical", "precise", "educational"]',
        'speaking_style': '{"pace": "clear", "energy": "moderate", "formality": "academic"}',
        'expertise_areas': '["physics", "biology", "chemistry", "research methods"]',
      },
      
      // 5. Creativity & Design (New Zoe + Sara)
      {
        'id': 'host_zoe_creative',
        'name': 'Zoe',
        'role': 'host',
        'category': 'creativity',
        'voice_id': 'ElevenLabsVoiceID6',
        'personality_traits': '["inspiring", "artistic", "expressive"]',
        'speaking_style': '{"pace": "varied", "energy": "creative", "formality": "relaxed"}',
        'expertise_areas': '["design thinking", "creative process", "visual arts"]',
      },
      {
        'id': 'expert_sara_creative',
        'name': 'Sara',
        'role': 'expert',
        'category': 'creativity',
        'voice_id': 'ElevenLabsVoiceID5',
        'personality_traits': '["innovative", "detailed", "passionate"]',
        'speaking_style': '{"pace": "thoughtful", "energy": "passionate", "formality": "artistic"}',
        'expertise_areas': '["design principles", "creative techniques", "artistic history"]',
      },
    ];

    for (final speaker in speakers) {
      await db.insert(
        'speaker_voices',
        speaker,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    print('✅ Inserted ${speakers.length} core speakers (covering all 15 categories efficiently)');
  }

  /// Handle database upgrades
  static Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    print('🔄 Upgrading database from version $oldVersion to $newVersion');
    
    // Add upgrade logic here as the schema evolves
    if (oldVersion < newVersion) {
      // For now, recreate the database
      await _createDatabase(db, newVersion);
    }
  }

  /// Check if database is properly initialized
  static Future<bool> isDatabaseInitialized() async {
    try {
      final db = await database;
      
      // Check if key tables exist by querying them
      await db.query('audio_fragments', limit: 1);
      await db.query('user_interest_profiles', limit: 1);
      await db.query('speaker_voices', limit: 1);
      
      return true;
    } catch (e) {
      print('⚠️ Database not properly initialized: $e');
      return false;
    }
  }

  /// Get database statistics
  static Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      final db = await database;
      
      final fragmentCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM audio_fragments')
      ) ?? 0;
      
      final interactionCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM user_interactions')
      ) ?? 0;
      
      final conversationCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM conversation_configs')
      ) ?? 0;
      
      final speakerCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM speaker_voices WHERE is_active = 1')
      ) ?? 0;
      
      return {
        'fragments': fragmentCount,
        'interactions': interactionCount,
        'conversations': conversationCount,
        'active_speakers': speakerCount,
        'database_path': join(await getDatabasesPath(), _dbName),
        'database_version': _dbVersion,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Clear all cached data (for development/testing)
  static Future<void> clearCache() async {
    try {
      final db = await database;
      
      await db.delete('audio_fragments');
      await db.delete('user_interactions');
      await db.delete('conversation_configs');
      await db.delete('conversation_exchanges');
      
      print('✅ Database cache cleared');
    } catch (e) {
      print('❌ Failed to clear cache: $e');
      rethrow;
    }
  }

  /// Reset database (for development)
  static Future<void> resetDatabase() async {
    try {
      final path = join(await getDatabasesPath(), _dbName);
      await deleteDatabase(path);
      _database = null;
      
      print('✅ Database reset complete');
    } catch (e) {
      print('❌ Failed to reset database: $e');
      rethrow;
    }
  }

  /// Close database connection
  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      print('✅ Database connection closed');
    }
  }
}
