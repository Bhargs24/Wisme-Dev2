# 🎯 Wisme Developer Guidebook
## "Beyond Duolingo Quality" - Professional Flutter Development Standards

> **Target Quality:** 40% Day-30 retention (vs Duolingo's 15%)  
> **Launch Target:** Q4 2025  
> **Architecture:** Production-grade Flutter with advanced AI content generation

---

## � **CURRENT DEVELOPMENT STATUS - MAJOR UPGRADE COMPLETE** ✅

### **Phase 2 Complete: Advanced AI Intelligence System**
- ✅ **Advanced Topic Classification:** Replaced hardcoded categorization with GPT-4 powered analysis
- ✅ **15 Categories × 4 Knowledge Levels:** Complete taxonomy system (60 learning combinations)
- ✅ **Podcast-Style Content Generation:** Professional prompt engineering for engaging content
- ✅ **Coach Personality System:** Kai (thoughtful) vs Vee (energetic) with distinct speech patterns
- ✅ **Intelligent Episode Planning:** AI-generated subtopics and learning paths

### **What Changed Today:**
1. **Removed Amateur Hardcoded Classification** 
   - Old: Simple regex matching with 8 basic categories
   - New: GPT-4 powered analysis with 15 categories and 4 levels each

2. **Added Professional Content Generation**
   - Category-specific prompt engineering
   - Coach personality integration
   - Podcast-style episode structures

3. **Created Comprehensive Documentation**
   - Complete AI Content Generation specification
   - Podcast-style prompt engineering masterclass
   - Implementation roadmap for production

---

## 📁 Updated Project Architecture

### Core Philosophy
Wisme now features **AI-first architecture** with sophisticated content generation that rivals the best educational podcasts and learning platforms.

```
lib/
├── core/                          # Professional foundation systems
│   ├── ai/                        # 🆕 Advanced AI classification & analysis
│   │   └── advanced_topic_classifier.dart
│   ├── content/                   # 🆕 Podcast-style content generation  
│   │   └── podcast_content_generator.dart
│   ├── animations/                # Motion design & micro-interactions
│   ├── accessibility/             # WCAG 2.1 AA compliance
│   ├── analytics/                 # Comprehensive user behavior tracking
│   ├── responsive/                # Adaptive design for all devices
│   ├── theme/                     # Design system & brand consistency
│   ├── validation/                # Form validation & data integrity
│   └── errors/                    # Error handling & user feedback
├── features/                      # Feature modules
│   ├── auth/                      # Authentication & onboarding
│   ├── onboarding/                # 5-screen gamified onboarding
│   ├── learning/                  # 🔄 Updated: AI topic input system
│   └── audio/                     # ElevenLabs audio engine
├── shared/                        # Reusable widgets & utilities
├── Docs/                          # 🆕 Complete documentation system
│   ├── 🧠 AI Content Generation System - Complete Specification.md
│   ├── 🎙️ Podcast-Style Content Generation - Prompt Engineering.md
│   └── [Additional specs...]
└── main.dart                      # Application entry point
```

---

## 🧠 **Advanced AI Classification System**

### Location: `lib/core/ai/advanced_topic_classifier.dart`

**Purpose:** Replaces amateur hardcoded categorization with sophisticated GPT-4 powered analysis.

#### **15 Primary Categories with 4 Knowledge Levels Each:**

1. **Technology & AI** - Core Concepts, Case Studies, Tools & Trends, Bit of Everything
2. **Business & Finance** - Fundamentals, Case Studies, Growth Strategy, Balanced Mix  
3. **Psychology & Mind** - Theories & Experiments, Real-Life Application, Mindfulness & Behavior, Mixed Approach
4. **Science & Nature** - Scientific Concepts, Discoveries, Ethics & Controversies, Narrative Mix
5. **Creativity & Design** - Design Fundamentals, Iconic Examples, Frameworks & Tools, Creative Blend
6. **Personal Development** - Philosophy & Mental Models, Self-Development, Habits & Mindset, Reflective Mix
7. **History & Culture** - Timelines, Cultural Impact, Media & Storytelling, Blended Approach
8. **Skills & Tools** - Getting Started, Pro Tools & Hacks, Workflows & Systems, Practical Guide
9. **Career & Strategy** - Identity & Purpose, Career Assets, Strategic Moves, Holistic Journey
10. **Law & Governance** - Legal Foundations, Governance & Policy, Case Law & Precedents, Civic Systems Mix
11. **Geopolitics & Global Affairs** - Power Dynamics, Diplomacy & Alliances, Conflicts & Security, Global Narrative Mix
12. **Environment & Sustainability** - Climate & Ecology, Sustainable Systems, Environmental Tech, Eco-Strategy Blend
13. **Mathematics & Logic** - Foundational Concepts, Applied Techniques, Logic & Formal Systems, Mathematical Narrative
14. **Gaming & Interactive Media** - Game Design Principles, Player Experience, Iconic Games & Genres, Gaming Culture Mix
15. **Society & Ethics** - Social Structures, Moral Frameworks, Real-World Ethics, Reflective Society Blend
16. **Futurism & Exploration** - Space & Cosmos, Emerging Futures, Exploration Scenarios, Futuristic Outlooks

#### Multi-Stage Analysis Process:
```dart
// Advanced topic analysis with AI
final classification = await AdvancedTopicClassifier.analyzeTopicWithAI(
  topic,
  userBackground: 'General learner',
  learningIntent: 'Explore and understand',
);

// Results include:
// - Intelligent category classification
// - Knowledge level detection  
// - Subtopic extraction for episodes
// - Learning style hints
// - Episode planning with progression
```

---

## 🎙️ **Podcast-Style Content Generation**

### Location: `lib/core/content/podcast_content_generator.dart`

**Purpose:** Creates engaging, personality-driven audio content that rivals professional podcasts.

#### **Category-Specific Prompt Engineering:**
- **Technology & AI:** Makes complex tech accessible with perfect analogies
- **Business & Finance:** Strategic storytelling with real-world drama
- **Psychology & Mind:** Science as adventure with practical applications  
- **Science & Nature:** Wonder-driven explanations that reveal hidden magic
- **Creativity & Design:** Visual thinking that enhances perception

#### **Coach Personality Integration:**

**Kai (Thoughtful Mentor):**
- Tone: Calm, philosophical, wise
- Openings: "Let's explore...", "Consider this..."
- Style: Socratic questioning, deep insights

**Vee (Energetic Friend):**
- Tone: Dynamic, enthusiastic, inspiring  
- Openings: "Hey there!", "This is going to blow your mind!"
- Style: Storytelling with energy, relatable excitement

#### **Episode Structure:**
```dart
final episodeContent = await PodcastContentGenerator.generateEpisodeContent(
  topic: topic,
  classification: classification,
  coachPersonality: 'Vee',
  subtopic: subtopic,
);

// Generated content includes:
// - Engaging intro (30-45 seconds)
// - Core content (8-12 minutes)  
// - TL;DR summary (60-90 seconds)
// - Daily action challenge (30-45 seconds)
```

---

## 🎨 Design System (WismeTheme)

### Location: `lib/core/theme/wisme_theme.dart`

**Purpose:** Provides comprehensive theming that surpasses industry standards with sophisticated color science and typography.

#### Key Features:
- **Brand Colors:** Primary blue (`#2196F3`), accent teal (`#00BCD4`)
- **Semantic Colors:** Success green, warning orange, error red, info blue
- **Typography:** SF Pro Display/Text with precise letter spacing
- **Shadows:** Four-tier shadow system (SM, MD, LG, XL)
- **Spacing:** Consistent 8px grid system (XS to 3XL)

#### Usage Example:
```dart
import 'package:wisme_app/core/core.dart';

Container(
  decoration: WismeTheme.cardDecoration,
  padding: EdgeInsets.all(WismeTheme.spaceMD),
  child: Text(
    'Professional Card',
    style: WismeTheme.headlineSmall,
  ),
)
```

#### Button Styles:
- `WismeTheme.primaryButtonStyle` - Primary CTAs
- `WismeTheme.secondaryButtonStyle` - Secondary actions
- `WismeTheme.textButtonStyle` - Tertiary actions

---

## 📱 Responsive Design (WismeResponsive)

### Location: `lib/core/responsive/wisme_responsive.dart`

**Purpose:** Ensures perfect user experience across all devices with adaptive layouts.

#### Breakpoints:
- **Mobile Small:** 320px
- **Mobile:** 375px  
- **Mobile Large:** 414px
- **Tablet:** 768px
- **Desktop:** 1200px

#### Key Functions:
```dart
// Device detection
bool isMobile = WismeResponsive.isMobile(context);
bool isTablet = WismeResponsive.isTablet(context);
bool isDesktop = WismeResponsive.isDesktop(context);

// Responsive values
double spacing = WismeResponsive.value(
  context,
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);

// Responsive padding
EdgeInsets padding = WismeResponsive.responsivePadding(context);
```

#### Layout Helpers:
- `responsiveGridColumns()` - Adaptive grid layouts
- `responsiveMaxWidth()` - Content width constraints
- `responsiveButtonSize()` - Touch-friendly button sizing

---

## ✨ Animation System (WismeAnimations)

### Location: `lib/core/animations/wisme_animations.dart`

**Purpose:** Professional motion design exceeding Duolingo's standards with delightful micro-interactions.

#### Performance Standards:
- **60 FPS** guaranteed on all animations
- **Optimized durations:** Fast (200ms), Medium (300ms), Slow (500ms)
- **Smooth curves:** easeOut, easeInOut, spring, bounce

#### Core Animations:
```dart
// Fade animations
Widget fadeInWidget = WismeAnimations.fadeIn(
  child: YourWidget(),
  duration: WismeAnimations.fast,
);

// Slide animations
Widget slideInWidget = WismeAnimations.slideInFromBottom(
  child: YourWidget(),
  delay: Duration(milliseconds: 100),
);

// Scale animations
Widget scaleInWidget = WismeAnimations.scaleIn(
  child: YourWidget(),
);

// Staggered list animations
Widget staggeredList = WismeAnimations.staggeredList(
  children: [widget1, widget2, widget3],
  staggerDelay: Duration(milliseconds: 100),
);
```

#### Interaction Animations:
- `pressableScale()` - Button press feedback
- `heroLogo()` - Logo transitions
- `shimmer()` - Loading states

---

## ♿ Accessibility (WismeAccessibility)

### Location: `lib/core/accessibility/wisme_accessibility.dart`

**Purpose:** WCAG 2.1 AA compliance ensuring inclusive design for all users.

#### Key Features:
- **Screen reader support** with semantic labels
- **Haptic feedback** for user actions
- **Keyboard navigation** support
- **High contrast** mode compatibility
- **Large text** scaling support

#### Usage Examples:
```dart
// Accessible button
WismeAccessibility.accessibleButton(
  label: 'Sign in to your account',
  onPressed: () => signIn(),
  child: Text('Sign In'),
);

// Accessible text field
WismeAccessibility.accessibleTextField(
  label: 'Email address input field',
  controller: emailController,
  hint: 'Enter your email',
);

// Announce messages
WismeAccessibility.announceSuccess('Account created successfully');
WismeAccessibility.announceError('Please check your credentials');
```

#### Focus Management:
- `requestFocus()` - Move focus to specific elements
- `clearFocus()` - Remove focus from inputs
- `nextFocus()` / `previousFocus()` - Navigate between fields

---

## 📊 Analytics System (WismeAnalytics)

### Location: `lib/core/analytics/wisme_analytics.dart`

**Purpose:** Comprehensive user behavior tracking enabling data-driven product decisions.

#### Event Categories:
- **Authentication:** Sign up/in events, password strength
- **Navigation:** Screen views, button presses, back navigation
- **Engagement:** Feature interactions, time spent, preferences
- **Errors:** Error tracking, validation failures
- **Performance:** Load times, metrics

#### Usage Examples:
```dart
// Track authentication events
WismeAnalytics.trackSignUpStarted();
WismeAnalytics.trackSignUpCompleted('email');

// Track navigation
WismeAnalytics.trackScreenView('welcome_screen');
WismeAnalytics.trackButtonPress('sign_in_button', 'welcome_screen');

// Track engagement
WismeAnalytics.trackFeatureInteraction('password_strength_meter');
WismeAnalytics.trackTimeSpent('onboarding', Duration(minutes: 3));

// Track errors
WismeAnalytics.trackError('validation', 'Invalid email format', 'sign_up_form');
```

#### Conversion Tracking:
- `trackOnboardingStep()` - Monitor onboarding flow
- `trackOnboardingCompleted()` - Measure completion rates
- `trackConversion()` - Custom conversion events

---

## ✅ Validation System (WismeValidation)

### Location: `lib/core/validation/wisme_validation_v2.dart`

**Purpose:** Professional form validation with user-friendly messaging and data integrity.

#### Email Validation:
```dart
String? emailError = WismeValidation.validateEmail(emailValue);
// Features:
// - Comprehensive regex validation
// - Common typo detection (gmial.com, yahooo.com)
// - Length checks (5-254 characters)
```

#### Password Validation:
```dart
String? passwordError = WismeValidation.validatePassword(passwordValue);
PasswordStrength strength = WismeValidation.calculatePasswordStrength(passwordValue);

// Requirements:
// - 8+ characters
// - Uppercase + lowercase letters
// - Numbers + special characters
// - Weak pattern detection
```

#### Password Strength Indicator:
```dart
PasswordStrength strength = WismeValidation.calculatePasswordStrength(password);
LinearProgressIndicator(
  value: strength.value,  // 0.0 to 1.0
  color: strength.color,  // Red to green
);
Text(strength.label);     // 'Weak' to 'Strong'
```

---

## 🚨 Error Handling (WismeErrorHandler)

### Location: `lib/core/errors/error_handler.dart`

**Purpose:** Professional error management with graceful recovery and user feedback.

#### Error Display:
```dart
// Show user-friendly errors
WismeErrorHandler.showError(
  context: context,
  message: 'Something went wrong. Please try again.',
  actionLabel: 'Retry',
  onAction: () => retryOperation(),
);

// Show success feedback
WismeErrorHandler.showSuccess(
  context: context,
  message: 'Account created successfully!',
);
```

#### Network Error Handling:
```dart
try {
  await apiCall();
} catch (e) {
  WismeErrorHandler.handleNetworkError(context, e);
}
```

#### Validation Integration:
```dart
String? error = WismeErrorHandler.validateEmail(emailValue);
String? error = WismeErrorHandler.validatePassword(passwordValue);
```

---

## 🔄 State Management Guidelines

### Current Implementation: StatefulWidget + setState
- **Simple and effective** for current scope
- **Easy to understand** for new developers
- **No external dependencies** required

### Future Considerations:
- **Bloc Pattern** for complex state management
- **Provider** for dependency injection
- **Riverpod** for advanced scenarios

---

## 🚀 Performance Standards

### Target Metrics:
- **60 FPS** on all animations
- **< 3 seconds** app startup time
- **< 1 second** navigation between screens
- **< 500ms** button press feedback

### Optimization Techniques:
- **Lazy loading** for large lists
- **Image caching** for network images
- **Widget recycling** in scroll views
- **Memory management** for animations

---

## 🧪 Testing Strategy

### Unit Tests:
- **Validation functions** (WismeValidation)
- **Utility functions** (WismeResponsive)
- **Business logic** components

### Widget Tests:
- **Form interactions**
- **Navigation flows**
- **Accessibility features**

### Integration Tests:
- **Complete user journeys**
- **Authentication flows**
- **Error scenarios**

---

## 🔧 Development Workflow

### Terminal Commands:
```bash
# Always run from project root directory
cd wisme_app

# Clean build (fixes most issues)
flutter clean && flutter pub get

# Run app (development)
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .
```

### Code Organization:
1. **Import order:** Dart → Flutter → Third-party → Local
2. **Barrel exports:** Use `lib/core/core.dart` and `lib/shared/shared.dart`
3. **Documentation:** Every public method needs documentation
4. **Error handling:** Always handle potential failures

---

## 📱 Feature Development Guide

### Authentication Feature (`lib/features/auth/`)

#### Files Structure:
```
auth/
├── screens/
│   ├── welcome_screen.dart      # First user touchpoint
│   ├── sign_in_screen.dart      # User login
│   └── sign_up_screen.dart      # Account creation
├── widgets/
│   ├── auth_button.dart         # Consistent button styling
│   ├── auth_text_field.dart     # Form input components
│   └── password_strength_indicator.dart
└── auth.dart                    # Barrel export file
```

#### Welcome Screen (`welcome_screen.dart`):
- **Purpose:** First impression with professional onboarding
- **Features:** Gradient logo, feature highlights, animated CTAs
- **Navigation:** Routes to sign-in or sign-up screens
- **Accessibility:** Full screen reader support

#### Sign Up Screen:
- **Email validation** with typo detection
- **Password strength** real-time feedback
- **Confirm password** matching validation
- **Terms acceptance** checkbox
- **Social sign-up** options (Google, Apple)

#### Authentication Flow:
1. Welcome screen → User chooses sign up/in
2. Form validation → Real-time feedback
3. API call → Loading state with animations
4. Success → Navigate to main app
5. Error → Display friendly error with retry

---

## 🎯 Quality Assurance Checklist

### Before Every Commit:
- [ ] Code compiles without warnings
- [ ] All imports use barrel exports
- [ ] Accessibility labels added
- [ ] Analytics events tracked
- [ ] Error handling implemented
- [ ] Responsive design verified
- [ ] Animations are smooth (60 FPS)

### Before Every Release:
- [ ] Performance testing completed
- [ ] Accessibility testing passed
- [ ] Multiple device testing done
- [ ] Error scenarios tested
- [ ] Analytics implementation verified
- [ ] User journey testing completed

---

## 🔮 Future Enhancements

### Phase 2 Features:
- **Learning modules** with adaptive content
- **Progress tracking** with beautiful visualizations
- **Social features** for community learning
- **Offline support** for uninterrupted learning

### Technical Improvements:
- **State management** upgrade (Bloc/Riverpod)
- **Internationalization** (i18n) support
- **Deep linking** for content sharing
- **Push notifications** for engagement

### Performance Optimizations:
- **Code splitting** for faster startup
- **Image optimization** with WebP
- **Caching strategies** for offline content
- **Bundle size optimization**

---

## 📞 Support & Resources

### Internal Documentation:
- **API Documentation:** `/docs/api/`
- **Design System:** `/docs/design/`
- **Architecture Decision Records:** `/docs/adr/`

### External Resources:
- **Flutter Documentation:** https://docs.flutter.dev/
- **Material Design:** https://material.io/design
- **WCAG Guidelines:** https://www.w3.org/WAI/WCAG21/quickref/

### Development Tools:
- **VS Code Extensions:** Flutter, Dart
- **Debugging:** Flutter Inspector, DevTools
- **Performance:** Timeline view, Memory tab

---

**Remember:** Every line of code should contribute to our goal of creating an app that exceeds Duolingo's quality and achieves 40% Day-30 retention. Think of user delight in every interaction!
