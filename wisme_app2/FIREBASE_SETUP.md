# 🔥 Firebase Setup Guide for Wisme App

## Step 1: Create Firebase Project

1. **Go to Firebase Console**: https://console.firebase.google.com/
2. **Click "Create a project"**
3. **Project Name**: `wisme-app` (or your preferred name)
4. **Enable Google Analytics**: Choose "Yes" (recommended)
5. **Select Analytics Account**: Choose default or create new
6. **Click "Create project"**

## Step 2: Add Android App

1. **Click "Add app" → Android**
2. **Android package name**: `com.wisme.wisme_app2` 
   (Check android/app/build.gradle for exact package name)
3. **App nickname**: `Wisme Android`
4. **SHA-1 certificate**: Leave blank for now (optional for testing)
5. **Click "Register app"**
6. **Download google-services.json**
7. **Place google-services.json in**: `android/app/` folder

## Step 3: Add iOS App (Optional)

1. **Click "Add app" → iOS**
2. **iOS bundle ID**: Check ios/Runner.xcodeproj for bundle ID
3. **App nickname**: `Wisme iOS`
4. **Download GoogleService-Info.plist**
5. **Place in**: `ios/Runner/` folder

## Step 4: Enable Required Services

### Authentication
1. Go to **Authentication → Sign-in method**
2. Enable **Email/Password**
3. Enable **Google** (optional)

### Firestore Database
1. Go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select closest **region** to your users

### Storage
1. Go to **Storage**
2. Click **Get started**
3. Choose **Start in test mode**

## Step 5: Get Configuration Values

After setup, go to **Project settings** → **General** tab:

- **Project ID**: Copy this value
- **Web API Key**: Copy this value  
- **Project Number**: This is your Sender ID
- **App ID**: Found in the app you registered

## Step 6: Update API Keys

Update your `lib/config/api_keys.dart` file with these values:

```dart
static const String firebaseApiKey = 'YOUR_WEB_API_KEY_HERE';
static const String firebaseProjectId = 'YOUR_PROJECT_ID_HERE';
static const String firebaseMessagingSenderId = 'YOUR_PROJECT_NUMBER_HERE';
static const String firebaseAppId = 'YOUR_APP_ID_HERE';
```

## Step 7: Install Firebase CLI (Required)

1. **Install Node.js**: https://nodejs.org/
2. **Install Firebase CLI**:
   ```
   npm install -g firebase-tools
   ```
3. **Login to Firebase**:
   ```
   firebase login
   ```

## Step 8: Initialize Firebase in Project

Run these commands in your project root:

```bash
# Initialize Firebase
firebase init

# Select:
# - Firestore (for database)
# - Storage (for file storage)
# - Choose your project
# - Accept defaults for now
```

## Quick Test

After setup, you can test the connection by running:

```bash
flutter run
```

The app should now start without provider errors!

---

## 🆘 Need Help?

1. **Firebase Console**: https://console.firebase.google.com/
2. **Flutter Firebase Docs**: https://firebase.flutter.dev/
3. **Check our logs**: The app will log connection status

---

**Next Steps After Firebase Setup:**
1. Get OpenAI API key
2. Get ElevenLabs API key  
3. Test lesson generation!
