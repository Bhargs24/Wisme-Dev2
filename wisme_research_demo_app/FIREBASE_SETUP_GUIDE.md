# 🔥 Complete Firebase Setup Guide for Wisme Research App

## 📋 Overview

Your Flutter app is configured to use Firebase project **`wisme-research-app`**. This guide will walk you through setting up Firebase services to make your authentication, database, and analytics fully functional.

---

## 🚀 Quick Start Checklist

- [ ] **Step 1**: Access Firebase Console
- [ ] **Step 2**: Configure Authentication
- [ ] **Step 3**: Set up Firestore Database 
- [ ] **Step 4**: Configure Firebase Storage
- [ ] **Step 5**: Enable Analytics
- [ ] **Step 6**: Set up Security Rules
- [ ] **Step 7**: Test the Integration

---

## Step 1: 🔑 Access Firebase Console

### 1.1 Go to Firebase Console
1. Visit [Firebase Console](https://console.firebase.google.com/)
2. Sign in with your Google account
3. Look for the project **`wisme-research-app`**
4. Click on it to access the project dashboard

### 1.2 If Project Doesn't Exist
If the project doesn't exist, you'll need to:
1. Click "Add project" in Firebase Console
2. Use the project name: **`wisme-research-app`**
3. Enable Google Analytics (recommended)
4. Choose your analytics account
5. Click "Create project"

---

## Step 2: 🔐 Configure Authentication

### 2.1 Enable Authentication Methods
1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. Enable the following providers:

#### Enable Email/Password Authentication:
- Click **Email/Password** 
- Toggle **Enable** to ON
- Click **Save**

#### Enable Google Sign-In (Optional but Recommended):
- Click **Google**
- Toggle **Enable** to ON
- Enter your project's support email
- Click **Save**

#### Enable Phone Authentication (If Needed):
- Click **Phone**
- Toggle **Enable** to ON
- Configure phone verification settings
- Click **Save**

### 2.2 Configure Authorized Domains
1. Go to **Authentication** > **Settings** > **Authorized domains**
2. Add these domains:
   - `localhost` (for development)
   - `wisme-research-app.firebaseapp.com`
   - Any custom domains you plan to use

---

## Step 3: 💾 Set up Firestore Database

### 3.1 Create Firestore Database
1. Go to **Firestore Database** in the Firebase Console
2. Click **Create database**
3. Choose **Start in production mode** (we'll configure rules later)
4. Select your preferred location (choose closest to your users)
5. Click **Done**

### 3.2 Create Required Collections
Your app needs these Firestore collections:

```
📁 users/
  └── {userId}/
      ├── age: number
      ├── education: string
      ├── occupation: string
      ├── learningGoals: array
      ├── subjectFamiliarity: map
      ├── createdAt: timestamp
      └── isAdmin: boolean

📁 research_sessions/
  └── {sessionId}/
      ├── userId: string
      ├── journeyId: string
      ├── startTime: timestamp
      ├── endTime: timestamp
      ├── engagementData: map
      └── feedback: map

📁 learning_journeys/
  └── {journeyId}/
      ├── title: string
      ├── description: string
      ├── episodes: array
      ├── totalDuration: number
      └── difficulty: string

📁 feedback/
  └── {feedbackId}/
      ├── userId: string
      ├── sessionId: string
      ├── type: string
      ├── responses: map
      ├── timestamp: timestamp
      └── ratings: map

📁 admin_logs/
  └── {logId}/
      ├── adminId: string
      ├── action: string
      ├── timestamp: timestamp
      └── metadata: map
```

**You don't need to create these manually** - your app will create them automatically when users interact with it.

---

## Step 4: 📦 Configure Firebase Storage

### 4.1 Set up Storage
1. Go to **Storage** in Firebase Console
2. Click **Get started**
3. Review the security rules (we'll modify these later)
4. Choose your storage location (same as Firestore)
5. Click **Done**

### 4.2 Storage Structure
Your app will use this storage structure:
```
📁 audio_files/
  ├── journeys/
  │   └── {journeyId}/
  │       └── episodes/
  │           └── {episodeId}.mp3
  └── user_recordings/ (if needed)
      └── {userId}/
          └── {recordingId}.wav

📁 user_avatars/
  └── {userId}.jpg

📁 research_data/
  └── exports/
      └── {exportId}.json
```

---

## Step 5: 📊 Enable Analytics

### 5.1 Configure Analytics
1. Go to **Analytics** in Firebase Console
2. If not already enabled, click **Enable Analytics**
3. Link to Google Analytics 4 property
4. Configure data retention settings:
   - Set to **14 months** (maximum for research data)

### 5.2 Analytics Events Your App Tracks
Your app automatically tracks these events:
- `user_signup_complete`
- `onboarding_complete`
- `journey_started`
- `journey_completed`
- `feedback_submitted`
- `custom_profession_entered`

---

## Step 6: 🔒 Set up Security Rules

### 6.1 Firestore Security Rules
1. Go to **Firestore Database** > **Rules**
2. Replace the default rules with these:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      // Admins can read all user data
      allow read: if request.auth != null && 
        exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Research sessions - users can create/read their own
    match /research_sessions/{sessionId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      // Admins can read all sessions
      allow read: if request.auth != null && 
        exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Learning journeys - everyone can read, admins can write
    match /learning_journeys/{journeyId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Feedback - users can create, admins can read
    match /feedback/{feedbackId} {
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
      allow read: if request.auth != null && 
        exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Admin logs - only admins can read/write
    match /admin_logs/{logId} {
      allow read, write: if request.auth != null && 
        exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
  }
}
```

3. Click **Publish** to save the rules

### 6.2 Storage Security Rules
1. Go to **Storage** > **Rules**
2. Replace with these rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Audio files - authenticated users can read
    match /audio_files/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        exists(/databases/{project}/documents/users/$(request.auth.uid)) &&
        get(/databases/{project}/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // User avatars - users can manage their own
    match /user_avatars/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Research data exports - admins only
    match /research_data/{allPaths=**} {
      allow read, write: if request.auth != null && 
        exists(/databases/{project}/documents/users/$(request.auth.uid)) &&
        get(/databases/{project}/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
  }
}
```

3. Click **Publish**

---

## Step 7: 👨‍💻 Create Your Admin Account

### 7.1 Create Admin User
1. Run your Flutter app
2. Sign up with your email (this will be your admin account)
3. Note the User ID from Firebase Console > Authentication > Users

### 7.2 Make User Admin
1. Go to **Firestore Database** 
2. Find the `users` collection
3. Find your user document (with your User ID)
4. Add a field: `isAdmin` with value `true`
5. Save the document

---

## Step 8: 🧪 Test the Integration

### 8.1 Test Authentication
1. Run your app
2. Try signing up with a new email
3. Check Firebase Console > Authentication > Users to see the new user
4. Try signing in with the email

### 8.2 Test Database
1. Complete the onboarding flow in your app
2. Check Firestore > users collection to see the user data
3. Navigate through the app to generate research session data

### 8.3 Test Admin Features
1. Sign in with your admin account
2. Access admin screens to verify admin permissions
3. Check that you can see analytics and user data

---

## 🔧 Troubleshooting Common Issues

### Issue 1: "CONFIGURATION_NOT_FOUND" Error
**Solution**: 
- Ensure Firebase project exists
- Verify `firebase_options.dart` has correct project ID
- Check that all Firebase services are enabled

### Issue 2: Authentication Not Working
**Solution**:
- Verify Email/Password is enabled in Firebase Console
- Check that your domain is in authorized domains
- Ensure your app is using correct API keys

### Issue 3: Firestore Permission Denied
**Solution**:
- Check your Firestore security rules
- Ensure user is authenticated
- Verify admin users have `isAdmin: true` in their document

### Issue 4: Storage Access Denied
**Solution**:
- Check Storage security rules
- Ensure user authentication is working
- Verify file paths match your security rules

---

## 🎯 Important Configuration Notes

### Production vs Development
- **Development**: Use Firebase Emulator Suite for local testing (optional)
- **Production**: Ensure all security rules are properly configured

### Email Configuration
- Set up custom email templates in Authentication > Templates
- Configure your own SMTP server for production (recommended)

### Analytics
- Analytics data appears with a delay (up to 24 hours)
- Use DebugView for real-time testing during development

### Privacy and GDPR
- Configure data retention policies in Analytics
- Implement user data deletion in your app
- Add privacy policy links to your authentication flows

---

## 📞 Need Help?

If you encounter issues:

1. **Check Firebase Console logs**: Go to Functions > Logs
2. **Review Flutter logs**: Check your app's debug console
3. **Verify configuration**: Double-check all steps above
4. **Test with Firebase Emulator**: Use local emulation for debugging

---

## 🎉 You're All Set!

Once you complete these steps, your Wisme Research App will have:

✅ **Secure user authentication**  
✅ **Real-time database for research data**  
✅ **File storage for audio content**  
✅ **Analytics for user behavior tracking**  
✅ **Admin controls for research management**  
✅ **Production-ready security rules**  

Your research participants can now sign up, complete onboarding, and generate valuable research data that you can analyze through the Firebase Console and your admin dashboard!
