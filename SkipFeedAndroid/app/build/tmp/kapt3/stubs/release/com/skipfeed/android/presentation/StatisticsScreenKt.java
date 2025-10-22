package com.skipfeed.android.presentation;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u0000J\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010 \n\u0002\b\t\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0000\u001a<\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\nH\u0003\u00f8\u0001\u0000\u00a2\u0006\u0004\b\u000b\u0010\f\u001a@\u0010\r\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u00062\f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\b0\u00102\b\b\u0002\u0010\t\u001a\u00020\nH\u0003\u001a\b\u0010\u0011\u001a\u00020\u0001H\u0003\u001a*\u0010\u0012\u001a\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0013\u001a\u00020\u00032\u0006\u0010\u0007\u001a\u00020\bH\u0003\u00f8\u0001\u0000\u00a2\u0006\u0004\b\u0014\u0010\u0015\u001a\b\u0010\u0016\u001a\u00020\u0001H\u0003\u001a*\u0010\u0017\u001a\u00020\u00012\u0006\u0010\u0018\u001a\u00020\u00032\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u0007\u001a\u00020\bH\u0003\u00f8\u0001\u0000\u00a2\u0006\u0004\b\u001b\u0010\u001c\u001a\b\u0010\u001d\u001a\u00020\u0001H\u0003\u001a\u0010\u0010\u001e\u001a\u00020\u00012\u0006\u0010\u001f\u001a\u00020 H\u0003\u001a \u0010!\u001a\u00020\u00012\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\u001a0\u00102\b\b\u0002\u0010\t\u001a\u00020\nH\u0003\u001a \u0010#\u001a\u00020\u00012\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020$0\u00102\b\b\u0002\u0010\t\u001a\u00020\nH\u0003\u001a\b\u0010%\u001a\u00020\u0001H\u0007\u001a\b\u0010&\u001a\u00020\u0001H\u0003\u001a \u0010\'\u001a\u00020\u00012\u0006\u0010(\u001a\u00020\u00032\u0006\u0010)\u001a\u00020\u001a2\u0006\u0010*\u001a\u00020\u001aH\u0003\u001a$\u0010+\u001a\u00020\u00012\u0006\u0010,\u001a\u00020 2\u0012\u0010-\u001a\u000e\u0012\u0004\u0012\u00020 \u0012\u0004\u0012\u00020\u00010.H\u0003\u0082\u0002\u0007\n\u0005\b\u00a1\u001e0\u0001\u00a8\u0006/"}, d2 = {"CompactStatCard", "", "title", "", "value", "icon", "Landroidx/compose/ui/graphics/vector/ImageVector;", "color", "Landroidx/compose/ui/graphics/Color;", "modifier", "Landroidx/compose/ui/Modifier;", "CompactStatCard-42QJj7c", "(Ljava/lang/String;Ljava/lang/String;Landroidx/compose/ui/graphics/vector/ImageVector;JLandroidx/compose/ui/Modifier;)V", "HeroStatCard", "subtitle", "gradient", "", "HeroStatsSection", "InsightItem", "text", "InsightItem-mxwnekA", "(Landroidx/compose/ui/graphics/vector/ImageVector;Ljava/lang/String;J)V", "ModernInsightsCard", "PlatformLegendItem", "name", "percentage", "", "PlatformLegendItem-mxwnekA", "(Ljava/lang/String;IJ)V", "PlatformUsagePieChartCard", "SearchTrendChartCard", "timeRange", "Lcom/skipfeed/android/presentation/TimeRange;", "SimpleLineChart", "data", "SimplePieChart", "Lcom/skipfeed/android/presentation/PieChartData;", "StatisticsScreen", "TimeOfDayAnalysisCard", "TimeOfDayRow", "period", "searches", "totalSearches", "TimeRangeSelector", "selectedTimeRange", "onTimeRangeSelected", "Lkotlin/Function1;", "app_release"})
public final class StatisticsScreenKt {
    
    @androidx.compose.runtime.Composable()
    public static final void StatisticsScreen() {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void TimeRangeSelector(com.skipfeed.android.presentation.TimeRange selectedTimeRange, kotlin.jvm.functions.Function1<? super com.skipfeed.android.presentation.TimeRange, kotlin.Unit> onTimeRangeSelected) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void HeroStatsSection() {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void HeroStatCard(java.lang.String title, java.lang.String value, java.lang.String subtitle, androidx.compose.ui.graphics.vector.ImageVector icon, java.util.List<androidx.compose.ui.graphics.Color> gradient, androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void PlatformUsagePieChartCard() {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void SimplePieChart(java.util.List<com.skipfeed.android.presentation.PieChartData> data, androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void SearchTrendChartCard(com.skipfeed.android.presentation.TimeRange timeRange) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void SimpleLineChart(java.util.List<java.lang.Integer> data, androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void TimeOfDayAnalysisCard() {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void TimeOfDayRow(java.lang.String period, int searches, int totalSearches) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void ModernInsightsCard() {
    }
}