# 🚀 Wisme Development Setup Guide

## Quick Start (5 Minutes to Working App)

### Step 1: Get API Keys (2 minutes)

1. **OpenAI API Key** (Required for content generation)
   - Go to https://platform.openai.com/api-keys
   - Click "Create new secret key"
   - Copy the key (starts with `sk-`)

2. **PlayHT API Key** (Required for voice generation)
   - Go to https://play.ht/studio/settings/api
   - Sign up for free account
   - Copy your API Key and User ID

### Step 2: Configure Environment (1 minute)

1. Open `wisme_app/.env` file
2. Replace the placeholder values:

```bash
# Replace with your actual keys
OPENAI_API_KEY=sk-your-actual-key-here
PLAYHT_API_KEY=your-playht-key-here
PLAYHT_USER_ID=your-playht-user-id-here

# Optional (can leave as-is for testing)
SUPABASE_URL=optional-for-now
SUPABASE_ANON_KEY=optional-for-now
```

### Step 3: Test the App (2 minutes)

```bash
cd wisme_app
flutter pub get
flutter run -d chrome
```

### What Works Now vs What's Next

✅ **Currently Working:**
- Beautiful UI with proper navigation
- Real AI topic classification (with your OpenAI key)
- Content generation pipeline
- Audio player interface
- Progress tracking UI

🔧 **Next Steps to Complete:**
- Connect PlayHT for actual voice generation
- Set up Supabase for data persistence  
- Add offline episode downloads
- Implement learning analytics

### Testing the Topic Input Flow

1. Click "Start Learning" on home screen
2. Type any topic like "Machine Learning"
3. Watch it use real AI to classify the topic
4. See actual episode content generation
5. Experience the complete learning flow

### API Cost Estimates (Very Low)

- **OpenAI**: ~$0.02 per episode generation
- **PlayHT**: ~$0.05 per episode voice generation
- **Total**: ~$0.07 per episode (extremely cost-effective)

### Troubleshooting

**"OpenAI API key not configured"**
- Check your .env file has the correct key
- Restart the app after changing .env

**"Network error"**
- Check your internet connection
- Verify API keys are valid

**"Content generation failed"**
- App will fall back to basic classification
- Check browser console for detailed errors

---

## Next Development Priorities

1. **Voice Generation**: Complete PlayHT integration
2. **Data Persistence**: Set up Supabase tables  
3. **Offline Support**: Download and cache episodes
4. **Analytics**: Track learning progress and engagement

This setup gets you a **functional AI learning app** in under 5 minutes!
