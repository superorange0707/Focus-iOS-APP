# SkipFeed Android - Setup Guide

## Overview

This Android version of SkipFeed has been successfully created with full feature parity to the iOS version. The app allows users to search across multiple social media platforms (Reddit, YouTube, X/Twitter, TikTok, Instagram, Facebook) without getting distracted by feeds.

## Project Structure

```
SkipFeedAndroid/
├── app/
│   ├── build.gradle.kts          # App-level Gradle configuration
│   ├── proguard-rules.pro        # ProGuard rules for release builds
│   └── src/main/
│       ├── AndroidManifest.xml   # App manifest with permissions
│       ├── java/com/skipfeed/android/
│       │   ├── data/              # Data layer
│       │   │   ├── api/           # API services (Reddit)
│       │   │   ├── database/      # Room database
│       │   │   ├── model/         # Data models
│       │   │   └── repository/    # Repository implementations
│       │   ├── di/                # Dependency injection (Hilt)
│       │   ├── presentation/      # UI layer
│       │   │   ├── components/    # Reusable Compose components
│       │   │   ├── navigation/    # Navigation setup
│       │   │   ├── screens/       # Main screens + ViewModels
│       │   │   └── theme/         # Material 3 theme
│       │   └── SkipFeedApplication.kt
│       └── res/                   # Android resources
│           ├── drawable/          # Icons and drawables
│           ├── mipmap-*/          # App launcher icons
│           ├── values/            # Strings, colors, themes
│           └── xml/               # Backup and data extraction rules
├── build.gradle.kts              # Project-level Gradle configuration
├── gradle.properties             # Gradle properties
├── settings.gradle.kts           # Project settings
└── README.md                     # Detailed documentation
```

## Key Features Implemented

### ✅ Core Functionality
- **Multi-Platform Search**: Search across 6 social media platforms
- **Native App Integration**: Automatically opens native apps when available
- **Web Browser Fallback**: Falls back to web browser when native apps aren't installed
- **Search History**: Persistent search history with Room database
- **Usage Analytics**: Track searches and time saved
- **User Preferences**: Customizable platform order and search modes

### ✅ Modern Android Architecture
- **MVVM Pattern**: Clean separation of concerns
- **Jetpack Compose**: Modern declarative UI
- **Dagger Hilt**: Dependency injection
- **Room Database**: Local data persistence
- **StateFlow**: Reactive state management
- **Coroutines**: Asynchronous operations

### ✅ UI/UX Design
- **Material 3 Design**: Modern Material Design 3 components
- **Responsive Layout**: Adapts to different screen sizes
- **Dark/Light Theme**: Automatic theme switching
- **Glass Morphism**: Modern glass effect styling
- **Smooth Animations**: Polished user interactions

## Setup Instructions

### Prerequisites
1. **Android Studio**: Hedgehog | 2023.1.1 or later
2. **Android SDK**: Level 34 (Android 14)
3. **Minimum SDK**: Level 24 (Android 7.0)
4. **Kotlin**: 1.9.22

### Building the App

1. **Open Project**:
   ```bash
   # Open Android Studio and import the SkipFeedAndroid folder
   ```

2. **Sync Dependencies**:
   - Android Studio will automatically prompt to sync Gradle files
   - Click "Sync Now" when prompted

3. **Build and Run**:
   - Connect an Android device or start an emulator
   - Click the "Run" button or use Ctrl+R (Cmd+R on Mac)

### Key Dependencies

```kotlin
// UI Framework
implementation("androidx.compose.ui:ui")
implementation("androidx.compose.material3:material3")
implementation("androidx.activity:activity-compose:1.8.2")

// Architecture Components
implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0")
implementation("androidx.navigation:navigation-compose:2.7.6")

// Dependency Injection
implementation("com.google.dagger:hilt-android:2.48")
implementation("androidx.hilt:hilt-navigation-compose:1.1.0")

// Database
implementation("androidx.room:room-runtime:2.6.1")
implementation("androidx.room:room-ktx:2.6.1")

// Network
implementation("com.squareup.retrofit2:retrofit:2.9.0")
implementation("com.squareup.retrofit2:converter-gson:2.9.0")
```

## App Screens

1. **Search Screen**: Main search interface with platform selector
2. **History Screen**: View and manage search history
3. **Statistics Screen**: Usage analytics and time saved metrics
4. **Settings Screen**: App preferences and configuration

## Platform Integration

The app integrates with native Android apps using the Intent system:

```kotlin
// Example: Opening Reddit app or web browser
fun createSearchIntent(query: String, context: Context): Intent? {
    return if (isAppInstalled(context)) {
        // Try native app first
        Intent.parseUri("reddit://www.reddit.com/search/?q=$query", Intent.URI_INTENT_SCHEME)
    } else {
        // Fall back to web browser
        Intent(Intent.ACTION_VIEW, Uri.parse("https://www.reddit.com/search/?q=$query"))
    }
}
```

## Testing the App

### Manual Testing Checklist

1. **Search Functionality**:
   - [ ] Test search on each platform (Reddit, YouTube, X, TikTok, Instagram, Facebook)
   - [ ] Verify native app opening (if installed)
   - [ ] Verify web browser fallback (if native app not installed)
   - [ ] Test TikTok special handling (no search query required)

2. **Search History**:
   - [ ] Verify searches are saved to history
   - [ ] Test clearing individual history items
   - [ ] Test clearing all history

3. **Statistics**:
   - [ ] Verify search count increments
   - [ ] Check time saved calculations
   - [ ] Test platform-specific statistics

4. **Settings**:
   - [ ] Test search mode toggle (Direct vs In-App)
   - [ ] Test language preferences
   - [ ] Test data reset functionality

5. **UI/UX**:
   - [ ] Test dark/light theme switching
   - [ ] Verify responsive layout on different screen sizes
   - [ ] Test navigation between screens

## Deployment Preparation

### Release Build Configuration

1. **Signing Configuration**: Add your keystore details to `build.gradle.kts`
2. **ProGuard**: Review and update `proguard-rules.pro` for code obfuscation
3. **Version Management**: Update `versionCode` and `versionName` in `build.gradle.kts`

### Google Play Store Preparation

1. **App Icons**: High-resolution app icons are already configured
2. **Screenshots**: Generate screenshots for different device sizes
3. **App Description**: Use content from README.md
4. **Privacy Policy**: Create privacy policy (app stores all data locally)
5. **Permissions**: Review permissions in AndroidManifest.xml

### Build Release APK

```bash
# Generate release APK
./gradlew assembleRelease

# Generate App Bundle (recommended for Play Store)
./gradlew bundleRelease
```

## Troubleshooting

### Common Issues

1. **Build Errors**: Ensure all dependencies are properly synced
2. **Hilt Compilation Issues**: Make sure all modules are properly annotated
3. **Room Database Issues**: Verify entity relationships and migrations
4. **Intent Handling**: Test on different devices with various app installations

### Debug Commands

```bash
# Clean and rebuild
./gradlew clean build

# Check for lint issues
./gradlew lint

# Run unit tests
./gradlew test
```

## Next Steps

1. **Testing**: Thoroughly test on various Android devices and versions
2. **Play Store**: Submit to Google Play Console for review
3. **Analytics**: Consider adding crash reporting (Firebase Crashlytics)
4. **Performance**: Profile app performance and optimize as needed
5. **Updates**: Plan for future feature additions and platform integrations

## Support

The Android app maintains full feature parity with the iOS version while following Android best practices and design patterns. All core functionality has been implemented and the app is ready for testing and deployment.
