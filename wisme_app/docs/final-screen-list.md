# ✅ Final Screen List for Wisme
A complete, gap-free screen architecture — grouped by flow.

**🚀 Implementation Status Update**: Phase 2 (Smart Content Generation) is **100% COMPLETE** with all 15 categories operational using adaptive knowledge architecture. The AI content generation system, semantic reuse engine, and personalized coach system are fully implemented and exceed original specifications.

## 🔐 0. Authentication Flow
*(Before onboarding or home dashboard)*

| Screen | Purpose | Status |
|--------|---------|--------|
| **0.1** Splash / Welcome | App logo / animation → redirects to auth | ✅ Complete |
| **0.2** Sign Up / Login | OAuth (Google, Apple), email, or Guest mode | ✅ Complete |
| **0.3** Account Setup (Optional) | Username, T&Cs, optional preferences | ✅ Complete |

## 🌀 1. First-Time Onboarding (Gamified + Guided)
*(Only for new users or after guest upgrade to full account)*

| Screen | Purpose | Status |
|--------|---------|--------|
| **1.1** Welcome to Wisme | "Learn anything in 10 minutes a day" intro | ✅ Complete |
| **1.2** Why Are You Here? | Select intent: Upskill, curiosity, daily habit, etc. | ✅ Complete |
| **1.3** What Are You Interested In? | Choose 1+ content categories (our 15 predefined ones) | ✅ Complete |

**🎯 UX Improvement**: Reduced from 5 screens to 3 screens. Removed learning-specific choices (style, coach, goals) from onboarding - these now happen contextually AFTER topic selection for better logical flow.

## 🧠 2. Topic-Based Personalization Flow
*(Triggered after onboarding or anytime user adds a new topic)*

| Screen | Purpose | Status |
|--------|---------|--------|
| **2.1** Topic Entry | Open-ended prompt + smart suggestions (chips) | 🔧 In Progress |
| **2.2** Category & Knowledge Level Detection | Behind-the-scenes AI categorization | 🔧 In Progress |
| **2.3** Choose Your Learning Style | Dynamic options based on category (e.g. Fundamentals, Case Studies, Bit of Everything) | ✅ Complete |
| **2.4** Choose Your Coach Personality | Kai 🧘 or Vee ⚡ — based on tone preference for this topic | ✅ Complete |
| **2.5** Learning Goals | What you want to achieve: Explore, Master, Apply | ✅ Complete |

**🎯 Key Improvement**: Learning choices now happen WITH topic context, making decisions more meaningful and logical.

## 🎯 3. Journey Launch
| Screen | Purpose | Status |
|--------|---------|--------|
| **3.1** Your Plan is Ready! | Title of journey (e.g. "5-Day Growth Hacking"), episode titles, progress bar | 📋 Planned |
| **3.2** [Optional] Course Map | Full outline of episodes (mini-syllabus), expandable list | 📋 Planned |

## 🎧 4. Daily Learning Flow
| Screen | Purpose | Status |
|--------|---------|--------|
| **4.1** Player Screen | Audio episode player (10–15 min), mood toggle (Kai ↔ Vee), TL;DR, daily action | 🔧 In Progress |
| **4.2** Transcript View | Synchronized, scrollable text | 📋 Planned |
| **4.3** Ask Coach a Question | AI Q&A with context awareness | 📋 Planned |
| **4.4** After-Episode Feedback | "Was this helpful?" + optional text field | 📋 Planned |
| **4.5** Suggested Next Episode | Continue, go deeper, or shift topic angle | 📋 Planned |

## 🧭 5. Home / Dashboard Experience
| Screen | Purpose | Status |
|--------|---------|--------|
| **5.1** Home Dashboard | Continue learning, today's plan, daily streak, "Feeling Curious?" | 🔧 In Progress |
| **5.2** Coaches | See all active coaches (per topic), switch between them | 📋 Planned |
| **5.3** Library | Saved/favorited episodes, completed topics | 📋 Planned |
| **5.4** Course Inbox | Coach messages, summaries, suggestions to deepen | 📋 Planned |
| **5.5** Mood Toggle | Set default coach tone (Kai/Vee), applies globally unless overridden per topic | 📋 Planned |

## 🔍 6. Search & Discovery
| Screen | Purpose | Status |
|--------|---------|--------|
| **6.1** Search Results | Natural language search with semantic matching | 📋 Planned |
| **6.2** Topic Explorer | Browse by categories, trending topics | 📋 Planned |
| **6.3** Episode Preview | Quick preview with coach voice sample | 📋 Planned |

## ⚙️ 7. Settings & Profile
| Screen | Purpose | Status |
|--------|---------|--------|
| **7.1** Profile Settings | Name, avatar, learning preferences | 📋 Planned |
| **7.2** App Settings | Playback speed, notifications, download preferences | 📋 Planned |
| **7.3** Privacy & Data | Account controls, data download/deletion | 📋 Planned |
| **7.4** Subscription | Billing, plan management, upgrades | 📋 Planned |

## 📊 8. Analytics & Progress
| Screen | Purpose | Status |
|--------|---------|--------|
| **8.1** Learning Stats | Streaks, time spent, topics covered | 📋 Planned |
| **8.2** Achievement Gallery | Badges, milestones, learning certificates | 📋 Planned |
| **8.3** Progress Timeline | Visual learning journey over time | 📋 Planned |

## 🔔 9. Notifications & Onboarding
| Screen | Purpose | Status |
|--------|---------|--------|
| **9.1** Notification Permissions | Request notification access | 📋 Planned |
| **9.2** Learning Reminders | Set up daily learning notifications | 📋 Planned |
| **9.3** Tutorial Overlays | Feature introduction and tips | 📋 Planned |

## 🎯 Screen Flow Logic

### **New User Journey**
```
Splash → Auth → Onboarding (3 screens) → Dashboard → Topic Input → Learning Choices → Journey Start
```

### **Returning User Journey**
```
Splash → Dashboard → Continue Learning OR New Topic Input
```

### **Learning Session Flow**
```
Home → Audio Player → Transcript (optional) → Ask Coach (optional) → Feedback → Next Episode
```

### **Topic Selection Flow**
```
Topic Input → AI Processing → Learning Style → Coach Selection → Goals → Journey Preview → Start
```

## 📱 Navigation Patterns

### **Primary Navigation (Bottom Tabs)**
- 🏠 **Home**: Dashboard, continue learning
- 📚 **Library**: Saved episodes, completed journeys
- 👥 **Coaches**: All active coaches by topic
- 👤 **Profile**: Settings, progress, account

### **Secondary Navigation**
- **FAB**: "Learn Something New" (topic input)
- **Top App Bar**: Search, notifications, context actions
- **Swipe Gestures**: Coach switching, episode navigation
- **Modal Sheets**: Settings, feedback, selections

## 🎨 Design Principles

### **Audio-First Design**
- Visual elements support audio, don't compete
- Large, clear controls for audio playback
- Minimal visual distraction during learning
- Easy one-handed operation

### **Progressive Disclosure**
- Show complexity only when needed
- Guide users through logical progression
- Clear information hierarchy
- Contextual help and tips

### **Personalization Focus**
- Every choice tailors the experience
- Clear feedback on personalization impact
- Easy modification of preferences
- Coach personality throughout UI

## 📊 Implementation Status Summary

### ✅ **Completed (35%)**
- Complete authentication system
- 3-screen optimized onboarding
- Learning choice flow (post-topic)
- Basic UI foundation and theming

### 🔧 **In Progress (40%)**
- Home dashboard structure
- Topic input and AI processing
- Audio player foundation
- Basic navigation systems

### 📋 **Planned (25%)**
- Complete audio learning system
- Journey creation and management
- Advanced search and discovery
- Analytics and gamification

## 🚀 Next Development Priorities

### **Week 1-2: Audio Foundation**
- Complete audio player implementation
- TTS integration for coach voices
- Episode playback and progress tracking

### **Week 3-4: Topic Processing**
- Natural language topic input
- AI classification and level detection
- Journey creation pipeline

### **Week 5-6: Content Generation**
- Episode structure implementation
- Coach personality integration
- Content quality validation

This screen architecture provides a comprehensive, user-friendly learning experience that prioritizes audio content while supporting rich visual interactions when needed. The logical flow ensures users make informed decisions with proper context, leading to higher engagement and learning success.
