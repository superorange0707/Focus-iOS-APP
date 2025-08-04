# 📱 SkipFeed Widget Setup Guide

## 🎯 Overview
Your SkipFeed widget code is ready! The widget will display:
- **Small Widget**: Total searches and time saved
- **Medium Widget**: Today's stats + total stats with beautiful design

## 🔧 Setup Steps

### 1. Open Xcode Project
```bash
open Focus.xcodeproj
```

### 2. Add Widget Extension Target

1. **Select Project File**: Click on `Focus.xcodeproj` in the navigator
2. **Add Target**: Click the "+" button at the bottom left
3. **Choose Widget Extension**: Select "Widget Extension" from the list
4. **Configure**:
   - **Product Name**: `FocusWidget`
   - **Bundle Identifier**: `Superorange.Focus.FocusWidget`
   - **Language**: Swift
   - **Include Configuration Intent**: ❌ NO (uncheck this)

### 3. Replace Generated Files

1. **Delete Auto-Generated Files**: Remove the files Xcode created
2. **Add Our Files**:
   - Drag `FocusWidget/FocusWidget.swift` to the widget target
   - Drag `FocusWidget/WidgetModels.swift` to the widget target
   - Drag `FocusWidget/Info.plist` to the widget target
   - Make sure all files are added to the FocusWidget target (not main app)

### 4. Configure App Groups

**For Main App (SkipFeed)**:
1. Select SkipFeed target
2. Go to "Signing & Capabilities"
3. Click "+" and add "App Groups"
4. Add group: `group.com.focus.app`

**For Widget (FocusWidget)**:
1. Select FocusWidget target
2. Go to "Signing & Capabilities"
3. Click "+" and add "App Groups"
4. Add group: `group.com.focus.app`

### 5. Build and Test

1. **Build Project**: Cmd+B
2. **Run on Simulator**: Cmd+R
3. **Add Widget**: Long press home screen → Add Widget → SkipFeed

## 🎨 Widget Features

### Small Widget (2x2)
- App icon and name
- Total searches count
- Time saved display
- Clean, minimal design

### Medium Widget (4x2)
- App branding
- Today's search count
- Today's time saved
- Total statistics
- Professional layout

## 🔍 Troubleshooting

### Widget Not Appearing?
1. Check App Groups are configured for both targets
2. Verify bundle identifier: `Superorange.Focus.FocusWidget`
3. Ensure widget files are in the correct target
4. Clean build folder (Cmd+Shift+K) and rebuild

### No Data Showing?
1. Use the main app first to generate some search data
2. Check that `group.com.focus.app` is correctly configured
3. Verify UserDefaults sharing is working

### Build Errors?
1. Make sure `UsageAnalytics` model is available to widget target
2. Check that all required files are included in widget target
3. Verify deployment target matches main app

## 📊 Data Sharing

The widget gets data from the main app via:
- **App Groups**: `group.com.focus.app`
- **UserDefaults**: Shared analytics data
- **Automatic Updates**: Refreshes every hour

## 🚀 After Setup

Once configured, users can:
1. **Add Widget**: Long press home screen → "+" → Search "SkipFeed"
2. **Choose Size**: Small (2x2) or Medium (4x2)
3. **View Stats**: Real-time search statistics and time saved
4. **Tap to Open**: Tapping widget opens the main app

## ✅ Verification

Your widget is working correctly when:
- ✅ Widget appears in iOS widget gallery
- ✅ Shows current search statistics
- ✅ Updates automatically
- ✅ Tapping opens main app
- ✅ Design matches iOS 16+ style

## 🎯 Next Steps

After widget setup:
1. Test on physical device
2. Verify data updates correctly
3. Test both widget sizes
4. Ensure proper App Store submission includes widget extension
