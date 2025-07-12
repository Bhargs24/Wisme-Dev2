# Wisme Development Setup Guide

**Target Environment**: Flutter 3.29.3+  
**Platform Support**: iOS, Android, Web  
**Last Updated**: January 2025  

## 🚀 Quick Start

### Prerequisites Checklist
- [ ] Flutter SDK 3.29.3+
- [ ] Dart 3.5+
- [ ] Android Studio with Android SDK 34
- [ ] Xcode 15+ (macOS only)
- [ ] VS Code with Flutter extensions
- [ ] Git 2.30+
- [ ] Firebase CLI
- [ ] Node.js 18+ (for Firebase functions)

### Installation Commands
```bash
# Verify Flutter installation
flutter doctor -v

# Clone repository
git clone <repository-url>
cd wisme_app

# Install dependencies
flutter pub get

# Run development build
flutter run
```

## 🔧 Environment Setup

### Flutter SDK Installation
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

### IDE Configuration

#### VS Code (Recommended)
**Required Extensions**:
- Flutter (Dart-Code.flutter)
- Dart (Dart-Code.dart-code)
- Firebase (Firebase.firebase-explorer)
- GitLens (eamodio.gitlens)

**Settings (settings.json)**:
```json
{
  "dart.debugExternal": true,
  "dart.debugSdkLibraries": false,
  "flutter.inspector.structuredErrors": true,
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true
}
```

#### Android Studio
**Required Plugins**:
- Flutter plugin
- Dart plugin
- Firebase plugin

### Platform Setup

#### Android Development
```bash
# Install Android Studio
# Download from: https://developer.android.com/studio

# Configure Android SDK (in Android Studio)
# SDK Platforms: Android 14 (API 34)
# SDK Tools: Android SDK Build-Tools, Platform-Tools

# Accept licenses
flutter doctor --android-licenses
```

#### iOS Development (macOS only)
```bash
# Install Xcode from App Store
# Install Xcode command line tools
sudo xcode-select --install

# Configure iOS deployment
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

## 🔥 Firebase Configuration

### Firebase CLI Setup
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize project
firebase init
```

### Environment Configuration
Create `.env` file in project root:
```env
# Firebase Configuration
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_project.appspot.com
FIREBASE_MESSAGING_SENDER_ID=123456789
FIREBASE_APP_ID=1:123456789:web:abcdef123456

# OpenAI Configuration (for AI features)
OPENAI_API_KEY=your_openai_api_key

# TTS Configuration (for audio features)
ELEVEN_LABS_API_KEY=your_elevenlabs_key
```

### Firebase Project Setup
1. **Create Firebase Project**: https://console.firebase.google.com
2. **Enable Authentication**: Email/Password, Google, Apple
3. **Create Firestore Database**: Start in test mode
4. **Enable Storage**: For audio files
5. **Configure Analytics**: App tracking

## 📁 Project Structure

### Directory Organization
```
wisme_app/
├── lib/
│   ├── core/                 # Core functionality
│   │   ├── constants/        # App constants, colors
│   │   ├── models/           # Data models
│   │   ├── services/         # API services, storage
│   │   ├── theme/            # Material Design 3 theming
│   │   └── utils/            # Helper functions
│   ├── features/             # Feature-based modules
│   │   ├── auth/             # Authentication
│   │   ├── onboarding/       # User onboarding
│   │   ├── learning/         # Learning system
│   │   ├── dashboard/        # Home dashboard
│   │   └── audio/            # Audio playback
│   ├── shared/               # Shared components
│   │   ├── widgets/          # Reusable UI components
│   │   └── providers/        # State management
│   └── main.dart             # App entry point
├── test/                     # Unit & widget tests
├── integration_test/         # Integration tests
├── android/                  # Android platform files
├── ios/                      # iOS platform files
├── docs/                     # Documentation
└── pubspec.yaml              # Dependencies
```

### Key Configuration Files
- **pubspec.yaml**: Flutter dependencies and assets
- **android/app/build.gradle**: Android build configuration
- **ios/Runner/Info.plist**: iOS app configuration
- **firebase.json**: Firebase project configuration
- **analysis_options.yaml**: Dart linting rules

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.0.5
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  
  # UI & Navigation
  go_router: ^12.1.3
  cupertino_icons: ^1.0.6
  
  # Audio
  just_audio: ^0.9.35
  audio_service: ^0.18.12
  
  # HTTP & API
  http: ^1.1.2
  dio: ^5.4.0
  
  # Utilities
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1
  permission_handler: ^11.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  integration_test:
    sdk: flutter
  mockito: ^5.4.4
```

## 🏃‍♂️ Development Workflow

### Running the App
```bash
# Development mode with hot reload
flutter run

# Debug mode on specific device
flutter run -d <device_id>

# Release mode for testing
flutter run --release

# Web development
flutter run -d chrome --web-renderer html
```

### Testing Commands
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/auth_test.dart

# Run integration tests
flutter test integration_test/

# Test coverage
flutter test --coverage
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format code
dart format lib/

# Fix common issues
dart fix --apply
```

### Build Commands
```bash
# Android APK (debug)
flutter build apk

# Android App Bundle (release)
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release

# Web build
flutter build web
```

## 🧪 Testing Strategy

### Unit Tests
**Location**: `test/`  
**Purpose**: Test business logic, models, services  
**Coverage**: Core functionality, data processing  

### Widget Tests
**Location**: `test/widgets/`  
**Purpose**: Test UI components in isolation  
**Coverage**: Custom widgets, screen layouts  

### Integration Tests
**Location**: `integration_test/`  
**Purpose**: Test complete user flows  
**Coverage**: Authentication, onboarding, learning flow  

### Testing Best Practices
- **AAA Pattern**: Arrange, Act, Assert
- **Mock External Dependencies**: Use mockito for API calls
- **Test User Interactions**: Simulate taps, swipes, text input
- **Golden Tests**: Visual regression testing for UI

## 🔍 Debugging Tools

### Flutter Inspector
- **Access**: VS Code Command Palette → "Flutter: Open Widget Inspector"
- **Features**: Widget tree visualization, property inspection
- **Usage**: Debug layout issues, performance problems

### Firebase Debug View
- **Access**: Firebase Console → Analytics → DebugView
- **Features**: Real-time event tracking, user behavior
- **Usage**: Validate analytics implementation

### Performance Profiling
```bash
# CPU profiling
flutter run --profile

# Memory profiling
flutter drive --profile --trace-startup --target=test_driver/perf_driver.dart
```

## 🚀 Deployment Setup

### Android Release
1. **Keystore Generation**:
   ```bash
   keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
   ```

2. **Build Configuration**: Update `android/key.properties`

3. **Build Release**:
   ```bash
   flutter build appbundle --release
   ```

### iOS Release
1. **Xcode Configuration**: Set up certificates and provisioning profiles
2. **Build Archive**: Use Xcode or command line
3. **App Store Connect**: Upload via Xcode or Transporter

### Web Deployment
```bash
# Build for web
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

## 🛠️ Troubleshooting

### Common Issues

#### Flutter Doctor Issues
```bash
# Fix Android licenses
flutter doctor --android-licenses

# Fix iOS deployment
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

#### Dependency Conflicts
```bash
# Clean and reinstall
flutter clean
flutter pub get

# Update dependencies
flutter pub upgrade
```

#### Platform-Specific Issues
```bash
# Android build issues
cd android && ./gradlew clean
cd .. && flutter clean && flutter pub get

# iOS build issues
cd ios && rm -rf Pods Podfile.lock
cd .. && flutter clean && flutter pub get
cd ios && pod install
```

### Performance Optimization
- **Tree Shaking**: Enable with `flutter build --split-debug-info`
- **Code Splitting**: Use deferred imports for large features
- **Image Optimization**: Use WebP format, appropriate resolutions
- **Memory Management**: Dispose controllers, close streams

## 📚 Additional Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Material Design 3](https://m3.material.io/)

### Development Tools
- [Flutter Inspector](https://flutter.dev/docs/development/tools/inspector)
- [Firebase Console](https://console.firebase.google.com)
- [Android Studio](https://developer.android.com/studio)

### Community
- [Flutter Discord](https://discord.gg/flutter)
- [Flutter GitHub](https://github.com/flutter/flutter)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
