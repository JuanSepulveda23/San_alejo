# How to Set Up the San Alejo Project

This guide explains how to properly set up and run the San Alejo application after Flutter is installed.

## Prerequisites

Before starting, ensure Flutter is installed and set up on your system:

```bash
# Check Flutter installation
flutter --version

# Get Flutter info
flutter doctor
```

If Flutter is not installed, follow the installation guide in the README.md file.

## Step-by-Step Setup

### Step 1: Navigate to the Project Directory

```bash
cd "/home/sebastiansc/Desktop/App san alejo"
```

### Step 2: Initialize the Flutter Project Structure

Since we created the core application files manually, we need to initialize the platform-specific code. Run either of these commands:

**Option A: Create the platform structure (recommended)**
```bash
# This creates the Android, iOS, web, and other platform directories
flutter create . --platforms android,ios
```

**Option B: Let Flutter handle everything (if starting from scratch)**
```bash
# Navigate up one level
cd "/home/sebastiansc/Desktop"

# Create a fresh Flutter project (this will delete and recreate everything)
flutter create --template=app "App san alejo"

# Then copy the lib/ folder and pubspec.yaml from our version
```

### Step 3: Get Dependencies

```bash
flutter pub get
```

### Step 4: Run the App

**On an Android emulator:**
```bash
# List available emulators
flutter emulators

# Launch an emulator (example)
flutter emulators --launch Android10

# Wait for emulator to start, then run:
flutter run
```

**On iOS (Mac only):**
```bash
# For iOS simulator
open -a Simulator  # Opens iOS Simulator
flutter run
```

**On a connected device:**
```bash
flutter devices  # Lists connected devices

flutter run -d <device_id>
```

### Step 5: Verify Everything Works

After running `flutter run`, you should see:
1. The app starting up in your emulator/device
2. The main screen showing 3 pre-loaded containers (Caja cocina, Maleta ropa invierno, Cajón cables)
3. The ability to tap on containers to see their contents
4. The ability to add new containers and objects

## Project Structure After Setup

After running `flutter create .`, your project will have this complete structure:

```
App san alejo/
├── android/                    # Android platform code
├── ios/                        # iOS platform code
├── linux/                      # Linux platform code
├── macos/                      # macOS platform code
├── web/                        # Web platform code
├── windows/                    # Windows platform code
├── lib/                        # Our Dart application code
│   ├── main.dart
│   ├── models/
│   ├── database/
│   ├── repositories/
│   └── screens/
├── test/                       # Test files
├── pubspec.yaml               # Dependencies and configuration
├── pubspec.lock               # Locked dependency versions
├── README.md                  # User documentation
├── analysis_options.yaml      # Code quality rules
└── .gitignore                 # Git ignore rules
```

## Common Issues and Solutions

### Issue: "flutter: command not found"

**Solution:** Add Flutter to your PATH:

```bash
# Find Flutter installation directory
which flutter

# Or manually add to PATH (add this to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:/path/to/flutter/bin"

# Reload shell
source ~/.bashrc
# or
source ~/.zshrc
```

### Issue: "No internet connection" / "Cannot download packages"

**Solution:** Check your internet and retry:

```bash
flutter pub get
# or
flutter pub upgrade
```

### Issue: "No devices found"

**Solution:** Start an emulator:

```bash
# List emulators
flutter emulators

# Start one
flutter emulators --launch <emulator_name>

# Or if you have an Android emulator installed
android-studio  # And create/start an emulator from the AVD Manager
```

### Issue: "Build failed" or "Compilation error"

**Solution:** Clean and rebuild:

```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "Error: Could not find the Android SDK"

**Solution:** Set Android SDK path:

```bash
flutter config --android-sdk /path/to/android-sdk

# Or set environment variable
export ANDROID_SDK_ROOT=/path/to/android-sdk
```

## Building for Distribution

### Build APK (Android)

```bash
# Debug APK
flutter build apk

# Release APK (optimized and signed)
flutter build apk --release

# Split APK for different architectures
flutter build apk --release --split-per-abi
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### Build Bundle (Android - for Google Play)

```bash
flutter build appbundle --release
```

### Build iOS App (Mac only)

```bash
flutter build ios --release
```

## Next Steps

1. **Run the app:** Follow Step 4 above
2. **Test functionality:** Use the app to create containers and objects
3. **Explore the code:** Read through the files in `lib/`
4. **Customize:** Update colors, fonts, or functionality as needed
5. **Version control:** Commit to Git when ready

## Additional Resources

- [Flutter Getting Started](https://flutter.dev/docs/get-started/codelab)
- [Flutter CLI Reference](https://flutter.dev/docs/reference/flutter-cli)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design in Flutter](https://flutter.dev/docs/development/ui/material)

---

**Need help?** Check the main README.md or Flutter's official documentation.
