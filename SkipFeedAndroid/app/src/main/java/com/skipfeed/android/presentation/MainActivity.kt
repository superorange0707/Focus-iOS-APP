package com.skipfeed.android.presentation

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.skipfeed.android.R
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            SkipFeedApp()
        }
    }
}

@Composable
fun SkipFeedApp() {
    val navController = rememberNavController()
    
    // iOS-style background
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFF2F2F7)) // iOS system background
    ) {
        NavHost(
            navController = navController,
            startDestination = "search",
            modifier = Modifier.fillMaxSize()
        ) {
            composable("search") { SearchScreen() }
            composable("history") { HistoryScreen() }
            composable("stats") { StatsScreen() }
            composable("settings") { SettingsScreen() }
        }
        
        // iOS-style tab bar
        IOSTabBar(
            navController = navController,
            modifier = Modifier.align(Alignment.BottomCenter)
        )
    }
}

@Composable
fun IOSTabBar(
    navController: NavHostController,
    modifier: Modifier = Modifier
) {
    val navBackStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = navBackStackEntry?.destination?.route
    
    val tabs = listOf(
        TabItem("search", "Search", Icons.Default.Search),
        TabItem("history", "History", Icons.Default.History),
        TabItem("stats", "Stats", Icons.Default.BarChart),
        TabItem("settings", "Settings", Icons.Default.Settings)
    )
    
    // iOS-style tab bar with home indicator
    Column(
        modifier = modifier.fillMaxWidth()
    ) {
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(topStart = 0.dp, topEnd = 0.dp),
            colors = CardDefaults.cardColors(
                containerColor = Color.White.copy(alpha = 0.95f)
            ),
            elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                tabs.forEach { tab ->
                    IOSTabItem(
                        tab = tab,
                        isSelected = currentRoute == tab.route,
                        onClick = {
                            navController.navigate(tab.route) {
                                popUpTo(navController.graph.startDestinationId)
                                launchSingleTop = true
                            }
                        }
                    )
                }
            }
        }
        
        // iOS home indicator
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(34.dp)
                .background(Color.White.copy(alpha = 0.95f)),
            contentAlignment = Alignment.Center
        ) {
            Box(
                modifier = Modifier
                    .width(134.dp)
                    .height(5.dp)
                    .background(Color.Black.copy(alpha = 0.3f), RoundedCornerShape(2.5.dp))
            )
        }
    }
}

@Composable
fun IOSTabItem(
    tab: TabItem,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier
            .clickable { onClick() }
            .padding(horizontal = 16.dp, vertical = 8.dp)
    ) {
        Icon(
            imageVector = tab.icon,
            contentDescription = tab.title,
            tint = if (isSelected) Color(0xFF007AFF) else Color(0xFF8E8E93),
            modifier = Modifier.size(24.dp)
        )
        
        Spacer(modifier = Modifier.height(4.dp))
        
        Text(
            text = tab.title,
            fontSize = 10.sp,
            fontWeight = if (isSelected) FontWeight.SemiBold else FontWeight.Medium,
            color = if (isSelected) Color(0xFF007AFF) else Color(0xFF8E8E93)
        )
    }
}

data class TabItem(
    val route: String,
    val title: String,
    val icon: ImageVector
)

// Platform data
data class Platform(
    val name: String,
    val iconRes: Int
)

val platforms = listOf(
    Platform("Reddit", R.drawable.icon_reddit),
    Platform("YouTube", R.drawable.icon_youtube),
    Platform("X", R.drawable.icon_x),
    Platform("TikTok", R.drawable.icon_tiktok),
    Platform("Instagram", R.drawable.icon_instagram),
    Platform("Facebook", R.drawable.icon_facebook)
)

@Composable
fun SearchScreen() {
    var searchQuery by remember { mutableStateOf("") }
    var selectedPlatform by remember { mutableStateOf("Reddit") }
    var searchMode by remember { mutableStateOf("Direct") } // Direct or In-App

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp)
            .padding(bottom = 120.dp) // Space for tab bar
    ) {
        Spacer(modifier = Modifier.height(60.dp))

        // App Title - exactly like iOS
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(
                text = "SkipFeed",
                fontSize = 34.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFF007AFF)
            )

            Spacer(modifier = Modifier.height(4.dp))

            Text(
                text = "Skip the feed, find what matters",
                fontSize = 17.sp,
                color = Color(0xFF8E8E93)
            )
        }

        Spacer(modifier = Modifier.height(40.dp))

        // Choose Platform header - exactly like iOS
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.padding(horizontal = 4.dp)
        ) {
            Icon(
                imageVector = Icons.Default.Language,
                contentDescription = null,
                tint = Color(0xFF1C1C1E),
                modifier = Modifier.size(20.dp)
            )

            Spacer(modifier = Modifier.width(8.dp))

            Text(
                text = "Choose Platform",
                fontSize = 17.sp,
                fontWeight = FontWeight.SemiBold,
                color = Color(0xFF1C1C1E)
            )
        }

        Spacer(modifier = Modifier.height(20.dp))

        // Platform selector - exactly like iOS with real icons
        LazyRow(
            horizontalArrangement = Arrangement.spacedBy(16.dp),
            contentPadding = PaddingValues(horizontal = 4.dp)
        ) {
            items(platforms) { platform ->
                IOSPlatformCard(
                    platform = platform,
                    isSelected = platform.name == selectedPlatform,
                    onClick = { selectedPlatform = platform.name }
                )
            }
        }

        Spacer(modifier = Modifier.height(32.dp))

        // Search card - exactly like iOS
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(20.dp),
            colors = CardDefaults.cardColors(
                containerColor = Color.White
            ),
            elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
        ) {
            Column(
                modifier = Modifier.padding(20.dp)
            ) {
                // Search input
                OutlinedTextField(
                    value = searchQuery,
                    onValueChange = { searchQuery = it },
                    placeholder = {
                        Text(
                            "Search $selectedPlatform...",
                            color = Color(0xFF8E8E93)
                        )
                    },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = Color(0xFF007AFF),
                        unfocusedBorderColor = Color(0xFFE5E5EA)
                    ),
                    singleLine = true,
                    leadingIcon = {
                        Icon(
                            imageVector = Icons.Default.Search,
                            contentDescription = null,
                            tint = Color(0xFF8E8E93)
                        )
                    }
                )

                Spacer(modifier = Modifier.height(16.dp))

                // Search mode toggle - exactly like iOS
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    SearchModeButton(
                        text = "Direct",
                        isSelected = searchMode == "Direct",
                        onClick = { searchMode = "Direct" },
                        modifier = Modifier.weight(1f)
                    )

                    SearchModeButton(
                        text = "In-App",
                        isSelected = searchMode == "In-App",
                        onClick = { searchMode = "In-App" },
                        modifier = Modifier.weight(1f)
                    )
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Search button - exactly like iOS
                Button(
                    onClick = {
                        // TODO: Implement search functionality
                    },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF007AFF)
                    ),
                    contentPadding = PaddingValues(vertical = 16.dp)
                ) {
                    Icon(
                        imageVector = Icons.Default.Search,
                        contentDescription = null,
                        tint = Color.White,
                        modifier = Modifier.size(20.dp)
                    )

                    Spacer(modifier = Modifier.width(8.dp))

                    Text(
                        text = "Search on $selectedPlatform",
                        fontSize = 17.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = Color.White
                    )
                }
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        // Bottom tagline - exactly like iOS
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(
                text = "Skip the feed, find what matters",
                fontSize = 17.sp,
                color = Color(0xFF007AFF),
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(4.dp))

            Text(
                text = "Direct search, zero distractions",
                fontSize = 15.sp,
                color = Color(0xFF8E8E93),
                textAlign = TextAlign.Center
            )
        }
    }
}

@Composable
fun IOSPlatformCard(
    platform: Platform,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .size(width = 88.dp, height = 110.dp)
            .clickable { onClick() },
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color.White
        ),
        elevation = CardDefaults.cardElevation(
            defaultElevation = if (isSelected) 4.dp else 1.dp
        ),
        border = if (isSelected) {
            androidx.compose.foundation.BorderStroke(2.dp, Color(0xFFFF9500))
        } else null
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(12.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // Real platform icon
            Image(
                painter = painterResource(id = platform.iconRes),
                contentDescription = platform.name,
                modifier = Modifier.size(40.dp),
                contentScale = ContentScale.Fit
            )

            Spacer(modifier = Modifier.height(12.dp))

            Text(
                text = platform.name,
                fontSize = 13.sp,
                fontWeight = if (isSelected) FontWeight.SemiBold else FontWeight.Medium,
                color = if (isSelected) Color(0xFF1C1C1E) else Color(0xFF8E8E93),
                maxLines = 1,
                textAlign = TextAlign.Center
            )
        }
    }
}

@Composable
fun SearchModeButton(
    text: String,
    isSelected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Button(
        onClick = onClick,
        modifier = modifier,
        shape = RoundedCornerShape(8.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = if (isSelected) Color(0xFF007AFF) else Color(0xFFF2F2F7),
            contentColor = if (isSelected) Color.White else Color(0xFF1C1C1E)
        ),
        elevation = ButtonDefaults.buttonElevation(
            defaultElevation = 0.dp
        ),
        contentPadding = PaddingValues(vertical = 12.dp)
    ) {
        Text(
            text = text,
            fontSize = 15.sp,
            fontWeight = FontWeight.Medium
        )
    }
}

@Composable
fun HistoryScreen() {
    var searchQuery by remember { mutableStateOf("") }
    var selectedFilter by remember { mutableStateOf("All") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp)
            .padding(bottom = 120.dp)
    ) {
        Spacer(modifier = Modifier.height(60.dp))

        // Header
        Text(
            text = "Search History",
            fontSize = 34.sp,
            fontWeight = FontWeight.Bold,
            color = Color(0xFF1C1C1E)
        )

        Spacer(modifier = Modifier.height(16.dp))

        // Search bar - exactly like iOS
        OutlinedTextField(
            value = searchQuery,
            onValueChange = { searchQuery = it },
            placeholder = {
                Text(
                    "Search history...",
                    color = Color(0xFF8E8E93)
                )
            },
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(12.dp),
            colors = OutlinedTextFieldDefaults.colors(
                focusedBorderColor = Color(0xFF007AFF),
                unfocusedBorderColor = Color(0xFFE5E5EA)
            ),
            singleLine = true,
            leadingIcon = {
                Icon(
                    imageVector = Icons.Default.Search,
                    contentDescription = null,
                    tint = Color(0xFF8E8E93)
                )
            }
        )

        Spacer(modifier = Modifier.height(16.dp))

        // Filter chips - exactly like iOS
        LazyRow(
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            val filters = listOf("All", "Reddit", "YouTube", "X", "TikTok", "Instagram")

            items(filters) { filter ->
                FilterChip(
                    text = filter,
                    isSelected = filter == selectedFilter,
                    onClick = { selectedFilter = filter }
                )
            }
        }

        Spacer(modifier = Modifier.height(8.dp))

        // Select and Clear All buttons - exactly like iOS
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            TextButton(
                onClick = { /* Select all */ }
            ) {
                Text(
                    text = "Select",
                    color = Color(0xFF007AFF),
                    fontSize = 17.sp
                )
            }

            TextButton(
                onClick = { /* Clear all */ }
            ) {
                Text(
                    text = "Clear All",
                    color = Color(0xFFFF3B30),
                    fontSize = 17.sp
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Today section
        Text(
            text = "Today",
            fontSize = 20.sp,
            fontWeight = FontWeight.SemiBold,
            color = Color(0xFF8E8E93),
            modifier = Modifier.padding(horizontal = 4.dp)
        )

        Spacer(modifier = Modifier.height(12.dp))

        // History items - exactly like iOS
        val historyItems = listOf(
            HistoryItem("Skip", "YouTube", "2:40:55 am", R.drawable.icon_youtube),
            HistoryItem("Skip", "Reddit", "1:42:46 am", R.drawable.icon_reddit),
            HistoryItem("Skipfeed", "Reddit", "12:35:47 am", R.drawable.icon_reddit)
        )

        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(1.dp)
        ) {
            items(historyItems) { item ->
                IOSHistoryItem(item)
            }
        }
    }
}

data class HistoryItem(
    val query: String,
    val platform: String,
    val timestamp: String,
    val iconRes: Int
)

@Composable
fun FilterChip(
    text: String,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Button(
        onClick = onClick,
        shape = RoundedCornerShape(20.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = if (isSelected) Color(0xFF007AFF) else Color(0xFFF2F2F7),
            contentColor = if (isSelected) Color.White else Color(0xFF1C1C1E)
        ),
        elevation = ButtonDefaults.buttonElevation(
            defaultElevation = 0.dp
        ),
        contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp)
    ) {
        Text(
            text = text,
            fontSize = 15.sp,
            fontWeight = FontWeight.Medium
        )
    }
}

@Composable
fun IOSHistoryItem(item: HistoryItem) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color.White
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Platform icon
            Image(
                painter = painterResource(id = item.iconRes),
                contentDescription = item.platform,
                modifier = Modifier.size(32.dp),
                contentScale = ContentScale.Fit
            )

            Spacer(modifier = Modifier.width(16.dp))

            Column(
                modifier = Modifier.weight(1f)
            ) {
                Text(
                    text = item.query,
                    fontSize = 17.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color(0xFF1C1C1E),
                    maxLines = 1
                )

                Spacer(modifier = Modifier.height(4.dp))

                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = item.platform,
                        fontSize = 15.sp,
                        color = Color(0xFF007AFF)
                    )

                    Text(
                        text = " • ",
                        fontSize = 15.sp,
                        color = Color(0xFF8E8E93)
                    )

                    Text(
                        text = item.timestamp,
                        fontSize = 15.sp,
                        color = Color(0xFF8E8E93)
                    )
                }
            }

            // Action buttons - exactly like iOS
            Row(
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                IconButton(
                    onClick = { /* Delete */ }
                ) {
                    Icon(
                        imageVector = Icons.Default.Delete,
                        contentDescription = "Delete",
                        tint = Color(0xFFFF3B30),
                        modifier = Modifier.size(20.dp)
                    )
                }

                IconButton(
                    onClick = { /* Restore/Repeat */ }
                ) {
                    Icon(
                        imageVector = Icons.Default.Refresh,
                        contentDescription = "Restore",
                        tint = Color(0xFF007AFF),
                        modifier = Modifier.size(20.dp)
                    )
                }
            }
        }
    }
}

@Composable
fun StatsScreen() {
    var selectedPeriod by remember { mutableStateOf("7 Days") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp)
            .padding(bottom = 120.dp)
    ) {
        Spacer(modifier = Modifier.height(60.dp))

        // Header
        Text(
            text = "Statistics",
            fontSize = 34.sp,
            fontWeight = FontWeight.Bold,
            color = Color(0xFF1C1C1E)
        )

        Spacer(modifier = Modifier.height(24.dp))

        // Period selector - exactly like iOS
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            PeriodButton(
                text = "7 Days",
                isSelected = selectedPeriod == "7 Days",
                onClick = { selectedPeriod = "7 Days" },
                modifier = Modifier.weight(1f)
            )

            PeriodButton(
                text = "30 Days",
                isSelected = selectedPeriod == "30 Days",
                onClick = { selectedPeriod = "30 Days" },
                modifier = Modifier.weight(1f)
            )
        }

        Spacer(modifier = Modifier.height(24.dp))

        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Time Saved Card - exactly like iOS
            item {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(20.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = Color(0xFF34C759) // iOS green
                    ),
                    elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
                ) {
                    Column(
                        modifier = Modifier.padding(24.dp)
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Default.Timer,
                                contentDescription = null,
                                tint = Color.White,
                                modifier = Modifier.size(24.dp)
                            )

                            Spacer(modifier = Modifier.width(8.dp))

                            Text(
                                text = "Time Saved",
                                fontSize = 17.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = Color.White
                            )
                        }

                        Spacer(modifier = Modifier.height(12.dp))

                        Text(
                            text = "1h 5m",
                            fontSize = 36.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.White
                        )

                        Text(
                            text = "vs endless scrolling",
                            fontSize = 15.sp,
                            color = Color.White.copy(alpha = 0.8f)
                        )
                    }
                }
            }

            // Stats row - exactly like iOS
            item {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    StatsCard(
                        title = "26",
                        subtitle = "Total",
                        icon = Icons.Default.Search,
                        color = Color(0xFF007AFF),
                        modifier = Modifier.weight(1f)
                    )

                    StatsCard(
                        title = "26",
                        subtitle = "Today",
                        icon = Icons.Default.Today,
                        color = Color(0xFFFF9500),
                        modifier = Modifier.weight(1f)
                    )
                }
            }

            // Platform Usage - exactly like iOS
            item {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(20.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = Color.White
                    ),
                    elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
                ) {
                    Column(
                        modifier = Modifier.padding(20.dp)
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Row(
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Icon(
                                    imageVector = Icons.Default.PieChart,
                                    contentDescription = null,
                                    tint = Color(0xFF007AFF),
                                    modifier = Modifier.size(20.dp)
                                )

                                Spacer(modifier = Modifier.width(8.dp))

                                Text(
                                    text = "Platform Usage",
                                    fontSize = 17.sp,
                                    fontWeight = FontWeight.SemiBold,
                                    color = Color(0xFF1C1C1E)
                                )
                            }

                            Text(
                                text = "7 Days",
                                fontSize = 15.sp,
                                color = Color(0xFF8E8E93)
                            )
                        }

                        Spacer(modifier = Modifier.height(20.dp))

                        // Platform usage items
                        PlatformUsageItem("Reddit", 53, 14, Color(0xFFFF4500))
                        Spacer(modifier = Modifier.height(12.dp))
                        PlatformUsageItem("YouTube", 46, 12, Color(0xFFFF0000))
                    }
                }
            }
        }
    }
}

@Composable
fun PeriodButton(
    text: String,
    isSelected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Button(
        onClick = onClick,
        modifier = modifier,
        shape = RoundedCornerShape(12.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = if (isSelected) Color.White else Color(0xFFF2F2F7),
            contentColor = Color(0xFF1C1C1E)
        ),
        elevation = ButtonDefaults.buttonElevation(
            defaultElevation = if (isSelected) 4.dp else 0.dp
        ),
        contentPadding = PaddingValues(vertical = 12.dp)
    ) {
        Text(
            text = text,
            fontSize = 15.sp,
            fontWeight = if (isSelected) FontWeight.SemiBold else FontWeight.Medium
        )
    }
}

@Composable
fun StatsCard(
    title: String,
    subtitle: String,
    icon: ImageVector,
    color: Color,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier,
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color.White
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
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
                text = title,
                fontSize = 28.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFF1C1C1E)
            )

            Text(
                text = subtitle,
                fontSize = 13.sp,
                color = Color(0xFF8E8E93)
            )
        }
    }
}

@Composable
fun PlatformUsageItem(
    platform: String,
    percentage: Int,
    searches: Int,
    color: Color
) {
    Row(
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Color indicator
        Box(
            modifier = Modifier
                .size(12.dp)
                .background(color, androidx.compose.foundation.shape.CircleShape)
        )

        Spacer(modifier = Modifier.width(12.dp))

        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = platform,
                fontSize = 17.sp,
                fontWeight = FontWeight.Medium,
                color = Color(0xFF1C1C1E)
            )

            Text(
                text = "$percentage% • $searches searches",
                fontSize = 15.sp,
                color = Color(0xFF8E8E93)
            )
        }
    }
}

@Composable
fun SettingsScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp)
            .padding(bottom = 120.dp)
    ) {
        Spacer(modifier = Modifier.height(60.dp))

        // Header
        Text(
            text = "Settings",
            fontSize = 34.sp,
            fontWeight = FontWeight.Bold,
            color = Color(0xFF1C1C1E)
        )

        Spacer(modifier = Modifier.height(32.dp))

        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            // Preferences Section
            item {
                SettingsSection(
                    title = "Preferences",
                    icon = Icons.Default.Settings,
                    iconColor = Color(0xFF007AFF)
                ) {
                    SettingsRow(
                        title = "Language",
                        subtitle = "Auto-detect",
                        icon = Icons.Default.Language,
                        onClick = { /* Language settings */ }
                    )
                }
            }

            // Data Management Section
            item {
                SettingsSection(
                    title = "Data Management",
                    icon = Icons.Default.Storage,
                    iconColor = Color(0xFF007AFF)
                ) {
                    SettingsRow(
                        title = "Data Retention Period",
                        subtitle = "How long to keep search history",
                        icon = Icons.Default.Schedule,
                        onClick = { /* Data retention */ }
                    )

                    Spacer(modifier = Modifier.height(16.dp))

                    // Data retention options - exactly like iOS
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        RetentionButton("7 Days", true, Modifier.weight(1f))
                        RetentionButton("30 Days", false, Modifier.weight(1f))
                        RetentionButton("Forever", false, Modifier.weight(1f))
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    // Platform Order toggle
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Default.SwapVert,
                                contentDescription = null,
                                tint = Color(0xFF8E8E93),
                                modifier = Modifier.size(20.dp)
                            )

                            Spacer(modifier = Modifier.width(12.dp))

                            Column {
                                Text(
                                    text = "Platform Order",
                                    fontSize = 17.sp,
                                    fontWeight = FontWeight.Medium,
                                    color = Color(0xFF1C1C1E)
                                )

                                Text(
                                    text = "Auto-sorted by usage frequency",
                                    fontSize = 13.sp,
                                    color = Color(0xFF8E8E93)
                                )
                            }
                        }

                        Switch(
                            checked = true,
                            onCheckedChange = { /* Toggle platform order */ },
                            colors = SwitchDefaults.colors(
                                checkedThumbColor = Color.White,
                                checkedTrackColor = Color(0xFF34C759),
                                uncheckedThumbColor = Color.White,
                                uncheckedTrackColor = Color(0xFF8E8E93)
                            )
                        )
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    SettingsRow(
                        title = "Export Data",
                        subtitle = "Export search history and statistics",
                        icon = Icons.Default.Download,
                        onClick = { /* Export data */ }
                    )

                    SettingsRow(
                        title = "Clear All Data",
                        subtitle = "Remove all search history and statistics",
                        icon = Icons.Default.Delete,
                        iconColor = Color(0xFFFF3B30),
                        textColor = Color(0xFFFF3B30),
                        onClick = { /* Clear data */ }
                    )
                }
            }

            // About & Support Section
            item {
                SettingsSection(
                    title = "About & Support",
                    icon = Icons.Default.Info,
                    iconColor = Color(0xFF007AFF)
                ) {
                    SettingsRow(
                        title = "Version",
                        subtitle = "1.0",
                        icon = Icons.Default.AppRegistration,
                        onClick = { /* Version info */ }
                    )

                    SettingsRow(
                        title = "Privacy Policy",
                        subtitle = "",
                        icon = Icons.Default.PrivacyTip,
                        onClick = { /* Privacy policy */ }
                    )
                }
            }
        }
    }
}

@Composable
fun SettingsSection(
    title: String,
    icon: ImageVector,
    iconColor: Color,
    content: @Composable () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color.White
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
    ) {
        Column(
            modifier = Modifier.padding(20.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = iconColor,
                    modifier = Modifier.size(20.dp)
                )

                Spacer(modifier = Modifier.width(8.dp))

                Text(
                    text = title,
                    fontSize = 17.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF1C1C1E)
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            content()
        }
    }
}

@Composable
fun SettingsRow(
    title: String,
    subtitle: String,
    icon: ImageVector,
    iconColor: Color = Color(0xFF8E8E93),
    textColor: Color = Color(0xFF1C1C1E),
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() }
            .padding(vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = iconColor,
            modifier = Modifier.size(20.dp)
        )

        Spacer(modifier = Modifier.width(12.dp))

        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = title,
                fontSize = 17.sp,
                fontWeight = FontWeight.Medium,
                color = textColor
            )

            if (subtitle.isNotEmpty()) {
                Text(
                    text = subtitle,
                    fontSize = 13.sp,
                    color = Color(0xFF8E8E93)
                )
            }
        }

        if (subtitle.isNotEmpty() && !subtitle.contains("Remove") && !subtitle.contains("Export")) {
            Text(
                text = subtitle,
                fontSize = 17.sp,
                color = Color(0xFF8E8E93)
            )

            Spacer(modifier = Modifier.width(8.dp))
        }

        Icon(
            imageVector = Icons.Default.ChevronRight,
            contentDescription = null,
            tint = Color(0xFF8E8E93),
            modifier = Modifier.size(16.dp)
        )
    }
}

@Composable
fun RetentionButton(
    text: String,
    isSelected: Boolean,
    modifier: Modifier = Modifier
) {
    Button(
        onClick = { /* Handle selection */ },
        modifier = modifier,
        shape = RoundedCornerShape(8.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = if (isSelected) Color(0xFFF2F2F7) else Color.Transparent,
            contentColor = Color(0xFF1C1C1E)
        ),
        elevation = ButtonDefaults.buttonElevation(
            defaultElevation = 0.dp
        ),
        border = if (!isSelected) {
            androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFE5E5EA))
        } else null,
        contentPadding = PaddingValues(vertical = 8.dp)
    ) {
        Text(
            text = text,
            fontSize = 13.sp,
            fontWeight = FontWeight.Medium
        )
    }
}
