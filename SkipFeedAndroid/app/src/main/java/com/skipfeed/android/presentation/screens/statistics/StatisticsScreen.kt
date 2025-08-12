package com.skipfeed.android.presentation.screens.statistics

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.skipfeed.android.R
import com.skipfeed.android.data.model.Platform
import com.skipfeed.android.presentation.theme.*

// Time Range enum for statistics filtering
enum class TimeRange(val displayName: String, val days: Int) {
    WEEK("7 Days", 7),
    MONTH("30 Days", 30)
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun StatisticsScreen(
    viewModel: StatisticsViewModel = hiltViewModel()
) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
    var selectedTimeRange by remember { mutableStateOf(TimeRange.WEEK) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(getSurfaceColor())
    ) {
        // Navigation header - exact iOS match
        TopAppBar(
            title = {
                Text(
                    text = "Statistics",
                    style = MaterialTheme.typography.headlineMedium.copy(
                        fontWeight = FontWeight.Bold
                    ),
                    color = MaterialTheme.colorScheme.onSurface
                )
            },
            colors = TopAppBarDefaults.topAppBarColors(
                containerColor = Color.Transparent
            )
        )

        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(vertical = 20.dp),
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            // Time Range Picker - exact iOS match
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp),
                horizontalArrangement = Arrangement.Center
            ) {
                SegmentedControl(
                    selectedTimeRange = selectedTimeRange,
                    onTimeRangeSelected = { selectedTimeRange = it }
                )
            }

            // Hero Stats Section - exact iOS match
            Column(
                modifier = Modifier.padding(horizontal = 20.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                HeroStatCard(
                    title = "Time Saved",
                    value = formatTimeSaved(uiState.analytics.getTimeSaved()),
                    subtitle = "vs endless scrolling",
                    icon = Icons.Outlined.Schedule,
                    gradient = listOf(SkipFeedColors.Success, Color(0xFF4CAF50))
                )

                Row(
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    CompactStatCard(
                        title = "Total",
                        value = uiState.analytics.totalSearches.toString(),
                        icon = Icons.Outlined.Search,
                        color = SkipFeedColors.Info,
                        modifier = Modifier.weight(1f)
                    )

                    CompactStatCard(
                        title = "Today",
                        value = uiState.analytics.getTodaysSearchCount().toString(),
                        icon = Icons.Outlined.CalendarToday,
                        color = SkipFeedColors.Warning,
                        modifier = Modifier.weight(1f)
                    )
                }
            }
            // Platform Usage Section - exact iOS match
            if (uiState.analytics.searchesByPlatform.isNotEmpty()) {
                PlatformUsageCard(
                    platforms = uiState.analytics.getMostUsedPlatforms(),
                    timeRange = selectedTimeRange,
                    modifier = Modifier.padding(horizontal = 20.dp)
                )
            }

            // Search Trend Section - exact iOS match
            SearchTrendCard(
                timeRange = selectedTimeRange,
                modifier = Modifier.padding(horizontal = 20.dp)
            )

            // Time of Day Analysis - exact iOS match
            TimeOfDayAnalysisCard(
                modifier = Modifier.padding(horizontal = 20.dp)
            )

            // Insights Section - exact iOS match
            InsightsCard(
                todayTimeSaved = uiState.analytics.getTimeSavedToday(),
                totalSearches = uiState.analytics.totalSearches,
                modifier = Modifier.padding(horizontal = 20.dp)
            )
        }
    }
}

// Segmented Control for time range selection - exact iOS match
@Composable
private fun SegmentedControl(
    selectedTimeRange: TimeRange,
    onTimeRangeSelected: (TimeRange) -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .background(
                color = getSurfaceVariantColor(),
                shape = RoundedCornerShape(8.dp)
            )
            .padding(4.dp),
        horizontalArrangement = Arrangement.spacedBy(0.dp)
    ) {
        TimeRange.entries.forEach { timeRange ->
            Button(
                onClick = { onTimeRangeSelected(timeRange) },
                colors = ButtonDefaults.buttonColors(
                    containerColor = if (selectedTimeRange == timeRange)
                        Color.White else Color.Transparent,
                    contentColor = if (selectedTimeRange == timeRange)
                        MaterialTheme.colorScheme.onSurface else getSecondaryTextColor()
                ),
                shape = RoundedCornerShape(6.dp),
                contentPadding = PaddingValues(horizontal = 24.dp, vertical = 8.dp),
                modifier = Modifier.height(32.dp)
            ) {
                Text(
                    text = timeRange.displayName,
                    style = MaterialTheme.typography.labelMedium.copy(
                        fontWeight = FontWeight.Medium
                    )
                )
            }
        }
    }
}

// Hero Stat Card - exact iOS match
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
        modifier = modifier
            .fillMaxWidth()
            .shadow(
                elevation = 8.dp,
                shape = RoundedCornerShape(20.dp),
                ambientColor = getShadowColor(),
                spotColor = getShadowColor()
            ),
        colors = CardDefaults.cardColors(
            containerColor = Color.Transparent
        ),
        shape = RoundedCornerShape(20.dp)
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(
                    brush = Brush.horizontalGradient(gradient),
                    shape = RoundedCornerShape(20.dp)
                )
                .padding(20.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = Color.White,
                    modifier = Modifier.size(32.dp)
                )

                Column(
                    modifier = Modifier.weight(1f)
                ) {
                    Text(
                        text = title,
                        style = MaterialTheme.typography.titleMedium.copy(
                            fontWeight = FontWeight.SemiBold
                        ),
                        color = Color.White
                    )
                    Text(
                        text = value,
                        style = MaterialTheme.typography.displaySmall.copy(
                            fontWeight = FontWeight.Bold
                        ),
                        color = Color.White
                    )
                    Text(
                        text = subtitle,
                        style = MaterialTheme.typography.bodySmall,
                        color = Color.White.copy(alpha = 0.9f)
                    )
                }
            }
        }
    }
}

// Compact Stat Card - exact iOS match
@Composable
private fun CompactStatCard(
    title: String,
    value: String,
    icon: ImageVector,
    color: Color,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .shadow(
                elevation = 8.dp,
                shape = RoundedCornerShape(20.dp),
                ambientColor = getShadowColor(),
                spotColor = getShadowColor()
            ),
        colors = CardDefaults.cardColors(
            containerColor = getSurfaceColor()
        ),
        shape = RoundedCornerShape(20.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = color,
                modifier = Modifier.size(32.dp)
            )

            Text(
                text = value,
                style = MaterialTheme.typography.displaySmall.copy(
                    fontWeight = FontWeight.Bold
                ),
                color = MaterialTheme.colorScheme.onSurface,
                textAlign = TextAlign.Center
            )

            Text(
                text = title,
                style = MaterialTheme.typography.bodySmall.copy(
                    fontWeight = FontWeight.Medium
                ),
                color = getSecondaryTextColor(),
                textAlign = TextAlign.Center
            )
        }
    }
}

// Platform Usage Card - exact iOS match
@Composable
private fun PlatformUsageCard(
    platforms: List<Pair<Platform, Int>>,
    timeRange: TimeRange,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .shadow(
                elevation = 8.dp,
                shape = RoundedCornerShape(20.dp),
                ambientColor = getShadowColor(),
                spotColor = getShadowColor()
            ),
        colors = CardDefaults.cardColors(
            containerColor = getSurfaceColor()
        ),
        shape = RoundedCornerShape(20.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Header
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Icon(
                        Icons.Outlined.PieChart,
                        contentDescription = null,
                        tint = SkipFeedColors.Info,
                        modifier = Modifier.size(20.dp)
                    )
                    Text(
                        text = "Platform Usage",
                        style = MaterialTheme.typography.headlineSmall.copy(
                            fontWeight = FontWeight.SemiBold
                        ),
                        color = MaterialTheme.colorScheme.onSurface
                    )
                }

                Text(
                    text = timeRange.displayName,
                    style = MaterialTheme.typography.labelMedium,
                    color = getSecondaryTextColor(),
                    modifier = Modifier
                        .background(
                            color = getSurfaceVariantColor(),
                            shape = RoundedCornerShape(8.dp)
                        )
                        .padding(horizontal = 8.dp, vertical = 4.dp)
                )
            }

            // Platform list
            Column(
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                platforms.take(4).forEach { (platform, count) ->
                    val total = platforms.sumOf { it.second }
                    val percentage = if (total > 0) (count.toFloat() / total * 100).toInt() else 0

                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(8.dp),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Circle(
                            color = platform.color,
                            size = 12.dp
                        )

                        Column(
                            modifier = Modifier.weight(1f)
                        ) {
                            Text(
                                text = platform.displayName,
                                style = MaterialTheme.typography.labelMedium.copy(
                                    fontWeight = FontWeight.Medium
                                ),
                                color = MaterialTheme.colorScheme.onSurface
                            )
                            Text(
                                text = "$percentage% • $count searches",
                                style = MaterialTheme.typography.labelSmall,
                                color = getSecondaryTextColor()
                            )
                        }
                    }
                }
            }
        }
    }
}

// Search Trend Card - exact iOS match
@Composable
private fun SearchTrendCard(
    timeRange: TimeRange,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .shadow(
                elevation = 8.dp,
                shape = RoundedCornerShape(20.dp),
                ambientColor = getShadowColor(),
                spotColor = getShadowColor()
            ),
        colors = CardDefaults.cardColors(
            containerColor = getSurfaceColor()
        ),
        shape = RoundedCornerShape(20.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Header
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Icon(
                        Icons.Outlined.TrendingUp,
                        contentDescription = null,
                        tint = SkipFeedColors.Info,
                        modifier = Modifier.size(20.dp)
                    )
                    Text(
                        text = "Search Trend",
                        style = MaterialTheme.typography.headlineSmall.copy(
                            fontWeight = FontWeight.SemiBold
                        ),
                        color = MaterialTheme.colorScheme.onSurface
                    )
                }

                Text(
                    text = timeRange.displayName,
                    style = MaterialTheme.typography.labelMedium,
                    color = getSecondaryTextColor(),
                    modifier = Modifier
                        .background(
                            color = getSurfaceVariantColor(),
                            shape = RoundedCornerShape(8.dp)
                        )
                        .padding(horizontal = 8.dp, vertical = 4.dp)
                )
            }

            // Placeholder for chart - would need chart library for full implementation
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(120.dp)
                    .background(
                        color = getSurfaceVariantColor(),
                        shape = RoundedCornerShape(12.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "Chart visualization would go here",
                    style = MaterialTheme.typography.bodySmall,
                    color = getSecondaryTextColor()
                )
            }
        }
    }
}

// Time of Day Analysis Card - exact iOS match
@Composable
private fun TimeOfDayAnalysisCard(
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .shadow(
                elevation = 8.dp,
                shape = RoundedCornerShape(20.dp),
                ambientColor = getShadowColor(),
                spotColor = getShadowColor()
            ),
        colors = CardDefaults.cardColors(
            containerColor = getSurfaceColor()
        ),
        shape = RoundedCornerShape(20.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Header
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Icon(
                    Icons.Outlined.Schedule,
                    contentDescription = null,
                    tint = Color(0xFF9C27B0),
                    modifier = Modifier.size(20.dp)
                )
                Text(
                    text = "Time of Day Analysis",
                    style = MaterialTheme.typography.headlineSmall.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    color = MaterialTheme.colorScheme.onSurface
                )
            }

            // Insight message
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier
                    .fillMaxWidth()
                    .background(
                        color = Color(0xFFFFF3E0),
                        shape = RoundedCornerShape(12.dp)
                    )
                    .padding(12.dp)
            ) {
                Text(
                    text = "💡",
                    style = MaterialTheme.typography.bodyMedium
                )
                Text(
                    text = "You search most often in the evening",
                    style = MaterialTheme.typography.bodyMedium.copy(
                        fontWeight = FontWeight.Medium
                    ),
                    color = Color(0xFFE65100)
                )
            }

            // Time periods
            Column(
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                TimeOfDayRow(
                    icon = "🌅",
                    period = "Morning",
                    searches = 0
                )
                TimeOfDayRow(
                    icon = "☀️",
                    period = "Afternoon",
                    searches = 0
                )
                TimeOfDayRow(
                    icon = "🌙",
                    period = "Evening",
                    searches = 3
                )
            }
        }
    }
}

// Insights Card - exact iOS match
@Composable
private fun InsightsCard(
    todayTimeSaved: Long,
    totalSearches: Int,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .shadow(
                elevation = 8.dp,
                shape = RoundedCornerShape(20.dp),
                ambientColor = getShadowColor(),
                spotColor = getShadowColor()
            ),
        colors = CardDefaults.cardColors(
            containerColor = getSurfaceColor()
        ),
        shape = RoundedCornerShape(20.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Header
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Text(
                    text = "💡",
                    style = MaterialTheme.typography.headlineMedium
                )
                Text(
                    text = "Insights",
                    style = MaterialTheme.typography.headlineSmall.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    color = MaterialTheme.colorScheme.onSurface
                )
            }

            // Insights
            Column(
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                InsightRow(
                    icon = Icons.Outlined.TrackChanges,
                    title = "Focus Score",
                    value = "52%",
                    subtitle = "You're staying focused!",
                    color = SkipFeedColors.Info
                )

                InsightRow(
                    icon = Icons.Outlined.Schedule,
                    title = "Today's Impact",
                    value = formatTimeSaved(todayTimeSaved),
                    subtitle = "Time saved from distractions",
                    color = SkipFeedColors.Success
                )

                InsightRow(
                    icon = Icons.Outlined.TrendingUp,
                    title = "Efficiency",
                    value = "High",
                    subtitle = "Direct searches save time",
                    color = SkipFeedColors.Info
                )
            }
        }
    }
}

// Time of Day Row component
@Composable
private fun TimeOfDayRow(
    icon: String,
    period: String,
    searches: Int,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                text = icon,
                style = MaterialTheme.typography.bodyMedium
            )
            Text(
                text = period,
                style = MaterialTheme.typography.bodyMedium.copy(
                    fontWeight = FontWeight.Medium
                ),
                color = MaterialTheme.colorScheme.onSurface
            )
        }

        Text(
            text = "$searches searches",
            style = MaterialTheme.typography.bodySmall,
            color = getSecondaryTextColor()
        )
    }
}

// Insight Row component
@Composable
private fun InsightRow(
    icon: ImageVector,
    title: String,
    value: String,
    subtitle: String,
    color: Color,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = color,
            modifier = Modifier.size(24.dp)
        )

        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = title,
                style = MaterialTheme.typography.bodyMedium.copy(
                    fontWeight = FontWeight.Medium
                ),
                color = MaterialTheme.colorScheme.onSurface
            )
            Text(
                text = subtitle,
                style = MaterialTheme.typography.bodySmall,
                color = getSecondaryTextColor()
            )
        }

        Text(
            text = value,
            style = MaterialTheme.typography.headlineSmall.copy(
                fontWeight = FontWeight.Bold
            ),
            color = color
        )
    }
}

// Circle helper component
@Composable
private fun Circle(
    color: Color,
    size: Dp,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .size(size)
            .background(
                color = color,
                shape = CircleShape
            )
    )
}

// Helper function for time formatting
private fun formatTimeSaved(timeInterval: Long): String {
    val hours = (timeInterval / 3600000).toInt()
    val minutes = ((timeInterval % 3600000) / 60000).toInt()

    return when {
        hours > 0 -> "${hours}h ${minutes}m"
        minutes > 0 -> "${minutes}m"
        else -> "0m"
    }
}
