# 🚀 Wisme App Setup Guide

This guide will help you set up the Wisme app for development and production deployment.

## 📋 Prerequisites

- Flutter SDK (3.7.2+)
- Dart SDK
- VS Code with Flutter extension
- Git

## 🔧 Initial Setup

### 1. Clone and Install Dependencies

```bash
git clone <repository-url>
cd wisme_app
flutter pub get
```

### 2. Environment Configuration

Copy the example environment file:
```bash
cp .env.example .env
```

Edit `.env` with your actual API keys and configuration:

```env
# Supabase Configuration (Required)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key

# AI Services (Required)
OPENAI_API_KEY=sk-your-openai-api-key
PLAYHT_API_KEY=your-playht-api-key
PLAYHT_USER_ID=your-playht-user-id

# Authentication (Optional)
GOOGLE_CLIENT_ID=your-google-oauth-client-id
APPLE_CLIENT_ID=your-apple-sign-in-client-id

# Email Service (Optional)
SENDGRID_API_KEY=your-sendgrid-api-key
```

## 🔑 Service Setup Instructions

### Supabase Backend (Required)

1. Go to [Supabase](https://supabase.com) and create a new project
2. Get your project URL and anon key from Settings > API
3. Set up these tables in your Supabase database:

```sql
-- User profiles table
CREATE TABLE user_profiles (
  user_id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT,
  name TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  learning_streak INTEGER DEFAULT 0,
  total_episodes_completed INTEGER DEFAULT 0,
  preferences JSONB DEFAULT '{}'
);

-- Episodes table
CREATE TABLE episodes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES user_profiles(user_id),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  audio_url TEXT,
  duration INTEGER,
  coach TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### OpenAI API (Required)

1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Create an account and add billing information
3. Generate an API key from API Keys section
4. Add to your `.env` file

### PlayHT TTS Service (Required)

1. Go to [PlayHT](https://play.ht/)
2. Create an account and subscribe to a plan
3. Get your API key and User ID from the dashboard
4. Add to your `.env` file

### Google OAuth (Optional)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add to your `.env` file

### Apple Sign-In (Optional)

1. Go to [Apple Developer](https://developer.apple.com/)
2. Register your app bundle ID
3. Enable Sign in with Apple capability
4. Configure your team ID and key ID
5. Add to your `.env` file

### SendGrid Email (Optional)

1. Go to [SendGrid](https://sendgrid.com/)
2. Create an account and verify your sender identity
3. Generate an API key with Mail Send permissions
4. Add to your `.env` file

## 🏃‍♂️ Running the App

### Development Mode

```bash
flutter run
```

The app will start with debug configuration and show environment status on startup.

### Check Configuration Status

When you run the app, it will print the configuration status:

```
=== Wisme Configuration Status ===
✅ Supabase: Configured
✅ OpenAI: Configured
✅ PlayHT: Configured
❌ Google OAuth: Missing
❌ Apple Sign-In: Missing
❌ SendGrid: Missing
================================
```

## 🧪 Testing

### Run Unit Tests

```bash
flutter test
```

### Run Integration Tests

```bash
flutter test integration_test/
```

## 🚀 Production Deployment

### Environment Variables

For production, set environment variables instead of using .env file:

```bash
export SUPABASE_URL="https://your-project.supabase.co"
export SUPABASE_ANON_KEY="your_key"
export OPENAI_API_KEY="your_key"
# ... etc
```

### Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## ⚙️ Configuration Validation

The app includes built-in configuration validation:

- **Required Services**: Supabase, OpenAI/Claude, PlayHT/ElevenLabs
- **Optional Services**: Google OAuth, Apple Sign-In, SendGrid
- **Graceful Degradation**: App works with minimal configuration

## 🔧 Troubleshooting

### Common Issues

**"Supabase configuration missing"**
- Check your SUPABASE_URL and SUPABASE_ANON_KEY
- Ensure .env file is in the project root

**"OpenAI API key not configured"**
- Verify your OPENAI_API_KEY is valid
- Check API key permissions and billing

**"PlayHT API key not configured"**
- Ensure both PLAYHT_API_KEY and PLAYHT_USER_ID are set
- Verify your PlayHT subscription is active

### Debug Mode

Set `DEBUG_MODE=true` in your .env file to see detailed configuration status and API call logs.

## 📞 Support

If you encounter issues:

1. Check the configuration status output
2. Verify all required environment variables are set
3. Test each service individually
4. Check the console for detailed error messages

For additional help, refer to the service provider documentation or create an issue in the repository.

---

🎯 **Ready to Learn!** Once configured, your Wisme app will provide AI-powered learning experiences with personalized coaches and high-quality audio content.
