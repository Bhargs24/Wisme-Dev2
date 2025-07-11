# 🚀 Complete Wisme App Setup Guide for Beginners

**Welcome!** Since you're new to Firebase, this guide will walk you through everything step-by-step. Follow each section in order, and you'll have your Wisme app up and running with all the API keys configured.

## ⚡ Quick Overview

You need to set up **3 things**:
1. **OpenAI API** (for generating lesson content)
2. **ElevenLabs API** (for text-to-speech audio)
3. **Firebase** (for storing user data and app backend)

**Total time:** About 30-45 minutes  
**Cost:** Free to start (all services have free tiers)

---

## 🏃‍♂️ Part 1: Get Your API Keys First

### Step 1.1: OpenAI API Key (5 minutes)

**What it does:** Generates personalized lessons for users.

1. **Go to:** https://platform.openai.com/
2. **Sign up** or **Sign in** to your account
3. **Add a payment method** (required, but you won't be charged much)
   - Click your profile → "Billing" → "Add payment method"
   - Add a credit card (they charge per usage, starts around $0.001 per request)
4. **Create API Key:**
   - Go to: https://platform.openai.com/api-keys
   - Click **"Create new secret key"**
   - Name it: `Wisme App`
   - **Copy the key** (starts with `sk-...`)
   REDACTED_OPENAI_KEY_SET_VIA_ENV
   - ⚠️ **Save it somewhere safe** - you won't see it again!

### Step 1.2: ElevenLabs API Key (3 minutes)

**What it does:** Converts lesson text to natural-sounding speech.

1. **Go to:** https://elevenlabs.io/
2. **Sign up** for a free account
3. **Get your API key:**
   - Click your profile picture → **"Profile"**
   - Copy the **API Key** from the dashboard
   - Save it with your OpenAI key

### Step 1.3: Add Keys to Your App (2 minutes)

1. **Open VS Code** and navigate to: `lib/config/api_keys.dart`
2. **Replace the placeholder values** with your actual keys:

```dart
class ApiKeys {
  // Replace with your actual OpenAI key (starts with sk-)
  static const String openAI = 'sk-your-actual-openai-key-here';
  
  // Replace with your actual ElevenLabs key
  static const String elevenLabs = 'your-elevenlabs-key-here';
  
  // Firebase values (we'll fill these in Part 2)
  static const String firebaseApiKey = 'REPLACE_WITH_FIREBASE_API_KEY';
  static const String firebaseProjectId = 'REPLACE_WITH_FIREBASE_PROJECT_ID';
  static const String firebaseMessagingSenderId = 'REPLACE_WITH_SENDER_ID';
  static const String firebaseAppId = 'REPLACE_WITH_FIREBASE_APP_ID';
  
  // ... rest stays the same
}
```

3. **Save the file** (Ctrl+S)

---

## 🔥 Part 2: Firebase Setup (The Main Event!)

### Step 2.1: Create Firebase Project (5 minutes)

**What it does:** Provides backend services like user authentication and data storage.

1. **Go to:** https://console.firebase.google.com/
2. **Click:** "Create a project"
3. **Project name:** `wisme-app` (or anything you like)
4. **Google Analytics:** Click "Continue" (recommended)
5. **Analytics account:** Choose "Default Account for Firebase" or create new
6. **Click:** "Create project"
7. **Wait** for setup to complete (~1 minute)
8. **Click:** "Continue" when ready

### Step 2.2: Add Your Flutter App to Firebase (5 minutes)

**Add Android App:**
1. **Click:** "Add app" → **Android** icon
2. **Android package name:** `com.example.wisme_app2`
   - (This matches what's in your `android/app/build.gradle.kts`)
3. **App nickname:** `Wisme Android`
4. **SHA-1 certificate:** Leave blank for now
5. **Click:** "Register app"
6. **Download** the `google-services.json` file
7. **Move the file** to: `android/app/google-services.json`
   - (Drag and drop it in VS Code)

**Add iOS App (if you plan to test on iPhone):**
1. **Click:** "Add app" → **iOS** icon
2. **iOS bundle ID:** Check your `ios/Runner.xcodeproj` for the bundle ID
3. **App nickname:** `Wisme iOS`
4. **Download** the `GoogleService-Info.plist` file
5. **Move the file** to: `ios/Runner/GoogleService-Info.plist`

### Step 2.3: Enable Required Services (10 minutes)

**Enable Authentication:**
1. **Left sidebar:** Click "Authentication"
2. **Click:** "Get started"
3. **Sign-in method tab:** Click "Email/Password"
4. **Toggle:** Enable "Email/Password"
5. **Click:** "Save"

**Enable Firestore Database:**
1. **Left sidebar:** Click "Firestore Database"
2. **Click:** "Create database"
3. **Security rules:** Choose "Start in test mode"
4. **Location:** Choose the region closest to your users
5. **Click:** "Done"

**Enable Storage:**
1. **Left sidebar:** Click "Storage"
2. **Click:** "Get started"
3. **Security rules:** Choose "Start in test mode"
4. **Location:** Same as your Firestore
5. **Click:** "Done"

### Step 2.4: Get Your Firebase Configuration (5 minutes)

1. **Go to:** Project Settings (gear icon in left sidebar)
2. **General tab:** Scroll down to "Your apps"
3. **Copy these values:**
   - **Web API Key:** Copy this
   - **Project ID:** Copy this
   - **Project Number:** Copy this (this is your Sender ID)
   - **App ID:** Copy this (from your Android app)

### Step 2.5: Add Firebase Config to Your App (3 minutes)

1. **Open:** `lib/config/api_keys.dart` again
2. **Replace the Firebase placeholders:**

```dart
// Replace with your actual values from Firebase Console
static const String firebaseApiKey = 'AIzaSyBcdefg...'; // Your Web API Key
static const String firebaseProjectId = 'wisme-app-12345'; // Your Project ID
static const String firebaseMessagingSenderId = '123456789'; // Project Number
static const String firebaseAppId = '1:123456789:android:abc123'; // Your App ID
```

3. **Save the file**

---

## 🛠️ Part 3: Install Firebase CLI (Required for Advanced Features)

### Step 3.1: Install Node.js (if you don't have it)

1. **Go to:** https://nodejs.org/
2. **Download:** LTS version (recommended)
3. **Install** with default settings
4. **Restart** VS Code terminal

### Step 3.2: Install Firebase CLI

1. **Open Terminal** in VS Code (Terminal → New Terminal)
2. **Run this command:**
   ```powershell
   npm install -g firebase-tools
   ```
3. **Wait** for installation to complete

### Step 3.3: Login to Firebase

1. **In the terminal, run:**
   ```powershell
   firebase login
   ```
2. **Browser will open** - sign in with the same Google account you used for Firebase
3. **Grant permissions** when asked
4. **Return to VS Code** - you should see "Success! Logged in as your-email@gmail.com"

### Step 3.4: Initialize Firebase in Your Project

1. **In the terminal, run:**
   ```powershell
   firebase init
   ```
2. **Use arrow keys** to select:
   - ☑️ Firestore: Configure security rules and indexes files for Firestore
   - ☑️ Storage: Configure a security rules file for Cloud Storage
   - Press **Space** to select, **Enter** to continue
3. **Choose:** "Use an existing project"
4. **Select** your `wisme-app` project
5. **Firestore rules file:** Press Enter (default: firestore.rules)
6. **Firestore indexes file:** Press Enter (default: firestore.indexes.json)
7. **Storage rules file:** Press Enter (default: storage.rules)

---

## 🧪 Part 4: Test Your Setup

### Step 4.1: Quick Test

1. **In VS Code terminal, run:**
   ```powershell
   flutter clean
   flutter pub get
   flutter run
   ```

2. **The app should start** without errors!

### Step 4.2: Test API Keys

1. **In your app**, look for setup status messages
2. **Or check manually** by running this in the terminal:
   ```powershell
   flutter run --verbose
   ```

---

## 🎉 Part 5: You're Done!

### What You've Accomplished:

✅ **OpenAI API** - Ready to generate lessons  
✅ **ElevenLabs API** - Ready to create audio  
✅ **Firebase Auth** - Users can sign up/sign in  
✅ **Firestore** - Store user data and lessons  
✅ **Firebase Storage** - Store audio files  
✅ **Development Environment** - Everything connected  

### Next Steps:

1. **Test lesson generation** in your app
2. **Create a test user account**
3. **Try the voice features**
4. **Explore the app features**

---

## 🆘 Troubleshooting

### Common Issues:

**"Provider errors" when starting app:**
- Run: `flutter clean && flutter pub get && flutter run`

**Firebase connection issues:**
- Check that `google-services.json` is in `android/app/`
- Verify your API keys in `lib/config/api_keys.dart`

**OpenAI API errors:**
- Verify you added a payment method to OpenAI
- Check that your API key starts with `sk-`

**ElevenLabs not working:**
- Verify you have characters remaining in your account
- Check your API key is correctly copied

### Need Help?

1. **Check the console** for error messages
2. **Look at our guides:**
   - `FIREBASE_SETUP.md` - Detailed Firebase guide
   - `API_KEYS_SETUP.md` - API keys guide
3. **Firebase Console:** https://console.firebase.google.com/
4. **Test your setup** with the app's built-in diagnostics

---

## 💡 Pro Tips

1. **Keep your API keys secret** - never share them publicly
2. **Monitor usage** in OpenAI dashboard to avoid surprise costs
3. **Start with test mode** for Firebase security rules
4. **Back up your Firebase project** after setup

**Estimated monthly costs for light usage:**
- OpenAI: $1-5 (depending on lesson generation)
- ElevenLabs: Free (10,000 chars/month)
- Firebase: Free (generous free tier)

---

You're all set! 🚀 Your Wisme app now has AI-powered lesson generation, text-to-speech, and a complete backend. Time to test it out!
