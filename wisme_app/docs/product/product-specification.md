# Wisme Product Specification

**Version**: MVP++ (Scalable Foundation)  
**Scope**: Flutter App (Frontend + Backend via Firebase)  
**Last Updated**: January 2025  

## 🎯 Product Vision

Wisme is an AI-powered personalized learning platform that delivers bite-sized, engaging audio lessons tailored to individual interests and learning styles. Users can learn anything in 10-15 minute daily sessions with AI coaches that adapt to their preferences.

## 🏗️ Core System Architecture

### Authentication & User Identity
- **Sign Up/Login**: Email/Password, Google, Apple OAuth
- **User Profiles**: Name, avatar, preferences, learning streak, personalized coach data
- **Privacy & Consent**: GDPR compliance, user consent tracking
- **Device Management**: Platform detection, last login, push notification tokens
- **Account Controls**: Active/Suspended/Deleted status for admin control

### Onboarding Experience (3 Screens)
1. **Welcome & Intent**: "Why are you here?" - Upskill, Learn Daily, Explore, etc.
2. **Category Interests**: Select broad learning areas from 15 predefined categories
3. **Profile Setup**: Basic account setup and learning preferences

*Note: Learning-specific choices (style, coach, goals) happen AFTER topic selection for better UX flow*

## 🧠 Topic Personalization Flow (Post-Onboarding)

### Topic Input & Processing
- **Free-text Input**: Users describe interests (e.g., "AI in Education")
- **AI Category Detection**: Auto-classify into 15 content categories
- **Knowledge Level Detection**: Beginner, Intermediate, Advanced, Expert
- **Subtopic Identification**: AI detects related subtopics for episode branching

### Learning Customization (Per Topic)
- **Learning Style Choice**: Fundamentals, Case Studies, Mixed Approach
- **Coach Personality**: Choose between Kai (calm) or Vee (energetic)
- **Coach Customization**: Name and avatar personalization per topic
- **Learning Goals**: Explore, Master, Apply (influences content recommendations)

## 🎷 Audio-Based Learning System

### AI Content Generation
- **Episode Structure**: 10-15 minute lessons with Intro, Core Story, TL;DR, Daily Action
- **Dual-Voice Rendering**: Both Kai and Vee versions generated
- **Smart Content Reuse**: Semantic matching prevents duplicate content exposure
- **Adaptive Difficulty**: Content difficulty adjusts based on user progress

### Audio Experience
- **High-Quality TTS**: Professional voice synthesis for both coaches
- **Synchronized Transcripts**: Real-time text following audio playback
- **Mood Toggle**: Switch between coach personalities mid-episode
- **Bookmark System**: Save episodes to personal library
- **Interactive Q&A**: GPT-powered questions about lesson content

## 📚 Learning Journey System

### 5-Episode Journeys
- **Personalized Paths**: AI-generated learning sequences per topic
- **Smart Progression**: Episodes build on each other logically
- **Journey Types**: Linear, Modular, Exploratory approaches
- **Continuation Suggestions**: Deeper learning or topic branching after completion
- **Progress Tracking**: Visual timeline with current and upcoming lessons

### Content Intelligence
- **AI Context Notes**: Episode-level context for smooth transitions
- **Semantic Tagging**: Hidden hashtags for content discovery
- **Vector Embeddings**: Advanced content matching and recommendations
- **Version Control**: Content versioning and update tracking

## 🏠 Dashboard & Daily Experience

### Home Dashboard
- **Continue Learning**: Resume current journeys
- **Daily Streak**: Visual progress tracking
- **Coach Avatars**: Quick access to active learning topics
- **Feeling Curious?**: AI-suggested surprise topics based on interests

### Library & Organization
- **My Coaches**: All active coaches organized by topic
- **Saved Episodes**: Bookmarked and favorited content
- **Completed Journeys**: Archive of finished learning paths
- **Search & Discovery**: Natural language search with semantic matching

## 🔍 Smart Search & Discovery

### Advanced Search Capabilities
- **Natural Language**: Search by keywords or conversational phrases
- **Vector Matching**: AI embeddings find most relevant content
- **Episode Previews**: Quick summaries and voice previews
- **Trending Topics**: Popular content based on community behavior
- **Search Learning**: System improves from user search patterns

## 📊 Analytics & Gamification

### Progress Tracking
- **Daily Streaks**: Consecutive learning day tracking
- **Engagement Analytics**: Listen time, completion rates, revisit frequency
- **Mastery Indicators**: Topic expertise based on engagement patterns
- **Time Optimization**: Learning time preferences for smart notifications

### Motivation System
- **Coach Nudges**: Personalized encouragement from Kai/Vee
- **Milestone Celebrations**: Achievement animations and rewards
- **Progress Visualization**: Clear progress indicators and achievements
- **Adaptive Reminders**: Smart notification timing based on behavior

## ⚙️ Settings & Account Management

### User Controls
- **Profile Management**: Name, avatar, email, learning preferences
- **Playback Settings**: Speed control, default coach preference, dark mode
- **Privacy Controls**: Data download, account deletion, consent management
- **Notification Settings**: Customizable reminder schedules
- **Subscription Management**: Billing, upgrades, renewal tracking

## ⚠️ Content Safety & Moderation

### Safety Measures
- **Input Filtering**: OpenAI Moderation API for user inputs
- **Content Screening**: All generated content passes safety checks
- **Blocked Topics**: Curated denylist for inappropriate content
- **User Reporting**: Flagging system for community moderation
- **Behavioral Monitoring**: Pattern detection for abuse prevention

### Moderation Response
- **Mild Violations**: Content softening and rephrasing requests
- **Moderate/Severe**: Content blocking with educational messaging
- **Repeat Violations**: Progressive restrictions and account actions

## 🧩 Technical Implementation

### AI Generation System
- **Modular Content Blocks**: Structured generation for reusability
- **Template System**: Standardized formatting for consistency
- **Multi-Coach Pipeline**: Parallel generation for both personalities
- **Style Injection**: Dynamic tone and pacing based on preferences
- **Quality Control**: Multi-stage review and editing process

### Data Architecture
- **User Data**: Profiles, preferences, progress tracking
- **Content Data**: Episodes, journeys, metadata, embeddings
- **Analytics Data**: Engagement metrics, behavior patterns
- **Moderation Data**: Safety logs, flagged content, user reports

## 🚀 Success Metrics

### User Engagement
- **Retention**: 40% Day-30 retention (target vs Duolingo's 15%)
- **Session Length**: 25+ minute daily engagement
- **Learning Efficacy**: 80% real-world skill application rate
- **Satisfaction**: 4.8+ App Store rating consistently

### Content Quality
- **Completion Rates**: High episode completion percentages
- **User Ratings**: Positive feedback on lesson quality
- **Knowledge Transfer**: Measured learning outcome success
- **Coach Preference**: Balanced usage between Kai and Vee

## 📱 Platform Support

### Initial Release
- **iOS**: iPhone and iPad support
- **Android**: Phone and tablet support
- **Cross-Platform**: Flutter-based unified codebase

### Future Platforms
- **Web**: Progressive Web App for desktop access
- **Wearables**: Apple Watch and Wear OS integration
- **Smart Speakers**: Alexa and Google Home compatibility
