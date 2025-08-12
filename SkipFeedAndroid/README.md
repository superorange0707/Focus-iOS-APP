# SkipFeed Android

SkipFeed Android is the Android version of the iOS SkipFeed app, a social media search application that helps users find content across multiple platforms without getting distracted by endless feeds.

## Features

- **Direct Search**: Search across multiple social media platforms (Reddit, YouTube, X/Twitter, TikTok, Instagram, Facebook) without opening feeds
- **Platform Integration**: Automatically opens native apps when available, falls back to web browser
- **Search History**: Track your search history (with privacy controls)
- **Usage Analytics**: See how much time you've saved by avoiding feeds
- **Multi-language Support**: Auto-detect device language or manually select preferred language
- **Customizable Platform Order**: Reorder platforms based on your preferences
- **Search Modes**: Choose between direct search (opens immediately) or in-app browsing (for Reddit)

## Architecture

The app follows modern Android development practices:

- **Architecture**: MVVM with Clean Architecture
- **UI**: Jetpack Compose
- **Dependency Injection**: Dagger Hilt
- **Database**: Room for local data storage
- **Network**: Retrofit for API calls (Reddit API)
- **Navigation**: Jetpack Navigation Compose
- **State Management**: StateFlow and Compose State

## Tech Stack

- **Language**: Kotlin
- **UI Framework**: Jetpack Compose
- **Architecture Components**: ViewModel, Room, Navigation
- **Dependency Injection**: Dagger Hilt
- **Network**: Retrofit + OkHttp
- **Database**: Room + SQLite
- **Image Loading**: Coil
- **Async**: Coroutines + Flow

## Project Structure

```
app/src/main/java/com/skipfeed/android/
├── data/
│   ├── api/              # API services (Reddit API)
│   ├── database/         # Room database, DAOs
│   ├── model/            # Data models
│   └── repository/       # Repository pattern implementations
├── di/                   # Dependency injection modules
├── presentation/
│   ├── components/       # Reusable Compose components
│   ├── navigation/       # Navigation setup
│   ├── screens/          # Screen composables and ViewModels
│   └── theme/            # App theme and styling
└── SkipFeedApplication.kt
```

## Building the App

### Prerequisites

- Android Studio Hedgehog | 2023.1.1 or later
- Android SDK 34
- Kotlin 1.9.22
- Minimum SDK 24 (Android 7.0)

### Setup

1. Clone the repository
2. Open the `SkipFeedAndroid` folder in Android Studio
3. Sync the project with Gradle files
4. Build and run the app

### Dependencies

Key dependencies include:
- Jetpack Compose BOM 2024.02.00
- Hilt 2.48
- Room 2.6.1
- Retrofit 2.9.0
- Navigation Compose 2.7.6
- Lifecycle ViewModel Compose 2.7.0

## Features Implemented

### Core Functionality
- ✅ Multi-platform search (Reddit, YouTube, X, TikTok, Instagram, Facebook)
- ✅ Native app integration with web fallback
- ✅ Search history management
- ✅ Usage analytics and time-saved tracking
- ✅ Platform preference ordering
- ✅ Search mode selection (Direct vs In-App)

### UI/UX
- ✅ Modern Material 3 design
- ✅ Responsive layout
- ✅ Dark/light theme support
- ✅ Smooth animations
- ✅ Bottom navigation
- ✅ Glass morphism effects

### Data Management
- ✅ Local database with Room
- ✅ SharedPreferences for user settings
- ✅ Search history persistence
- ✅ Usage analytics storage

### Platform Integration
- ✅ Intent handling for native apps
- ✅ URL scheme detection
- ✅ Package manager queries
- ✅ Web browser fallback

## Comparison with iOS Version

The Android version maintains feature parity with the iOS version while adapting to Android-specific patterns:

| Feature | iOS | Android |
|---------|-----|---------|
| UI Framework | SwiftUI | Jetpack Compose |
| Database | UserDefaults + JSON | Room + SQLite |
| Navigation | TabView | Navigation Compose |
| State Management | @StateObject | StateFlow + Compose State |
| Dependency Injection | Manual | Dagger Hilt |
| Network | URLSession | Retrofit |
| Platform Integration | URL Schemes | Intents + Package Manager |

## Future Enhancements

- [ ] Widget support for quick search
- [ ] Backup and sync across devices
- [ ] More granular privacy controls
- [ ] Advanced search filters per platform
- [ ] Trending topics integration
- [ ] Search suggestions based on history

## Privacy

The app prioritizes user privacy:
- All data is stored locally on the device
- No personal data is transmitted to external servers
- Search history can be cleared at any time
- Analytics are local and anonymous

## Support

For support, feature requests, or bug reports, please visit the main repository or contact support through the app's settings page.
