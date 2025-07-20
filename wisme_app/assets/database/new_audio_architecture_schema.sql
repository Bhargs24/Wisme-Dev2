-- NEW_AUDIO_ARCHITECTURE Database Schema
-- Migration script for Phase 1 two-speaker audio system
-- Execute this script to set up all required tables for the enhanced audio features

-- =============================================================================
-- SMART FRAGMENT CACHE TABLES
-- =============================================================================

-- Audio fragment cache for smart reuse and cost optimization
CREATE TABLE IF NOT EXISTS audio_fragments (
  id TEXT PRIMARY KEY,
  content_hash TEXT NOT NULL UNIQUE,
  content_text TEXT NOT NULL,
  speaker_config TEXT NOT NULL, -- JSON serialized SpeakerVoice config
  audio_data BLOB NOT NULL,
  file_size INTEGER NOT NULL,
  duration_ms INTEGER NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_accessed DATETIME DEFAULT CURRENT_TIMESTAMP,
  access_count INTEGER DEFAULT 1,
  similarity_hash TEXT NOT NULL, -- For semantic matching
  quality_score REAL DEFAULT 0.0,
  usage_context TEXT, -- JSON array of contexts where this fragment was used
  compression_ratio REAL DEFAULT 1.0
);

-- Index for efficient fragment lookups
CREATE INDEX IF NOT EXISTS idx_fragments_content_hash ON audio_fragments(content_hash);
CREATE INDEX IF NOT EXISTS idx_fragments_similarity ON audio_fragments(similarity_hash);
CREATE INDEX IF NOT EXISTS idx_fragments_last_accessed ON audio_fragments(last_accessed);
CREATE INDEX IF NOT EXISTS idx_fragments_duration ON audio_fragments(duration_ms);

-- Fragment usage statistics for optimization
CREATE TABLE IF NOT EXISTS fragment_usage_stats (
  fragment_id TEXT NOT NULL,
  episode_id TEXT NOT NULL,
  usage_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  context_type TEXT NOT NULL, -- 'generation', 'replay', 'similar_content'
  user_rating INTEGER, -- Optional user feedback (1-5)
  performance_metrics TEXT, -- JSON with load time, cache hit, etc.
  FOREIGN KEY (fragment_id) REFERENCES audio_fragments(id),
  PRIMARY KEY (fragment_id, episode_id, usage_date)
);

-- =============================================================================
-- PERSONALIZATION ENGINE TABLES  
-- =============================================================================

-- User interest profiles for content personalization
CREATE TABLE IF NOT EXISTS user_interest_profiles (
  user_id TEXT PRIMARY KEY,
  interests TEXT NOT NULL, -- JSON array of interests with weights
  learning_style TEXT NOT NULL, -- JSON object with style preferences
  engagement_history TEXT NOT NULL, -- JSON array of engagement data
  preferred_speakers TEXT NOT NULL, -- JSON array of preferred speaker types
  listening_patterns TEXT NOT NULL, -- JSON object with time patterns, speeds, etc.
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- User interaction tracking for machine learning
CREATE TABLE IF NOT EXISTS user_interactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id TEXT NOT NULL,
  episode_id TEXT NOT NULL,
  interaction_type TEXT NOT NULL, -- 'play', 'pause', 'skip', 'replay', 'speed_change'
  interaction_data TEXT, -- JSON with specific interaction details
  session_id TEXT NOT NULL,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  position_ms INTEGER, -- Position in audio when interaction occurred
  speaker_at_time TEXT, -- Which speaker was active during interaction
  engagement_score REAL DEFAULT 0.0
);

CREATE INDEX IF NOT EXISTS idx_interactions_user_episode ON user_interactions(user_id, episode_id);
CREATE INDEX IF NOT EXISTS idx_interactions_type ON user_interactions(interaction_type);
CREATE INDEX IF NOT EXISTS idx_interactions_timestamp ON user_interactions(timestamp);

-- Engagement analytics for optimization
CREATE TABLE IF NOT EXISTS engagement_analytics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id TEXT NOT NULL,
  episode_id TEXT NOT NULL,
  session_duration_ms INTEGER NOT NULL,
  completion_percentage REAL NOT NULL,
  replay_count INTEGER DEFAULT 0,
  skip_count INTEGER DEFAULT 0,
  average_speed REAL DEFAULT 1.0,
  speaker_preferences TEXT, -- JSON with speaker engagement data
  topic_affinity_score REAL DEFAULT 0.0,
  date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- TWO-SPEAKER CONVERSATION TABLES
-- =============================================================================

-- Conversation configurations for episodes
CREATE TABLE IF NOT EXISTS conversation_configs (
  episode_id TEXT PRIMARY KEY,
  conversation_type TEXT NOT NULL, -- 'host_expert', 'debate', 'interview'
  host_speaker TEXT NOT NULL, -- JSON serialized SpeakerVoice
  expert_speaker TEXT NOT NULL, -- JSON serialized SpeakerVoice  
  total_exchanges INTEGER NOT NULL,
  total_duration_ms INTEGER NOT NULL,
  generated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  user_id TEXT, -- Optional: if personalized
  difficulty_level TEXT NOT NULL,
  topic_category TEXT NOT NULL
);

-- Individual conversation exchanges
CREATE TABLE IF NOT EXISTS conversation_exchanges (
  id TEXT PRIMARY KEY,
  episode_id TEXT NOT NULL,
  exchange_order INTEGER NOT NULL,
  speaker_role TEXT NOT NULL, -- 'host' or 'expert'
  text_content TEXT NOT NULL,
  audio_file_path TEXT, -- Path to generated audio file
  duration_ms INTEGER NOT NULL,
  start_time_ms INTEGER NOT NULL, -- Position in overall conversation
  end_time_ms INTEGER NOT NULL,
  emphasis_level TEXT DEFAULT 'normal', -- 'low', 'normal', 'high'
  emotional_tone TEXT DEFAULT 'neutral',
  FOREIGN KEY (episode_id) REFERENCES conversation_configs(episode_id)
);

CREATE INDEX IF NOT EXISTS idx_exchanges_episode_order ON conversation_exchanges(episode_id, exchange_order);
CREATE INDEX IF NOT EXISTS idx_exchanges_speaker ON conversation_exchanges(speaker_role);

-- =============================================================================
-- VOICE CONFIGURATION TABLES
-- =============================================================================

-- Available speaker voices and configurations
CREATE TABLE IF NOT EXISTS speaker_voices (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  role TEXT NOT NULL, -- 'host', 'expert'
  category TEXT NOT NULL, -- 'technology', 'business', 'science'
  voice_id TEXT NOT NULL, -- ElevenLabs voice ID
  personality_traits TEXT NOT NULL, -- JSON array of traits
  speaking_style TEXT NOT NULL, -- JSON object with style parameters
  expertise_areas TEXT NOT NULL, -- JSON array of expertise areas
  sample_audio_url TEXT, -- URL to sample audio for preview
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  is_active BOOLEAN DEFAULT TRUE,
  usage_count INTEGER DEFAULT 0
);

-- Insert default speaker voices for Phase 1
INSERT OR REPLACE INTO speaker_voices VALUES
  ('host_kai_tech', 'Kai', 'host', 'technology', 'ElevenLabsVoiceID1', 
   '["curious", "encouraging", "clear"]', 
   '{"pace": "moderate", "energy": "high", "formality": "casual"}',
   '["technology", "programming", "ai"]', NULL, CURRENT_TIMESTAMP, TRUE, 0),
   
  ('expert_alex_tech', 'Alex', 'expert', 'technology', 'ElevenLabsVoiceID2',
   '["knowledgeable", "patient", "detailed"]',
   '{"pace": "thoughtful", "energy": "moderate", "formality": "professional"}', 
   '["software engineering", "machine learning", "data science"]', NULL, CURRENT_TIMESTAMP, TRUE, 0),
   
  ('host_maya_business', 'Maya', 'host', 'business', 'ElevenLabsVoiceID3',
   '["enthusiastic", "practical", "engaging"]',
   '{"pace": "energetic", "energy": "high", "formality": "business_casual"}',
   '["entrepreneurship", "leadership", "strategy"]', NULL, CURRENT_TIMESTAMP, TRUE, 0),
   
  ('expert_david_business', 'David', 'expert', 'business', 'ElevenLabsVoiceID4', 
   '["experienced", "analytical", "insightful"]',
   '{"pace": "measured", "energy": "moderate", "formality": "professional"}',
   '["finance", "economics", "business_strategy"]', NULL, CURRENT_TIMESTAMP, TRUE, 0);

-- =============================================================================
-- SYSTEM PERFORMANCE TABLES
-- =============================================================================

-- Performance metrics for system optimization
CREATE TABLE IF NOT EXISTS system_performance_metrics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metric_type TEXT NOT NULL, -- 'cache_hit_rate', 'generation_time', 'user_satisfaction'
  metric_value REAL NOT NULL,
  episode_id TEXT,
  user_id TEXT,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  additional_data TEXT -- JSON with extra context
);

-- Cache performance tracking
CREATE TABLE IF NOT EXISTS cache_performance (
  date DATE PRIMARY KEY,
  total_requests INTEGER NOT NULL,
  cache_hits INTEGER NOT NULL,
  cache_misses INTEGER NOT NULL,
  hit_rate REAL NOT NULL,
  avg_generation_time_ms REAL NOT NULL,
  storage_size_mb REAL NOT NULL,
  cost_savings_usd REAL DEFAULT 0.0
);

-- =============================================================================
-- TRIGGERS FOR AUTOMATIC MAINTENANCE
-- =============================================================================

-- Update fragment last_accessed timestamp on each access
CREATE TRIGGER IF NOT EXISTS update_fragment_access
  AFTER INSERT ON fragment_usage_stats
  BEGIN
    UPDATE audio_fragments 
    SET last_accessed = CURRENT_TIMESTAMP,
        access_count = access_count + 1
    WHERE id = NEW.fragment_id;
  END;

-- Update user interest profile timestamp on interaction
CREATE TRIGGER IF NOT EXISTS update_user_profile_timestamp
  AFTER INSERT ON user_interactions
  BEGIN
    UPDATE user_interest_profiles 
    SET updated_at = CURRENT_TIMESTAMP
    WHERE user_id = NEW.user_id;
  END;

-- =============================================================================
-- VIEWS FOR EASY ANALYTICS
-- =============================================================================

-- View for cache efficiency analysis
CREATE VIEW IF NOT EXISTS cache_efficiency_view AS
SELECT 
  DATE(created_at) as date,
  COUNT(*) as fragments_created,
  AVG(access_count) as avg_access_count,
  SUM(file_size) as total_storage_bytes,
  AVG(quality_score) as avg_quality_score,
  COUNT(CASE WHEN access_count > 1 THEN 1 END) as reused_fragments,
  CAST(COUNT(CASE WHEN access_count > 1 THEN 1 END) AS REAL) / COUNT(*) as reuse_rate
FROM audio_fragments
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- View for user engagement insights
CREATE VIEW IF NOT EXISTS user_engagement_view AS
SELECT 
  ui.user_id,
  COUNT(DISTINCT ui.episode_id) as episodes_engaged,
  AVG(ea.completion_percentage) as avg_completion_rate,
  AVG(ea.session_duration_ms) / 1000.0 as avg_session_duration_seconds,
  COUNT(ui.id) as total_interactions,
  AVG(ui.engagement_score) as avg_engagement_score
FROM user_interactions ui
LEFT JOIN engagement_analytics ea ON ui.user_id = ea.user_id AND ui.episode_id = ea.episode_id
GROUP BY ui.user_id;

-- View for speaker performance analysis
CREATE VIEW IF NOT EXISTS speaker_performance_view AS
SELECT 
  sv.name,
  sv.role,
  sv.category,
  COUNT(ce.id) as total_exchanges,
  AVG(ce.duration_ms) as avg_exchange_duration,
  sv.usage_count,
  AVG(ui.engagement_score) as avg_user_engagement
FROM speaker_voices sv
LEFT JOIN conversation_exchanges ce ON 
  (sv.role = 'host' AND ce.speaker_role = 'host') OR 
  (sv.role = 'expert' AND ce.speaker_role = 'expert')
LEFT JOIN user_interactions ui ON ce.episode_id = ui.episode_id
GROUP BY sv.id
ORDER BY avg_user_engagement DESC;

-- =============================================================================
-- INITIAL DATA SETUP COMPLETE
-- =============================================================================

-- Set database version for migration tracking
CREATE TABLE IF NOT EXISTS schema_version (
  version INTEGER PRIMARY KEY,
  applied_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT OR REPLACE INTO schema_version (version) VALUES (1);

-- Success message
SELECT 'NEW_AUDIO_ARCHITECTURE database schema setup complete!' as status;
