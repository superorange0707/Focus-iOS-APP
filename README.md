# Focus Search - iOS App

A distraction-free search app that helps users find what they need quickly without getting lost in recommendation algorithms.

## Features

### 🎯 **Direct Search Experience**
- Clean, focused interface without distracting recommendations
- Quick access to multiple platforms from one app
- Smart search suggestions and auto-complete

### 🔍 **Multi-Platform Search**
- **YouTube**: Video tutorials, reviews, and content
- **Reddit**: Community discussions and posts
- **Instagram**: Visual content and hashtags
- **Facebook**: Groups and community content
- **Twitter**: Real-time discussions and news
- **Google**: Comprehensive web search
- **Bing**: Alternative search engine

### 💡 **Smart Features**
- **Auto-suggestions**: Real-time search suggestions as you type
- **Recent searches**: Quick access to your search history
- **Quick search buttons**: One-tap access to popular searches
- **Platform-specific tips**: Helpful search suggestions for each platform

### 🎨 **iOS 26 Glass Style UI**
- Modern glass morphism design
- Smooth animations and transitions
- Adaptive color schemes for each platform
- Beautiful gradient backgrounds

### 📱 **Smart Navigation**
- **Native app integration**: Opens content in the appropriate app when available
- **Browser fallback**: Seamlessly opens in Safari when native apps aren't installed
- **Preview mode**: Quick preview of search results before opening
- **Share functionality**: Easy sharing of search results

### 🔄 **Enhanced Results**
- **Rich previews**: Detailed content previews with metadata
- **Adaptive result types**: Different layouts for videos, posts, articles, etc.
- **Quick actions**: One-tap access to open, share, or bookmark content
- **Platform indicators**: Clear visual identification of content sources

## How It Works

### 1. **Choose Your Platform**
Select from 7 popular platforms using the intuitive platform selector with platform-specific colors and icons.

### 2. **Smart Search Input**
- Type your query and get real-time suggestions
- Use quick search buttons for common searches
- Access recent searches for quick re-finding

### 3. **Focused Results**
- Clean, distraction-free result display
- Rich previews with content snippets
- Platform-specific metadata (views, duration, upvotes, etc.)

### 4. **Smart Navigation**
- **Primary action**: Opens content in the native app (if installed)
- **Secondary action**: Opens in Safari browser
- **Preview mode**: Quick content preview without leaving the app
- **Share**: Easy sharing to other apps

## Technical Features

### 🏗️ **Architecture**
- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **ObservableObject**: Reactive data management
- **URL Schemes**: Deep linking to external apps

### 🔧 **Key Components**
- `SearchService`: Manages search logic and suggestions
- `URLSchemeHandler`: Handles external app navigation
- `PlatformSelectorView`: Platform selection interface
- `SearchInputView`: Enhanced search input with suggestions
- `SearchResultsView`: Rich result display with actions

### 📊 **Data Management**
- **Recent searches**: Persistent local storage
- **Search suggestions**: Smart filtering and ranking
- **Platform metadata**: Rich result information
- **User preferences**: Platform-specific settings

## Installation

### Requirements
- iOS 15.0 or later
- Xcode 13.0 or later
- Swift 5.5 or later

### Setup
1. Clone the repository
2. Open `Focus.xcodeproj` in Xcode
3. Select your development team
4. Build and run on device or simulator

### Configuration
The app includes proper URL scheme configuration in `Info.plist` for:
- YouTube, Reddit, Instagram, Facebook, Twitter
- Google, Bing search engines
- Safari browser integration

## Usage Examples

### For Developers
```
Search: "iOS tutorial" → YouTube results with video previews
Search: "r/iOSProgramming" → Reddit community discussions
Search: "SwiftUI tips" → Mixed platform results
```

### For Content Creators
```
Search: "#iOS" → Instagram visual content
Search: "app development" → Facebook groups and communities
Search: "coding tutorial" → YouTube educational content
```

### For Researchers
```
Search: "iOS development" → Google comprehensive results
Search: "SwiftUI vs UIKit" → Reddit community discussions
Search: "App Store guidelines" → Official documentation
```

## Design Philosophy

### 🎯 **Focus First**
- No distracting recommendations
- Clean, minimal interface
- Direct access to search results

### 🚀 **Speed Matters**
- Instant search suggestions
- Quick platform switching
- Fast result loading

### 🎨 **Beautiful Experience**
- iOS 26 glass morphism design
- Smooth animations
- Platform-specific theming

### 🔗 **Smart Integration**
- Native app deep linking
- Browser fallback
- Share functionality

## Future Enhancements

### Planned Features
- **Voice search**: Speech-to-text search input
- **Search filters**: Date, type, and platform filters
- **Bookmarks**: Save and organize favorite results
- **Search history**: Detailed search analytics
- **Custom platforms**: Add your own search sources
- **Dark mode**: Enhanced dark theme support
- **Widgets**: Quick search from home screen

### Technical Improvements
- **Real API integration**: Replace mock data with actual APIs
- **Offline support**: Cached results for offline viewing
- **Search analytics**: User behavior insights
- **Performance optimization**: Faster search and loading
- **Accessibility**: Enhanced VoiceOver support

## Contributing

We welcome contributions! Please see our contributing guidelines for:
- Code style and standards
- Testing requirements
- Pull request process
- Issue reporting

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, questions, or feature requests:
- Create an issue on GitHub
- Contact the development team
- Check our documentation

---

**Focus Search** - Because finding what you need shouldn't be a distraction. 