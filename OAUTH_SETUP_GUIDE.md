# 🔐 OAuth & External Services Setup Guide

## 🎯 Phase 1 Day 2-3: Authentication Services Setup

### Current Status (from Environment Monitor)
- ✅ **Supabase**: Configured and initialized
- ✅ **OpenAI**: Configured  
- ✅ **PlayHT**: Configured
- ❌ **Google OAuth**: Missing
- ❌ **Apple Sign-In**: Missing
- ❌ **SendGrid**: Missing

---

## 1. 🔑 Google OAuth Setup

### Step 1: Google Cloud Console Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create new project or select existing: `Wisme Production`
3. Enable **Google+ API** and **OAuth2 API**

### Step 2: OAuth Client Configuration
1. Navigate to **APIs & Services > Credentials**
2. Click **Create Credentials > OAuth 2.0 Client ID**
3. Configure application type: **Web Application**
4. Set authorized origins:
   ```
   http://localhost:3000
   https://your-domain.com
   ```
5. Set authorized redirect URIs:
   ```
   http://localhost:3000/auth/callback
   https://your-domain.com/auth/callback
   ```

### Step 3: Environment Configuration
Add to `.env` file:
```env
# Google OAuth Configuration
GOOGLE_CLIENT_ID=your_google_client_id_here.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_google_client_secret_here
GOOGLE_REDIRECT_URI=http://localhost:3000/auth/callback
```

---

## 2. 🍎 Apple Sign-In Setup

### Step 1: Apple Developer Console
1. Go to [Apple Developer](https://developer.apple.com/)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Create **App ID** for Wisme

### Step 2: Sign In with Apple Configuration
1. Create **Services ID** for web authentication
2. Configure domains and return URLs:
   ```
   Domain: your-domain.com
   Return URL: https://your-domain.com/auth/apple/callback
   ```

### Step 3: Generate Private Key
1. Create new **Key** for Sign in with Apple
2. Download `.p8` private key file
3. Note the **Key ID** and **Team ID**

### Step 4: Environment Configuration
Add to `.env` file:
```env
# Apple Sign-In Configuration
APPLE_CLIENT_ID=com.wisme.app.service
APPLE_TEAM_ID=your_apple_team_id_here
APPLE_KEY_ID=your_apple_key_id_here
APPLE_PRIVATE_KEY_PATH=path/to/apple_private_key.p8
```

---

## 3. 📧 SendGrid Email Setup

### Step 1: SendGrid Account
1. Create account at [SendGrid](https://sendgrid.com/)
2. Verify sender identity
3. Set up domain authentication (optional but recommended)

### Step 2: API Key Generation
1. Go to **Settings > API Keys**
2. Create new API key with **Full Access**
3. Copy the generated key immediately

### Step 3: Email Templates
Create templates for:
- Welcome email
- Password reset
- Daily streak notifications
- Weekly habit reports

### Step 4: Environment Configuration
Add to `.env` file:
```env
# SendGrid Email Configuration
SENDGRID_API_KEY=SG.your_sendgrid_api_key_here
SENDGRID_FROM_EMAIL=noreply@wisme.app
SENDGRID_FROM_NAME=Wisme App
```

---

## 4. 🔄 Testing Configuration

After setting up each service, test with our environment monitor:

1. **Update `.env` file** with real credentials
2. **Restart Flutter app**: `flutter run -d chrome --web-port=3000`
3. **Check configuration status** in console output
4. **Verify each service** shows ✅ instead of ❌

### Expected Output After Setup:
```
=== Wisme Configuration Status ===
✅ Supabase: Configured
✅ OpenAI: Configured
✅ PlayHT: Configured
✅ Google OAuth: Configured
✅ Apple Sign-In: Configured
✅ SendGrid: Configured
❌ ElevenLabs: Missing (Optional)
❌ Firebase: Missing (Optional)
❌ Algolia: Missing (Optional)
================================
```

---

## 5. 🚨 Security Best Practices

### Environment Variables
- ✅ Never commit `.env` to version control
- ✅ Use different keys for development/production
- ✅ Rotate API keys regularly
- ✅ Set up key restrictions and scopes

### OAuth Security
- ✅ Use state parameters to prevent CSRF
- ✅ Validate redirect URIs
- ✅ Implement proper token refresh logic
- ✅ Store tokens securely (encrypted)

### Production Deployment
- ✅ Use environment-specific configurations
- ✅ Set up monitoring and alerts
- ✅ Implement rate limiting
- ✅ Use HTTPS only

---

## 📋 Next Steps: Phase 1 Day 4-7

After completing OAuth setup:

1. **Session Management**: Implement token refresh and persistence
2. **AI Services**: Configure remaining AI/TTS services
3. **Error Handling**: Add comprehensive error handling
4. **Testing**: Validate all authentication flows
5. **Production Setup**: Deploy with production credentials

---

## 🛠️ Quick Setup Commands

```bash
# Test current configuration
flutter run -d chrome --web-port=3000

# Hot reload after config changes
r

# View DevTools
flutter run -d chrome --web-port=3000 --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@0.33.0/bin/
```

---

*This guide provides step-by-step instructions for setting up critical authentication and email services for Wisme production deployment.*
