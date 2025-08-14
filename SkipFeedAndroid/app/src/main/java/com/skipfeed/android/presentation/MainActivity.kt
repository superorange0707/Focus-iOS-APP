package com.skipfeed.android.presentation

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import android.content.Intent
import android.net.Uri
import android.widget.Toast
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.clickable
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.draw.shadow
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import java.util.Calendar

import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import java.net.URLEncoder
import java.text.SimpleDateFormat
import java.util.*
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.skipfeed.android.R
import com.skipfeed.android.data.repository.SearchRepository
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject

// Data classes
data class HistoryItem(
    val query: String,
    val platform: String,
    val timestamp: String,
    val iconRes: Int,
    val timestampMillis: Long = 0L // Add actual timestamp for filtering
)

data class Platform(
    val name: String,
    val iconRes: Int
)

@AndroidEntryPoint
class MainActivity : ComponentActivity() {

    @Inject
    lateinit var searchRepository: SearchRepository

    override fun onCreate(savedInstanceState: Bundle?) {
        // Install splash screen before super.onCreate()
        installSplashScreen()

        super.onCreate(savedInstanceState)
        setContent {
            SkipFeedApp(searchRepository)
        }
    }
}

@Composable
fun SkipFeedApp(searchRepository: SearchRepository) {
    val navController = rememberNavController()
    
    // iOS-style gradient background
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = androidx.compose.ui.graphics.Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFFF0F8FF), // Alice Blue
                        Color(0xFFE6F3FF), // Light blue
                        Color(0xFFD1E9FF)  // Deeper light blue
                    )
                )
            )
    ) {
        NavHost(
            navController = navController,
            startDestination = "search",
            modifier = Modifier.fillMaxSize()
        ) {
            composable("search") { SearchScreen(navController, searchRepository) }
            composable("history") { HistoryScreen() }
            composable("stats") { StatsScreen() }
            composable("settings") { SettingsScreen() }
            composable("reddit_search/{query}") { backStackEntry ->
                val query = backStackEntry.arguments?.getString("query") ?: ""
                RedditSearchScreen(
                    query = query,
                    onDismiss = { navController.popBackStack() }
                )
            }
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
    
    // iOS-style tab bar - clean without extra lines, blends with gradient
    Box(
        modifier = modifier
            .fillMaxWidth()
            .background(Color.White.copy(alpha = 0.7f)) // More transparent to blend with gradient
            .padding(bottom = 4.dp) // Minimal bottom space, tabs closer to bottom
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 8.dp), // Much more compact internal padding
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
            .padding(horizontal = 12.dp, vertical = 4.dp) // Much more compact padding
    ) {
        Icon(
            imageVector = tab.icon,
            contentDescription = tab.title,
            tint = if (isSelected) Color(0xFF007AFF) else Color(0xFF8E8E93),
            modifier = Modifier.size(22.dp) // Slightly smaller icon
        )

        Spacer(modifier = Modifier.height(2.dp)) // Reduced spacing
        
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

val platforms = listOf(
    Platform("Reddit", R.drawable.icon_reddit),
    Platform("YouTube", R.drawable.icon_youtube),
    Platform("X", R.drawable.icon_x),
    Platform("TikTok", R.drawable.icon_tiktok),
    Platform("Instagram", R.drawable.icon_instagram),
    Platform("Facebook", R.drawable.icon_facebook)
)

// Search functionality implementation
fun performSearch(context: android.content.Context, platform: String, query: String, mode: String) {
    val encodedQuery = URLEncoder.encode(query, "UTF-8")

    when (platform) {
        "Reddit" -> {
            if (mode == "In-App") {
                // Try to open Reddit app first, then fallback to browser
                val redditAppIntent = Intent(Intent.ACTION_VIEW, Uri.parse("reddit://www.reddit.com/search/?q=$encodedQuery"))
                val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.reddit.com/search/?q=$encodedQuery"))

                try {
                    // Try Reddit app first
                    redditAppIntent.setPackage("com.reddit.frontpage")
                    context.startActivity(redditAppIntent)
                    Toast.makeText(context, "Opening Reddit app for: $query", Toast.LENGTH_SHORT).show()
                } catch (e: Exception) {
                    try {
                        // Fallback to browser
                        context.startActivity(browserIntent)
                        Toast.makeText(context, "Opening Reddit in browser for: $query", Toast.LENGTH_SHORT).show()
                    } catch (e2: Exception) {
                        Toast.makeText(context, "Unable to open Reddit", Toast.LENGTH_SHORT).show()
                        return
                    }
                }
            } else {
                // Direct mode - always use browser
                val searchUrl = "https://www.reddit.com/search/?q=$encodedQuery"
                try {
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(searchUrl))
                    context.startActivity(intent)
                    Toast.makeText(context, "Searching Reddit for: $query", Toast.LENGTH_SHORT).show()
                } catch (e: Exception) {
                    Toast.makeText(context, "Unable to open browser", Toast.LENGTH_SHORT).show()
                    return
                }
            }
        }
        else -> {
            // All other platforms - direct search only
            val searchUrl = when (platform) {
                "YouTube" -> "https://www.youtube.com/results?search_query=$encodedQuery"
                "X" -> "https://twitter.com/search?q=$encodedQuery"
                "TikTok" -> "https://www.tiktok.com/search?q=$encodedQuery"
                "Instagram" -> "https://www.instagram.com/explore/tags/$encodedQuery/"
                "Facebook" -> "https://www.facebook.com/search/top?q=$encodedQuery"
                else -> "https://www.google.com/search?q=$encodedQuery"
            }

            try {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(searchUrl))
                context.startActivity(intent)
                Toast.makeText(context, "Searching $platform for: $query", Toast.LENGTH_SHORT).show()
            } catch (e: Exception) {
                Toast.makeText(context, "Unable to open browser", Toast.LENGTH_SHORT).show()
                return
            }
        }
    }

    // Save to search history
    saveSearchHistory(context, query, platform, mode)
}

// Save search history (simplified implementation)
fun saveSearchHistory(context: android.content.Context, query: String, platform: String, mode: String = "Direct") {
    val sharedPrefs = context.getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE)
    val timestamp = java.text.SimpleDateFormat("h:mm:ss a", java.util.Locale.getDefault()).format(java.util.Date())

    // Save the search (in a real app, you'd use a proper database)
    val historyKey = "${System.currentTimeMillis()}"
    sharedPrefs.edit()
        .putString("${historyKey}_query", query)
        .putString("${historyKey}_platform", platform)
        .putString("${historyKey}_timestamp", timestamp)
        .putString("${historyKey}_mode", mode)
        .apply()
}

// Load search history
fun loadSearchHistory(context: android.content.Context): List<HistoryItem> {
    // Don't auto-clean - only clean when explicitly requested

    val sharedPrefs = context.getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE)
    val allEntries = sharedPrefs.all
    val historyItems = mutableListOf<HistoryItem>()

    // Group entries by timestamp
    val groupedEntries = allEntries.keys
        .filter { it.endsWith("_query") }
        .map { it.replace("_query", "") }
        .sortedByDescending { it.toLongOrNull() ?: 0L }
        .take(10) // Show last 10 searches

    for (key in groupedEntries) {
        val query = sharedPrefs.getString("${key}_query", "") ?: ""
        val platform = sharedPrefs.getString("${key}_platform", "") ?: ""
        val timestamp = sharedPrefs.getString("${key}_timestamp", "") ?: ""

        // Filter out invalid entries and timestamps
        if (query.isNotEmpty() && platform.isNotEmpty() && timestamp.isNotEmpty()) {
            // For timestamp validation, check if the key (which is the actual timestamp) is valid
            val timestampLong = key.toLongOrNull() ?: 0L
            val year2020 = 1577836800000L // Jan 1, 2020 in milliseconds
            val now = System.currentTimeMillis()

            // Only include entries with valid timestamps (after 2020 and not in the future)
            if (timestampLong > 0L && timestampLong >= year2020 && timestampLong <= now) {
                val iconRes = when (platform) {
                    "Reddit" -> R.drawable.icon_reddit
                    "YouTube" -> R.drawable.icon_youtube
                    "X" -> R.drawable.icon_x
                    "TikTok" -> R.drawable.icon_tiktok
                    "Instagram" -> R.drawable.icon_instagram
                    "Facebook" -> R.drawable.icon_facebook
                    else -> R.drawable.icon_reddit
                }
                historyItems.add(HistoryItem(query, platform, timestamp, iconRes, timestampLong))
            }
        }
    }

    // Return empty list if no valid history found
    // Don't return sample data as it causes 1970 date issues

    return historyItems
}

// Delete search history item
fun deleteSearchHistory(context: android.content.Context, item: HistoryItem) {
    val sharedPrefs = context.getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE)
    val allEntries = sharedPrefs.all
    val editor = sharedPrefs.edit()

    // Find and delete the matching entry
    for ((key, _) in allEntries) {
        if (key.endsWith("_query")) {
            val baseKey = key.replace("_query", "")
            val query = sharedPrefs.getString("${baseKey}_query", "")
            val platform = sharedPrefs.getString("${baseKey}_platform", "")
            val timestamp = sharedPrefs.getString("${baseKey}_timestamp", "")

            // Match by query and platform (timestamp might be formatted differently)
            if (query == item.query && platform == item.platform) {
                editor.remove("${baseKey}_query")
                editor.remove("${baseKey}_platform")
                editor.remove("${baseKey}_timestamp")
                editor.remove("${baseKey}_mode")

                // Also try to remove any other related keys
                editor.remove(baseKey) // In case there's a base key without suffix
                break
            }
        }
    }
    editor.apply()
}

// Clear all search history
fun clearAllHistory(context: android.content.Context) {
    val sharedPrefs = context.getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE)
    sharedPrefs.edit().clear().apply()
    Toast.makeText(context, "Search history cleared", Toast.LENGTH_SHORT).show()
}

// Clean invalid history entries (like Jan 1, 1970)
fun cleanInvalidHistory(context: android.content.Context) {
    val sharedPrefs = context.getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE)
    val allEntries = sharedPrefs.all
    val editor = sharedPrefs.edit()
    var removedCount = 0

    // Find and remove invalid entries
    for ((key, value) in allEntries) {
        var shouldRemove = false

        if (key.endsWith("_query")) {
            val baseKey = key.replace("_query", "")
            val query = sharedPrefs.getString("${baseKey}_query", "") ?: ""
            val platform = sharedPrefs.getString("${baseKey}_platform", "") ?: ""
            val timestamp = sharedPrefs.getString("${baseKey}_timestamp", "") ?: ""

            // Check if this is one of the problematic entries
            // Remove entries with "Skip" or "Skipfeed" queries that seem to be test data
            if (query == "Skip" || query == "Skipfeed" || query.isEmpty() || query.isBlank()) {
                shouldRemove = true
            }

            // Check if baseKey looks like a very old timestamp (close to 0 or before 2020)
            val baseKeyLong = baseKey.toLongOrNull()
            if (baseKeyLong != null) {
                val year2020 = 1577836800000L // Jan 1, 2020 in milliseconds
                val now = System.currentTimeMillis()
                if (baseKeyLong <= 0L || baseKeyLong < year2020 || baseKeyLong > now) {
                    shouldRemove = true
                }
            } else {
                // If baseKey is not a valid timestamp, remove it
                shouldRemove = true
            }

            if (shouldRemove) {
                editor.remove("${baseKey}_query")
                editor.remove("${baseKey}_platform")
                editor.remove("${baseKey}_timestamp")
                editor.remove("${baseKey}_mode")
                editor.remove(baseKey) // Remove base key too
                removedCount++
            }
        }
    }

    editor.apply()
    // Silently clean without showing toast
}

// Force clean all problematic records including sample data
fun forceCleanProblematicRecords(context: android.content.Context) {
    val sharedPrefs = context.getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE)
    val allEntries = sharedPrefs.all
    val editor = sharedPrefs.edit()
    var removedCount = 0

    // Remove any entries that contain "Skip" or "Skipfeed" in the query (sample data)
    for ((key, value) in allEntries) {
        val valueStr = value.toString()
        if (valueStr.contains("Skip", ignoreCase = true) ||
            valueStr.contains("Skipfeed", ignoreCase = true) ||
            key.contains("Skip", ignoreCase = true)) {
            editor.remove(key)
            removedCount++
        }
    }

    editor.apply()
    // Silently clean without showing toast
}

// Get search mode for history item
fun getSearchMode(context: android.content.Context, item: HistoryItem): String {
    val sharedPrefs = context.getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE)
    val allEntries = sharedPrefs.all

    // Find the matching entry and get its mode
    for ((key, _) in allEntries) {
        if (key.endsWith("_query")) {
            val baseKey = key.replace("_query", "")
            val query = sharedPrefs.getString("${baseKey}_query", "")
            val platform = sharedPrefs.getString("${baseKey}_platform", "")
            val timestamp = sharedPrefs.getString("${baseKey}_timestamp", "")
            val mode = sharedPrefs.getString("${baseKey}_mode", "Direct")

            if (query == item.query && platform == item.platform && timestamp == item.timestamp) {
                return mode ?: "Direct"
            }
        }
    }

    return "Direct" // Default fallback
}

// Recent search functions
fun loadRecentSearches(context: android.content.Context): List<String> {
    val sharedPrefs = context.getSharedPreferences("recent_searches", android.content.Context.MODE_PRIVATE)
    val recentSearchesString = sharedPrefs.getString("searches", "")
    return if (recentSearchesString.isNullOrEmpty()) {
        emptyList()
    } else {
        recentSearchesString.split(",").filter { it.isNotBlank() }
    }
}

fun saveRecentSearch(context: android.content.Context, query: String) {
    val sharedPrefs = context.getSharedPreferences("recent_searches", android.content.Context.MODE_PRIVATE)
    val currentSearches = loadRecentSearches(context).toMutableList()

    // Remove if already exists
    currentSearches.remove(query)

    // Add to beginning
    currentSearches.add(0, query)

    // Keep only last 10 searches
    if (currentSearches.size > 10) {
        currentSearches.removeAt(currentSearches.size - 1)
    }

    // Save back
    sharedPrefs.edit()
        .putString("searches", currentSearches.joinToString(","))
        .apply()
}

// Save to both recent searches and search history database
fun saveSearchToHistory(context: android.content.Context, query: String, platform: String, searchRepository: SearchRepository) {
    // Save to recent searches (for Recent Search chips)
    saveRecentSearch(context, query)

    // Save to search history database (for History page)
    CoroutineScope(Dispatchers.IO).launch {
        try {
            val platformEnum = when (platform) {
                "Reddit" -> com.skipfeed.android.data.model.Platform.REDDIT
                "YouTube" -> com.skipfeed.android.data.model.Platform.YOUTUBE
                "X" -> com.skipfeed.android.data.model.Platform.X
                "TikTok" -> com.skipfeed.android.data.model.Platform.TIKTOK
                "Instagram" -> com.skipfeed.android.data.model.Platform.INSTAGRAM
                "Facebook" -> com.skipfeed.android.data.model.Platform.FACEBOOK
                else -> com.skipfeed.android.data.model.Platform.REDDIT
            }

            android.util.Log.d("SearchHistory", "Saving search: query='$query', platform='$platform' -> $platformEnum")
            searchRepository.addToSearchHistory(query, platformEnum)
            android.util.Log.d("SearchHistory", "Search saved successfully")
        } catch (e: Exception) {
            android.util.Log.e("SearchHistory", "Failed to save search history", e)
            Toast.makeText(context, "Failed to save search: ${e.message}", Toast.LENGTH_SHORT).show()
        }
    }
}

fun clearRecentSearches(context: android.content.Context) {
    val sharedPrefs = context.getSharedPreferences("recent_searches", android.content.Context.MODE_PRIVATE)
    sharedPrefs.edit().clear().apply()
}

@Composable
fun RecentSearchChip(
    query: String,
    onClick: () -> Unit
) {
    Button(
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(
            containerColor = Color.Transparent,
            contentColor = Color(0xFF007AFF)
        ),
        shape = RoundedCornerShape(12.dp),
        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp),
        modifier = Modifier
            .background(
                color = Color.White.copy(alpha = 0.9f),
                shape = RoundedCornerShape(12.dp)
            )
            .border(
                width = 1.dp,
                color = Color(0xFFE5E5EA),
                shape = RoundedCornerShape(12.dp)
            )
    ) {
        Text(
            text = query,
            fontSize = 12.sp,
            fontWeight = FontWeight.Medium,
            color = Color(0xFF007AFF)
        )
    }
}

@Composable
fun SearchScreen(navController: NavHostController, searchRepository: SearchRepository) {
    var searchQuery by remember { mutableStateOf("") }
    var selectedPlatform by remember { mutableStateOf("Reddit") }
    var searchMode by remember { mutableStateOf("Direct") } // Direct or In-App
    val context = LocalContext.current

    // Load recent searches - refresh when needed
    var recentSearches by remember { mutableStateOf(loadRecentSearches(context)) }

    // Reset search mode when platform changes (only Reddit supports In-App)
    LaunchedEffect(selectedPlatform) {
        if (selectedPlatform != "Reddit") {
            searchMode = "Direct"
        }
    }

    Box(
        modifier = Modifier.fillMaxSize()
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 20.dp)
                .padding(top = 16.dp, bottom = 100.dp) // Much closer to top
        ) {

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

            Spacer(modifier = Modifier.height(32.dp))

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

            Spacer(modifier = Modifier.height(16.dp))

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

            Spacer(modifier = Modifier.height(24.dp))

            // TikTok special interface - show immediately after platform selection
            if (selectedPlatform == "TikTok") {
                // TikTok info section
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 5.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.Search,
                        contentDescription = null,
                        tint = Color(0xFF007AFF),
                        modifier = Modifier.size(20.dp)
                    )

                    Spacer(modifier = Modifier.width(8.dp))

                    Text(
                        text = "Opens TikTok search page where you can input your query",
                        fontSize = 14.sp,
                        color = Color(0xFF8E8E93),
                        lineHeight = 18.sp
                    )
                }

                Spacer(modifier = Modifier.height(20.dp))

                // Open TikTok Search button
                Button(
                    onClick = {
                        try {
                            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.tiktok.com/search"))
                            context.startActivity(intent)
                            Toast.makeText(context, "Opening TikTok search", Toast.LENGTH_SHORT).show()
                        } catch (e: Exception) {
                            Toast.makeText(context, "Unable to open TikTok", Toast.LENGTH_SHORT).show()
                        }
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(55.dp)
                        .shadow(
                            elevation = 10.dp,
                            shape = RoundedCornerShape(16.dp),
                            ambientColor = Color(0xFF007AFF).copy(alpha = 0.3f),
                            spotColor = Color(0xFF007AFF).copy(alpha = 0.3f)
                        ),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF007AFF)
                    ),
                    shape = RoundedCornerShape(16.dp)
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Search,
                            contentDescription = null,
                            tint = Color.White,
                            modifier = Modifier.size(20.dp)
                        )

                        Spacer(modifier = Modifier.width(12.dp))

                        Text(
                            text = "Open TikTok Search",
                            fontSize = 17.sp,
                            fontWeight = FontWeight.SemiBold,
                            color = Color.White
                        )
                    }
                }
            }

            // Search area - subtle glassmorphism style like iOS (hidden for TikTok)
            if (selectedPlatform != "TikTok") {
                Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(
                        color = Color.White.copy(alpha = 0.4f), // More subtle background
                        shape = RoundedCornerShape(20.dp)
                    )
                    .border(
                        width = 0.5.dp,
                        color = Color(0xFFE5E5EA).copy(alpha = 0.3f), // Very subtle border
                        shape = RoundedCornerShape(20.dp)
                    )
                    .padding(22.dp)
            ) {
                // Search input - subtle iOS style
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(
                            color = Color.White.copy(alpha = 0.6f), // More subtle background
                            shape = RoundedCornerShape(20.dp)
                        )
                        .border(
                            width = 0.5.dp,
                            color = Color(0xFFE5E5EA).copy(alpha = 0.4f), // Very subtle border
                            shape = RoundedCornerShape(20.dp)
                        )
                        .padding(horizontal = 22.dp, vertical = 18.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.Search,
                        contentDescription = null,
                        tint = Color(0xFF007AFF).copy(alpha = 0.75f),
                        modifier = Modifier.size(20.dp)
                    )

                    Spacer(modifier = Modifier.width(15.dp))

                    BasicTextField(
                        value = searchQuery,
                        onValueChange = { searchQuery = it },
                        modifier = Modifier.weight(1f),
                        textStyle = TextStyle(
                            fontSize = 16.sp,
                            color = Color.Black
                        ),
                        singleLine = true,
                        decorationBox = { innerTextField ->
                            if (searchQuery.isEmpty()) {
                                Text(
                                    "Search $selectedPlatform...",
                                    color = Color(0xFF8E8E93),
                                    fontSize = 16.sp
                                )
                            }
                            innerTextField()
                        }
                    )

                    if (searchQuery.isNotEmpty()) {
                        IconButton(
                            onClick = { searchQuery = "" },
                            modifier = Modifier.size(20.dp)
                        ) {
                            Icon(
                                imageVector = Icons.Default.Cancel,
                                contentDescription = "Clear",
                                tint = Color(0xFF8E8E93),
                                modifier = Modifier.size(16.dp)
                            )
                        }
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Search mode toggle - iOS style for Reddit
                if (selectedPlatform == "Reddit") {
                    Row(
                        modifier = Modifier
                            .background(
                                color = Color(0xFFF2F2F7),
                                shape = RoundedCornerShape(16.dp)
                            )
                            .border(
                                width = 0.5.dp,
                                color = Color(0xFFD1D1D6),
                                shape = RoundedCornerShape(16.dp)
                            )
                            .padding(4.dp),
                        horizontalArrangement = Arrangement.spacedBy(0.dp)
                    ) {
                        // Direct mode button
                        Button(
                            onClick = { searchMode = "Direct" },
                            colors = ButtonDefaults.buttonColors(
                                containerColor = if (searchMode == "Direct")
                                    Color(0xFF007AFF) else Color.Transparent,
                                contentColor = if (searchMode == "Direct")
                                    Color.White else Color.Black
                            ),
                            shape = RoundedCornerShape(12.dp),
                            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
                            modifier = Modifier
                                .weight(1f)
                                .height(32.dp),
                            elevation = ButtonDefaults.buttonElevation(0.dp)
                        ) {
                            Text(
                                text = "Direct",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Medium
                            )
                        }

                        // In-App mode button
                        Button(
                            onClick = { searchMode = "In-App" },
                            colors = ButtonDefaults.buttonColors(
                                containerColor = if (searchMode == "In-App")
                                    Color(0xFF007AFF) else Color.Transparent,
                                contentColor = if (searchMode == "In-App")
                                    Color.White else Color.Black
                            ),
                            shape = RoundedCornerShape(12.dp),
                            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
                            modifier = Modifier
                                .weight(1f)
                                .height(32.dp),
                            elevation = ButtonDefaults.buttonElevation(0.dp)
                        ) {
                            Text(
                                text = "In-App",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Medium
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))
                }

                // Search button - iOS glassmorphism style
                Button(
                    onClick = {
                        if (searchQuery.isNotBlank()) {
                            // Save to both recent searches and search history database
                            saveSearchToHistory(context, searchQuery, selectedPlatform, searchRepository)
                            recentSearches = loadRecentSearches(context) // Refresh UI

                            if (selectedPlatform == "Reddit" && searchMode == "In-App") {
                                // Navigate to in-app Reddit search
                                navController.navigate("reddit_search/${java.net.URLEncoder.encode(searchQuery, "UTF-8")}")
                            } else {
                                // External search
                                performSearch(context, selectedPlatform, searchQuery, searchMode)
                            }
                        } else {
                            Toast.makeText(context, "Please enter a search query", Toast.LENGTH_SHORT).show()
                        }
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(55.dp)
                        .shadow(
                            elevation = 10.dp,
                            shape = RoundedCornerShape(20.dp),
                            ambientColor = Color(0xFF007AFF).copy(alpha = 0.2f),
                            spotColor = Color(0xFF007AFF).copy(alpha = 0.2f)
                        ),
                    shape = RoundedCornerShape(20.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color.Transparent
                    ),
                    contentPadding = PaddingValues(0.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(
                                brush = Brush.horizontalGradient(
                                    colors = listOf(
                                        Color(0xFF007AFF),
                                        Color(0xFF5856D6).copy(alpha = 0.7f)
                                    )
                                ),
                                shape = RoundedCornerShape(20.dp)
                            )
                            .border(
                                width = 1.dp,
                                color = Color.White.copy(alpha = 0.2f),
                                shape = RoundedCornerShape(20.dp)
                            ),
                        contentAlignment = Alignment.Center
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.Center
                        ) {
                            Icon(
                                imageVector = Icons.Default.Search,
                                contentDescription = null,
                                tint = Color.White,
                                modifier = Modifier.size(18.dp)
                            )

                            Spacer(modifier = Modifier.width(12.dp))

                            Text(
                                text = if (selectedPlatform == "Reddit" && searchMode == "In-App") {
                                    "Browse $selectedPlatform"
                                } else {
                                    "Search on $selectedPlatform"
                                },
                                fontSize = 17.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = Color.White
                            )
                        }
                    }
                }
            }

            // Recent searches section - exactly like iOS
            if (recentSearches.isNotEmpty() && searchQuery.isEmpty() && selectedPlatform != "TikTok") {
                Spacer(modifier = Modifier.height(28.dp))

                // Header row
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 5.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(
                            imageVector = Icons.Default.AccessTime,
                            contentDescription = null,
                            tint = Color(0xFF007AFF),
                            modifier = Modifier.size(12.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            text = "Recent Searches",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Medium,
                            color = Color(0xFF8E8E93)
                        )
                    }

                    TextButton(
                        onClick = {
                            clearRecentSearches(context)
                            recentSearches = emptyList() // Update UI immediately
                        },
                        contentPadding = PaddingValues(0.dp)
                    ) {
                        Text(
                            text = "Clear",
                            fontSize = 10.sp,
                            color = Color(0xFF8E8E93)
                        )
                    }
                }

                Spacer(modifier = Modifier.height(15.dp))

                // Horizontal scrolling chips
                LazyRow(
                    horizontalArrangement = Arrangement.spacedBy(10.dp),
                    contentPadding = PaddingValues(horizontal = 5.dp)
                ) {
                    items(recentSearches.take(5)) { recentSearch ->
                        RecentSearchChip(
                            query = recentSearch,
                            onClick = {
                                searchQuery = recentSearch
                                // Save to both recent searches and search history database
                                saveSearchToHistory(context, recentSearch, selectedPlatform, searchRepository)
                                recentSearches = loadRecentSearches(context) // Refresh UI

                                if (selectedPlatform == "Reddit" && searchMode == "In-App") {
                                    navController.navigate("reddit_search/${java.net.URLEncoder.encode(recentSearch, "UTF-8")}")
                                } else {
                                    performSearch(context, selectedPlatform, recentSearch, searchMode)
                                }
                            }
                        )
                    }
                }
            }
        }
        }



        // Bottom tagline - fixed position, always visible
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .fillMaxWidth()
                .padding(bottom = 90.dp) // Adjusted for much more compact tab bar
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
            containerColor = Color.White.copy(alpha = 0.3f) // Very subtle background
        ),
        elevation = CardDefaults.cardElevation(
            defaultElevation = 0.dp
        ),
        border = if (isSelected) {
            androidx.compose.foundation.BorderStroke(2.dp, Color(0xFFFF9500))
        } else {
            androidx.compose.foundation.BorderStroke(0.5.dp, Color(0xFFE5E5EA).copy(alpha = 0.6f)) // Subtle border for all cards
        }
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(12.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // Real platform icon - clean and simple
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
    val context = LocalContext.current
    var historyItems by remember { mutableStateOf(loadSearchHistory(context)) }
    var searchQuery by remember { mutableStateOf("") }
    var selectedFilter by remember { mutableStateOf("All") }
    var selectedTimeFilter by remember { mutableStateOf("All Time") }
    var showTimeFilterMenu by remember { mutableStateOf(false) }
    var isSelectionMode by remember { mutableStateOf(false) }
    var selectedItems by remember { mutableStateOf(setOf<String>()) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFFAFAFA))
    ) {
        // HEADER SECTION - Fixed at top
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .background(Color.White)
                .padding(20.dp)
        ) {
            // Title
            Text(
                text = "Search History",
                fontSize = 22.sp,
                fontWeight = FontWeight.SemiBold,
                color = Color(0xFF1C1C1E),
                modifier = Modifier.fillMaxWidth(),
                textAlign = androidx.compose.ui.text.style.TextAlign.Center
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Search bar and time filter row
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Search bar
                OutlinedTextField(
                    value = searchQuery,
                    onValueChange = { searchQuery = it },
                    placeholder = {
                        Text(
                            "Search history",
                            color = Color(0xFF8E8E93),
                            fontSize = 16.sp
                        )
                    },
                    modifier = Modifier
                        .weight(1f)
                        .background(Color(0xFFF2F2F7), RoundedCornerShape(12.dp)),
                    shape = RoundedCornerShape(12.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = Color.Transparent,
                        unfocusedBorderColor = Color.Transparent
                    ),
                    leadingIcon = {
                        Icon(
                            Icons.Default.Search,
                            contentDescription = null,
                            tint = Color(0xFF8E8E93),
                            modifier = Modifier.size(18.dp)
                        )
                    },
                    singleLine = true,
                    textStyle = androidx.compose.ui.text.TextStyle(fontSize = 16.sp)
                )

                // Time filter button (icon like iOS)
                Box {
                    IconButton(
                        onClick = { showTimeFilterMenu = true },
                        modifier = Modifier
                            .size(48.dp)
                            .background(
                                Color(0xFFF2F2F7),
                                RoundedCornerShape(12.dp)
                            )
                    ) {
                        Icon(
                            imageVector = when (selectedTimeFilter) {
                                "Today" -> Icons.Default.WbSunny
                                "Yesterday" -> Icons.Default.Nightlight
                                "This Week" -> Icons.Default.CalendarMonth
                                "This Month" -> Icons.Default.CalendarToday
                                else -> Icons.Default.AccessTime
                            },
                            contentDescription = "Time Filter",
                            tint = Color(0xFF007AFF),
                            modifier = Modifier.size(20.dp)
                        )
                    }

                    DropdownMenu(
                        expanded = showTimeFilterMenu,
                        onDismissRequest = { showTimeFilterMenu = false },
                        modifier = Modifier.background(Color.White)
                    ) {
                        val timeFilters = listOf(
                            "All Time" to Icons.Default.AccessTime,
                            "Today" to Icons.Default.WbSunny,
                            "Yesterday" to Icons.Default.Nightlight,
                            "This Week" to Icons.Default.CalendarMonth,
                            "This Month" to Icons.Default.CalendarToday
                        )
                        timeFilters.forEach { (filter, icon) ->
                            DropdownMenuItem(
                                text = {
                                    Row(
                                        verticalAlignment = Alignment.CenterVertically,
                                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                                    ) {
                                        Icon(
                                            imageVector = icon,
                                            contentDescription = null,
                                            tint = Color(0xFF007AFF),
                                            modifier = Modifier.size(16.dp)
                                        )
                                        Text(filter)
                                        Spacer(modifier = Modifier.weight(1f))
                                        if (selectedTimeFilter == filter) {
                                            Icon(
                                                imageVector = Icons.Default.Check,
                                                contentDescription = null,
                                                tint = Color(0xFF007AFF),
                                                modifier = Modifier.size(16.dp)
                                            )
                                        }
                                    }
                                },
                                onClick = {
                                    selectedTimeFilter = filter
                                    showTimeFilterMenu = false
                                }
                            )
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Platform filter chips
            LazyRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                contentPadding = PaddingValues(horizontal = 0.dp)
            ) {
                val platforms = listOf("All", "Reddit", "YouTube", "X", "TikTok", "Instagram")
                items(platforms) { platform ->
                    FilterChip(
                        text = platform,
                        isSelected = selectedFilter == platform,
                        onClick = { selectedFilter = platform }
                    )
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Action buttons - iOS style
            if (isSelectionMode) {
                // Selection mode: Cancel, Select All, Delete buttons
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    // Left side: Cancel and Select All
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        // Cancel button
                        Button(
                            onClick = {
                                isSelectionMode = false
                                selectedItems = setOf()
                            },
                            colors = ButtonDefaults.buttonColors(
                                containerColor = Color(0xFFFF3B30).copy(alpha = 0.1f),
                                contentColor = Color(0xFFFF3B30)
                            ),
                            shape = RoundedCornerShape(14.dp),
                            elevation = ButtonDefaults.buttonElevation(defaultElevation = 0.dp),
                            contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
                        ) {
                            Text(
                                text = "Cancel",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Medium
                            )
                        }

                        // Select All button
                        Button(
                            onClick = {
                                selectedItems = if (selectedItems.size == historyItems.size) {
                                    setOf() // Deselect all
                                } else {
                                    historyItems.map { "${it.query}_${it.platform}_${it.timestamp}" }.toSet() // Select all
                                }
                            },
                            colors = ButtonDefaults.buttonColors(
                                containerColor = Color(0xFF007AFF).copy(alpha = 0.1f),
                                contentColor = Color(0xFF007AFF)
                            ),
                            shape = RoundedCornerShape(14.dp),
                            elevation = ButtonDefaults.buttonElevation(defaultElevation = 0.dp),
                            contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
                        ) {
                            Text(
                                text = if (selectedItems.size == historyItems.size) "Deselect All" else "Select All",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Medium
                            )
                        }
                    }

                    // Right side: Delete button (only show if items selected)
                    if (selectedItems.isNotEmpty()) {
                        Button(
                            onClick = {
                                // Delete selected items
                                selectedItems.forEach { itemKey ->
                                    val matchingItem = historyItems.find { historyItem ->
                                        "${historyItem.query}_${historyItem.platform}_${historyItem.timestamp}" == itemKey
                                    }
                                    matchingItem?.let { item ->
                                        deleteSearchHistory(context, item)
                                    }
                                }
                                historyItems = loadSearchHistory(context)
                                selectedItems = setOf()
                                isSelectionMode = false
                            },
                            colors = ButtonDefaults.buttonColors(
                                containerColor = Color(0xFFFF3B30).copy(alpha = 0.1f),
                                contentColor = Color(0xFFFF3B30)
                            ),
                            shape = RoundedCornerShape(14.dp),
                            elevation = ButtonDefaults.buttonElevation(defaultElevation = 0.dp),
                            contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
                        ) {
                            Text(
                                text = "Delete (${selectedItems.size})",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Medium
                            )
                        }
                    }
                }
            } else if (historyItems.isNotEmpty()) {
                // Normal mode: Select and Clear All buttons
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    // Select button
                    Button(
                        onClick = { isSelectionMode = true },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color(0xFF007AFF).copy(alpha = 0.1f),
                            contentColor = Color(0xFF007AFF)
                        ),
                        shape = RoundedCornerShape(14.dp),
                        elevation = ButtonDefaults.buttonElevation(defaultElevation = 0.dp),
                        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
                    ) {
                        Text(
                            text = "Select",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Medium
                        )
                    }

                    // Clear All button
                    Button(
                        onClick = {
                            clearAllHistory(context)
                            historyItems = loadSearchHistory(context)
                        },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color(0xFFFF3B30).copy(alpha = 0.1f),
                            contentColor = Color(0xFFFF3B30)
                        ),
                        shape = RoundedCornerShape(14.dp),
                        elevation = ButtonDefaults.buttonElevation(defaultElevation = 0.dp),
                        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
                    ) {
                        Text(
                            text = "Clear All",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Medium
                        )
                    }
                }
            }
        }

        // CONTENT SECTION - Search records appear HERE (below header)
        // Filter items based on search query, platform, and time
        val filteredItems = historyItems.filter { item ->
            // Search query filter
            val matchesSearch = if (searchQuery.isBlank()) true
                else item.query.contains(searchQuery, ignoreCase = true)

            // Platform filter
            val matchesPlatform = if (selectedFilter == "All") true
                else item.platform == selectedFilter

            // Time filter - fixed with proper Calendar calculations
            val matchesTime = when (selectedTimeFilter) {
                "Today" -> {
                    val calendar = java.util.Calendar.getInstance()
                    calendar.set(java.util.Calendar.HOUR_OF_DAY, 0)
                    calendar.set(java.util.Calendar.MINUTE, 0)
                    calendar.set(java.util.Calendar.SECOND, 0)
                    calendar.set(java.util.Calendar.MILLISECOND, 0)
                    val todayStart = calendar.timeInMillis
                    item.timestampMillis >= todayStart
                }
                "Yesterday" -> {
                    val calendar = java.util.Calendar.getInstance()
                    // Start of today
                    calendar.set(java.util.Calendar.HOUR_OF_DAY, 0)
                    calendar.set(java.util.Calendar.MINUTE, 0)
                    calendar.set(java.util.Calendar.SECOND, 0)
                    calendar.set(java.util.Calendar.MILLISECOND, 0)
                    val todayStart = calendar.timeInMillis

                    // Start of yesterday
                    calendar.add(java.util.Calendar.DAY_OF_MONTH, -1)
                    val yesterdayStart = calendar.timeInMillis

                    item.timestampMillis >= yesterdayStart && item.timestampMillis < todayStart
                }
                "This Week" -> {
                    val calendar = java.util.Calendar.getInstance()
                    calendar.add(java.util.Calendar.DAY_OF_MONTH, -7)
                    val weekStart = calendar.timeInMillis
                    item.timestampMillis >= weekStart
                }
                "This Month" -> {
                    val calendar = java.util.Calendar.getInstance()
                    calendar.add(java.util.Calendar.DAY_OF_MONTH, -30)
                    val monthStart = calendar.timeInMillis
                    item.timestampMillis >= monthStart
                }
                else -> true // "All Time" - show everything
            }

            matchesSearch && matchesPlatform && matchesTime
        }

        if (filteredItems.isEmpty()) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(20.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                Icon(
                    imageVector = Icons.Default.History,
                    contentDescription = "No history",
                    modifier = Modifier.size(64.dp),
                    tint = Color(0xFF8E8E93)
                )
                Spacer(modifier = Modifier.height(16.dp))
                Text(
                    text = "No search history yet",
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color(0xFF1C1C1E),
                    textAlign = TextAlign.Center
                )
            }
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(horizontal = 20.dp)
                    .padding(bottom = 100.dp)
            ) {
                // Group by date and show records
                item {
                    Text(
                        text = "Today",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = Color(0xFF8E8E93),
                        modifier = Modifier.padding(vertical = 8.dp)
                    )
                }

                items(filteredItems) { historyItem ->
                    val itemKey = "${historyItem.query}_${historyItem.platform}_${historyItem.timestamp}"

                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 4.dp)
                            .clickable {
                                if (isSelectionMode) {
                                    selectedItems = if (selectedItems.contains(itemKey)) {
                                        selectedItems - itemKey
                                    } else {
                                        selectedItems + itemKey
                                    }
                                } else {
                                    // Restore/repeat search
                                    val originalMode = getSearchMode(context, historyItem)
                                    performSearch(context, historyItem.platform, historyItem.query, originalMode)
                                }
                            },
                        colors = CardDefaults.cardColors(containerColor = Color.White),
                        shape = RoundedCornerShape(16.dp)
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(16.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            // Selection toggle (if in selection mode) - circular like iOS
                            if (isSelectionMode) {
                                Box(
                                    modifier = Modifier
                                        .size(24.dp)
                                        .background(
                                            if (selectedItems.contains(itemKey)) Color(0xFF007AFF) else Color.Transparent,
                                            CircleShape
                                        )
                                        .border(
                                            2.dp,
                                            if (selectedItems.contains(itemKey)) Color(0xFF007AFF) else Color(0xFFE5E5EA),
                                            CircleShape
                                        )
                                        .clickable {
                                            selectedItems = if (selectedItems.contains(itemKey)) {
                                                selectedItems - itemKey
                                            } else {
                                                selectedItems + itemKey
                                            }
                                        },
                                    contentAlignment = Alignment.Center
                                ) {
                                    if (selectedItems.contains(itemKey)) {
                                        Icon(
                                            imageVector = Icons.Default.Check,
                                            contentDescription = null,
                                            tint = Color.White,
                                            modifier = Modifier.size(14.dp)
                                        )
                                    }
                                }
                                Spacer(modifier = Modifier.width(12.dp))
                            }

                            Image(
                                painter = painterResource(id = historyItem.iconRes),
                                contentDescription = historyItem.platform,
                                modifier = Modifier.size(24.dp)
                            )

                            Spacer(modifier = Modifier.width(12.dp))

                            Column(modifier = Modifier.weight(1f)) {
                                Text(
                                    text = historyItem.query,
                                    fontSize = 16.sp,
                                    fontWeight = FontWeight.Medium,
                                    color = Color(0xFF1C1C1E)
                                )
                                Text(
                                    text = "${historyItem.platform} • ${historyItem.timestamp}",
                                    fontSize = 12.sp,
                                    color = Color(0xFF8E8E93)
                                )
                            }

                            // Action buttons (if not in selection mode)
                            if (!isSelectionMode) {
                                Row {
                                    IconButton(
                                        onClick = {
                                            deleteSearchHistory(context, historyItem)
                                            historyItems = loadSearchHistory(context)
                                        }
                                    ) {
                                        Icon(
                                            Icons.Default.Delete,
                                            contentDescription = "Delete",
                                            tint = Color(0xFFFF3B30)
                                        )
                                    }

                                    IconButton(
                                        onClick = {
                                            val originalMode = getSearchMode(context, historyItem)
                                            performSearch(context, historyItem.platform, historyItem.query, originalMode)
                                        }
                                    ) {
                                        Icon(
                                            Icons.Default.Refresh,
                                            contentDescription = "Restore",
                                            tint = Color(0xFF007AFF)
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun FilterChip(
    text: String,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Button(
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(
            containerColor = if (isSelected) Color(0xFF007AFF) else Color(0xFF007AFF).copy(alpha = 0.1f),
            contentColor = if (isSelected) Color.White else Color(0xFF007AFF)
        ),
        shape = RoundedCornerShape(16.dp),
        elevation = ButtonDefaults.buttonElevation(
            defaultElevation = 0.dp
        ),
        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
    ) {
        Text(
            text = text,
            fontSize = 12.sp,
            fontWeight = FontWeight.Medium
        )
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

            // Time of Day Analysis - exactly like iOS
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
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Default.Schedule,
                                contentDescription = null,
                                tint = Color(0xFF007AFF),
                                modifier = Modifier.size(20.dp)
                            )

                            Spacer(modifier = Modifier.width(8.dp))

                            Text(
                                text = "Time of Day Analysis",
                                fontSize = 17.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = Color(0xFF1C1C1E)
                            )
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        Text(
                            text = "Most Active: 2:00 AM - 3:00 AM",
                            fontSize = 15.sp,
                            color = Color(0xFF8E8E93)
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        Text(
                            text = "Peak search time when you need focus most",
                            fontSize = 13.sp,
                            color = Color(0xFF8E8E93)
                        )
                    }
                }
            }

            // Focus Insights - exactly like iOS
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
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Default.Psychology,
                                contentDescription = null,
                                tint = Color(0xFF007AFF),
                                modifier = Modifier.size(20.dp)
                            )

                            Spacer(modifier = Modifier.width(8.dp))

                            Text(
                                text = "Focus Insights",
                                fontSize = 17.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = Color(0xFF1C1C1E)
                            )
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        // Focus Score
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(
                                text = "Focus Score",
                                fontSize = 15.sp,
                                color = Color(0xFF1C1C1E)
                            )

                            Text(
                                text = "85/100",
                                fontSize = 15.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = Color(0xFF34C759)
                            )
                        }

                        Spacer(modifier = Modifier.height(8.dp))

                        // Efficiency
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(
                                text = "Search Efficiency",
                                fontSize = 15.sp,
                                color = Color(0xFF1C1C1E)
                            )

                            Text(
                                text = "92%",
                                fontSize = 15.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = Color(0xFF34C759)
                            )
                        }
                    }
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
                    // Data Retention Period with current selection
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Default.Schedule,
                                contentDescription = null,
                                tint = Color(0xFF8E8E93),
                                modifier = Modifier.size(20.dp)
                            )

                            Spacer(modifier = Modifier.width(12.dp))

                            Column {
                                Text(
                                    text = "Data Retention Period",
                                    fontSize = 17.sp,
                                    fontWeight = FontWeight.Medium,
                                    color = Color(0xFF1C1C1E)
                                )

                                Text(
                                    text = "How long to keep search history",
                                    fontSize = 13.sp,
                                    color = Color(0xFF8E8E93)
                                )
                            }
                        }

                        Text(
                            text = "7 Days",
                            fontSize = 17.sp,
                            color = Color(0xFF8E8E93)
                        )
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
