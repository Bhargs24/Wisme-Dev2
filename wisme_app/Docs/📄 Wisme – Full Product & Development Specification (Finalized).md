📄 Wisme – Full Product & Development Specification (Finalized)
Version: MVP++ (Scalable Foundation)
 Scope: Flutter App (Frontend + Backend via Supabase / Firebase)
________________________________________
🔐 0. Authentication & User Identity
Feature	Description
Sign Up / Login	Required to use the app. Options: Email/Password, Google, or Apple.
User Profiles	Stores user info (name, avatar), preferences, learning streak, and personalized coach data.
Consent & Privacy	GDPR consent version, user agreed date.
Device Metadata	Platform, last login, device token for notifications.
Account Status	Active, Suspended, or Deleted (for admin control).
App Version Tracking	Track last used app version for debug & segmentation.
________________________________________
🔀 1. Onboarding Experience
Feature	Description
Multi-Screen Intro	Swipeable onboarding slides: what Wisme is, how it works, benefits.
Intent Selection	"Why are you here?" – Upskill, Learn Daily, Explore, etc.
Category Preferences	User selects their favorite categories to personalize suggestions.
________________________________________
🧠 2. Topic Personalization Flow
Feature	Description
Topic Input	Free-text input to describe interest (e.g., “AI in Education”)
Category & Level Mapping	AI auto-detects topic category (15 types) and knowledge level (4 levels)
Learning Style Choice	Fundamentals / Case Studies / Mixed, etc.
Coach Personality Choice	Choose per-topic voice tone: Kai (calm) or Vee (energetic)
Coach Customization	Name and avatar per coach, saved with the topic.
Topic Goal (optional)	Optional field: "Explore, Master, Apply" – influences future suggestions.
Subtopic Detection	AI detects subtopics for branching episodes later.
Revisit Tracker	Tracks how many times a topic was returned to.
________________________________________
🎷 3. Audio-Based Lessons
Feature	Description
AI Audio Lessons	10–15 min episodes with intro, core story, TL;DR, daily action.
Dual-Voice Options	Kai or Vee audio rendering per episode.
Scrollable Transcript	Live-synced text with audio.
Bookmark / Save	Save episodes to Library.
Ask the Coach	GPT-powered Q&A on any lesson.
Mood Toggle	Switch voice tone mid-episode if both versions exist.
Episode Feedback	One-tap emoji/scale rating for quick feedback.
Playback Stats	Stores time listened, completion rate, revisit time.
________________________________________
📚 4. Learning Journey System
Feature	Description
5-Episode Journeys	Smart personalized journeys per topic.
Episode Titles	Tailored (e.g. “Growth Hacking 101”, “The Airbnb Playbook”).
Journey View	Timeline showing current & upcoming lessons.
Journey Status	Active / Completed / In Progress.
Journey Continuation	Suggests deeper learning or topic branching after 5 episodes.
Journey Type	Linear / Modular / Exploratory (for future flexibility).
AI Context Notes	Episode-level context to help transitions between lessons.
________________________________________
♻️ 5. Content Reuse Engine
Feature	Description
Smart Storage	Stored by: Topic > Category > Level > Coach > Episode.
Hashtag Metadata	Hidden hashtags attached to each episode (semantic tags).
Semantic Matching	Uses hashtag + vector embedding to match user queries to stored content.
Dynamic Composer	Reuses existing content and fills gaps with new generation.
Versioning	Episodes store version, last_updated, reuse_count.
Seen Tracker	Prevents reuse of previously listened content per user.
Difficulty & Tone Tagging	Episode scored by difficulty and emotional tone.
________________________________________
🏠 6. Dashboard & Daily Use
Feature	Description
Home Dashboard	Next up, coach avatars, progress status.
My Coaches	Displays each coach (by topic), active journeys.
Library	Bookmarked + completed episodes.
Feeling Curious?	Suggests surprise topics based on user interest graph.
Mood Selector	Global toggle: all content in Kai or Vee style.
Daily Prompting	Encouragements or reflective questions.
________________________________________
🔍 7. Smart Search & Topic Explorer
Feature	Description
Natural Language Search	Search by keywords or phrases.
Vector Matching	Uses AI embeddings to find most relevant episodes.
Episode Previews	Title, summary, coach voice preview.
Trending Topics	Based on aggregated behavior data.
Search Logs	Tracks search behavior for future personalization.
________________________________________
📊 8. Progress, Analytics & Gamification
Feature	Description
Daily Streak Tracker	Days in a row the user learned something.
Playback Analytics	How long, how often, completion rates.
Coach Nudges	Kai/Vee nudge you to keep learning.
Milestone Animations	Celebratory animations for journey or streak milestones.
Time-of-Day Trends	Tracks when user learns to optimize reminders.
Tag-based Mastery	Tracks experience by hashtags to detect mastery or gaps.
________________________________________
⚙️ 9. Settings & Account Management
Feature	Description
Profile Settings	Name, avatar, email, learning preferences.
Playback Settings	Speed, tone preference, dark mode.
Privacy & Data Control	Download or delete account + data.
OAuth Provider Data	Google/Apple login metadata.
Notification Settings	Time-based or streak-based reminder controls.
Subscription Settings	Billing, upgrades, renewal history.
Referral System	Invite code, referrals tracked for future growth.
________________________________________
⚠️ 10. Content Moderation & Safety Layer
Area	Method
User Input Filtering	Use moderation API (OpenAI, Perspective API) to scan inputs
Blocked Topics DB	Manual + AI-curated denylist (e.g. hate, violence, adult)
Flagging System	Tag flagged content (flagged_reason, flagged_at)
Shadow Filtering	Show vague response: "Try rewording or pick another topic"
Episode Moderation	Final content passed through second safety scan before saving
Auto-Learn Filter	Logs edge cases to improve moderation logic over time
User Behavior Log	Detect repeat abuse, auto-warn/suspend if needed
🔐 Technical Details
●	Use OpenAI /moderations or Perspective API

●	All prompt/generation calls return moderation metadata:

{
  "moderation_status": "safe" | "flagged" | "review_needed",
  "flagged_categories": ["hate", "violence"]
}

🔹 Suggested Response Cases
Level of Violation	Action
Mild	Warn; soften content or request rephrasing
Moderate/Severe	Block response; show message about sensitive topic
Repeated Violation	Shadow-ban topic creation, limit personalization access
📂 Supabase Storage Additions
/MODERATION_LOGS/
  └── user_id/
      ├── prompt_logs.json
      ├── flagged_attempts.json
      └── moderation_events.json

Update /EPISODES entries with:
{
  "moderation_status": "safe",
  "flagged_categories": [],
  "last_moderated": "2025-07-11T12:00:00Z"
}

Update /USERS/user_id/profile.json with:
{
  "flagged_count": 2,
  "last_flagged_at": "2025-07-10T17:22:00Z"
}

📂 Flutter Folder Addition
/core/services/
  ├── moderation_service.dart  # Handles moderation API integration
  └── index.dart

/core/models/
  ├── moderation_result.dart
  └── moderation_category.dart

________________________________________
🧩 11. Modular AI Generation & System Design
Feature	Description
Generation Blocks	AI-generated content is structured into blocks (Intro, Core, TL;DR, Action).
Block Templates	Each block uses standardized tone + pacing depending on coach + style.
Component Reusability	Each segment can be reused across episodes and adapted by context.
Multi-Coach Support	Dual render pipelines (Kai/Vee) use same logic, different tone templates.
Style Prompt Injection	Style tokens injected at generation time (e.g. calm, fast-paced, story-rich).
Subtopic Modularity	Subtopics can be generated as independent mini-episodes or grouped.
Controlled Regeneration	Editors/devs can regenerate specific blocks or segments as needed.
AI Planning Pass	Before generation, AI maps the journey structure with episode intents.
System Roles	Each generation stage has a role: Planner, Narrator, Voice Stylist, Editor.
________________________________________
Let me know if you'd like a CLI generator, endpoint map, or AI system flowchart next.

