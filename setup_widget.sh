#!/bin/bash

echo "🔧 Setting up SkipFeed Widget Extension..."

# Check if Xcode is available
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode command line tools not found. Please install Xcode."
    exit 1
fi

echo "📋 Widget setup instructions:"
echo ""
echo "1. Open Focus.xcodeproj in Xcode"
echo "2. Select the project file in the navigator"
echo "3. Click the '+' button at the bottom left to add a new target"
echo "4. Choose 'Widget Extension' from the list"
echo "5. Configure the widget:"
echo "   - Product Name: FocusWidget"
echo "   - Bundle Identifier: Superorange.Focus.FocusWidget"
echo "   - Language: Swift"
echo "   - Include Configuration Intent: NO"
echo ""
echo "6. After creating the target:"
echo "   - Delete the auto-generated widget files"
echo "   - Add FocusWidget/FocusWidget.swift to the widget target"
echo "   - Add FocusWidget/Info.plist to the widget target"
echo ""
echo "7. Configure App Groups for both targets:"
echo "   - Main app (SkipFeed): Add 'group.com.focus.app'"
echo "   - Widget (FocusWidget): Add 'group.com.focus.app'"
echo ""
echo "8. Build and run the project"
echo ""
echo "✅ Widget files are ready in the FocusWidget/ directory"
echo "📱 After setup, you'll find the widget in iOS Settings > Widgets"

# Check if widget files exist
if [ -f "FocusWidget/FocusWidget.swift" ] && [ -f "FocusWidget/Info.plist" ]; then
    echo ""
    echo "✅ Widget files found:"
    echo "   - FocusWidget/FocusWidget.swift"
    echo "   - FocusWidget/Info.plist"
else
    echo ""
    echo "❌ Widget files missing. Please check the FocusWidget directory."
fi

echo ""
echo "🎯 Once configured, your widget will show:"
echo "   - Total searches and time saved"
echo "   - Today's search statistics"
echo "   - Beautiful iOS 16+ design"
