# Wisme User Flows & Screen Architecture

**Version**: Current Implementation  
**Last Updated**: January 2025  

## 📱 Complete Screen Architecture

### 🔐 Authentication Flow
*Entry point before onboarding or main app*

| Screen | Purpose | Status |
|--------|---------|--------|
| **0.1** Splash Screen | App logo/animation → auto-redirect | ✅ Implemented |
| **0.2** Sign Up/Login | OAuth (Google, Apple), email, guest mode | ✅ Implemented |
| **0.3** Account Setup | Username, T&Cs, basic preferences | ✅ Implemented |

### 🌀 Onboarding Flow (3 Screens)
*First-time user experience - simplified for better UX*

| Screen | Purpose | Status |
|--------|---------|--------|
| **1.1** Welcome & Intent | "Why are you here?" - Select motivation | ✅ Implemented |
| **1.2** Category Interests | Choose broad learning areas (15 categories) | ✅ Implemented |
| **1.3** Profile Setup | Account finalization and basic preferences | ✅ Implemented |

**Key UX Improvement**: Removed learning-specific choices (style, coach, goals) from onboarding. These now happen contextually after topic selection for better logical flow.

### 🧠 Learning Choice Flow (Post-Topic Selection)
*Contextual choices made AFTER user selects what to learn*

| Screen | Purpose | Status |
|--------|---------|--------|
| **2.1** Learning Style | How to learn this topic (Fundamentals/Cases/Mixed) | ✅ Implemented |
| **2.2** Coach Selection | Choose personality for this topic (Kai/Vee) | ✅ Implemented |
| **2.3** Learning Goals | What to achieve with this topic (Explore/Master/Apply) | ✅ Implemented |

### 🎯 Topic Entry & Processing
*Natural language topic input and AI processing*

| Screen | Purpose | Status |
|--------|---------|--------|
| **3.1** Topic Input | Free-text "What do you want to learn?" | 🔧 In Progress |
| **3.2** AI Processing | Behind-the-scenes categorization and planning | 🔧 In Progress |
| **3.3** Journey Preview | "Your plan is ready!" - show 5-episode preview | 📋 Planned |

### 🎧 Daily Learning Experience
*Core audio learning functionality*

| Screen | Purpose | Status |
|--------|---------|--------|
| **4.1** Audio Player | Main lesson player with coach toggle | 🔧 In Progress |
| **4.2** Transcript View | Synchronized scrollable text | 📋 Planned |
| **4.3** Ask Coach | AI Q&A about current lesson | 📋 Planned |
| **4.4** Episode Feedback | Quick rating and optional comments | 📋 Planned |
| **4.5** Next Suggestion | Continue journey or explore related topics | 📋 Planned |

### 🧭 Home Dashboard
*Main app navigation and daily use*

| Screen | Purpose | Status |
|--------|---------|--------|
| **5.1** Home Dashboard | Continue learning, streak, daily plan | 🔧 In Progress |
| **5.2** My Coaches | All active coaches organized by topic | 📋 Planned |
| **5.3** Library | Saved episodes, completed journeys | 📋 Planned |
| **5.4** Discovery | "Feeling curious?" surprise topic suggestions | 📋 Planned |
| **5.5** Search | Natural language content search | 📋 Planned |

### ⚙️ Settings & Profile
*Account management and preferences*

| Screen | Purpose | Status |
|--------|---------|--------|
| **6.1** Profile Settings | Name, avatar, basic info | 📋 Planned |
| **6.2** Learning Preferences | Default coach, playback speed, notifications | 📋 Planned |
| **6.3** Privacy & Data | Account controls, data download/deletion | 📋 Planned |
| **6.4** Subscription | Billing, plan management, upgrades | 📋 Planned |

## 🔄 User Journey Flows

### New User Journey
```
Splash → Auth → Onboarding (3 screens) → Home Dashboard → Topic Input → Learning Choices → Journey Start
```

### Returning User Journey
```
Splash → Home Dashboard → Continue Learning OR New Topic Input
```

### Daily Learning Session
```
Home → Audio Player → Transcript (optional) → Ask Coach (optional) → Feedback → Next Episode
```

## 🎨 Navigation Patterns

### Primary Navigation
- **Bottom Tab Bar**: Home, Library, Coaches, Profile
- **Floating Action Button**: "Learn Something New" topic input
- **Top App Bar**: Context-specific actions and search

### Secondary Navigation
- **Swipe Gestures**: Episode navigation, coach switching
- **Deep Links**: Direct links to specific episodes or journeys
- **Modal Sheets**: Settings, feedback, coach selection

## 📊 Screen Flow Logic

### Onboarding Decision Tree
```
New User?
├── Yes → Authentication → 3-Screen Onboarding → Dashboard
└── No → Authentication → Dashboard (skip onboarding)

Topic Selected?
├── First Time → Learning Choices Flow (3 screens)
└── Returning → Direct to Journey/Player
```

### Learning Flow States
```
Topic Input → AI Processing → Learning Choices → Journey Preview → Episode 1
Episode N → Feedback → Next Episode OR Journey Complete → Suggestions
```

### Coach System Flow
```
Per-Topic Basis:
Select Topic → Choose Coach → Customize Name/Avatar → Start Learning
Switch Coach → Preview Voice → Confirm Switch → Continue Learning
```

## 🚀 Implementation Status

### ✅ Completed Flows
- **Authentication**: Complete sign-up/login flow with OAuth
- **Onboarding**: 3-screen simplified flow (major UX improvement)
- **Learning Choices**: Post-topic selection choices (better logic)

### 🔧 In Progress
- **Home Dashboard**: Basic structure implemented
- **Audio Player**: Foundation in development
- **Topic Input**: AI integration in progress

### 📋 Next Priority
1. **Topic Input System**: Natural language processing
2. **Audio Player**: Complete playback functionality  
3. **AI Content Generation**: Episode creation pipeline
4. **Journey System**: 5-episode learning paths

## 🎯 UX Principles

### Design Philosophy
- **Simplicity First**: Minimal cognitive load for learning focus
- **Audio-Centric**: Visual elements support, don't distract from audio
- **Personalization**: Every choice tailors the experience
- **Progressive Disclosure**: Show complexity only when needed

### Accessibility
- **Voice-First Design**: Works without looking at screen
- **High Contrast**: Clear visual hierarchy and readability
- **Large Touch Targets**: Easy interaction for all users
- **Screen Reader Support**: Full VoiceOver/TalkBack compatibility

## 📱 Platform Considerations

### iOS Specific
- **Siri Integration**: "Hey Siri, continue my learning"
- **CarPlay Support**: Learning during commute
- **Watch App**: Quick learning session controls
- **Shortcuts App**: Custom learning automation

### Android Specific  
- **Google Assistant**: Voice command integration
- **Android Auto**: Hands-free learning while driving
- **Wear OS**: Wrist-based controls and progress
- **Tasker Integration**: Advanced automation possibilities
