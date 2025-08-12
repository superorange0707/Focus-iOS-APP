package com.skipfeed.android.presentation.screens.statistics;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u0000d\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010 \n\u0002\b\u0005\n\u0002\u0010\t\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\u001a,\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u00f8\u0001\u0000\u00a2\u0006\u0004\b\b\u0010\t\u001a<\u0010\n\u001a\u00020\u00012\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\f2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u00f8\u0001\u0000\u00a2\u0006\u0004\b\u0010\u0010\u0011\u001a@\u0010\u0012\u001a\u00020\u00012\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\f2\u0006\u0010\u0013\u001a\u00020\f2\u0006\u0010\u000e\u001a\u00020\u000f2\f\u0010\u0014\u001a\b\u0012\u0004\u0012\u00020\u00030\u00152\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u001aD\u0010\u0016\u001a\u00020\u00012\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\f2\u0006\u0010\u0013\u001a\u00020\f2\u0006\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u00f8\u0001\u0000\u00a2\u0006\u0004\b\u0017\u0010\u0018\u001a\"\u0010\u0019\u001a\u00020\u00012\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u001a4\u0010\u001e\u001a\u00020\u00012\u0018\u0010\u001f\u001a\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020!\u0012\u0004\u0012\u00020\u001d0 0\u00152\u0006\u0010\"\u001a\u00020#2\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u001a\u001a\u0010$\u001a\u00020\u00012\u0006\u0010\"\u001a\u00020#2\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u001a.\u0010%\u001a\u00020\u00012\u0006\u0010&\u001a\u00020#2\u0012\u0010\'\u001a\u000e\u0012\u0004\u0012\u00020#\u0012\u0004\u0012\u00020\u00010(2\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u001a\u0012\u0010)\u001a\u00020\u00012\b\b\u0002\u0010*\u001a\u00020+H\u0007\u001a\u0012\u0010,\u001a\u00020\u00012\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u001a*\u0010-\u001a\u00020\u00012\u0006\u0010\u000e\u001a\u00020\f2\u0006\u0010.\u001a\u00020\f2\u0006\u0010/\u001a\u00020\u001d2\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u001a\u0010\u00100\u001a\u00020\f2\u0006\u00101\u001a\u00020\u001bH\u0002\u0082\u0002\u0007\n\u0005\b\u00a1\u001e0\u0001\u00a8\u00062"}, d2 = {"Circle", "", "color", "Landroidx/compose/ui/graphics/Color;", "size", "Landroidx/compose/ui/unit/Dp;", "modifier", "Landroidx/compose/ui/Modifier;", "Circle-5DgIosw", "(JFLandroidx/compose/ui/Modifier;)V", "CompactStatCard", "title", "", "value", "icon", "Landroidx/compose/ui/graphics/vector/ImageVector;", "CompactStatCard-42QJj7c", "(Ljava/lang/String;Ljava/lang/String;Landroidx/compose/ui/graphics/vector/ImageVector;JLandroidx/compose/ui/Modifier;)V", "HeroStatCard", "subtitle", "gradient", "", "InsightRow", "InsightRow-jzV_Hc0", "(Landroidx/compose/ui/graphics/vector/ImageVector;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JLandroidx/compose/ui/Modifier;)V", "InsightsCard", "todayTimeSaved", "", "totalSearches", "", "PlatformUsageCard", "platforms", "Lkotlin/Pair;", "Lcom/skipfeed/android/data/model/Platform;", "timeRange", "Lcom/skipfeed/android/presentation/screens/statistics/TimeRange;", "SearchTrendCard", "SegmentedControl", "selectedTimeRange", "onTimeRangeSelected", "Lkotlin/Function1;", "StatisticsScreen", "viewModel", "Lcom/skipfeed/android/presentation/screens/statistics/StatisticsViewModel;", "TimeOfDayAnalysisCard", "TimeOfDayRow", "period", "searches", "formatTimeSaved", "timeInterval", "app_debug"})
public final class StatisticsScreenKt {
    
    @kotlin.OptIn(markerClass = {androidx.compose.material3.ExperimentalMaterial3Api.class})
    @androidx.compose.runtime.Composable()
    public static final void StatisticsScreen(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.presentation.screens.statistics.StatisticsViewModel viewModel) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void SegmentedControl(com.skipfeed.android.presentation.screens.statistics.TimeRange selectedTimeRange, kotlin.jvm.functions.Function1<? super com.skipfeed.android.presentation.screens.statistics.TimeRange, kotlin.Unit> onTimeRangeSelected, androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void HeroStatCard(java.lang.String title, java.lang.String value, java.lang.String subtitle, androidx.compose.ui.graphics.vector.ImageVector icon, java.util.List<androidx.compose.ui.graphics.Color> gradient, androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void PlatformUsageCard(java.util.List<? extends kotlin.Pair<? extends com.skipfeed.android.data.model.Platform, java.lang.Integer>> platforms, com.skipfeed.android.presentation.screens.statistics.TimeRange timeRange, androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void SearchTrendCard(com.skipfeed.android.presentation.screens.statistics.TimeRange timeRange, androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void TimeOfDayAnalysisCard(androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void InsightsCard(long todayTimeSaved, int totalSearches, androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void TimeOfDayRow(java.lang.String icon, java.lang.String period, int searches, androidx.compose.ui.Modifier modifier) {
    }
    
    private static final java.lang.String formatTimeSaved(long timeInterval) {
        return null;
    }
}