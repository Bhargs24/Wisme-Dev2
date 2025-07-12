# Wisme Backend Setup Guide
## Complete Production Backend Configuration

### 🎯 **STEP 2: Backend Infrastructure Setup**

This guide will help you set up a complete production backend for Wisme using Supabase.

---

## 🚀 **1. Create Supabase Project**

### Option A: Supabase Dashboard (Recommended)
1. **Go to** [supabase.com](https://supabase.com)
2. **Click** "Start your project" → "Sign up"
3. **Create New Project:**
   - **Project Name:** `wisme-production`
   - **Database Password:** Generate a strong password (save it!)
   - **Region:** Choose closest to your users
   - **Pricing:** Start with Free tier (upgradeable)

### Option B: Supabase CLI (Advanced)
```bash
# Install Supabase CLI
npm install -g @supabase/cli

# Login and create project
supabase login
supabase projects create wisme-production
```

---

## 🗄️ **2. Set Up Database Schema**

### Using Supabase Dashboard:
1. **Go to** your project dashboard
2. **Navigate to** SQL Editor
3. **Copy and paste** the contents of `database/schema.sql`
4. **Click** "Run" to execute the schema

### Key Tables Created:
- ✅ **user_profiles** - User data and preferences
- ✅ **episodes** - AI-generated learning content
- ✅ **learning_sessions** - Analytics and progress tracking
- ✅ **user_favorites** - Favorited episodes
- ✅ **user_learning_stats** - Learning analytics view

---

## 🔐 **3. Configure Authentication**

### In Supabase Dashboard:
1. **Go to** Authentication → Settings
2. **Enable Providers:**
   - ✅ Email (already enabled)
   - ✅ Google OAuth
   - ✅ Apple OAuth (for iOS)

### Google OAuth Setup:
1. **Go to** [Google Cloud Console](https://console.cloud.google.com)
2. **Create** new project or select existing
3. **Enable** Google+ API
4. **Create** OAuth 2.0 credentials
5. **Add** authorized redirect URIs:
   ```
   https://[YOUR_PROJECT_REF].supabase.co/auth/v1/callback
   ```
6. **Copy** Client ID and Secret to Supabase

### Apple OAuth Setup (iOS):
1. **Go to** [Apple Developer Portal](https://developer.apple.com)
2. **Create** Sign in with Apple service
3. **Configure** return URLs
4. **Add** credentials to Supabase

---

## 📱 **4. Connect Flutter App**

### Get Your Credentials:
1. **In Supabase Dashboard** → Settings → API
2. **Copy:**
   - **Project URL:** `https://[YOUR_PROJECT_REF].supabase.co`
   - **Anon Key:** `eyJ...` (public key)

### Update Flutter App:
1. **Open** `lib/core/services/supabase_service.dart`
2. **Replace** the placeholder values:
   ```dart
   await Supabase.initialize(
     url: 'https://your-project-ref.supabase.co',
     anonKey: 'your-anon-key-here',
   );
   ```

### Initialize in main.dart:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  runApp(MyApp());
}
```

---

## 🧪 **5. Test Backend Integration**

### Run the Flutter App:
```bash
cd wisme_app
flutter run
```

### Test Features:
1. ✅ **Sign Up** - Create new account
2. ✅ **Sign In** - Login with email/password
3. ✅ **Generate Episode** - Create and save episode
4. ✅ **View Episodes** - Load user's episodes
5. ✅ **Track Progress** - Update episode completion

---

## 📊 **6. Set Up Analytics & Monitoring**

### Supabase Analytics:
- **Go to** Reports tab in dashboard
- **Monitor:** User growth, API usage, database performance

### Flutter Crash Reporting:
```bash
# Add to pubspec.yaml
flutter pub add firebase_crashlytics
flutter pub add firebase_analytics
```

---

## 🔒 **7. Security Configuration**

### Row Level Security (RLS):
- ✅ **Already configured** in schema.sql
- ✅ **Users can only access their own data**
- ✅ **Episodes are private to each user**

### API Keys:
- ✅ **Never commit** real API keys to git
- ✅ **Use environment variables** in production
- ✅ **Rotate keys** regularly

---

## 🚀 **8. Production Deployment**

### Environment Variables:
Create `.env` file (DO NOT COMMIT):
```env
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-anon-key
OPENAI_API_KEY=your-openai-key
ELEVENLABS_API_KEY=your-elevenlabs-key
```

### Build for Production:
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## 📋 **Next Steps Checklist**

- [ ] ✅ Supabase project created
- [ ] ✅ Database schema deployed
- [ ] ✅ Authentication configured
- [ ] ✅ Flutter app connected
- [ ] ✅ Google/Apple OAuth setup
- [ ] ✅ Test user registration
- [ ] ✅ Test episode creation
- [ ] ✅ Test data persistence
- [ ] ⚡ **Ready for Step 3: Authentication UI**

---

## 🆘 **Troubleshooting**

### Common Issues:

**"Invalid API Key"**
- ✅ Check URL and anon key are correct
- ✅ Ensure no extra spaces in credentials

**"RLS Policy Violation"**
- ✅ User must be authenticated
- ✅ Check auth state before database calls

**"Network Error"**
- ✅ Check internet connection
- ✅ Verify Supabase project is active

### Get Help:
- 📖 [Supabase Docs](https://supabase.com/docs)
- 💬 [Flutter Community](https://flutter.dev/community)
- 🐛 [File Issue](https://github.com/supabase/supabase/issues)

---

## 💡 **Pro Tips**

1. **Start with Free Tier** - Upgrade when needed
2. **Monitor Usage** - Set up billing alerts
3. **Backup Database** - Regular automated backups
4. **Test Offline** - Handle network failures gracefully
5. **Cache Data** - Reduce API calls with local storage

**🎉 Backend setup complete! Ready to implement authentication UI next.**
