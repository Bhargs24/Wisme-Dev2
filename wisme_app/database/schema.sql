-- Wisme Backend Database Schema
-- Supabase PostgreSQL Schema for Production Deployment
-- Updated with NEW_AUDIO_ARCHITECTURE support

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- User Profiles Table
CREATE TABLE user_profiles (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Learning Preferences
    learning_streak INTEGER DEFAULT 0,
    total_episodes_completed INTEGER DEFAULT 0,
    preferred_coach TEXT DEFAULT 'Kai',
    daily_goal_minutes INTEGER DEFAULT 30,
    
    -- Subscription & Billing
    subscription_status TEXT DEFAULT 'free',
    subscription_expires_at TIMESTAMP WITH TIME ZONE,
    
    -- User Settings
    notifications_enabled BOOLEAN DEFAULT true,
    audio_quality TEXT DEFAULT 'high',
    download_over_wifi_only BOOLEAN DEFAULT true,
    
    UNIQUE(user_id)
);

-- Episodes Table
CREATE TABLE episodes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- Episode Content
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    category TEXT NOT NULL,
    knowledge_level TEXT NOT NULL,
    coach_personality TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL,
    hashtags TEXT[] DEFAULT '{}',
    
    -- Episode Status
    is_completed BOOLEAN DEFAULT false,
    completion_percentage REAL DEFAULT 0.0,
    is_favorited BOOLEAN DEFAULT false,
    audio_url TEXT,
    transcript TEXT,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_played_at TIMESTAMP WITH TIME ZONE,
    
    -- Metadata
    episode_type TEXT DEFAULT 'generated', -- 'generated', 'curated', 'premium'
    ai_model_used TEXT DEFAULT 'gpt-4',
    voice_model_used TEXT DEFAULT 'elevenlabs',
    generation_cost_cents INTEGER DEFAULT 0
);

-- Learning Sessions Table (for analytics)
CREATE TABLE learning_sessions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    episode_id UUID REFERENCES episodes(id) ON DELETE CASCADE,
    
    -- Session Data
    duration_seconds INTEGER NOT NULL,
    completion_percentage REAL DEFAULT 0.0,
    session_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Device & Context
    device_type TEXT,
    platform TEXT,
    app_version TEXT,
    
    -- Learning Quality Metrics
    playback_speed REAL DEFAULT 1.0,
    pauses_count INTEGER DEFAULT 0,
    rewinds_count INTEGER DEFAULT 0,
    skips_count INTEGER DEFAULT 0
);

-- User Favorites Table
CREATE TABLE user_favorites (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    episode_id UUID REFERENCES episodes(id) ON DELETE CASCADE,
    favorited_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(user_id, episode_id)
);

-- Learning Journeys Table
CREATE TABLE learning_journeys (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- Journey Content
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL,
    knowledge_level TEXT NOT NULL,
    episode_ids UUID[] DEFAULT '{}',
    
    -- Journey Progress
    is_completed BOOLEAN DEFAULT false,
    completion_percentage REAL DEFAULT 0.0,
    current_episode_index INTEGER DEFAULT 0,
    
    -- Rewards & Achievements
    reward_badge TEXT,
    estimated_duration_minutes INTEGER DEFAULT 0,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

-- User Learning Stats View (for dashboard)
CREATE VIEW user_learning_stats AS
SELECT 
    up.user_id,
    up.learning_streak,
    up.total_episodes_completed,
    up.daily_goal_minutes,
    
    -- Current Stats
    COUNT(DISTINCT e.id) as total_episodes_created,
    COUNT(DISTINCT CASE WHEN e.is_completed THEN e.id END) as episodes_completed,
    COALESCE(SUM(CASE WHEN e.is_completed THEN e.duration_minutes END), 0) as total_minutes_learned,
    
    -- This Week Stats
    COUNT(DISTINCT CASE 
        WHEN ls.session_date >= date_trunc('week', NOW()) 
        THEN ls.id 
    END) as sessions_this_week,
    
    COALESCE(SUM(CASE 
        WHEN ls.session_date >= date_trunc('week', NOW()) 
        THEN ls.duration_seconds 
    END), 0) / 60 as minutes_this_week,
    
    -- Favorite Categories
    mode() WITHIN GROUP (ORDER BY e.category) as favorite_category,
    mode() WITHIN GROUP (ORDER BY e.coach_personality) as favorite_coach

FROM user_profiles up
LEFT JOIN episodes e ON up.user_id = e.user_id
LEFT JOIN learning_sessions ls ON up.user_id = ls.user_id
GROUP BY up.user_id, up.learning_streak, up.total_episodes_completed, up.daily_goal_minutes;

-- Indexes for Performance
CREATE INDEX idx_episodes_user_id ON episodes(user_id);
CREATE INDEX idx_episodes_category ON episodes(category);
CREATE INDEX idx_episodes_created_at ON episodes(created_at DESC);
CREATE INDEX idx_episodes_coach ON episodes(coach_personality);
CREATE INDEX idx_learning_sessions_user_date ON learning_sessions(user_id, session_date DESC);
CREATE INDEX idx_user_favorites_user_id ON user_favorites(user_id);

-- Full Text Search for Episodes
CREATE INDEX idx_episodes_search ON episodes USING gin(to_tsvector('english', title || ' ' || content));

-- Row Level Security (RLS) Policies
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE episodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;

-- User Profiles RLS
CREATE POLICY "Users can view own profile" ON user_profiles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON user_profiles
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own profile" ON user_profiles
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Episodes RLS
CREATE POLICY "Users can view own episodes" ON episodes
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own episodes" ON episodes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own episodes" ON episodes
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own episodes" ON episodes
    FOR DELETE USING (auth.uid() = user_id);

-- Learning Sessions RLS
CREATE POLICY "Users can view own sessions" ON learning_sessions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own sessions" ON learning_sessions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- User Favorites RLS
CREATE POLICY "Users can manage own favorites" ON user_favorites
    FOR ALL USING (auth.uid() = user_id);

-- Database Functions
CREATE OR REPLACE FUNCTION increment_user_stats(user_id_param UUID)
RETURNS void AS $$
BEGIN
    UPDATE user_profiles 
    SET 
        total_episodes_completed = total_episodes_completed + 1,
        learning_streak = CASE 
            WHEN updated_at::date = CURRENT_DATE - INTERVAL '1 day' 
            THEN learning_streak + 1
            WHEN updated_at::date = CURRENT_DATE 
            THEN learning_streak
            ELSE 1
        END,
        updated_at = NOW()
    WHERE user_id = user_id_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Update timestamps trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_profiles_updated_at 
    BEFORE UPDATE ON user_profiles 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_episodes_updated_at 
    BEFORE UPDATE ON episodes 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Initial Data Seeding (Optional)
INSERT INTO public.user_profiles (user_id, email, name, preferred_coach) VALUES
    ('00000000-0000-0000-0000-000000000000', 'demo@wisme.app', 'Demo User', 'Kai');

-- =============================================================================
-- NEW_AUDIO_ARCHITECTURE TABLES (PostgreSQL Version)
-- =============================================================================

-- Audio fragment cache for smart reuse and cost optimization  
CREATE TABLE audio_fragments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    content_hash TEXT NOT NULL UNIQUE,
    content_text TEXT NOT NULL,
    speaker_config JSONB NOT NULL, -- SpeakerVoice configuration
    audio_data BYTEA NOT NULL,
    file_size INTEGER NOT NULL,
    duration_ms INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_accessed TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    access_count INTEGER DEFAULT 1,
    similarity_hash TEXT NOT NULL,
    quality_score REAL DEFAULT 0.0,
    usage_context JSONB DEFAULT '[]', -- Array of usage contexts
    compression_ratio REAL DEFAULT 1.0
);

-- Indexes for efficient fragment lookups
CREATE INDEX idx_fragments_content_hash ON audio_fragments(content_hash);
CREATE INDEX idx_fragments_similarity ON audio_fragments(similarity_hash);
CREATE INDEX idx_fragments_last_accessed ON audio_fragments(last_accessed);
CREATE INDEX idx_fragments_duration ON audio_fragments(duration_ms);

-- User interest profiles for personalization
CREATE TABLE user_interest_profiles (
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    interests JSONB NOT NULL DEFAULT '{}', -- Interest weights
    learning_style JSONB NOT NULL DEFAULT '{}', -- Style preferences  
    engagement_history JSONB NOT NULL DEFAULT '[]', -- Engagement data
    preferred_speakers JSONB NOT NULL DEFAULT '[]', -- Speaker preferences
    listening_patterns JSONB NOT NULL DEFAULT '{}', -- Time patterns, speeds, etc.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User interaction tracking for machine learning
CREATE TABLE user_interactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    episode_id UUID REFERENCES episodes(id) ON DELETE CASCADE,
    interaction_type TEXT NOT NULL,
    interaction_data JSONB DEFAULT '{}',
    session_id UUID NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    position_ms INTEGER,
    speaker_at_time TEXT,
    engagement_score REAL DEFAULT 0.0
);

-- Indexes for analytics queries
CREATE INDEX idx_interactions_user_episode ON user_interactions(user_id, episode_id);
CREATE INDEX idx_interactions_type ON user_interactions(interaction_type);
CREATE INDEX idx_interactions_timestamp ON user_interactions(timestamp);

-- Conversation configurations for episodes
CREATE TABLE conversation_configs (
    episode_id UUID REFERENCES episodes(id) ON DELETE CASCADE PRIMARY KEY,
    conversation_type TEXT NOT NULL,
    host_speaker JSONB NOT NULL,
    expert_speaker JSONB NOT NULL, 
    total_exchanges INTEGER NOT NULL,
    total_duration_ms INTEGER NOT NULL,
    generated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    difficulty_level TEXT NOT NULL,
    topic_category TEXT NOT NULL
);

-- Individual conversation exchanges
CREATE TABLE conversation_exchanges (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    episode_id UUID REFERENCES episodes(id) ON DELETE CASCADE,
    exchange_order INTEGER NOT NULL,
    speaker_role TEXT NOT NULL,
    text_content TEXT NOT NULL,
    audio_file_path TEXT,
    duration_ms INTEGER NOT NULL,
    start_time_ms INTEGER NOT NULL,
    end_time_ms INTEGER NOT NULL,
    emphasis_level TEXT DEFAULT 'normal',
    emotional_tone TEXT DEFAULT 'neutral'
);

-- Speaker voices available in the system
CREATE TABLE speaker_voices (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    role TEXT NOT NULL,
    category TEXT NOT NULL, 
    voice_id TEXT NOT NULL, -- ElevenLabs voice ID
    personality_traits JSONB NOT NULL DEFAULT '[]',
    speaking_style JSONB NOT NULL DEFAULT '{}',
    expertise_areas JSONB NOT NULL DEFAULT '[]',
    sample_audio_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    usage_count INTEGER DEFAULT 0
);

-- Insert default speaker voices
INSERT INTO speaker_voices (id, name, role, category, voice_id, personality_traits, speaking_style, expertise_areas) VALUES
    (uuid_generate_v4(), 'Kai', 'host', 'technology', 'ElevenLabsVoiceID1', '["curious", "encouraging", "clear"]', '{"pace": "moderate", "energy": "high", "formality": "casual"}', '["technology", "programming", "ai"]'),
    (uuid_generate_v4(), 'Alex', 'expert', 'technology', 'ElevenLabsVoiceID2', '["knowledgeable", "patient", "detailed"]', '{"pace": "thoughtful", "energy": "moderate", "formality": "professional"}', '["software engineering", "machine learning", "data science"]'),
    (uuid_generate_v4(), 'Maya', 'host', 'business', 'ElevenLabsVoiceID3', '["enthusiastic", "practical", "engaging"]', '{"pace": "energetic", "energy": "high", "formality": "business_casual"}', '["entrepreneurship", "leadership", "strategy"]'),
    (uuid_generate_v4(), 'David', 'expert', 'business', 'ElevenLabsVoiceID4', '["experienced", "analytical", "insightful"]', '{"pace": "measured", "energy": "moderate", "formality": "professional"}', '["finance", "economics", "business_strategy"]');

-- =============================================================================
-- NEW_AUDIO_ARCHITECTURE COMPLETE
-- =============================================================================

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT SELECT ON user_learning_stats TO authenticated;
