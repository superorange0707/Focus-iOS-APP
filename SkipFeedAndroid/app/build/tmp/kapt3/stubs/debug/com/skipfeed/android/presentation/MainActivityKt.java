package com.skipfeed.android.presentation;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u0000\u0080\u0001\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0013\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u001a\u001a@\u0010\u0005\u001a\u00020\u00062\f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\u00060\b2\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00060\b2\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\u00060\b2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00060\bH\u0007\u001ai\u0010\f\u001a\u00020\u00062\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u00060\b2Q\u0010\u000e\u001aM\u0012\u0013\u0012\u00110\u0010\u00a2\u0006\f\b\u0011\u0012\b\b\u0012\u0012\u0004\b\b(\u0013\u0012\u0013\u0012\u00110\u0010\u00a2\u0006\f\b\u0011\u0012\b\b\u0012\u0012\u0004\b\b(\u0014\u0012\u0019\u0012\u0017\u0012\u0004\u0012\u00020\u00100\u0001\u00a2\u0006\f\b\u0011\u0012\b\b\u0012\u0012\u0004\b\b(\u0015\u0012\u0004\u0012\u00020\u00060\u000fH\u0007\u001aV\u0010\u0016\u001a\u00020\u00062\u0006\u0010\u0017\u001a\u00020\u00102\u0006\u0010\u0018\u001a\u00020\u00192\f\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u00060\b2\u0012\u0010\u001b\u001a\u000e\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00060\u001c2\f\u0010\u001d\u001a\b\u0012\u0004\u0012\u00020\u00060\b2\f\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020\u00060\bH\u0007\u001a&\u0010\u001f\u001a\u00020\u00062\u0006\u0010 \u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u00192\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\u00060\bH\u0007\u001a\u0018\u0010#\u001a\u00020\u00062\u0006\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020\'H\u0007\u001a&\u0010(\u001a\u00020\u00062\u0006\u0010)\u001a\u00020\u00022\u0006\u0010!\u001a\u00020\u00192\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\u00060\bH\u0007\u001a\u001a\u0010*\u001a\u00020\u00062\u0006\u0010+\u001a\u00020,2\b\b\u0002\u0010-\u001a\u00020.H\u0007\u001a&\u0010/\u001a\u00020\u00062\u0006\u00100\u001a\u0002012\u0006\u0010!\u001a\u00020\u00192\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\u00060\bH\u0007\u001a&\u00102\u001a\u00020\u00062\u0006\u00103\u001a\u00020\u00102\u0006\u0010\u0015\u001a\u00020\u00102\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u00060\bH\u0007\u001aN\u00104\u001a\u00020\u00062\u0006\u00105\u001a\u00020\u00102\u0006\u00106\u001a\u00020\u00192\u0012\u00107\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00060\u001c2\u0012\u00108\u001a\u000e\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00060\u001c2\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u00060\bH\u0007\u001a.\u00109\u001a\u00020\u00062\u0006\u0010:\u001a\u00020;2\u0006\u00103\u001a\u00020\u00102\u0006\u0010<\u001a\u00020\u00192\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\u00060\bH\u0007\u001a:\u0010=\u001a\u00020\u00062\u0006\u00106\u001a\u00020\u00192\u0006\u00105\u001a\u00020\u00102\f\u0010>\u001a\b\u0012\u0004\u0012\u00020\u00060\b2\u0012\u00108\u001a\u000e\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00060\u001cH\u0007\u001a0\u0010?\u001a\u00020\u00062\u0006\u0010:\u001a\u00020;2\u0006\u00103\u001a\u00020\u00102\u0006\u0010@\u001a\u00020\u00102\u000e\u0010\"\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\bH\u0007\u001a<\u0010A\u001a\u00020\u00062\u0006\u0010:\u001a\u00020;2\u0006\u00103\u001a\u00020\u00102\u0006\u0010B\u001a\u00020\u00102\u0006\u0010C\u001a\u00020\u00192\u0012\u0010D\u001a\u000e\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00060\u001cH\u0007\u001a\u001e\u0010E\u001a\u00020\u00062\u0006\u0010F\u001a\u00020\u00102\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\u00060\bH\u0007\u001a\"\u0010G\u001a\u00020\u00062\u0006\u0010 \u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u00192\b\b\u0002\u0010-\u001a\u00020.H\u0007\u001a2\u0010H\u001a\u00020\u00062\u0006\u0010I\u001a\u00020\u00102\u0012\u0010J\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00060\u001c2\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u00060\bH\u0007\u001a0\u0010K\u001a\u00020\u00062\u0006\u0010 \u001a\u00020\u00102\u0006\u0010!\u001a\u00020\u00192\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\u00060\b2\b\b\u0002\u0010-\u001a\u00020.H\u0007\u001a \u0010L\u001a\u00020\u00062\u0006\u0010+\u001a\u00020,2\u0006\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020\'H\u0007\u001aL\u0010M\u001a\u00020\u00062\u0006\u00103\u001a\u00020\u00102\u0006\u0010B\u001a\u00020\u00102\u0006\u0010:\u001a\u00020;2\b\b\u0002\u0010N\u001a\u00020O2\b\b\u0002\u0010P\u001a\u00020O2\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\u00060\bH\u0007\u00f8\u0001\u0000\u00a2\u0006\u0004\bQ\u0010R\u001a\u0018\u0010S\u001a\u00020\u00062\u0006\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020\'H\u0007\u001a\u0018\u0010T\u001a\u00020\u00062\u0006\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020\'H\u0007\u001a:\u0010U\u001a\u00020\u00062\u0006\u00103\u001a\u00020\u00102\u0006\u0010V\u001a\u00020\u00102\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u00060\b2\u0012\u0010W\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00060\u001cH\u0007\u001a\u0016\u0010X\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010[\u001a\u00020\u0010\u001a\u0016\u0010\\\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010]\u001a\u00020\u0010\u001a\u0016\u0010^\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010_\u001a\u00020\u0019\u001a\u000e\u0010`\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z\u001a&\u0010a\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\n\b\u0002\u0010$\u001a\u0004\u0018\u00010%2\n\b\u0002\u0010&\u001a\u0004\u0018\u00010\'\u001a\u000e\u0010b\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z\u001a\u0016\u0010c\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010d\u001a\u00020e\u001a,\u0010f\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010\u0013\u001a\u00020\u00102\u0006\u0010\u0014\u001a\u00020\u00102\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00100\u0001\u001a\u000e\u0010g\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z\u001a\"\u0010h\u001a\u00020\u00102\f\u0010i\u001a\b\u0012\u0004\u0012\u00020e0\u00012\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00100\u0001\u001a\"\u0010j\u001a\u00020\u00102\f\u0010i\u001a\b\u0012\u0004\u0012\u00020e0\u00012\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00100\u0001\u001a\"\u0010k\u001a\u00020\u00102\f\u0010i\u001a\b\u0012\u0004\u0012\u00020e0\u00012\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00100\u0001\u001a\u0006\u0010l\u001a\u00020\u0010\u001a\u0016\u0010m\u001a\u00020\u00102\u0006\u0010Y\u001a\u00020Z2\u0006\u0010d\u001a\u00020e\u001a\u0006\u0010n\u001a\u00020\u0010\u001a\u0006\u0010o\u001a\u00020\u0010\u001a\u0006\u0010p\u001a\u00020\u0010\u001a\u001e\u0010q\u001a\u00020\u00192\u0006\u0010Y\u001a\u00020Z2\u0006\u0010r\u001a\u00020\u00102\u0006\u0010s\u001a\u00020\u0019\u001a\u001e\u0010q\u001a\u00020\u00102\u0006\u0010Y\u001a\u00020Z2\u0006\u0010r\u001a\u00020\u00102\u0006\u0010s\u001a\u00020\u0010\u001a\u0014\u0010t\u001a\b\u0012\u0004\u0012\u00020\u00100\u00012\u0006\u0010Y\u001a\u00020Z\u001a\u0014\u0010u\u001a\b\u0012\u0004\u0012\u00020e0\u00012\u0006\u0010Y\u001a\u00020Z\u001a&\u0010v\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010)\u001a\u00020\u00102\u0006\u0010F\u001a\u00020\u00102\u0006\u0010w\u001a\u00020\u0010\u001a\u000e\u0010x\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z\u001a\u000e\u0010y\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z\u001a\u0016\u0010z\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010F\u001a\u00020\u0010\u001a(\u0010{\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010F\u001a\u00020\u00102\u0006\u0010)\u001a\u00020\u00102\b\b\u0002\u0010w\u001a\u00020\u0010\u001a\u001c\u0010{\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\f\u0010i\u001a\b\u0012\u0004\u0012\u00020e0\u0001\u001a&\u0010|\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010F\u001a\u00020\u00102\u0006\u0010)\u001a\u00020\u00102\u0006\u0010$\u001a\u00020%\u001a\u001e\u0010}\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010r\u001a\u00020\u00102\u0006\u0010@\u001a\u00020\u0019\u001a\u001e\u0010}\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010r\u001a\u00020\u00102\u0006\u0010@\u001a\u00020\u0010\u001a\u001e\u0010~\u001a\u00020\u00062\u0006\u0010Y\u001a\u00020Z2\u0006\u0010\u0015\u001a\u00020\u00102\u0006\u0010\u0013\u001a\u00020\u0010\"\u0017\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0003\u0010\u0004\u0082\u0002\u0007\n\u0005\b\u00a1\u001e0\u0001\u00a8\u0006\u007f"}, d2 = {"platforms", "", "Lcom/skipfeed/android/presentation/PlatformInfo;", "getPlatforms", "()Ljava/util/List;", "AboutSupportCard", "", "onPrivacyPolicyClick", "Lkotlin/Function0;", "onTermsClick", "onSupportClick", "onContactClick", "DataExportDialog", "onDismiss", "onExport", "Lkotlin/Function3;", "", "Lkotlin/ParameterName;", "name", "format", "timeRange", "content", "DataManagementCard", "dataRetentionPeriod", "automaticPlatformOrder", "", "onRetentionClick", "onPlatformOrderToggle", "Lkotlin/Function1;", "onExportClick", "onClearDataClick", "FilterChip", "text", "isSelected", "onClick", "HistoryScreen", "searchRepository", "Lcom/skipfeed/android/data/repository/SearchRepository;", "usageAnalyticsRepository", "Lcom/skipfeed/android/data/repository/UsageAnalyticsRepository;", "IOSPlatformCard", "platform", "IOSTabBar", "navController", "Landroidx/navigation/NavHostController;", "modifier", "Landroidx/compose/ui/Modifier;", "IOSTabItem", "tab", "Lcom/skipfeed/android/presentation/TabItem;", "InternalWebViewDialog", "title", "LanguageSelectorDialog", "currentLanguage", "autoDetectLanguage", "onLanguageSelected", "onAutoDetectToggle", "ModernActionRow", "icon", "Landroidx/compose/ui/graphics/vector/ImageVector;", "isDestructive", "ModernPreferencesCard", "onLanguageClick", "ModernSettingRow", "value", "ModernToggleRow", "subtitle", "isOn", "onToggle", "RecentSearchChip", "query", "RetentionButton", "RetentionPeriodDialog", "currentPeriod", "onPeriodSelected", "SearchModeButton", "SearchScreen", "SettingsRow", "iconColor", "Landroidx/compose/ui/graphics/Color;", "textColor", "SettingsRow-BQnUqu0", "(Ljava/lang/String;Ljava/lang/String;Landroidx/compose/ui/graphics/vector/ImageVector;JJLkotlin/jvm/functions/Function0;)V", "SettingsScreen", "SkipFeedApp", "WebViewDialog", "url", "onOpenUrl", "applyDataRetentionPolicy", "context", "Landroid/content/Context;", "period", "applyLanguageChange", "languageCode", "applyPlatformOrderingChange", "isAutomatic", "cleanInvalidHistory", "clearAllHistory", "clearRecentSearches", "deleteSearchHistory", "item", "Lcom/skipfeed/android/presentation/HistoryItem;", "exportSearchData", "forceCleanProblematicRecords", "generateCSVContent", "items", "generateJSONContent", "generateTXTContent", "getPrivacyPolicyContent", "getSearchMode", "getSupportFAQContent", "getSystemLanguage", "getTermsOfServiceContent", "getUserPreference", "key", "defaultValue", "loadRecentSearches", "loadSearchHistory", "performSearch", "mode", "reorderPlatformsByUsage", "resetPlatformsToDefaultOrder", "saveRecentSearch", "saveSearchHistory", "saveSearchToHistory", "saveUserPreferences", "shareExportedData", "app_debug"})
public final class MainActivityKt {
    @org.jetbrains.annotations.NotNull()
    private static final java.util.List<com.skipfeed.android.presentation.PlatformInfo> platforms = null;
    
    @androidx.compose.runtime.Composable()
    public static final void SkipFeedApp(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.SearchRepository searchRepository, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository) {
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
    public static final java.util.List<com.skipfeed.android.presentation.PlatformInfo> getPlatforms() {
        return null;
    }
    
    public static final void performSearch(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String platform, @org.jetbrains.annotations.NotNull()
    java.lang.String query, @org.jetbrains.annotations.NotNull()
    java.lang.String mode) {
    }
    
    public static final void saveSearchHistory(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String query, @org.jetbrains.annotations.NotNull()
    java.lang.String platform, @org.jetbrains.annotations.NotNull()
    java.lang.String mode) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.util.List<com.skipfeed.android.presentation.HistoryItem> loadSearchHistory(@org.jetbrains.annotations.NotNull()
    android.content.Context context) {
        return null;
    }
    
    public static final void deleteSearchHistory(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.presentation.HistoryItem item) {
    }
    
    public static final void clearAllHistory(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.Nullable()
    com.skipfeed.android.data.repository.SearchRepository searchRepository, @org.jetbrains.annotations.Nullable()
    com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository) {
    }
    
    public static final void cleanInvalidHistory(@org.jetbrains.annotations.NotNull()
    android.content.Context context) {
    }
    
    public static final void forceCleanProblematicRecords(@org.jetbrains.annotations.NotNull()
    android.content.Context context) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.lang.String getSearchMode(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.presentation.HistoryItem item) {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.util.List<java.lang.String> loadRecentSearches(@org.jetbrains.annotations.NotNull()
    android.content.Context context) {
        return null;
    }
    
    public static final void saveRecentSearch(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String query) {
    }
    
    public static final void saveSearchToHistory(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String query, @org.jetbrains.annotations.NotNull()
    java.lang.String platform, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.SearchRepository searchRepository) {
    }
    
    public static final void clearRecentSearches(@org.jetbrains.annotations.NotNull()
    android.content.Context context) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void RecentSearchChip(@org.jetbrains.annotations.NotNull()
    java.lang.String query, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void SearchScreen(@org.jetbrains.annotations.NotNull()
    androidx.navigation.NavHostController navController, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.SearchRepository searchRepository, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void IOSPlatformCard(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.presentation.PlatformInfo platform, boolean isSelected, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void SearchModeButton(@org.jetbrains.annotations.NotNull()
    java.lang.String text, boolean isSelected, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick, @org.jetbrains.annotations.NotNull()
    androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void HistoryScreen(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.SearchRepository searchRepository, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void FilterChip(@org.jetbrains.annotations.NotNull()
    java.lang.String text, boolean isSelected, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.lang.String getPrivacyPolicyContent() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.lang.String getTermsOfServiceContent() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.lang.String getSupportFAQContent() {
        return null;
    }
    
    @androidx.compose.runtime.Composable()
    public static final void SettingsScreen(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.SearchRepository searchRepository, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void ModernPreferencesCard(boolean autoDetectLanguage, @org.jetbrains.annotations.NotNull()
    java.lang.String currentLanguage, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onLanguageClick, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super java.lang.Boolean, kotlin.Unit> onAutoDetectToggle) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void RetentionButton(@org.jetbrains.annotations.NotNull()
    java.lang.String text, boolean isSelected, @org.jetbrains.annotations.NotNull()
    androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void DataManagementCard(@org.jetbrains.annotations.NotNull()
    java.lang.String dataRetentionPeriod, boolean automaticPlatformOrder, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onRetentionClick, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super java.lang.Boolean, kotlin.Unit> onPlatformOrderToggle, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onExportClick, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClearDataClick) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void AboutSupportCard(@org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onPrivacyPolicyClick, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onTermsClick, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onSupportClick, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onContactClick) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void ModernSettingRow(@org.jetbrains.annotations.NotNull()
    androidx.compose.ui.graphics.vector.ImageVector icon, @org.jetbrains.annotations.NotNull()
    java.lang.String title, @org.jetbrains.annotations.NotNull()
    java.lang.String value, @org.jetbrains.annotations.Nullable()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void ModernToggleRow(@org.jetbrains.annotations.NotNull()
    androidx.compose.ui.graphics.vector.ImageVector icon, @org.jetbrains.annotations.NotNull()
    java.lang.String title, @org.jetbrains.annotations.NotNull()
    java.lang.String subtitle, boolean isOn, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super java.lang.Boolean, kotlin.Unit> onToggle) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void ModernActionRow(@org.jetbrains.annotations.NotNull()
    androidx.compose.ui.graphics.vector.ImageVector icon, @org.jetbrains.annotations.NotNull()
    java.lang.String title, boolean isDestructive, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void LanguageSelectorDialog(@org.jetbrains.annotations.NotNull()
    java.lang.String currentLanguage, boolean autoDetectLanguage, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super java.lang.String, kotlin.Unit> onLanguageSelected, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super java.lang.Boolean, kotlin.Unit> onAutoDetectToggle, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onDismiss) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void DataExportDialog(@org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onDismiss, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function3<? super java.lang.String, ? super java.lang.String, ? super java.util.List<java.lang.String>, kotlin.Unit> onExport) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void RetentionPeriodDialog(@org.jetbrains.annotations.NotNull()
    java.lang.String currentPeriod, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super java.lang.String, kotlin.Unit> onPeriodSelected, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onDismiss) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void WebViewDialog(@org.jetbrains.annotations.NotNull()
    java.lang.String title, @org.jetbrains.annotations.NotNull()
    java.lang.String url, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onDismiss, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super java.lang.String, kotlin.Unit> onOpenUrl) {
    }
    
    public static final void saveUserPreferences(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String key, @org.jetbrains.annotations.NotNull()
    java.lang.String value) {
    }
    
    public static final void saveUserPreferences(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String key, boolean value) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.lang.String getUserPreference(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String key, @org.jetbrains.annotations.NotNull()
    java.lang.String defaultValue) {
        return null;
    }
    
    public static final boolean getUserPreference(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String key, boolean defaultValue) {
        return false;
    }
    
    public static final void exportSearchData(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String format, @org.jetbrains.annotations.NotNull()
    java.lang.String timeRange, @org.jetbrains.annotations.NotNull()
    java.util.List<java.lang.String> content) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.lang.String generateCSVContent(@org.jetbrains.annotations.NotNull()
    java.util.List<com.skipfeed.android.presentation.HistoryItem> items, @org.jetbrains.annotations.NotNull()
    java.util.List<java.lang.String> content) {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.lang.String generateTXTContent(@org.jetbrains.annotations.NotNull()
    java.util.List<com.skipfeed.android.presentation.HistoryItem> items, @org.jetbrains.annotations.NotNull()
    java.util.List<java.lang.String> content) {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.lang.String generateJSONContent(@org.jetbrains.annotations.NotNull()
    java.util.List<com.skipfeed.android.presentation.HistoryItem> items, @org.jetbrains.annotations.NotNull()
    java.util.List<java.lang.String> content) {
        return null;
    }
    
    public static final void shareExportedData(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String content, @org.jetbrains.annotations.NotNull()
    java.lang.String format) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final java.lang.String getSystemLanguage() {
        return null;
    }
    
    public static final void applyLanguageChange(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String languageCode) {
    }
    
    public static final void applyDataRetentionPolicy(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String period) {
    }
    
    public static final void saveSearchHistory(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.util.List<com.skipfeed.android.presentation.HistoryItem> items) {
    }
    
    public static final void applyPlatformOrderingChange(@org.jetbrains.annotations.NotNull()
    android.content.Context context, boolean isAutomatic) {
    }
    
    public static final void reorderPlatformsByUsage(@org.jetbrains.annotations.NotNull()
    android.content.Context context) {
    }
    
    public static final void resetPlatformsToDefaultOrder(@org.jetbrains.annotations.NotNull()
    android.content.Context context) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void InternalWebViewDialog(@org.jetbrains.annotations.NotNull()
    java.lang.String title, @org.jetbrains.annotations.NotNull()
    java.lang.String content, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onDismiss) {
    }
}