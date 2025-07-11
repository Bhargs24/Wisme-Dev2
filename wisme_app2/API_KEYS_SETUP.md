# 🔑 API Keys Setup Guide

## Step 1: Get OpenAI API Key

### 1.1 Create OpenAI Account
1. **Go to**: https://platform.openai.com/
2. **Sign up** or **Sign in** to your account
3. **Add payment method** (required for API usage)

### 1.2 Create API Key
1. **Go to**: https://platform.openai.com/api-keys
2. **Click "Create new secret key"**
3. **Name**: `Wisme App`
4. **Copy the key** (starts with `sk-...`)
5. **⚠️ Important**: Save it now - you won't see it again!

### 1.3 Set Usage Limits (Recommended)
1. **Go to**: https://platform.openai.com/usage
2. **Set monthly limit**: Start with $10-20
3. **Set up alerts** at 80% usage

---

## Step 2: Get ElevenLabs API Key

### 2.1 Create ElevenLabs Account
1. **Go to**: https://elevenlabs.io/
2. **Sign up** for an account
3. **Choose plan**: Free tier gives you 10,000 characters/month

### 2.2 Get API Key
1. **Go to**: https://elevenlabs.io/speech-synthesis
2. **Click your profile** → **Profile**
3. **Copy API Key** from the dashboard
4. **Save the key** (starts with letters/numbers)

---

## Step 3: Add Keys to Your App

### 3.1 Open API Keys File
Edit this file: `lib/config/api_keys.dart`

### 3.2 Replace Placeholder Values
```dart
class ApiKeys {
  // Replace with your actual OpenAI key
  static const String openAI = 'REDACTED_OPENAI_KEY_SET_VIA_ENV';
  
  // Replace with your actual ElevenLabs key  
  static const String elevenLabs = 'sk_4251133ba2069affc76cc7a2b55378362cfe9ac389f0e708';
  
  // Firebase values (from Firebase setup)
  static const String firebaseApiKey = 'your-firebase-web-api-key';
  static const String firebaseProjectId = 'your-firebase-project-id';
  static const String firebaseMessagingSenderId = 'your-sender-id';
  static const String firebaseAppId = 'your-firebase-app-id';
}
```

### 3.3 Example (with fake keys):
```dart
class ApiKeys {
  static const String openAI = 'sk-proj-abcdef123456...'; // Your real key here
  static const String elevenLabs = 'abc123def456...';      // Your real key here
  // ... rest of config
}
```

---

## Step 4: Verify Setup

### 4.1 Test API Keys
Run this command to test your setup:

```bash
flutter run
```

### 4.2 Check Logs
Look for these success messages:
- ✅ `API keys loaded successfully`
- ✅ `Firebase initialized successfully`
- ✅ `Production security initialized`

### 4.3 Test Lesson Generation
1. **Open app**
2. **Navigate to**: Smart Content Demo screen
3. **Enter topic**: "Introduction to AI"
4. **Tap "Generate Smart Content"**
5. **Should see**: Content generation starting

---

## 🔒 Security Notes

### ✅ Do:
- Keep API keys secret
- Add `api_keys.dart` to `.gitignore`
- Set usage limits on APIs
- Monitor API usage regularly

### ❌ Don't:
- Commit API keys to git
- Share keys publicly
- Use production keys in development
- Exceed API rate limits

---

## 💰 Cost Estimation

### OpenAI (GPT-4 API):
- **Input**: ~$0.03 per 1K tokens
- **Output**: ~$0.06 per 1K tokens
- **1 lesson**: ~$0.05-0.15
- **100 lessons**: ~$5-15

### ElevenLabs (Text-to-Speech):
- **Free tier**: 10,000 characters/month
- **1 lesson**: ~500-1500 characters
- **Paid**: $5/month for 30,000 characters

### Total Monthly Cost (moderate usage):
- **Development**: ~$10-20/month
- **Production**: Scale based on users

---

## 🆘 Troubleshooting

### API Key Not Working?
1. Check if key is correctly copied
2. Verify account has credit/subscription
3. Check API rate limits
4. Restart the app after adding keys

### Firebase Connection Issues?
1. Check internet connection
2. Verify `google-services.json` is in `android/app/`
3. Run `flutter clean` and rebuild
4. Check Firebase project settings

### Need Help?
- OpenAI Support: https://help.openai.com/
- ElevenLabs Support: https://elevenlabs.io/docs
- Firebase Support: https://firebase.google.com/support

---

**✨ Once setup is complete, you'll be able to generate AI-powered lessons with voice narration!**
