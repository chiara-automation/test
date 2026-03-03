# SETUP_INSTRUCTIONS.md

## English Bot - Flutter App Setup Guide

### Step 1: Prerequisites

Make sure you have Flutter installed and properly configured:

```bash
# Check Flutter version
flutter --version

# Check if Flutter is configured correctly
flutter doctor
```

All green checkmarks (✓) are required before proceeding.

### Step 2: Install Dependencies

Navigate to the project directory and install all required packages:

```bash
cd englishbot
flutter pub get
```

### Step 3: Run the App

#### For Android:
```bash
flutter run -d android
```

#### For iOS:
```bash
flutter run -d ios
```

#### For Web (if enabled):
```bash
flutter run -d web
```

#### For Windows/macOS:
```bash
flutter run
```

### Step 4: Build Release Version

To create a production build:

#### Android APK:
```bash
flutter build apk --release
```

#### iOS:
```bash
flutter build ios --release
```

#### Web:
```bash
flutter build web --release
```

### Troubleshooting

1. **Pod install errors (iOS):**
   ```bash
   cd ios
   pod install --repo-update
   cd ..
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Java not found (Android):**
   - Ensure Android SDK is properly installed
   - Set `ANDROID_HOME` environment variable

3. **Build cache issues:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### IDE Setup

#### VS Code
- Install the Flutter extension (ID: Dart-Code.flutter)
- Install the Dart extension (ID: Dart-Code.dart-code)
- Reload the window

#### Android Studio
- Install the Flutter plugin from Settings > Plugins
- Reload the IDE

### Next Steps

1. Update the `BotService` in `lib/services/bot_service.dart` to connect to your real API
2. Customize the theme colors in `lib/main.dart`
3. Add more features as needed
4. Build and deploy your app!
