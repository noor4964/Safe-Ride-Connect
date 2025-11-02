# 🔥 Firebase Setup Guide for Safe Ride Connect

This guide will walk you through setting up Firebase for your Safe Ride Connect app.

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Enter project name: `Safe Ride Connect`
4. Enable/Disable Google Analytics (recommended: enable)
5. Select or create a Google Analytics account
6. Click **"Create project"**
7. Wait for project creation to complete

## Step 2: Add Android App to Firebase

1. In Firebase Console, click the **Android icon** (⚙️)
2. Register app with details:
   - **Android package name**: `com.example.safe_ride_connect`
   - **App nickname**: Safe Ride Connect (Android)
   - **Debug signing certificate SHA-1**: (Optional for now, needed for Google Sign-In later)
3. Click **"Register app"**
4. Download `google-services.json`
5. Place the file in: `android/app/google-services.json`

## Step 3: Configure FlutterFire CLI

Open terminal and run these commands:

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Make sure it's in your PATH
# Add to your shell profile if needed:
# export PATH="$PATH":"$HOME/.pub-cache/bin"

# Configure Firebase for your Flutter app
cd "c:\Users\Noor\Safe Ride Conncet\safe_ride_connect"
flutterfire configure
```

When prompted:
- Select your Firebase project: **Safe Ride Connect**
- Select platforms: **android, ios, web** (use arrow keys and space)
- It will generate `lib/firebase_options.dart` automatically

## Step 4: Enable Authentication

1. In Firebase Console, go to **Build** > **Authentication**
2. Click **"Get started"**
3. Go to **"Sign-in method"** tab
4. Click on **Email/Password**
5. Enable it (toggle the switch)
6. Click **"Save"**

## Step 5: Create Firestore Database

1. In Firebase Console, go to **Build** > **Firestore Database**
2. Click **"Create database"**
3. Select **"Start in test mode"** (for development)
4. Choose location: **asia-south1** (Mumbai) - closest to Bangladesh
5. Click **"Enable"**

## Step 6: Configure Firestore Security Rules

1. Go to **Firestore Database** > **Rules** tab
2. Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && isOwner(userId);
      allow update: if isAuthenticated() && isOwner(userId);
      allow delete: if isAuthenticated() && isOwner(userId);
    }
    
    // Verification requests
    match /verificationRequests/{requestId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if false; // Only admin can update
      allow delete: if false;
    }
  }
}
```

3. Click **"Publish"**

## Step 7: Setup Firebase Storage (for ID verification)

1. In Firebase Console, go to **Build** > **Storage**
2. Click **"Get started"**
3. Choose **"Start in test mode"**
4. Click **"Next"** > **"Done"**
5. Go to **Rules** tab
6. Update rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    // ID verification documents
    match /id_verification/{userId}_{timestamp}.jpg {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated() && isOwner(userId);
    }
    
    // Profile photos
    match /profile_photos/{userId}_{timestamp}.jpg {
      allow read: if true; // Public read
      allow write: if isAuthenticated() && isOwner(userId);
    }
  }
}
```

7. Click **"Publish"**

## Step 8: Setup Cloud Messaging (for notifications)

1. In Firebase Console, go to **Build** > **Cloud Messaging**
2. Under **"Cloud Messaging API"**, click **"Get started"**
3. Note: FCM is automatically configured with FlutterFire

## Step 9: Enable Firebase Crashlytics

1. In Firebase Console, go to **Build** > **Crashlytics**
2. Click **"Set up Crashlytics"**
3. Follow the setup wizard (most is auto-configured)

## Step 10: Setup Google Maps API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **APIs & Services** > **Library**
4. Search and enable these APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Places API**
   - **Geocoding API**
   - **Directions API**
5. Go to **APIs & Services** > **Credentials**
6. Click **"Create Credentials"** > **API Key**
7. Restrict the API key:
   - **Android apps**: Add your package name and SHA-1
   - **iOS apps**: Add your bundle ID
8. Copy your API key

### Add Google Maps API Key to Android

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    ...
    <!-- Add this inside <application> tag -->
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_API_KEY_HERE"/>
</application>
```

### Add Google Maps API Key to iOS

Edit `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Step 11: Test Your Setup

Run the app to verify everything works:

```bash
flutter clean
flutter pub get
flutter run
```

## ✅ Verification Checklist

- [ ] Firebase project created
- [ ] `google-services.json` placed in `android/app/`
- [ ] `firebase_options.dart` generated
- [ ] Email/Password authentication enabled
- [ ] Firestore database created
- [ ] Security rules configured
- [ ] Firebase Storage setup
- [ ] Google Maps API key added
- [ ] App runs without errors

## 🐛 Troubleshooting

### "No Firebase App has been created"
- Run `flutterfire configure` again
- Check `firebase_options.dart` exists
- Verify Firebase is initialized in `main.dart`

### "PERMISSION_DENIED" in Firestore
- Check your security rules
- Make sure user is authenticated
- Verify rules allow the operation

### Google Maps not showing
- Verify API key is correct
- Check APIs are enabled in Google Cloud Console
- Ensure billing is enabled (required for Maps API)

### Build errors after adding Firebase
- Run `flutter clean`
- Delete `android/build` folder
- Run `flutter pub get`
- Try building again

## 📚 Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)

## 🔐 Security Best Practices

1. **Never commit sensitive data to Git**:
   - Add to `.gitignore`:
     ```
     # Firebase
     **/google-services.json
     **/GoogleService-Info.plist
     lib/firebase_options.dart
     
     # API Keys
     **/api_keys.dart
     ```

2. **Use environment variables for API keys** (for production)

3. **Implement proper Firestore security rules** before going live

4. **Enable App Check** for production to prevent abuse

---

**Need Help?** Check the troubleshooting section or create an issue on GitHub!
