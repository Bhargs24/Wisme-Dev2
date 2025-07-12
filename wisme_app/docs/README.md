# Wisme - Intelligent Learning Platform

**Version**: MVP++ (Scalable Foundation)  
**Status**: Production-Ready Development Phase  
**Last Updated**: January 2025  

## 🎯 Project Overview

Wisme is an AI-powered personalized learning platform that delivers bite-sized, engaging audio lessons tailored to individual interests and learning styles. Built with Flutter for cross-platform mobile deployment.

## 📁 Documentation Structure

```
docs/
├── README.md                           # This file - project overview
├── ai-content-generation-system.md    # Complete AI system specification
├── complete-development-roadmap.md    # 38-week development roadmap
├── features.md                         # Complete feature list and priorities
├── final-screen-list.md               # Screen architecture and user flows
├── full-product-specification.md      # Complete product requirements
├── smart-content-engine.md            # WSCE 2.0 technical specification
├── tts-audio-system-plan.md           # Audio/TTS system architecture
├── phase-2-completion.md              # Phase 2 implementation report
├── production-audit.md                # Current implementation audit
├── development-status.md              # Development progress tracking
└── development/                       # Technical architecture
    └── architecture.md                # System architecture overview
```

## 🚀 Quick Start

### Prerequisites
- Flutter 3.29.3+
- Dart 3.5+
- Android Studio / Xcode
- Firebase CLI
- VS Code with Flutter extensions

### Setup
```bash
# Clone repository
git clone <repository-url>
cd wisme_app

# Install dependencies
flutter pub get

# Run development build
flutter run
```

## 🏗️ Architecture Overview

### Core Technologies
- **Frontend**: Flutter 3.29.3 with Material Design 3
- **State Management**: Provider pattern
- **Backend**: Firebase (Auth, Firestore, Cloud Functions)
- **AI**: OpenAI GPT-4 for content generation
- **Audio**: Text-to-Speech integration
- **Storage**: Firebase Storage for audio files

### Key Features
- **Personalized Onboarding**: 3-screen flow for user setup
- **AI Content Generation**: Dynamic lesson creation
- **Dual Coach System**: Kai (calm) and Vee (energetic) personalities
- **Learning Journeys**: 5-episode structured learning paths
- **Audio-First Experience**: 10-15 minute engaging lessons

## 📊 Current Implementation Status

### ✅ Completed Features
- User authentication system
- Initial onboarding flow (3 screens)
- Basic UI components and themes
- Firebase integration setup
- Project architecture foundation

### 🔧 In Progress
- Learning choice flow (post-topic selection)
- AI content generation system
- Audio playback system
- Dashboard implementation

### 📋 Planned Features
- Coach personality system
- Advanced analytics
- Offline support
- Social features

## 🔗 Key Documents

1. **[AI Content Generation System](./ai-content-generation-system.md)** - Complete AI system with 15 categories
2. **[Smart Content Engine](./smart-content-engine.md)** - WSCE 2.0 technical specification  
3. **[Full Product Specification](./full-product-specification.md)** - Complete feature requirements
4. **[Complete Development Roadmap](./complete-development-roadmap.md)** - 38-week development plan
5. **[Final Screen List](./final-screen-list.md)** - Screen architecture and user flows
6. **[Features](./features.md)** - Complete feature list and priorities
7. **[TTS Audio System](./tts-audio-system-plan.md)** - Audio generation architecture
8. **[System Architecture](./development/architecture.md)** - Technical architecture overview
9. **[Phase 2 Completion](./phase-2-completion.md)** - Implementation achievements
10. **[Production Audit](./production-audit.md)** - Current system status

## 🎯 Vision & Goals

**Mission**: Create the world's most intelligent, personalized, and engaging daily learning platform that makes acquiring any skill as addictive as social media, but infinitely more valuable.

**Success Metrics**:
- 40% Day-30 retention rate
- 25+ minute daily session engagement
- 80% real-world skill transfer rate
- 4.8+ App Store rating consistently

## 🤝 Contributing

See [Development Guide](./development/setup-guide.md) for contribution guidelines and development workflow.

## 📄 License

[Add license information]
