package com.skipfeed.android.presentation;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u0000f\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\b\u001a&\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00060\fH\u0007\u001a\b\u0010\r\u001a\u00020\u0006H\u0007\u001a\u0010\u0010\u000e\u001a\u00020\u00062\u0006\u0010\u000f\u001a\u00020\u0010H\u0007\u001a&\u0010\u0011\u001a\u00020\u00062\u0006\u0010\u0012\u001a\u00020\u00022\u0006\u0010\t\u001a\u00020\n2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00060\fH\u0007\u001a\u001a\u0010\u0013\u001a\u00020\u00062\u0006\u0010\u0014\u001a\u00020\u00152\b\b\u0002\u0010\u0016\u001a\u00020\u0017H\u0007\u001a&\u0010\u0018\u001a\u00020\u00062\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\t\u001a\u00020\n2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00060\fH\u0007\u001a0\u0010\u001b\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00060\f2\b\b\u0002\u0010\u0016\u001a\u00020\u0017H\u0007\u001a2\u0010\u001c\u001a\u00020\u00062\u0006\u0010\u0012\u001a\u00020\b2\u0006\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u001e2\u0006\u0010 \u001a\u00020!H\u0007\u00f8\u0001\u0000\u00a2\u0006\u0004\b\"\u0010#\u001a\"\u0010$\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u0016\u001a\u00020\u0017H\u0007\u001a0\u0010%\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00060\f2\b\b\u0002\u0010\u0016\u001a\u00020\u0017H\u0007\u001a\b\u0010&\u001a\u00020\u0006H\u0007\u001aL\u0010\'\u001a\u00020\u00062\u0006\u0010(\u001a\u00020\b2\u0006\u0010)\u001a\u00020\b2\u0006\u0010*\u001a\u00020+2\b\b\u0002\u0010,\u001a\u00020!2\b\b\u0002\u0010-\u001a\u00020!2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00060\fH\u0007\u00f8\u0001\u0000\u00a2\u0006\u0004\b.\u0010/\u001a\b\u00100\u001a\u00020\u0006H\u0007\u001a=\u00101\u001a\u00020\u00062\u0006\u0010(\u001a\u00020\b2\u0006\u0010*\u001a\u00020+2\u0006\u0010,\u001a\u00020!2\u0011\u00102\u001a\r\u0012\u0004\u0012\u00020\u00060\f\u00a2\u0006\u0002\b3H\u0007\u00f8\u0001\u0000\u00a2\u0006\u0004\b4\u00105\u001a\b\u00106\u001a\u00020\u0006H\u0007\u001a<\u00107\u001a\u00020\u00062\u0006\u0010(\u001a\u00020\b2\u0006\u0010)\u001a\u00020\b2\u0006\u0010*\u001a\u00020+2\u0006\u0010 \u001a\u00020!2\b\b\u0002\u0010\u0016\u001a\u00020\u0017H\u0007\u00f8\u0001\u0000\u00a2\u0006\u0004\b8\u00109\u001a\b\u0010:\u001a\u00020\u0006H\u0007\"\u0017\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0003\u0010\u0004\u0082\u0002\u0007\n\u0005\b\u00a1\u001e0\u0001\u00a8\u0006;"}, d2 = {"platforms", "", "Lcom/skipfeed/android/presentation/Platform;", "getPlatforms", "()Ljava/util/List;", "FilterChip", "", "text", "", "isSelected", "", "onClick", "Lkotlin/Function0;", "HistoryScreen", "IOSHistoryItem", "item", "Lcom/skipfeed/android/presentation/HistoryItem;", "IOSPlatformCard", "platform", "IOSTabBar", "navController", "Landroidx/navigation/NavHostController;", "modifier", "Landroidx/compose/ui/Modifier;", "IOSTabItem", "tab", "Lcom/skipfeed/android/presentation/TabItem;", "PeriodButton", "PlatformUsageItem", "percentage", "", "searches", "color", "Landroidx/compose/ui/graphics/Color;", "PlatformUsageItem-g2O1Hgs", "(Ljava/lang/String;IIJ)V", "RetentionButton", "SearchModeButton", "SearchScreen", "SettingsRow", "title", "subtitle", "icon", "Landroidx/compose/ui/graphics/vector/ImageVector;", "iconColor", "textColor", "SettingsRow-BQnUqu0", "(Ljava/lang/String;Ljava/lang/String;Landroidx/compose/ui/graphics/vector/ImageVector;JJLkotlin/jvm/functions/Function0;)V", "SettingsScreen", "SettingsSection", "content", "Landroidx/compose/runtime/Composable;", "SettingsSection-9LQNqLg", "(Ljava/lang/String;Landroidx/compose/ui/graphics/vector/ImageVector;JLkotlin/jvm/functions/Function0;)V", "SkipFeedApp", "StatsCard", "StatsCard-42QJj7c", "(Ljava/lang/String;Ljava/lang/String;Landroidx/compose/ui/graphics/vector/ImageVector;JLandroidx/compose/ui/Modifier;)V", "StatsScreen", "app_debug"})
public final class MainActivityKt {
    @org.jetbrains.annotations.NotNull()
    private static final java.util.List<com.skipfeed.android.presentation.Platform> platforms = null;
    
    @androidx.compose.runtime.Composable()
    public static final void SkipFeedApp() {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void IOSTabBar(@org.jetbrains.annotations.NotNull()
    androidx.navigation.NavHostController navController, @org.jetbrains.annotations.NotNull()
    androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void IOSTabItem(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.presentation.TabItem tab, boolean isSelected, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.util.List<com.skipfeed.android.presentation.Platform> getPlatforms() {
        return null;
    }
    
    @androidx.compose.runtime.Composable()
    public static final void SearchScreen() {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void IOSPlatformCard(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.presentation.Platform platform, boolean isSelected, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void SearchModeButton(@org.jetbrains.annotations.NotNull()
    java.lang.String text, boolean isSelected, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick, @org.jetbrains.annotations.NotNull()
    androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void HistoryScreen() {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void FilterChip(@org.jetbrains.annotations.NotNull()
    java.lang.String text, boolean isSelected, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void IOSHistoryItem(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.presentation.HistoryItem item) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void StatsScreen() {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void PeriodButton(@org.jetbrains.annotations.NotNull()
    java.lang.String text, boolean isSelected, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick, @org.jetbrains.annotations.NotNull()
    androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void SettingsScreen() {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void RetentionButton(@org.jetbrains.annotations.NotNull()
    java.lang.String text, boolean isSelected, @org.jetbrains.annotations.NotNull()
    androidx.compose.ui.Modifier modifier) {
    }
}