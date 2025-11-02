# ⚡ Quick Start Guide

## 🎯 Run Your App in 5 Minutes

### Step 1: Firebase Setup (2 minutes)

```bash
# Install Firebase tools
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# Login and configure
firebase login
cd "c:\Users\Noor\Safe Ride Conncet\safe_ride_connect"
flutterfire configure
```

**Select**:
- Create new project or use existing
- Select platforms: Android, iOS, Web

### Step 2: Enable Authentication (1 minute)

1. Open https://console.firebase.google.com/
2. Go to **Authentication** → **Sign-in method**
3. Enable **Email/Password**

### Step 3: Create Database (1 minute)

1. Go to **Firestore Database**
2. Click **Create database**
3. Choose **Test mode**
4. Select location: **asia-south1**

### Step 4: Run! (1 minute)

```bash
flutter pub get
flutter run
```

---

## 🧪 Test It Out

### Create Your First User

1. Launch app → Click **"Create New Account"**
2. Use any university email (e.g., `test@aiub.edu`)
3. Fill in details → Click **"Create Account"**
4. Check email → Click verification link
5. Return to app → Automatically logged in! 🎉

### Supported Email Domains

Try these:
- `yourname@aiub.edu`
- `yourname@northsouth.edu`
- `yourname@bracu.ac.bd`
- `yourname@du.ac.bd`
- `yourname@buet.ac.bd`

---

## 📁 Key Files

- **`lib/main.dart`** - App entry point
- **`lib/screens/auth/login_screen.dart`** - Login UI
- **`lib/screens/auth/registration_screen.dart`** - Registration flow
- **`lib/models/university_model.dart`** - Add more universities here
- **`lib/providers/auth_provider.dart`** - Authentication logic

---

## 🎨 Customize

### Change App Colors

**File**: `lib/main.dart` (line ~27)

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.purple, // Your color!
),
```

### Add More Universities

**File**: `lib/models/university_model.dart`

```dart
University(
  id: 'your_id',
  name: 'Your University Name',
  domains: ['youruniversity.edu'],
  lat: 23.0000,
  lng: 90.0000,
),
```

---

## 🐛 Troubleshooting

### Can't run app?
```bash
flutter clean
flutter pub get
flutter run
```

### Firebase not working?
- Make sure you ran `flutterfire configure`
- Check `lib/firebase_options.dart` exists
- Verify Authentication is enabled in Firebase Console

### Email verification not coming?
- Check spam folder
- Wait 1-2 minutes
- Click "Resend" in the app

---

## 📖 Full Documentation

- **SETUP_COMPLETE.md** - Complete feature list
- **FIREBASE_SETUP.md** - Detailed Firebase guide
- **README.md** - Project overview

---

## 🚀 What's Next?

### Phase 2: Ride Features (Coming Next!)

You're ready to build:
- 🗺️ Google Maps integration
- 🚗 Ride creation & discovery
- 📍 Location picker
- 🔍 Search & filters

---

**Ready to build something amazing? Let's go! 🔥**
