# 📄 Wisme – Full Product & Development Specification (Finalized)

**Version**: MVP++ (Scalable Foundation)  
**Scope**: Flutter App (Frontend + Backend via Firebase)  
**Target Launch**: Q4 2025  

## 🔐 0. Authentication & User Identity

| Feature | Description |
|---------|-------------|
| **Sign Up / Login** | Required to use the app. Options: Email/Password, Google, or Apple. |
| **User Profiles** | Stores user info (name, avatar), preferences, learning streak, and personalized coach data. |
| **Consent & Privacy** | GDPR consent version, user agreed date. |
| **Device Metadata** | Platform, last login, device token for notifications. |
| **Account Status** | Active, Suspended, or Deleted (for admin control). |
| **App Version Tracking** | Track last used app version for debug & segmentation. |

## 🔀 1. Onboarding Experience

| Feature | Description |
|---------|-------------|
| **Welcome & Intent** | "Why are you here?" – Upskill, Learn Daily, Explore, etc. |
| **Category Preferences** | User selects their favorite categories to personalize suggestions. |
| **Profile Setup** | Basic account completion and preferences. |

**🎯 Key Improvement**: Streamlined to 3 screens. Learning-specific choices (style, coach, goals) moved to post-topic selection for better UX flow.

## 🧠 2. Topic Personalization Flow

| Feature | Description |
|---------|-------------|
| **Topic Input** | Free-text input to describe interest (e.g., "AI in Education") |
| **Category & Level Mapping** | AI auto-detects topic category (15 types) and knowledge level (4 levels) |
| **Learning Style Choice** | Fundamentals / Case Studies / Mixed, etc. |
| **Coach Personality Choice** | Choose per-topic voice tone: Kai (calm) or Vee (energetic) |
| **Coach Customization** | Name and avatar per coach, saved with the topic. |
| **Topic Goal (optional)** | Optional field: "Explore, Master, Apply" – influences future suggestions. |
| **Subtopic Detection** | AI detects subtopics for branching episodes later. |
| **Revisit Tracker** | Tracks how many times a topic was returned to. |

## 🎷 3. Audio-Based Lessons

| Feature | Description |
|---------|-------------|
| **AI Audio Lessons** | 10–15 min episodes with intro, core story, TL;DR, daily action. |
| **Dual-Voice Options** | Kai or Vee audio rendering per episode. |
| **Scrollable Transcript** | Live-synced text with audio. |
| **Bookmark / Save** | Save episodes to Library. |
| **Ask the Coach** | GPT-powered Q&A on any lesson. |
| **Mood Toggle** | Switch voice tone mid-episode if both versions exist. |
| **Episode Feedback** | One-tap emoji/scale rating for quick feedback. |
| **Playback Stats** | Stores time listened, completion rate, revisit time. |

## 📚 4. Learning Journey System

| Feature | Description |
|---------|-------------|
| **5-Episode Journeys** | Smart personalized journeys per topic. |
| **Episode Titles** | Tailored (e.g. "Growth Hacking 101", "The Airbnb Playbook"). |
| **Journey View** | Timeline showing current & upcoming lessons. |
| **Journey Status** | Active / Completed / In Progress. |
| **Journey Continuation** | Suggests deeper learning or topic branching after 5 episodes. |
| **Journey Type** | Linear / Modular / Exploratory (for future flexibility). |
| **AI Context Notes** | Episode-level context to help transitions between lessons. |

## ♻️ 5. Content Reuse Engine

| Feature | Description |
|---------|-------------|
| **Smart Storage** | Stored by: Topic > Category > Level > Coach > Episode. |
| **Hashtag Metadata** | Hidden hashtags attached to each episode (semantic tags). |
| **Semantic Matching** | Uses hashtag + vector embedding to match user queries to stored content. |
| **Dynamic Composer** | Reuses existing content and fills gaps with new generation. |
| **Versioning** | Episodes store version, last_updated, reuse_count. |
| **Seen Tracker** | Prevents reuse of previously listened content per user. |
| **Difficulty & Tone Tagging** | Episode scored by difficulty and emotional tone. |

## 🏠 6. Dashboard & Daily Use

| Feature | Description |
|---------|-------------|
| **Home Dashboard** | Next up, coach avatars, progress status. |
| **My Coaches** | Displays each coach (by topic), active journeys. |
| **Library** | Bookmarked + completed episodes. |
| **Feeling Curious?** | Suggests surprise topics based on user interest graph. |
| **Mood Selector** | Global toggle: all content in Kai or Vee style. |
| **Daily Prompting** | Encouragements or reflective questions. |

## 🔍 7. Smart Search & Topic Explorer

| Feature | Description |
|---------|-------------|
| **Natural Language Search** | Search by keywords or phrases. |
| **Vector Matching** | Uses AI embeddings to find most relevant episodes. |
| **Episode Previews** | Title, summary, coach voice preview. |
| **Trending Topics** | Based on aggregated behavior data. |
| **Search Logs** | Tracks search behavior for future personalization. |

## 📊 8. Progress, Analytics & Gamification

| Feature | Description |
|---------|-------------|
| **Daily Streak Tracker** | Days in a row the user learned something. |
| **Playback Analytics** | How long, how often, completion rates. |
| **Coach Nudges** | Kai/Vee nudge you to keep learning. |
| **Milestone Animations** | Celebratory animations for journey or streak milestones. |
| **Time-of-Day Trends** | Tracks when user learns to optimize reminders. |
| **Tag-based Mastery** | Tracks experience by hashtags to detect mastery or gaps. |

## ⚙️ 9. Settings & Account Management

| Feature | Description |
|---------|-------------|
| **Profile Settings** | Name, avatar, email, learning preferences. |
| **Playback Settings** | Speed, tone preference, dark mode. |
| **Privacy & Data Control** | Download or delete account + data. |
| **OAuth Provider Data** | Google/Apple login metadata. |
| **Notification Settings** | Time-based or streak-based reminder controls. |
| **Subscription Settings** | Billing, upgrades, renewal history. |
| **Referral System** | Invite code, referrals tracked for future growth. |

## ⚠️ 10. Content Moderation & Safety Layer

| Area | Method |
|------|--------|
| **User Input Filtering** | Use moderation API (OpenAI, Perspective API) to scan inputs |
| **Blocked Topics DB** | Manual + AI-curated denylist (e.g. hate, violence, adult) |
| **Flagging System** | Tag flagged content (flagged_reason, flagged_at) |
| **Shadow Filtering** | Show vague response: "Try rewording or pick another topic" |
| **Episode Moderation** | Final content passed through second safety scan before saving |
| **Auto-Learn Filter** | Logs edge cases to improve moderation logic over time |
| **User Behavior Log** | Detect repeat abuse, auto-warn/suspend if needed |

### 🔐 Technical Details
- Use OpenAI /moderations or Perspective API
- All prompt/generation calls return moderation metadata:
```json
{
  "moderation_status": "safe" | "flagged" | "review_needed",
  "flagged_categories": ["hate", "violence"]
}
```

### 🔹 Suggested Response Cases
| Level of Violation | Action |
|-------------------|--------|
| **Mild** | Warn; soften content or request rephrasing |
| **Moderate/Severe** | Block response; show message about sensitive topic |
| **Repeated Violation** | Shadow-ban topic creation, limit personalization access |

## 📂 Firebase Database Structure

### User Data
```
/users/{userId}
├── profile: { name, avatar, preferences, created_at }
├── learning_history: { topics, progress, streaks, total_time }
├── coaches: { [topicId]: { name, personality, avatar, customization } }
├── analytics: { engagement_metrics, learning_patterns, preferences }
└── moderation: { flagged_count, last_flagged_at, behavior_score }
```

### Content Data
```
/topics/{topicId}
├── metadata: { category, level, created_at, popularity }
├── episodes: { [episodeId]: { title, content, audio_urls, transcript } }
├── journey: { episode_sequence, prerequisites, difficulty_curve }
└── analytics: { completion_rates, user_ratings, engagement_score }

/episodes/{episodeId}
├── content: { title, description, transcript, duration }
├── audio: { kai_url, vee_url, file_sizes, generation_metadata }
├── metadata: { tags, difficulty, category, topics, version }
├── analytics: { play_count, completion_rate, user_ratings }
└── moderation: { safety_status, review_flags, last_moderated }
```

### Content Generation
```
/content_cache/
├── semantic_embeddings: { [contentId]: embedding_vector }
├── reuse_mappings: { topic_combinations, common_segments }
├── generation_templates: { category_prompts, coach_styles }
└── quality_scores: { content_ratings, engagement_metrics }
```

## 🧩 11. Modular AI Generation & System Design

| Feature | Description |
|---------|-------------|
| **Generation Blocks** | AI-generated content is structured into blocks (Intro, Core, TL;DR, Action). |
| **Block Templates** | Each block uses standardized tone + pacing depending on coach + style. |
| **Component Reusability** | Each segment can be reused across episodes and adapted by context. |
| **Multi-Coach Support** | Dual render pipelines (Kai/Vee) use same logic, different tone templates. |
| **Style Prompt Injection** | Style tokens injected at generation time (e.g. calm, fast-paced, story-rich). |
| **Subtopic Modularity** | Subtopics can be generated as independent mini-episodes or grouped. |
| **Controlled Regeneration** | Editors/devs can regenerate specific blocks or segments as needed. |
| **AI Planning Pass** | Before generation, AI maps the journey structure with episode intents. |
| **System Roles** | Each generation stage has a role: Planner, Narrator, Voice Stylist, Editor. |

## 🎯 Success Metrics & KPIs

### User Engagement
- **Daily Active Users**: Target 10K+ by month 3
- **Session Duration**: 25+ minutes average
- **Retention Rate**: 40% Day-30, 20% Day-90
- **Episode Completion**: 80%+ completion rate

### Learning Effectiveness
- **Knowledge Retention**: 90% recall after 7 days
- **Skill Application**: 80% users apply learned concepts
- **Goal Achievement**: 70% users complete learning objectives
- **Coach Preference**: Balanced usage between Kai and Vee

### Business Metrics
- **User Acquisition Cost**: <$15 per user
- **Lifetime Value**: $120+ per user
- **Monthly Revenue**: $50K+ by month 6
- **Content Production**: 100+ episodes per week

## 🚀 Implementation Phases

### **Phase 1: Foundation (Weeks 1-6)**
✅ Authentication, onboarding, basic UI, navigation

### **Phase 2: AI Content System (Weeks 7-10)**
✅ 15-category content generation, semantic reuse, dual coach system

### **Phase 3: Audio Learning (Weeks 11-14)**
🔧 Episode generation, audio player, TTS integration, interactive features

### **Phase 4: Learning Journeys (Weeks 15-18)**
📋 5-episode journeys, topic processing, progress tracking

### **Phase 5: Dashboard & Discovery (Weeks 19-22)**
📋 Home dashboard, library, search, discovery features

### **Phase 6: Analytics & Polish (Weeks 23-26)**
📋 Progress analytics, gamification, optimization, launch preparation

## 🔮 Future Roadmap (Post-Launch)

### **Year 2: Advanced Intelligence**
- ML-driven content personalization
- Voice cloning for personalized coaches
- Real-time content adaptation
- Predictive learning recommendations

### **Year 3: Platform Expansion**
- Enterprise learning solutions
- Creator economy and user-generated content
- Global expansion with multi-language support
- API platform for third-party integrations

### **Year 4: Next-Generation Learning**
- AR/VR immersive learning experiences
- IoT integration with smart home devices
- Blockchain-verified learning credentials
- AI teaching assistant capabilities

---

**📈 Overall Vision**: Wisme will become the most intelligent, engaging, and effective personalized learning platform, setting new standards for retention, engagement, and learning outcomes in the digital education space.
