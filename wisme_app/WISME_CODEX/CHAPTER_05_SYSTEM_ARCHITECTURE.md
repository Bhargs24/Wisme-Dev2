# 🏗️ **CHAPTER 5: SYSTEM ARCHITECTURE**
## *How I Structure Code for Scale and Maintainability*

---

Architecture isn't just about organizing files - it's about creating a system that can evolve as Wisme grows from thousands to millions of users, from a single developer to a full team, and from basic features to advanced AI-powered personalization. 

In this chapter, I'll walk you through the architectural decisions that shape how Wisme is built: from the Flutter app structure that keeps code maintainable, to the state management patterns that keep the UI responsive, to the error handling strategies that keep the app stable even when things go wrong.

---

## 📁 **FLUTTER APP ARCHITECTURE**

### **My Folder Organization Philosophy**

I've organized Wisme's codebase around clarity and scalability. Here's the structure I use:

```
lib/
├── core/                    # Shared foundation
│   ├── config/             # App configuration and constants
│   ├── services/           # Business logic and external integrations
│   ├── utils/              # Helper functions and utilities
│   └── providers/          # Global Riverpod providers
├── features/               # Feature-based organization
│   ├── auth/              # Authentication and user management
│   ├── home/              # Home screen and navigation
│   ├── learning/          # Learning sessions and progress
│   └── content/           # Content generation and playback
├── shared/                 # Reusable components
│   ├── widgets/           # Common UI components
│   ├── models/            # Data models used across features
│   └── constants/         # App-wide constants
└── main.dart              # Application entry point
```

**Why This Structure Works:**

**Core Directory**: Contains the foundation that everything else builds on. Services, configuration, and global state management live here because they're used throughout the app.

**Features Directory**: Each major feature gets its own folder with everything it needs. Authentication, learning sessions, content generation - each is self-contained but can depend on core services.

**Shared Directory**: Components, models, and constants that are used across multiple features. This prevents duplication while keeping related code together.

**Scalability**: New features get their own folders. New developers can understand one feature without learning the entire codebase. Changes to one feature don't accidentally break others.

### **Feature-First Architecture**

Instead of organizing by file type (all widgets in one folder, all models in another), I organize by feature. Here's what a typical feature folder looks like:

```
features/learning/
├── models/
│   ├── lesson.dart
│   ├── progress.dart
│   └── learning_session.dart
├── providers/
│   ├── learning_provider.dart
│   └── progress_provider.dart
├── screens/
│   ├── lesson_screen.dart
│   └── progress_screen.dart
├── widgets/
│   ├── lesson_card.dart
│   └── progress_indicator.dart
└── services/
    └── learning_service.dart
```

**Benefits of Feature-First Organization:**
- **Clear boundaries**: Everything related to learning is in one place
- **Team collaboration**: Different developers can work on different features with minimal conflicts
- **Testing simplicity**: Test files mirror the structure, making it easy to find and write tests
- **Refactoring safety**: Changes to learning features are isolated from other functionality

---

## 🔄 **STATE MANAGEMENT WITH RIVERPOD**

### **Why I Chose Riverpod**

State management is crucial for an app like Wisme that handles complex user interactions, real-time data updates, and offline synchronization. I chose Riverpod because:

**Compile-Time Safety**: Riverpod catches state management errors at compile time rather than runtime, preventing crashes users would otherwise experience.

**Testability**: Every provider can be easily mocked and tested in isolation, making the app more reliable.

**Performance**: Widgets only rebuild when the specific data they depend on changes, not when any state anywhere changes.

**Scalability**: As Wisme grows more complex, Riverpod's dependency injection and provider composition scale naturally.

### **My Provider Architecture**

I use different types of providers for different purposes:

**Configuration Providers** (Core):
```dart
// core/providers/config_providers.dart
@riverpod
AppConfig appConfig(AppConfigRef ref) {
  return AppConfig(
    supabaseUrl: Platform.environment['SUPABASE_URL']!,
    supabaseAnonKey: Platform.environment['SUPABASE_ANON_KEY']!,
    openAIApiKey: Platform.environment['OPENAI_API_KEY']!,
  );
}

@riverpod
Supabase supabaseClient(SupabaseClientRef ref) {
  final config = ref.watch(appConfigProvider);
  return Supabase.initialize(
    url: config.supabaseUrl,
    anonKey: config.supabaseAnonKey,
  );
}
```

**Service Providers** (Business Logic):
```dart
// core/providers/service_providers.dart
@riverpod
AuthService authService(AuthServiceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthService(supabase: supabase);
}

@riverpod
ContentGenerationService contentService(ContentServiceRef ref) {
  final openAI = ref.watch(openAIClientProvider);
  return ContentGenerationService(openAI: openAI);
}
```

**Feature Providers** (UI State):
```dart
// features/learning/providers/learning_provider.dart
@riverpod
class LearningSession extends _$LearningSession {
  @override
  LearningSessionState build() {
    return const LearningSessionState.initial();
  }

  Future<void> startLesson(String lessonId) async {
    state = const LearningSessionState.loading();
    
    try {
      final lesson = await ref.read(learningServiceProvider).getLesson(lessonId);
      state = LearningSessionState.active(lesson: lesson);
    } catch (error) {
      state = LearningSessionState.error(error.toString());
    }
  }
}
```

### **State Management Patterns I Use**

**Separation of Concerns**: Configuration providers handle app setup, service providers handle business logic, feature providers handle UI state.

**Dependency Injection**: Services depend on configuration, features depend on services, UI depends on features. Clear dependency chain prevents circular dependencies.

**Error Boundaries**: Each provider handles its own errors and exposes them in a consistent way to the UI layer.

**Async State Handling**: Loading, success, and error states are explicitly modeled so the UI always knows what to display.

---

## 🎯 **CLEAN ARCHITECTURE PRINCIPLES**

### **Layers of Abstraction**

I structure Wisme using clean architecture principles that separate concerns clearly:

**Presentation Layer** (UI):
- Screens and widgets that display information
- Handle user interactions and navigation
- Observe state from providers, trigger actions
- No business logic - just UI logic

**Business Logic Layer** (Services):
- Core application functionality and rules
- Integrate with external services (Supabase, OpenAI, etc.)
- Transform data between external and internal formats
- Independent of UI concerns

**Data Layer** (Repositories and Models):
- Handle data persistence and retrieval
- Manage caching and synchronization
- Define data models and validation rules
- Abstract away external service details

### **Dependency Direction**

Dependencies flow inward - UI depends on business logic, business logic depends on data access, but never the reverse:

```dart
// Clean dependency flow example
class LessonScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UI depends on provider (business logic)
    final sessionState = ref.watch(learningSessionProvider);
    
    return sessionState.when(
      loading: () => const LoadingWidget(),
      active: (lesson) => LessonContentWidget(lesson: lesson),
      error: (error) => ErrorWidget(message: error),
      initial: () => const StartLessonWidget(),
    );
  }
}

class LearningService {
  // Business logic depends on repository (data access)
  final LessonRepository _repository;
  
  Future<Lesson> getLesson(String id) async {
    // Business logic: validate, transform, add metadata
    final lesson = await _repository.getLesson(id);
    return lesson.copyWith(
      startedAt: DateTime.now(),
      userId: await _getCurrentUserId(),
    );
  }
}

class LessonRepository {
  // Data access handles external service integration
  final SupabaseClient _supabase;
  
  Future<Lesson> getLesson(String id) async {
    final response = await _supabase
        .from('lessons')
        .select()
        .eq('id', id)
        .single();
    
    return Lesson.fromJson(response);
  }
}
```

**Benefits of This Architecture:**
- **Testability**: Each layer can be tested independently with mocked dependencies
- **Maintainability**: Changes to external services only affect the data layer
- **Scalability**: New features follow the same patterns, making the codebase predictable
- **Team Development**: Different developers can work on different layers with minimal conflicts

---

## 🛡️ **ERROR HANDLING AND RESILIENCE**

### **My Error Handling Philosophy**

In an educational app like Wisme, errors can break learning flow and frustrate users. My error handling strategy focuses on graceful degradation and clear user communication.

### **Hierarchical Error Handling**

**Service Level Errors**:
```dart
abstract class WismeException implements Exception {
  final String message;
  final String? code;
  const WismeException(this.message, {this.code});
}

class NetworkException extends WismeException {
  const NetworkException(String message) : super(message, code: 'NETWORK_ERROR');
}

class ContentGenerationException extends WismeException {
  const ContentGenerationException(String message) : super(message, code: 'CONTENT_ERROR');
}

class AuthenticationException extends WismeException {
  const AuthenticationException(String message) : super(message, code: 'AUTH_ERROR');
}
```

**Provider Level Error Handling**:
```dart
@riverpod
class ContentGenerator extends _$ContentGenerator {
  @override
  AsyncValue<GeneratedContent> build() {
    return const AsyncValue.data(GeneratedContent.empty());
  }

  Future<void> generateContent(String topic) async {
    state = const AsyncValue.loading();
    
    try {
      final content = await ref.read(contentServiceProvider).generateContent(topic);
      state = AsyncValue.data(content);
    } on NetworkException catch (e) {
      state = AsyncValue.error(
        'Network connection issue. Please check your internet and try again.',
        StackTrace.current,
      );
    } on ContentGenerationException catch (e) {
      state = AsyncValue.error(
        'Unable to generate content for this topic. Please try a different topic.',
        StackTrace.current,
      );
    } catch (e) {
      state = AsyncValue.error(
        'Something went wrong. Please try again later.',
        StackTrace.current,
      );
    }
  }
}
```

**UI Level Error Display**:
```dart
class ContentGenerationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentState = ref.watch(contentGeneratorProvider);
    
    return contentState.when(
      data: (content) => ContentDisplayWidget(content: content),
      loading: () => const LoadingWidget(message: 'Generating your content...'),
      error: (error, stackTrace) => ErrorWidget(
        message: error.toString(),
        onRetry: () => ref.read(contentGeneratorProvider.notifier).generateContent(topic),
      ),
    );
  }
}
```

### **Offline Resilience Patterns**

**Graceful Degradation**:
```dart
class OfflineFirstService {
  Future<List<Lesson>> getLessons() async {
    try {
      // Try to get fresh data from network
      final networkLessons = await _networkRepository.getLessons();
      
      // Cache successful response
      await _localRepository.cacheLessons(networkLessons);
      
      return networkLessons;
    } on NetworkException {
      // Fall back to cached data
      final cachedLessons = await _localRepository.getCachedLessons();
      
      if (cachedLessons.isNotEmpty) {
        return cachedLessons;
      }
      
      // No cached data available
      throw const WismeException('No lessons available offline');
    }
  }
}
```

**Background Sync**:
```dart
@riverpod
class SyncManager extends _$SyncManager {
  Timer? _syncTimer;
  
  @override
  SyncState build() {
    _startPeriodicSync();
    return const SyncState.idle();
  }
  
  void _startPeriodicSync() {
    _syncTimer = Timer.periodic(Duration(minutes: 5), (_) {
      if (ref.read(connectivityProvider).isConnected) {
        _syncPendingData();
      }
    });
  }
  
  Future<void> _syncPendingData() async {
    final pendingActions = await _localRepository.getPendingSync();
    
    for (final action in pendingActions) {
      try {
        await _executeSync(action);
        await _localRepository.markSynced(action);
      } catch (e) {
        // Will retry on next sync cycle
        continue;
      }
    }
  }
}
```

---

## 🔧 **NAVIGATION AND ROUTING**

### **Why I Use GoRouter**

Navigation in Wisme needs to handle complex scenarios: deep linking to specific lessons, authentication-based routing, and maintaining navigation state across app restarts. GoRouter provides:

**Declarative Routing**: Routes are defined upfront, making navigation predictable and debuggable.

**Deep Linking**: Users can bookmark specific lessons or share direct links to content.

**Authentication Guards**: Some routes require authentication, others redirect to login.

**Type Safety**: Route parameters are type-safe, preventing runtime navigation errors.

### **My Routing Structure**

```dart
final goRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isLoggingIn = state.location == '/login';
    
    if (!isLoggedIn && !isLoggingIn) {
      return '/login';
    }
    
    return null; // No redirect needed
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/lesson/:lessonId',
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId']!;
        return LessonScreen(lessonId: lessonId);
      },
    ),
    GoRoute(
      path: '/generate/:topic',
      builder: (context, state) {
        final topic = state.pathParameters['topic']!;
        return ContentGenerationScreen(topic: topic);
      },
    ),
  ],
);
```

**Navigation Patterns I Use**:

**Context-Based Navigation**:
```dart
// Type-safe navigation with parameters
void navigateToLesson(BuildContext context, String lessonId) {
  context.go('/lesson/$lessonId');
}

// Navigation with query parameters
void navigateToGeneration(BuildContext context, String topic, {String? difficulty}) {
  final uri = Uri(
    path: '/generate/$topic',
    queryParameters: difficulty != null ? {'difficulty': difficulty} : null,
  );
  context.go(uri.toString());
}
```

**Authentication-Aware Navigation**:
```dart
@riverpod
class AppRouter extends _$AppRouter {
  @override
  GoRouter build() {
    return GoRouter(
      refreshListenable: ref.watch(authStateProvider.notifier),
      redirect: (context, state) {
        final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
        final isAuthRoute = state.location.startsWith('/auth');
        
        if (!isAuthenticated && !isAuthRoute) {
          return '/auth/login';
        }
        
        if (isAuthenticated && isAuthRoute) {
          return '/';
        }
        
        return null;
      },
      routes: _buildRoutes(),
    );
  }
}
```

---

## 🎨 **UI ARCHITECTURE AND THEMING**

### **Design System Foundation**

Wisme uses a consistent design system that scales across features:

```dart
class WismeTheme {
  static const _primaryColor = Color(0xFF2563EB);
  static const _secondaryColor = Color(0xFF7C3AED);
  
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: _textTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      cardTheme: _cardTheme,
    );
  }
  
  static const _textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 1.5,
    ),
  );
}
```

**Component Architecture**:
```dart
class WismeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final WismeButtonStyle style;
  
  const WismeButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.style = WismeButtonStyle.primary,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: _getButtonStyle(context, style),
      child: isLoading 
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(text),
    );
  }
}
```

---

## 🎯 **THE ARCHITECTURE THAT ENABLES GROWTH**

This system architecture isn't just about organizing code - it's about creating a foundation that can evolve with Wisme's growth:

**For Individual Development**: Clear patterns and conventions mean I can focus on building features rather than deciding how to structure code.

**For Team Growth**: New developers can understand one feature without learning the entire codebase. Clear boundaries prevent conflicts between team members.

**For Feature Evolution**: The architecture supports both simple features and complex AI-powered systems using the same patterns and conventions.

**For User Experience**: Error handling and offline resilience ensure users can learn effectively even when things go wrong.

**For Platform Scaling**: The clean architecture makes it possible to optimize performance, add new platforms, and integrate new services without rewriting existing code.

In the next chapter, I'll show you how this architecture supports the multi-database strategy that gives Wisme its performance and reliability advantages.
