# Wisme System Architecture

**Version**: MVP Foundation  
**Technology Stack**: Flutter + Firebase  
**Last Updated**: January 2025  

## 🏗️ High-Level Architecture

### System Overview
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │   Firebase      │    │   AI Services   │
│  (Mobile/Web)   │◄──►│   Backend       │◄──►│  (OpenAI/TTS)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Local State   │    │  Cloud Storage  │    │  Audio Files    │
│ (Preferences)   │    │  (User Data)    │    │   (Generated)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📱 Flutter Application Layer

### Core Architecture Pattern
**Feature-Based Modular Architecture**
- Clean separation of concerns
- Scalable and maintainable structure
- Independent feature development

### State Management
**Provider Pattern**
```dart
// Example state management structure
ChangeNotifierProvider<AuthProvider>
├── UserProvider (user profile, preferences)
├── LearningProvider (current learning state)
├── AudioProvider (playback controls)
└── ThemeProvider (UI theming)
```

### Directory Structure
```
lib/
├── core/                     # Core functionality
│   ├── constants/           # App-wide constants
│   ├── models/              # Data models
│   ├── services/            # External service integrations
│   ├── theme/               # Material Design 3 theming
│   └── utils/               # Helper functions
├── features/                # Feature modules
│   ├── auth/                # Authentication
│   ├── onboarding/          # User onboarding
│   ├── learning/            # Learning choice flows
│   ├── dashboard/           # Home dashboard
│   ├── audio/               # Audio playback
│   └── profile/             # User profile management
├── shared/                  # Shared components
│   ├── widgets/             # Reusable UI components
│   └── providers/           # Shared state providers
└── main.dart                # Application entry point
```

## 🔥 Firebase Backend Layer

### Authentication
**Firebase Auth with OAuth**
```
User Registration/Login
├── Email/Password authentication
├── Google OAuth integration
├── Apple Sign-In (iOS)
└── Guest mode with upgrade path
```

### Database Design
**Cloud Firestore Structure**
```
/users/{userId}
├── profile: { name, avatar, preferences }
├── learning_history: { topics, progress, streaks }
├── coaches: { [topicId]: { name, personality, avatar } }
└── analytics: { engagement_metrics, learning_stats }

/topics/{topicId}
├── metadata: { category, level, created_at }
├── episodes: { [episodeId]: { title, content, audio_url } }
├── journey: { episode_sequence, progress_tracking }
└── analytics: { popularity, completion_rates }

/content/{contentId}
├── generated_content: { text, metadata, version }
├── audio_files: { kai_version, vee_version }
├── tags: { semantic_tags, difficulty, topics }
└── moderation: { safety_status, review_flags }
```

### Storage Architecture
**Firebase Storage Organization**
```
/audio/
├── generated/
│   ├── kai/          # Calm coach audio files
│   └── vee/          # Energetic coach audio files
├── user_uploads/     # User-generated content
└── cache/            # Temporary audio cache

/assets/
├── avatars/          # Coach and user avatars
├── images/           # UI images and illustrations
└── icons/            # App iconography
```

## 🤖 AI Services Layer

### Content Generation Pipeline
```
User Input → Topic Analysis → Content Planning → Episode Generation → Audio Synthesis
     │             │               │                  │                  │
     ▼             ▼               ▼                  ▼                  ▼
OpenAI API    Category AI     Journey AI        Content AI         TTS Service
```

### OpenAI Integration
**Content Generation Workflow**
1. **Topic Analysis**: Categorize and assess difficulty level
2. **Journey Planning**: Create 5-episode learning sequence
3. **Episode Generation**: Generate structured content blocks
4. **Personalization**: Adapt content for coach personality
5. **Quality Assurance**: Content moderation and safety checks

### Text-to-Speech System
**Dual-Coach Audio Generation**
```
Generated Text Content
├── Kai Personality Processing (calm, thoughtful)
└── Vee Personality Processing (energetic, motivating)
         │                              │
         ▼                              ▼
    Kai Audio File                 Vee Audio File
```

## 🔄 Data Flow Architecture

### User Learning Journey
```
1. User Input (Topic Interest)
   ↓
2. AI Processing (Category + Level Detection)
   ↓
3. Learning Customization (Style + Coach + Goals)
   ↓
4. Content Generation (5-Episode Journey)
   ↓
5. Audio Synthesis (Dual-Coach Versions)
   ↓
6. Learning Session (Audio Playback + Interaction)
   ↓
7. Progress Tracking (Analytics + Recommendations)
```

### Real-time Synchronization
```
Flutter App ←→ Firebase Realtime Updates
     │              │
     ├── User Progress Sync
     ├── Content Updates
     ├── Analytics Events
     └── Coach Preferences
```

## 🛡️ Security Architecture

### Authentication Security
- **JWT Tokens**: Secure session management
- **OAuth Integration**: Trusted third-party authentication
- **Biometric Auth**: Device-level security (future)
- **Session Management**: Automatic token refresh

### Data Security
- **Firestore Rules**: Database-level access control
- **Content Moderation**: AI-powered safety filtering
- **User Privacy**: GDPR compliance and data controls
- **Encryption**: End-to-end data protection

### Content Safety
```
User Input → Moderation API → Content Filter → Safe Content Generation
     │             │               │                    │
     ▼             ▼               ▼                    ▼
Input Scan    Safety Check    Content Review      Clean Output
```

## 📊 Analytics & Monitoring

### User Analytics
**Firebase Analytics Integration**
- Learning session tracking
- Feature usage metrics
- User engagement patterns
- Conversion funnel analysis

### Performance Monitoring
**Firebase Performance**
- App startup time
- Screen load performance
- Audio playback quality
- Network request optimization

### Error Tracking
**Firebase Crashlytics**
- Real-time crash reporting
- Error trend analysis
- Performance issue detection
- User impact assessment

## 🔧 Development Architecture

### Build System
```
Source Code → Flutter Build → Platform Compilation → App Distribution
     │             │               │                      │
     ▼             ▼               ▼                      ▼
   Git Repo    Flutter SDK    iOS/Android SDK      App Stores
```

### Testing Strategy
```
Unit Tests → Widget Tests → Integration Tests → E2E Tests
     │             │               │               │
     ▼             ▼               ▼               ▼
Business     UI Components    User Flows     Complete App
  Logic
```

### Deployment Pipeline
```
Development → Testing → Staging → Production
     │            │         │          │
     ▼            ▼         ▼          ▼
Local Dev    CI/CD Tests  Beta Release  App Store
```

## 🚀 Scalability Considerations

### Performance Optimization
- **Lazy Loading**: Load content on demand
- **Caching Strategy**: Local storage for frequent data
- **Image Optimization**: WebP format, multiple resolutions
- **Code Splitting**: Modular loading for large features

### Database Scalability
- **Firestore Limits**: Document size and query optimization
- **Indexing Strategy**: Efficient query performance
- **Data Partitioning**: Logical separation by user/topic
- **Archive Strategy**: Historical data management

### Audio System Scalability
- **CDN Distribution**: Global audio file delivery
- **Compression**: Optimized audio formats
- **Streaming**: Progressive audio loading
- **Offline Support**: Downloaded content for offline use

## 🔮 Future Architecture Evolution

### Microservices Migration
**Planned Service Decomposition**
- Authentication Service
- Content Generation Service
- Audio Processing Service
- Analytics Service
- Recommendation Engine

### Advanced AI Integration
- **Voice Cloning**: Personalized coach voices
- **Real-time Adaptation**: Dynamic content adjustment
- **Multimodal Learning**: Visual + Audio + Interactive
- **Predictive Analytics**: Learning outcome prediction

### Platform Expansion
- **Web Application**: Desktop browser support
- **Voice Assistants**: Alexa, Google Home integration
- **Wearables**: Apple Watch, Wear OS apps
- **IoT Integration**: Smart home learning triggers

This architecture provides a solid foundation for Wisme's growth from MVP to a comprehensive learning platform, with built-in scalability and flexibility for future enhancements.
