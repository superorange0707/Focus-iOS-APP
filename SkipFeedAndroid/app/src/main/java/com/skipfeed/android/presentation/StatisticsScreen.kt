package com.skipfeed.android.presentation

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.res.stringResource
import androidx.hilt.navigation.compose.hiltViewModel
import com.skipfeed.android.R
import com.skipfeed.android.data.LocalizationManager
import com.skipfeed.android.data.model.Platform
import com.skipfeed.android.data.model.SearchHistoryItem
import com.skipfeed.android.data.model.UsageAnalytics
import com.skipfeed.android.presentation.viewmodel.StatisticsViewModel
import java.text.SimpleDateFormat
import java.util.*
import kotlin.math.*

@Composable
fun StatisticsScreen(
    viewModel: StatisticsViewModel = hiltViewModel()
) {
    val localizationManager = remember { LocalizationManager.getInstance() }
    var selectedTimeRange by remember { mutableStateOf(TimeRange.WEEK) }
    val usageAnalytics by viewModel.usageAnalytics.collectAsState()
    val searchHistory by viewModel.searchHistory.collectAsState()

    // Debug: Add a button to clear all data for testing
    var showDebugOptions by remember { mutableStateOf(false) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFF2F2F7))
    ) {
        // iOS-style navigation bar with title in the middle
        Surface(
            modifier = Modifier.fillMaxWidth(),
            color = Color.White,
            shadowElevation = 0.5.dp
        ) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 16.dp),
                contentAlignment = Alignment.Center
            ) {
                // Title smaller and centered in the header box
                Text(
                    text = stringResource(R.string.stats),
                    fontSize = 17.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF1C1C1E)
                )
            }
        }

        LazyColumn(
            modifier = Modifier.fillMaxSize(),
            verticalArrangement = Arrangement.spacedBy(20.dp),
            contentPadding = PaddingValues(start = 20.dp, end = 20.dp, top = 20.dp, bottom = 140.dp)
        ) {


            // Time Range Selector
            item {
                TimeRangeSelector(
                    selectedTimeRange = selectedTimeRange,
                    onTimeRangeSelected = { selectedTimeRange = it }
                )
            }

            // Hero Stats Section
            item {
                HeroStatsSection(usageAnalytics = usageAnalytics)
            }

            // Platform Usage Pie Chart
            item {
                PlatformUsagePieChartCard(usageAnalytics = usageAnalytics)
            }

            // Search Trend Chart
            item {
                SearchTrendChartCard(
                    timeRange = selectedTimeRange,
                    usageAnalytics = usageAnalytics
                )
            }

            // Time of Day Analysis
            item {
                TimeOfDayAnalysisCard(searchHistory = searchHistory)
            }

            // Insights Section
            item {
                ModernInsightsCard(
                    usageAnalytics = usageAnalytics,
                    searchHistory = searchHistory
                )
            }
        }
    }
}

@Composable
private fun TimeRangeSelector(
    selectedTimeRange: TimeRange,
    onTimeRangeSelected: (TimeRange) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        TimeRange.values().forEach { timeRange ->
            val isSelected = selectedTimeRange == timeRange
            
            Button(
                onClick = { onTimeRangeSelected(timeRange) },
                modifier = Modifier.weight(1f),
                colors = ButtonDefaults.buttonColors(
                    containerColor = if (isSelected) Color(0xFF007AFF) else Color.White,
                    contentColor = if (isSelected) Color.White else Color(0xFF007AFF)
                ),
                shape = RoundedCornerShape(8.dp),
                elevation = ButtonDefaults.buttonElevation(
                    defaultElevation = if (isSelected) 2.dp else 0.dp
                )
            ) {
                Text(
                    text = when (timeRange) {
                        TimeRange.WEEK -> stringResource(R.string.last_seven_days)
                        TimeRange.MONTH -> stringResource(R.string.last_thirty_days)
                    },
                    fontSize = 14.sp,
                    fontWeight = if (isSelected) FontWeight.SemiBold else FontWeight.Medium
                )
            }
        }
    }
}

@Composable
private fun HeroStatsSection(usageAnalytics: UsageAnalytics) {
    // Calculate time saved (estimate: 2 minutes per search vs endless scrolling)
    val timeSavedMinutes = usageAnalytics.totalSearches * 2
    val timeSavedHours = timeSavedMinutes / 60
    val remainingMinutes = timeSavedMinutes % 60

    val timeSavedText = if (timeSavedHours > 0) {
        "${timeSavedHours}h ${remainingMinutes}m"
    } else {
        "${remainingMinutes}m"
    }

    // Calculate today's searches
    val today = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
    val todaysSearches = usageAnalytics.dailySearches[today] ?: 0

    Column(
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Main Hero Card - Time Saved
        HeroStatCard(
            title = stringResource(R.string.time_saved),
            value = timeSavedText,
            subtitle = stringResource(R.string.since_first_use),
            icon = Icons.Default.Schedule,
            gradient = listOf(Color(0xFF34C759), Color(0xFF30D158))
        )

        // Compact Stats Row
        Row(
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            CompactStatCard(
                title = stringResource(R.string.total_searches),
                value = usageAnalytics.totalSearches.toString(),
                icon = Icons.Default.Search,
                color = Color(0xFF007AFF),
                modifier = Modifier.weight(1f)
            )

            CompactStatCard(
                title = stringResource(R.string.searches_today),
                value = todaysSearches.toString(),
                icon = Icons.Default.Today,
                color = Color(0xFFFF9500),
                modifier = Modifier.weight(1f)
            )
        }
    }
}

@Composable
private fun HeroStatCard(
    title: String,
    value: String,
    subtitle: String,
    icon: ImageVector,
    gradient: List<Color>,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.fillMaxWidth(),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(containerColor = Color.Transparent),
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(
                    brush = Brush.linearGradient(
                        colors = gradient,
                        start = androidx.compose.ui.geometry.Offset(0f, 0f),
                        end = androidx.compose.ui.geometry.Offset(1000f, 1000f)
                    )
                )
                .padding(24.dp)
        ) {
            Column {
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = icon,
                        contentDescription = null,
                        tint = Color.White,
                        modifier = Modifier.size(24.dp)
                    )
                    
                    Spacer(modifier = Modifier.width(12.dp))
                    
                    Text(
                        text = title,
                        color = Color.White,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Medium
                    )
                }
                
                Spacer(modifier = Modifier.height(16.dp))
                
                Text(
                    text = value,
                    color = Color.White,
                    fontSize = 36.sp,
                    fontWeight = FontWeight.Bold
                )
                
                Text(
                    text = subtitle,
                    color = Color.White.copy(alpha = 0.8f),
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium
                )
            }
        }
    }
}

@Composable
private fun CompactStatCard(
    title: String,
    value: String,
    icon: ImageVector,
    color: Color,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier,
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier.padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = color,
                modifier = Modifier.size(32.dp)
            )

            Spacer(modifier = Modifier.height(12.dp))

            Text(
                text = value,
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFF1C1C1E),
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(4.dp))

            Text(
                text = title,
                fontSize = 12.sp,
                fontWeight = FontWeight.Medium,
                color = Color(0xFF8E8E93),
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}

@Composable
private fun PlatformUsagePieChartCard(usageAnalytics: UsageAnalytics) {
    // Calculate platform usage data from real analytics
    val platformData = usageAnalytics.searchesByPlatform.entries
        .sortedByDescending { it.value }
        .take(4) // Show top 4 platforms
        .map { (platformName, count) ->
            val platform = Platform.values().find { it.name == platformName } ?: Platform.REDDIT
            val total = usageAnalytics.totalSearches
            val percentage = if (total > 0) (count * 100) / total else 0
            PieChartData(platform.displayName, percentage, platform.color, count)
        }

    // Only show if there's data
    if (platformData.isNotEmpty()) {
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(20.dp),
            colors = CardDefaults.cardColors(containerColor = Color.White),
            elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
        ) {
            Column(
                modifier = Modifier.padding(20.dp)
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.PieChart,
                        contentDescription = null,
                        tint = Color(0xFF5856D6),
                        modifier = Modifier.size(24.dp)
                    )

                    Spacer(modifier = Modifier.width(12.dp))

                    Text(
                        text = stringResource(R.string.platform_usage),
                        fontSize = 18.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = Color(0xFF1C1C1E)
                    )
                }

                Spacer(modifier = Modifier.height(20.dp))

                Row(
                    horizontalArrangement = Arrangement.spacedBy(20.dp)
                ) {
                    // Simple Pie Chart with real data
                    SimplePieChart(
                        data = platformData,
                        modifier = Modifier.size(120.dp)
                    )

                    // Legend with real data
                    Column(
                        modifier = Modifier.weight(1f),
                        verticalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        platformData.forEach { data ->
                            PlatformLegendItem(data.name, data.percentage, data.color, data.searchCount)
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun PlatformLegendItem(
    name: String,
    percentage: Int,
    color: Color,
    searchCount: Int
) {
    Row(
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(12.dp)
                .background(color, RoundedCornerShape(2.dp))
        )

        Spacer(modifier = Modifier.width(8.dp))

        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = name,
                fontSize = 14.sp,
                fontWeight = FontWeight.Medium,
                color = Color(0xFF1C1C1E)
            )
            Text(
                text = "$searchCount searches",
                fontSize = 12.sp,
                fontWeight = FontWeight.Normal,
                color = Color(0xFF8E8E93)
            )
        }

        Text(
            text = "$percentage%",
            fontSize = 14.sp,
            fontWeight = FontWeight.SemiBold,
            color = Color(0xFF8E8E93)
        )
    }
}

data class PieChartData(
    val name: String,
    val percentage: Int,
    val color: Color,
    val searchCount: Int
)

@Composable
private fun SimplePieChart(
    data: List<PieChartData>,
    modifier: Modifier = Modifier
) {
    val total = data.sumOf { it.percentage }

    Canvas(
        modifier = modifier
    ) {
        val center = Offset(size.width / 2, size.height / 2)
        val radius = size.minDimension / 2 * 0.8f
        val innerRadius = radius * 0.5f

        var startAngle = -90f

        data.forEach { item ->
            val sweepAngle = (item.percentage.toFloat() / total.toFloat()) * 360f

            drawArc(
                color = item.color,
                startAngle = startAngle,
                sweepAngle = sweepAngle,
                useCenter = false,
                topLeft = Offset(
                    center.x - radius,
                    center.y - radius
                ),
                size = androidx.compose.ui.geometry.Size(radius * 2f, radius * 2f),
                style = Stroke(width = radius - innerRadius)
            )

            startAngle += sweepAngle
        }
    }
}

@Composable
private fun SearchTrendChartCard(timeRange: TimeRange, usageAnalytics: UsageAnalytics) {
    // Generate real data based on analytics
    val chartData = generateChartData(timeRange, usageAnalytics)

    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier.padding(20.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.fillMaxWidth()
            ) {
                Icon(
                    imageVector = Icons.Default.TrendingUp,
                    contentDescription = null,
                    tint = Color(0xFF007AFF),
                    modifier = Modifier.size(24.dp)
                )

                Spacer(modifier = Modifier.width(12.dp))

                Text(
                    text = stringResource(R.string.search_trend),
                    fontSize = 18.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF1C1C1E)
                )

                Spacer(modifier = Modifier.weight(1f))

                // Time range badge
                Text(
                    text = when (timeRange) {
                        TimeRange.WEEK -> "7 ${stringResource(R.string.days)}"
                        TimeRange.MONTH -> "30 ${stringResource(R.string.days)}"
                    },
                    fontSize = 12.sp,
                    color = Color(0xFF8E8E93),
                    modifier = Modifier
                        .background(
                            Color(0xFFF2F2F7),
                            RoundedCornerShape(8.dp)
                        )
                        .padding(horizontal = 8.dp, vertical = 4.dp)
                )
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Line Chart with X and Y axes
            LineChartWithAxes(
                data = chartData,
                timeRange = timeRange,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(180.dp)
            )
        }
    }
}

// Helper function to generate chart data from analytics
private fun generateChartData(timeRange: TimeRange, usageAnalytics: UsageAnalytics): List<Pair<String, Int>> {
    val calendar = Calendar.getInstance()
    val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
    val days = when (timeRange) {
        TimeRange.WEEK -> 7
        TimeRange.MONTH -> 30
    }

    val data = mutableListOf<Pair<String, Int>>()

    for (i in (days - 1) downTo 0) {
        calendar.time = Date()
        calendar.add(Calendar.DAY_OF_YEAR, -i)
        val dateKey = dateFormat.format(calendar.time)
        val count = usageAnalytics.dailySearches[dateKey] ?: 0

        val label = when (timeRange) {
            TimeRange.WEEK -> {
                val dayFormat = SimpleDateFormat("EEE", Locale.getDefault())
                dayFormat.format(calendar.time)
            }
            TimeRange.MONTH -> {
                // For 30 days, show date format like "24 Jul", "29 Jul", etc.
                // But only show every 5th day to prevent overcrowding
                if (i % 5 == 0 || i == days - 1) {
                    val dayFormat = SimpleDateFormat("d MMM", Locale.getDefault())
                    dayFormat.format(calendar.time)
                } else {
                    "" // Empty label for intermediate days
                }
            }
        }

        data.add(label to count)
    }

    return data
}

@Composable
private fun LineChartWithAxes(
    data: List<Pair<String, Int>>,
    timeRange: TimeRange,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier) {
        // Chart area with proper axis alignment
        Row {
            // Chart area
            Box(
                modifier = Modifier
                    .weight(1f)
                    .height(140.dp)
            ) {
                Canvas(modifier = Modifier.fillMaxSize()) {
                    if (data.isEmpty()) return@Canvas

                    val actualMaxValue = data.maxOfOrNull { it.second } ?: 0
                    val maxValue = if (actualMaxValue == 0) 4 else actualMaxValue.coerceAtLeast(4)
                    val chartHeight = size.height - 20.dp.toPx() // Leave space at bottom
                    val chartWidth = size.width - 10.dp.toPx() // Leave small margin
                    val chartStartX = 5.dp.toPx()
                    val chartStartY = 10.dp.toPx()

                    // Draw horizontal grid lines
                    val ySteps = if (maxValue <= 4) 4 else maxValue.coerceAtMost(6)
                    for (i in 0..ySteps) {
                        val y = chartStartY + (chartHeight * i / ySteps)
                        drawLine(
                            color = Color(0xFFF2F2F7),
                            start = Offset(chartStartX, y),
                            end = Offset(chartStartX + chartWidth, y),
                            strokeWidth = 1.dp.toPx()
                        )
                    }

                    // Draw vertical grid lines aligned with data points
                    val stepX = if (data.size > 1) chartWidth / (data.size - 1) else 0f
                    data.forEachIndexed { index, _ ->
                        val x = chartStartX + (stepX * index)
                        drawLine(
                            color = Color(0xFFF2F2F7),
                            start = Offset(x, chartStartY),
                            end = Offset(x, chartStartY + chartHeight),
                            strokeWidth = 1.dp.toPx()
                        )
                    }

                    // Calculate points for the line
                    val points = data.mapIndexed { index, (_, value) ->
                        val x = chartStartX + (stepX * index)
                        val y = chartStartY + chartHeight - (chartHeight * value / maxValue.coerceAtLeast(1))
                        Offset(x, y)
                    }

                    // Draw area under the line
                    if (points.size > 1) {
                        val path = Path().apply {
                            moveTo(points.first().x, chartStartY + chartHeight)
                            lineTo(points.first().x, points.first().y)
                            points.drop(1).forEach { point ->
                                lineTo(point.x, point.y)
                            }
                            lineTo(points.last().x, chartStartY + chartHeight)
                            close()
                        }
                        drawPath(
                            path = path,
                            color = Color(0xFF007AFF).copy(alpha = 0.1f)
                        )
                    }

                    // Draw the line
                    for (i in 0 until points.size - 1) {
                        drawLine(
                            color = Color(0xFF007AFF),
                            start = points[i],
                            end = points[i + 1],
                            strokeWidth = 3.dp.toPx(),
                            cap = StrokeCap.Round
                        )
                    }

                    // Draw points
                    if (timeRange == TimeRange.WEEK) {
                        points.forEach { point ->
                            drawCircle(
                                color = Color(0xFF007AFF),
                                radius = 4.dp.toPx(),
                                center = point
                            )
                        }
                    } else {
                        points.filterIndexed { index, _ -> index % 5 == 0 || index == points.size - 1 }.forEach { point ->
                            drawCircle(
                                color = Color(0xFF007AFF),
                                radius = 4.dp.toPx(),
                                center = point
                            )
                        }
                    }
                }
            }

            // Y-axis labels column on the right
            Column(
                modifier = Modifier
                    .width(30.dp)
                    .height(140.dp),
                verticalArrangement = Arrangement.SpaceBetween
            ) {
                val actualMaxValue = data.maxOfOrNull { it.second } ?: 0
                val maxValue = if (actualMaxValue == 0) 4 else actualMaxValue.coerceAtLeast(4)
                val ySteps = if (maxValue <= 4) 4 else maxValue.coerceAtMost(6)

                for (i in 0..ySteps) {
                    val value = maxValue - (maxValue * i / ySteps)
                    Text(
                        text = value.toString(),
                        fontSize = 10.sp,
                        color = Color(0xFF8E8E93),
                        textAlign = TextAlign.Start,
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(start = 4.dp)
                    )
                }
            }
        }

        // X-axis labels properly aligned
        Row {
            Spacer(modifier = Modifier.width(0.dp)) // No spacer needed since Y-axis is on right

            Box(
                modifier = Modifier.weight(1f)
            ) {
                if (timeRange == TimeRange.WEEK) {
                    // For 7 days, show all labels
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        data.forEach { (label, _) ->
                            Text(
                                text = label,
                                fontSize = 10.sp,
                                color = Color(0xFF8E8E93),
                                textAlign = TextAlign.Center
                            )
                        }
                    }
                } else {
                    // For 30 days, show filtered labels
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        data.filter { it.first.isNotEmpty() }.forEach { (label, _) ->
                            Text(
                                text = label,
                                fontSize = 10.sp,
                                color = Color(0xFF8E8E93),
                                textAlign = TextAlign.Center
                            )
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.width(30.dp)) // Match Y-axis width on right
        }
    }
}

@Composable
private fun TimeOfDayAnalysisCard(searchHistory: List<SearchHistoryItem>) {
    // Calculate time of day data from real search history
    val timeOfDayData = calculateTimeOfDayDataComposable(searchHistory)
    val mostActiveTime = if (searchHistory.isEmpty()) {
        "evening" // Default when no data
    } else {
        timeOfDayData.maxByOrNull { it.second }?.first ?: "evening"
    }

    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier.padding(20.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Schedule,
                    contentDescription = null,
                    tint = Color(0xFFAF52DE),
                    modifier = Modifier.size(24.dp)
                )

                Spacer(modifier = Modifier.width(12.dp))

                Text(
                    text = stringResource(R.string.time_of_day_analysis),
                    fontSize = 18.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF1C1C1E)
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Insight
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(
                        Color(0xFFFFF3CD),
                        RoundedCornerShape(12.dp)
                    )
                    .padding(12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Lightbulb,
                    contentDescription = null,
                    tint = Color(0xFFFF9500),
                    modifier = Modifier.size(20.dp)
                )

                Spacer(modifier = Modifier.width(8.dp))

                Text(
                    text = stringResource(R.string.you_search_most_often_in_the_evening),
                    fontSize = 14.sp,
                    color = Color(0xFF8E8E93)
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Time periods with real data - iOS style layout
            Column(
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                timeOfDayData.forEach { (period, count) ->
                    TimeOfDayRowIOS(period, count, searchHistory.size)
                }
            }
        }
    }
}

// Helper function to calculate time of day data with localization
@Composable
private fun calculateTimeOfDayDataComposable(searchHistory: List<SearchHistoryItem>): List<Pair<String, Int>> {
    val morningText = stringResource(R.string.morning)
    val afternoonText = stringResource(R.string.afternoon)
    val eveningText = stringResource(R.string.evening)

    // If no search history, return all zeros
    if (searchHistory.isEmpty()) {
        return listOf(
            morningText to 0,
            afternoonText to 0,
            eveningText to 0
        )
    }

    var morningCount = 0
    var afternoonCount = 0
    var eveningCount = 0

    val calendar = Calendar.getInstance()

    searchHistory.forEach { item ->
        calendar.timeInMillis = item.timestamp
        val hour = calendar.get(Calendar.HOUR_OF_DAY)
        val minute = calendar.get(Calendar.MINUTE)
        val totalMinutes = hour * 60 + minute

        // Morning: 3:00 (180) to 11:30 (690)
        // Afternoon: 11:30 (690) to 18:00 (1080)
        // Evening: 18:00 (1080) to 3:00 (180 next day)
        when {
            totalMinutes >= 180 && totalMinutes < 690 -> morningCount++
            totalMinutes >= 690 && totalMinutes < 1080 -> afternoonCount++
            else -> eveningCount++
        }
    }

    return listOf(
        morningText to morningCount,
        afternoonText to afternoonCount,
        eveningText to eveningCount
    )
}

@Composable
private fun TimeOfDayRow(
    period: String,
    searches: Int,
    totalSearches: Int
) {
    val progress = searches.toFloat() / totalSearches.toFloat()

    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = period,
            fontSize = 14.sp,
            fontWeight = FontWeight.Medium,
            color = Color(0xFF1C1C1E),
            modifier = Modifier.width(80.dp)
        )

        LinearProgressIndicator(
            progress = progress,
            modifier = Modifier
                .weight(1f)
                .height(8.dp)
                .clip(RoundedCornerShape(4.dp)),
            color = Color(0xFFAF52DE),
            trackColor = Color(0xFFF2F2F7)
        )

        Spacer(modifier = Modifier.width(12.dp))

        Text(
            text = "$searches",
            fontSize = 14.sp,
            fontWeight = FontWeight.SemiBold,
            color = Color(0xFF8E8E93),
            modifier = Modifier.width(30.dp)
        )
    }
}

@Composable
private fun TimeOfDayRowIOS(
    period: String,
    searches: Int,
    totalSearches: Int
) {
    val progress = if (totalSearches > 0) searches.toFloat() / totalSearches.toFloat() else 0f

    // Get appropriate icon for time period
    val icon = when (period.lowercase()) {
        "morning" -> Icons.Default.WbSunny
        "afternoon" -> Icons.Default.LightMode
        "evening" -> Icons.Default.NightsStay
        else -> Icons.Default.Schedule
    }

    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Icon
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = Color(0xFFAF52DE),
            modifier = Modifier.size(20.dp)
        )

        Spacer(modifier = Modifier.width(12.dp))

        // Period name and progress bar
        Column(
            modifier = Modifier.weight(1f)
        ) {
            // Period name and search count on same line like iOS
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = period,
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color(0xFF1C1C1E)
                )

                // Search count with "searches" text like iOS
                Text(
                    text = "$searches ${stringResource(R.string.searches)}",
                    fontSize = 12.sp,
                    color = Color(0xFF8E8E93)
                )
            }

            Spacer(modifier = Modifier.height(4.dp))

            // Progress bar
            LinearProgressIndicator(
                progress = { progress },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(6.dp)
                    .clip(RoundedCornerShape(3.dp)),
                color = Color(0xFFAF52DE),
                trackColor = Color(0xFFF2F2F7)
            )
        }
    }
}

@Composable
private fun ModernInsightsCard(
    usageAnalytics: UsageAnalytics,
    searchHistory: List<SearchHistoryItem>
) {
    // Calculate real insights
    val focusScore = min(100, usageAnalytics.totalSearches * 2)
    val todayTimeSaved = calculateTodayTimeSaved(usageAnalytics)
    val efficiencyLevel = when {
        usageAnalytics.totalSearches > 50 -> 2 // High
        usageAnalytics.totalSearches > 20 -> 1 // Medium
        else -> 0 // Low
    }
    val efficiency = when (efficiencyLevel) {
        2 -> stringResource(R.string.high)
        1 -> stringResource(R.string.medium)
        else -> stringResource(R.string.low)
    }

    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier.padding(20.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Lightbulb,
                    contentDescription = null,
                    tint = Color(0xFFFF9500),
                    modifier = Modifier.size(24.dp)
                )

                Spacer(modifier = Modifier.width(12.dp))

                Text(
                    text = stringResource(R.string.insights),
                    fontSize = 18.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF1C1C1E)
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            Column(
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                // Focus Score
                InsightRowWithValue(
                    icon = Icons.Default.GpsFixed,
                    title = stringResource(R.string.focus_score),
                    value = "$focusScore%",
                    description = stringResource(R.string.staying_focused),
                    valueColor = Color(0xFF007AFF)
                )

                // Today's Impact
                InsightRowWithValue(
                    icon = Icons.Default.Schedule,
                    title = stringResource(R.string.todays_impact),
                    value = "${todayTimeSaved}m",
                    description = stringResource(R.string.time_saved_from_distractions),
                    valueColor = Color(0xFF007AFF)
                )

                // Efficiency
                InsightRowWithValue(
                    icon = Icons.Default.TrendingUp,
                    title = stringResource(R.string.efficiency),
                    value = efficiency,
                    description = stringResource(R.string.direct_searches_save_time),
                    valueColor = when (efficiencyLevel) {
                        2 -> Color(0xFF34C759) // High
                        1 -> Color(0xFFFF9500) // Medium
                        else -> Color(0xFF8E8E93) // Low
                    }
                )
            }
        }
    }
}

// Helper function to calculate today's time saved
private fun calculateTodayTimeSaved(usageAnalytics: UsageAnalytics): Int {
    val today = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
    val todaysSearches = usageAnalytics.dailySearches[today] ?: 0
    return todaysSearches * 2 // 2 minutes saved per search
}

@Composable
private fun InsightRowWithValue(
    icon: ImageVector,
    title: String,
    value: String,
    description: String,
    valueColor: Color
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = Color(0xFF007AFF),
            modifier = Modifier.size(20.dp)
        )

        Spacer(modifier = Modifier.width(12.dp))

        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = title,
                fontSize = 14.sp,
                fontWeight = FontWeight.Medium,
                color = Color(0xFF1C1C1E)
            )
            Text(
                text = description,
                fontSize = 12.sp,
                color = Color(0xFF8E8E93)
            )
        }

        Text(
            text = value,
            fontSize = 16.sp,
            fontWeight = FontWeight.SemiBold,
            color = valueColor
        )
    }
}

// Data classes for charts - removed duplicate

enum class TimeRange {
    WEEK, MONTH
}
