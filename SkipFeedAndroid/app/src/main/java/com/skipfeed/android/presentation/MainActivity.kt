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
import androidx.compose.runtime.rememberCoroutineScope
import kotlinx.coroutines.launch
import com.skipfeed.android.data.model.Platform
import com.skipfeed.android.data.repository.UsageAnalyticsRepository
import com.skipfeed.android.presentation.components.TikTokWebViewDialog

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
import com.skipfeed.android.presentation.screens.history.SearchHistoryScreen
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.TextButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.RadioButtonDefaults
import androidx.compose.material3.Checkbox
import androidx.compose.material3.CheckboxDefaults
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.foundation.layout.heightIn
import androidx.compose.ui.draw.scale
import androidx.compose.foundation.BorderStroke
import androidx.compose.ui.res.stringResource
import androidx.compose.material3.Surface
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.runtime.CompositionLocalProvider

// Data classes
data class HistoryItem(
    val query: String,
    val platform: String,
    val timestamp: String,
    val iconRes: Int,
    val timestampMillis: Long = 0L // Add actual timestamp for filtering
)

data class PlatformInfo(
    val name: String,
    val iconRes: Int
)

@AndroidEntryPoint
class MainActivity : ComponentActivity() {

    @Inject
    lateinit var searchRepository: SearchRepository

    @Inject
    lateinit var usageAnalyticsRepository: UsageAnalyticsRepository

    override fun onCreate(savedInstanceState: Bundle?) {
        // Install splash screen before super.onCreate()
        installSplashScreen()

        super.onCreate(savedInstanceState)

        // Initialize LocalizationManager
        com.skipfeed.android.data.LocalizationManager.getInstance().initialize(this)

        setContent {
            SkipFeedApp(searchRepository, usageAnalyticsRepository)
        }
    }
}

@Composable
fun SkipFeedApp(searchRepository: SearchRepository, usageAnalyticsRepository: UsageAnalyticsRepository) {
    val navController = rememberNavController()
    val localizationManager = remember { com.skipfeed.android.data.LocalizationManager.getInstance() }

    // Set layout direction based on current language
    val layoutDirection = if (localizationManager.isRightToLeft()) {
        LayoutDirection.Rtl
    } else {
        LayoutDirection.Ltr
    }

    CompositionLocalProvider(LocalLayoutDirection provides layoutDirection) {
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
            composable("search") { SearchScreen(navController, searchRepository, usageAnalyticsRepository) }
            composable("history") { HistoryScreen(searchRepository, usageAnalyticsRepository) }
            composable("stats") { StatisticsScreen() }
            composable("settings") { SettingsScreen(searchRepository, usageAnalyticsRepository) }
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
}

@Composable
fun IOSTabBar(
    navController: NavHostController,
    modifier: Modifier = Modifier
) {
    val navBackStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = navBackStackEntry?.destination?.route
    
    val tabs = listOf(
        TabItem("search", stringResource(R.string.search), Icons.Default.Search),
        TabItem("history", stringResource(R.string.history), Icons.Default.History),
        TabItem("stats", stringResource(R.string.stats), Icons.Default.BarChart),
        TabItem("settings", stringResource(R.string.settings), Icons.Default.Settings)
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
    PlatformInfo("Reddit", R.drawable.icon_reddit),
    PlatformInfo("YouTube", R.drawable.icon_youtube),
    PlatformInfo("X", R.drawable.icon_x),
    PlatformInfo("TikTok", R.drawable.icon_tiktok),
    PlatformInfo("Instagram", R.drawable.icon_instagram),
    PlatformInfo("Facebook", R.drawable.icon_facebook)
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

// Clear all search history (both SharedPreferences and Room database)
fun clearAllHistory(context: android.content.Context, searchRepository: SearchRepository? = null, usageAnalyticsRepository: UsageAnalyticsRepository? = null) {
    // Clear SharedPreferences (legacy storage)
    val sharedPrefs = context.getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE)
    sharedPrefs.edit().clear().apply()
    clearRecentSearches(context)

    // Clear Room database if repositories are available
    if (searchRepository != null && usageAnalyticsRepository != null) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                searchRepository.clearSearchHistory()
                usageAnalyticsRepository.clearAnalytics()
                CoroutineScope(Dispatchers.Main).launch {
                    Toast.makeText(context, "All data cleared successfully", Toast.LENGTH_SHORT).show()
                }
            } catch (e: Exception) {
                CoroutineScope(Dispatchers.Main).launch {
                    Toast.makeText(context, "Error clearing data: ${e.message}", Toast.LENGTH_SHORT).show()
                }
            }
        }
    } else {
        Toast.makeText(context, "Search history cleared", Toast.LENGTH_SHORT).show()
    }
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
fun SearchScreen(navController: NavHostController, searchRepository: SearchRepository, usageAnalyticsRepository: UsageAnalyticsRepository) {
    var searchQuery by remember { mutableStateOf("") }
    var selectedPlatform by remember { mutableStateOf("Reddit") }
    var searchMode by remember { mutableStateOf("Direct") } // Direct or In-App
    var showTikTokWebView by remember { mutableStateOf(false) }
    val context = LocalContext.current
    val coroutineScope = rememberCoroutineScope()

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
                    text = stringResource(R.string.tagline),
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
                    text = stringResource(R.string.choose_platform),
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
                        text = stringResource(R.string.tiktok_search_message),
                        fontSize = 14.sp,
                        color = Color(0xFF8E8E93),
                        lineHeight = 18.sp
                    )
                }

                Spacer(modifier = Modifier.height(20.dp))

                // Open TikTok Search button
                Button(
                    onClick = {
                        // Record analytics
                        coroutineScope.launch {
                            usageAnalyticsRepository.recordSearch(Platform.TIKTOK)
                        }

                        // Show in-app TikTok WebView
                        showTikTokWebView = true
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
                            text = stringResource(R.string.open_tiktok_search),
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
                                    stringResource(R.string.search_hint),
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
                            // Record analytics
                            val platform = when (selectedPlatform) {
                                "Reddit" -> Platform.REDDIT
                                "YouTube" -> Platform.YOUTUBE
                                "X" -> Platform.X
                                "TikTok" -> Platform.TIKTOK
                                "Instagram" -> Platform.INSTAGRAM
                                else -> Platform.REDDIT
                            }

                            coroutineScope.launch {
                                usageAnalyticsRepository.recordSearch(platform)
                            }

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
                            text = stringResource(R.string.recent_searches),
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
                text = stringResource(R.string.subtitle),
                fontSize = 15.sp,
                color = Color(0xFF8E8E93),
                textAlign = TextAlign.Center
            )
        }
    }

    // TikTok WebView Dialog
    if (showTikTokWebView) {
        TikTokWebViewDialog(
            onDismiss = { showTikTokWebView = false }
        )
    }
}

@Composable
fun IOSPlatformCard(
    platform: PlatformInfo,
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
fun HistoryScreen(searchRepository: SearchRepository, usageAnalyticsRepository: UsageAnalyticsRepository) {
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
                text = stringResource(R.string.search_history),
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
                            clearAllHistory(context, searchRepository, usageAnalyticsRepository)
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
                    text = stringResource(R.string.no_search_history),
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


// MARK: - Legal Content Functions

fun getPrivacyPolicyContent(): String {
    return """
SkipFeed Privacy Policy

Last updated: ${java.text.SimpleDateFormat("MMMM dd, yyyy", java.util.Locale.getDefault()).format(java.util.Date())}

1. Information We Collect
We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support.

2. How We Use Your Information
We use the information we collect to provide, maintain, and improve our services.

3. Information Sharing
We do not sell, trade, or otherwise transfer your personal information to third parties.

4. Data Security
We implement appropriate security measures to protect your personal information.

5. Contact Us
If you have any questions about this Privacy Policy, please contact us at privacy@skipfeed.app.
""".trimIndent()
}

fun getTermsOfServiceContent(): String {
    return """
SkipFeed Terms of Service

Last updated: ${java.text.SimpleDateFormat("MMMM dd, yyyy", java.util.Locale.getDefault()).format(java.util.Date())}

1. Acceptance of Terms
By using SkipFeed, you agree to these terms.

2. Description of Service
SkipFeed is a search aggregation service for social media platforms.

3. User Responsibilities
You are responsible for your use of the service and any content you access.

4. Privacy
Your privacy is important to us. Please review our Privacy Policy.

5. Modifications
We may modify these terms at any time.

6. Contact
Questions about these terms? Contact us at legal@skipfeed.app.
""".trimIndent()
}

fun getSupportFAQContent(): String {
    return """
SkipFeed Support & FAQ

Frequently Asked Questions

Q: How does SkipFeed work?
A: SkipFeed allows you to search across multiple social media platforms directly, without getting distracted by feeds or endless scrolling.

Q: Which platforms are supported?
A: We currently support Reddit, YouTube, X (Twitter), TikTok, Instagram, and Facebook.

Q: Is my data private?
A: Yes! All your search history and usage data is stored locally on your device. We don't collect or transmit your personal data.

Q: Can I export my search history?
A: Yes, you can export your search history in CSV, TXT, or JSON format from the Settings page.

Q: How do I change the language?
A: Go to Settings > Language to choose your preferred language or enable auto-detection.

Q: Can I customize platform order?
A: Yes! You can enable automatic ordering based on your usage frequency, or keep them in a fixed order.

Q: How do I clear my search history?
A: Go to Settings > Data Management > Clear All Data, or use the time filter options to clear specific periods.

Q: Is there a premium version?
A: Premium features are coming soon! Stay tuned for updates.

Q: How do I contact support?
A: Email us at support@skipfeed.app for any questions or issues.

Q: Where can I learn more?
A: Visit our website at https://skipfeed.app for more information.

Need more help?
Contact us at: support@skipfeed.app
""".trimIndent()
}

@Composable
fun SettingsScreen(searchRepository: SearchRepository, usageAnalyticsRepository: UsageAnalyticsRepository) {
    var showLanguageSelector by remember { mutableStateOf(false) }
    var showDataExport by remember { mutableStateOf(false) }
    var showClearDataDialog by remember { mutableStateOf(false) }
    var showPrivacyPolicy by remember { mutableStateOf(false) }
    var showTermsOfService by remember { mutableStateOf(false) }
    var showSupportFAQ by remember { mutableStateOf(false) }
    var showRetentionSelector by remember { mutableStateOf(false) }

    val context = LocalContext.current
    val localizationManager = remember { com.skipfeed.android.data.LocalizationManager.getInstance() }

    // User preferences state - load from SharedPreferences
    var autoDetectLanguage by remember {
        mutableStateOf(getUserPreference(context, "auto_detect_language", true))
    }
    var currentLanguage by remember {
        mutableStateOf(localizationManager.getCurrentLanguageDisplayName())
    }
    var automaticPlatformOrder by remember {
        mutableStateOf(getUserPreference(context, "automatic_platform_order", true))
    }
    var dataRetentionPeriod by remember {
        mutableStateOf(getUserPreference(context, "data_retention_period", "1 Month"))
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFF2F2F7)) // iOS grouped background
    ) {
        // iOS-style navigation bar
        Surface(
            modifier = Modifier.fillMaxWidth(),
            color = Color.White,
            shadowElevation = 0.5.dp
        ) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 60.dp, bottom = 16.dp),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = stringResource(R.string.settings),
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
            // Preferences Card
            item {
                ModernPreferencesCard(
                    autoDetectLanguage = autoDetectLanguage,
                    currentLanguage = currentLanguage,
                    onLanguageClick = { showLanguageSelector = true },
                    onAutoDetectToggle = {
                        autoDetectLanguage = it
                        saveUserPreferences(context, "auto_detect_language", it)
                        if (it) {
                            currentLanguage = "System Default"
                            saveUserPreferences(context, "current_language", "System Default")
                            applyLanguageChange(context, getSystemLanguage())
                        }
                    }
                )
            }

            // Data Management Card
            item {
                DataManagementCard(
                    dataRetentionPeriod = dataRetentionPeriod,
                    automaticPlatformOrder = automaticPlatformOrder,
                    onRetentionClick = { showRetentionSelector = true },
                    onPlatformOrderToggle = {
                    automaticPlatformOrder = it
                    saveUserPreferences(context, "automatic_platform_order", it)
                    // Apply platform ordering change immediately
                    applyPlatformOrderingChange(context, it)
                },
                    onExportClick = { showDataExport = true },
                    onClearDataClick = { showClearDataDialog = true }
                )
            }

            // About & Support Card
            item {
                AboutSupportCard(
                    onPrivacyPolicyClick = { showPrivacyPolicy = true },
                    onTermsClick = { showTermsOfService = true },
                    onSupportClick = { showSupportFAQ = true },
                    onContactClick = {
                        val intent = Intent(Intent.ACTION_SENDTO).apply {
                            data = Uri.parse("mailto:support@skipfeed.app")
                        }
                        context.startActivity(intent)
                    }
                )
            }
        }
    }

    // Dialogs and Sheets
    if (showLanguageSelector) {
        LanguageSelectorDialog(
            currentLanguage = currentLanguage,
            autoDetectLanguage = autoDetectLanguage,
            onLanguageSelected = { languageCode ->
                // LocalizationManager handles the restart
                localizationManager.setLanguage(context, languageCode)
                saveUserPreferences(context, "auto_detect_language", false)
                showLanguageSelector = false
            },
            onAutoDetectToggle = { enabled ->
                autoDetectLanguage = enabled
                saveUserPreferences(context, "auto_detect_language", enabled)
                if (enabled) {
                    val systemLang = localizationManager.getSystemLanguage()
                    // LocalizationManager handles the restart
                    localizationManager.setLanguage(context, systemLang)
                }
            },
            onDismiss = { showLanguageSelector = false }
        )
    }

    if (showDataExport) {
        DataExportDialog(
            onDismiss = { showDataExport = false },
            onExport = { format, timeRange, content ->
                exportSearchData(context, format, timeRange, content)
                showDataExport = false
            }
        )
    }

    if (showClearDataDialog) {
        AlertDialog(
            onDismissRequest = { showClearDataDialog = false },
            title = { Text("Clear All Data") },
            text = { Text("This will permanently delete all your search history and usage statistics. This action cannot be undone.") },
            confirmButton = {
                TextButton(
                    onClick = {
                        clearAllHistory(context, searchRepository, usageAnalyticsRepository)
                        showClearDataDialog = false
                    }
                ) {
                    Text("Clear", color = Color(0xFFFF3B30))
                }
            },
            dismissButton = {
                TextButton(onClick = { showClearDataDialog = false }) {
                    Text("Cancel")
                }
            }
        )
    }

    if (showRetentionSelector) {
        RetentionPeriodDialog(
            currentPeriod = dataRetentionPeriod,
            onPeriodSelected = { period ->
                dataRetentionPeriod = period
                saveUserPreferences(context, "data_retention_period", period)
                // Apply retention policy immediately
                applyDataRetentionPolicy(context, period)
                showRetentionSelector = false
            },
            onDismiss = { showRetentionSelector = false }
        )
    }

    if (showPrivacyPolicy) {
        InternalWebViewDialog(
            title = stringResource(R.string.privacy_policy_title),
            content = getPrivacyPolicyContent(),
            onDismiss = { showPrivacyPolicy = false }
        )
    }

    if (showTermsOfService) {
        InternalWebViewDialog(
            title = stringResource(R.string.terms_of_service_title),
            content = getTermsOfServiceContent(),
            onDismiss = { showTermsOfService = false }
        )
    }

    if (showSupportFAQ) {
        InternalWebViewDialog(
            title = stringResource(R.string.support_faq_title),
            content = getSupportFAQContent(),
            onDismiss = { showSupportFAQ = false }
        )
    }
}

// MARK: - Modern Card Components

@Composable
fun ModernPreferencesCard(
    autoDetectLanguage: Boolean,
    currentLanguage: String,
    onLanguageClick: () -> Unit,
    onAutoDetectToggle: (Boolean) -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(10.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            // Header
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Settings,
                    contentDescription = null,
                    tint = Color(0xFF007AFF),
                    modifier = Modifier.size(24.dp)
                )

                Spacer(modifier = Modifier.width(12.dp))

                Text(
                    text = stringResource(R.string.preferences),
                    fontSize = 18.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF1C1C1E)
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Language Settings Row
            ModernSettingRow(
                icon = Icons.Default.Language,
                title = stringResource(R.string.language),
                value = if (autoDetectLanguage) stringResource(R.string.auto_detect_language) else currentLanguage,
                onClick = onLanguageClick
            )
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

// MARK: - New Modern Components

@Composable
fun DataManagementCard(
    dataRetentionPeriod: String,
    automaticPlatformOrder: Boolean,
    onRetentionClick: () -> Unit,
    onPlatformOrderToggle: (Boolean) -> Unit,
    onExportClick: () -> Unit,
    onClearDataClick: () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(10.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            // Header
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Storage,
                    contentDescription = null,
                    tint = Color(0xFF007AFF),
                    modifier = Modifier.size(24.dp)
                )

                Spacer(modifier = Modifier.width(12.dp))

                Text(
                    text = stringResource(R.string.data_management),
                    fontSize = 18.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF1C1C1E)
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Data Retention Period
            ModernSettingRow(
                icon = Icons.Default.Schedule,
                title = stringResource(R.string.data_retention_period),
                value = dataRetentionPeriod,
                onClick = onRetentionClick
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Platform Order Toggle
            ModernToggleRow(
                icon = Icons.Default.SwapVert,
                title = stringResource(R.string.automatic_platform_order),
                subtitle = if (automaticPlatformOrder) "Platforms sorted by usage frequency" else "Platforms in fixed order",
                isOn = automaticPlatformOrder,
                onToggle = onPlatformOrderToggle
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Export Data
            ModernActionRow(
                icon = Icons.Default.Download,
                title = stringResource(R.string.export_data),
                isDestructive = false,
                onClick = onExportClick
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Clear All Data
            ModernActionRow(
                icon = Icons.Default.Delete,
                title = stringResource(R.string.clear_all_data),
                isDestructive = true,
                onClick = onClearDataClick
            )
        }
    }
}

@Composable
fun AboutSupportCard(
    onPrivacyPolicyClick: () -> Unit,
    onTermsClick: () -> Unit,
    onSupportClick: () -> Unit,
    onContactClick: () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(10.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            // Header
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Info,
                    contentDescription = null,
                    tint = Color(0xFF007AFF),
                    modifier = Modifier.size(24.dp)
                )

                Spacer(modifier = Modifier.width(12.dp))

                Text(
                    text = stringResource(R.string.about_support),
                    fontSize = 18.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF1C1C1E)
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // App Version
            ModernSettingRow(
                icon = Icons.Default.AppRegistration,
                title = "Version",
                value = "1.0.0",
                onClick = null
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Privacy Policy
            ModernActionRow(
                icon = Icons.Default.PrivacyTip,
                title = stringResource(R.string.privacy_policy),
                isDestructive = false,
                onClick = onPrivacyPolicyClick
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Terms of Service
            ModernActionRow(
                icon = Icons.Default.Description,
                title = stringResource(R.string.terms_of_service),
                isDestructive = false,
                onClick = onTermsClick
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Support & FAQ
            ModernActionRow(
                icon = Icons.Default.Help,
                title = stringResource(R.string.support_faq),
                isDestructive = false,
                onClick = onSupportClick
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Contact Us
            ModernActionRow(
                icon = Icons.Default.Email,
                title = stringResource(R.string.contact_us),
                isDestructive = false,
                onClick = onContactClick
            )
        }
    }
}

// MARK: - Modern Setting Components

@Composable
fun ModernSettingRow(
    icon: ImageVector,
    title: String,
    value: String,
    onClick: (() -> Unit)?
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .then(
                if (onClick != null) {
                    Modifier.clickable { onClick() }
                } else {
                    Modifier
                }
            )
            .padding(vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = Color(0xFF007AFF),
            modifier = Modifier.size(24.dp)
        )

        Spacer(modifier = Modifier.width(12.dp))

        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = title,
                fontSize = 16.sp,
                fontWeight = FontWeight.Medium,
                color = Color(0xFF1C1C1E)
            )

            if (value.isNotEmpty()) {
                Text(
                    text = value,
                    fontSize = 12.sp,
                    color = Color(0xFF8E8E93)
                )
            }
        }

        if (onClick != null) {
            Icon(
                imageVector = Icons.Default.ChevronRight,
                contentDescription = null,
                tint = Color(0xFF8E8E93),
                modifier = Modifier.size(16.dp)
            )
        }
    }
}

@Composable
fun ModernToggleRow(
    icon: ImageVector,
    title: String,
    subtitle: String,
    isOn: Boolean,
    onToggle: (Boolean) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = Color(0xFF007AFF),
            modifier = Modifier.size(24.dp)
        )

        Spacer(modifier = Modifier.width(12.dp))

        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = title,
                fontSize = 16.sp,
                fontWeight = FontWeight.Medium,
                color = Color(0xFF1C1C1E)
            )

            Text(
                text = subtitle,
                fontSize = 12.sp,
                color = Color(0xFF8E8E93)
            )
        }

        Switch(
            checked = isOn,
            onCheckedChange = onToggle,
            colors = SwitchDefaults.colors(
                checkedThumbColor = Color.White,
                checkedTrackColor = Color(0xFF34C759),
                uncheckedThumbColor = Color.White,
                uncheckedTrackColor = Color(0xFF8E8E93)
            )
        )
    }
}

@Composable
fun ModernActionRow(
    icon: ImageVector,
    title: String,
    isDestructive: Boolean,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() }
            .padding(vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = if (isDestructive) Color(0xFFFF3B30) else Color(0xFF007AFF),
            modifier = Modifier.size(24.dp)
        )

        Spacer(modifier = Modifier.width(12.dp))

        Text(
            text = title,
            fontSize = 16.sp,
            fontWeight = FontWeight.Medium,
            color = if (isDestructive) Color(0xFFFF3B30) else Color(0xFF1C1C1E),
            modifier = Modifier.weight(1f)
        )

        Icon(
            imageVector = Icons.Default.ChevronRight,
            contentDescription = null,
            tint = Color(0xFF8E8E93),
            modifier = Modifier.size(16.dp)
        )
    }
}

// MARK: - Dialog Components

@Composable
fun LanguageSelectorDialog(
    currentLanguage: String,
    autoDetectLanguage: Boolean,
    onLanguageSelected: (String) -> Unit,
    onAutoDetectToggle: (Boolean) -> Unit,
    onDismiss: () -> Unit
) {
    val localizationManager = remember { com.skipfeed.android.data.LocalizationManager.getInstance() }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.language)) },
        text = {
            LazyColumn {
                item {
                    // Auto-detect toggle
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 8.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.LocationOn,
                            contentDescription = null,
                            tint = Color(0xFF007AFF),
                            modifier = Modifier.size(24.dp)
                        )

                        Spacer(modifier = Modifier.width(12.dp))

                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = stringResource(R.string.auto_detect_language),
                                fontSize = 16.sp,
                                fontWeight = FontWeight.Medium
                            )
                            Text(
                                text = stringResource(R.string.use_system_language),
                                fontSize = 12.sp,
                                color = Color(0xFF8E8E93)
                            )
                        }

                        Switch(
                            checked = autoDetectLanguage,
                            onCheckedChange = onAutoDetectToggle,
                            colors = SwitchDefaults.colors(
                                checkedThumbColor = Color.White,
                                checkedTrackColor = Color(0xFF34C759)
                            )
                        )
                    }

                    Spacer(modifier = Modifier.height(16.dp))
                }

                // Exactly 11 language items - using LazyColumn items
                items(11) { index ->
                    val (code, name) = when (index) {
                        0 -> "ar" to "العربية"
                        1 -> "zh" to "中文"
                        2 -> "de" to "Deutsch"
                        3 -> "en" to "English"
                        4 -> "es" to "Español"
                        5 -> "fr" to "Français"
                        6 -> "it" to "Italiano"
                        7 -> "ja" to "日本語"
                        8 -> "ko" to "한국어"
                        9 -> "pt" to "Português"
                        10 -> "ru" to "Русский"
                        else -> "en" to "English" // fallback
                    }

                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { onLanguageSelected(code) }
                            .padding(vertical = 8.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        RadioButton(
                            selected = localizationManager.currentLanguage == code && !autoDetectLanguage,
                            onClick = { onLanguageSelected(code) },
                            colors = RadioButtonDefaults.colors(selectedColor = Color(0xFF007AFF))
                        )
                        Spacer(modifier = Modifier.width(12.dp))
                        Text(text = name, fontSize = 16.sp, color = Color(0xFF1C1C1E))
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = onDismiss) {
                Text(stringResource(R.string.done), color = Color(0xFF007AFF))
            }
        }
    )
}

@Composable
fun DataExportDialog(
    onDismiss: () -> Unit,
    onExport: (format: String, timeRange: String, content: List<String>) -> Unit
) {
    var selectedFormat by remember { mutableStateOf("CSV") }
    var selectedTimeRange by remember { mutableStateOf("All Time") }
    var includeSearchQueries by remember { mutableStateOf(true) }
    var includePlatformUsage by remember { mutableStateOf(true) }
    var includeUsageStatistics by remember { mutableStateOf(true) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Export Data") },
        text = {
            Column {
                // Format Selection
                Text(
                    text = "Export Format",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color(0xFF1C1C1E)
                )

                Spacer(modifier = Modifier.height(8.dp))

                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    val formats = listOf("CSV", "TXT", "JSON")
                    formats.forEach { format ->
                        FilterChip(
                            text = format,
                            isSelected = selectedFormat == format,
                            onClick = { selectedFormat = format }
                        )
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Time Range Selection
                Text(
                    text = "Time Range",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color(0xFF1C1C1E)
                )

                Spacer(modifier = Modifier.height(8.dp))

                val timeRanges = listOf("All Time", "Last 7 Days", "Last 30 Days", "Last 3 Months")
                timeRanges.forEach { range ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { selectedTimeRange = range }
                            .padding(vertical = 4.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        RadioButton(
                            selected = selectedTimeRange == range,
                            onClick = { selectedTimeRange = range },
                            colors = RadioButtonDefaults.colors(
                                selectedColor = Color(0xFF007AFF)
                            )
                        )

                        Spacer(modifier = Modifier.width(8.dp))

                        Text(
                            text = range,
                            fontSize = 14.sp,
                            color = Color(0xFF1C1C1E)
                        )
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Content Selection
                Text(
                    text = "Export Content",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color(0xFF1C1C1E)
                )

                Spacer(modifier = Modifier.height(8.dp))

                // Search Queries Toggle
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Switch(
                        checked = includeSearchQueries,
                        onCheckedChange = { includeSearchQueries = it },
                        colors = SwitchDefaults.colors(
                            checkedThumbColor = Color.White,
                            checkedTrackColor = Color(0xFF007AFF),
                            uncheckedThumbColor = Color.White,
                            uncheckedTrackColor = Color(0xFF8E8E93)
                        ),
                        modifier = Modifier.scale(0.8f)
                    )

                    Spacer(modifier = Modifier.width(8.dp))

                    Column {
                        Text(
                            text = "Search Queries",
                            fontSize = 14.sp,
                            color = Color(0xFF1C1C1E)
                        )
                        Text(
                            text = "All search terms and timestamps",
                            fontSize = 12.sp,
                            color = Color(0xFF8E8E93)
                        )
                    }
                }

                // Platform Usage Toggle
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Switch(
                        checked = includePlatformUsage,
                        onCheckedChange = { includePlatformUsage = it },
                        colors = SwitchDefaults.colors(
                            checkedThumbColor = Color.White,
                            checkedTrackColor = Color(0xFF007AFF),
                            uncheckedThumbColor = Color.White,
                            uncheckedTrackColor = Color(0xFF8E8E93)
                        ),
                        modifier = Modifier.scale(0.8f)
                    )

                    Spacer(modifier = Modifier.width(8.dp))

                    Column {
                        Text(
                            text = "Platform Usage",
                            fontSize = 14.sp,
                            color = Color(0xFF1C1C1E)
                        )
                        Text(
                            text = "Which platforms you searched most",
                            fontSize = 12.sp,
                            color = Color(0xFF8E8E93)
                        )
                    }
                }

                // Usage Statistics Toggle
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Switch(
                        checked = includeUsageStatistics,
                        onCheckedChange = { includeUsageStatistics = it },
                        colors = SwitchDefaults.colors(
                            checkedThumbColor = Color.White,
                            checkedTrackColor = Color(0xFF007AFF),
                            uncheckedThumbColor = Color.White,
                            uncheckedTrackColor = Color(0xFF8E8E93)
                        ),
                        modifier = Modifier.scale(0.8f)
                    )

                    Spacer(modifier = Modifier.width(8.dp))

                    Column {
                        Text(
                            text = "Usage Statistics",
                            fontSize = 14.sp,
                            color = Color(0xFF1C1C1E)
                        )
                        Text(
                            text = "Search counts and time saved data",
                            fontSize = 12.sp,
                            color = Color(0xFF8E8E93)
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(
                onClick = {
                    val content = mutableListOf<String>()
                    if (includeSearchQueries) content.add("queries")
                    if (includePlatformUsage) content.add("platforms")
                    if (includeUsageStatistics) content.add("statistics")
                    onExport(selectedFormat, selectedTimeRange, content)
                }
            ) {
                Text("Export", color = Color(0xFF007AFF))
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Cancel")
            }
        }
    )
}

@Composable
fun RetentionPeriodDialog(
    currentPeriod: String,
    onPeriodSelected: (String) -> Unit,
    onDismiss: () -> Unit
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Data Retention Period") },
        text = {
            Column {
                Text(
                    text = "How long should search history be kept?",
                    fontSize = 14.sp,
                    color = Color(0xFF8E8E93),
                    modifier = Modifier.padding(bottom = 16.dp)
                )

                val periods = listOf(
                    "7 Days",
                    "30 Days",
                    "3 Months",
                    "1 Year",
                    "Forever"
                )

                periods.forEach { period ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { onPeriodSelected(period) }
                            .padding(vertical = 8.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        RadioButton(
                            selected = currentPeriod == period,
                            onClick = { onPeriodSelected(period) },
                            colors = RadioButtonDefaults.colors(
                                selectedColor = Color(0xFF007AFF)
                            )
                        )

                        Spacer(modifier = Modifier.width(12.dp))

                        Text(
                            text = period,
                            fontSize = 16.sp,
                            color = Color(0xFF1C1C1E)
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = onDismiss) {
                Text("Done", color = Color(0xFF007AFF))
            }
        }
    )
}

@Composable
fun WebViewDialog(
    title: String,
    url: String,
    onDismiss: () -> Unit,
    onOpenUrl: (String) -> Unit
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = {
            Column {
                Text(
                    text = "This will open in your browser:",
                    fontSize = 14.sp,
                    color = Color(0xFF8E8E93)
                )

                Spacer(modifier = Modifier.height(8.dp))

                Text(
                    text = url,
                    fontSize = 14.sp,
                    color = Color(0xFF007AFF),
                    modifier = Modifier.padding(8.dp)
                )
            }
        },
        confirmButton = {
            TextButton(
                onClick = {
                    onOpenUrl(url)
                    onDismiss()
                }
            ) {
                Text("Open", color = Color(0xFF007AFF))
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Cancel")
            }
        }
    )
}

// MARK: - User Preferences Management

fun saveUserPreferences(context: android.content.Context, key: String, value: String) {
    val sharedPrefs = context.getSharedPreferences("user_preferences", android.content.Context.MODE_PRIVATE)
    sharedPrefs.edit().putString(key, value).apply()
}

fun saveUserPreferences(context: android.content.Context, key: String, value: Boolean) {
    val sharedPrefs = context.getSharedPreferences("user_preferences", android.content.Context.MODE_PRIVATE)
    sharedPrefs.edit().putBoolean(key, value).apply()
}

fun getUserPreference(context: android.content.Context, key: String, defaultValue: String): String {
    val sharedPrefs = context.getSharedPreferences("user_preferences", android.content.Context.MODE_PRIVATE)
    return sharedPrefs.getString(key, defaultValue) ?: defaultValue
}

fun getUserPreference(context: android.content.Context, key: String, defaultValue: Boolean): Boolean {
    val sharedPrefs = context.getSharedPreferences("user_preferences", android.content.Context.MODE_PRIVATE)
    return sharedPrefs.getBoolean(key, defaultValue)
}

// Export data functionality
fun exportSearchData(context: android.content.Context, format: String, timeRange: String, content: List<String>) {
    val historyItems = loadSearchHistory(context)

    // Filter by time range
    val filteredItems = when (timeRange) {
        "Last 7 Days" -> {
            val weekAgo = System.currentTimeMillis() - (7 * 24 * 60 * 60 * 1000)
            historyItems.filter { it.timestampMillis >= weekAgo }
        }
        "Last 30 Days" -> {
            val monthAgo = System.currentTimeMillis() - (30 * 24 * 60 * 60 * 1000)
            historyItems.filter { it.timestampMillis >= monthAgo }
        }
        "Last 3 Months" -> {
            val threeMonthsAgo = System.currentTimeMillis() - (90 * 24 * 60 * 60 * 1000)
            historyItems.filter { it.timestampMillis >= threeMonthsAgo }
        }
        else -> historyItems // All Time
    }

    // Generate export content based on format
    val exportContent = when (format) {
        "CSV" -> generateCSVContent(filteredItems, content)
        "TXT" -> generateTXTContent(filteredItems, content)
        "JSON" -> generateJSONContent(filteredItems, content)
        else -> generateCSVContent(filteredItems, content)
    }

    // Create and share file
    shareExportedData(context, exportContent, format.lowercase())
}

fun generateCSVContent(items: List<HistoryItem>, content: List<String>): String {
    val sb = StringBuilder()

    if (content.contains("queries")) {
        sb.append("Query,Platform,Timestamp,Date\n")
        items.forEach { item ->
            val date = java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", java.util.Locale.getDefault())
                .format(java.util.Date(item.timestampMillis))
            sb.append("\"${item.query}\",\"${item.platform}\",\"${item.timestamp}\",\"$date\"\n")
        }
    }

    if (content.contains("platforms")) {
        sb.append("\nPlatform Usage:\n")
        val platformCounts = items.groupBy { it.platform }.mapValues { it.value.size }
        platformCounts.forEach { (platform, count) ->
            sb.append("$platform,$count\n")
        }
    }

    if (content.contains("statistics")) {
        sb.append("\nStatistics:\n")
        sb.append("Total Searches,${items.size}\n")
        sb.append("Unique Queries,${items.map { it.query }.distinct().size}\n")
        sb.append("Platforms Used,${items.map { it.platform }.distinct().size}\n")
    }

    return sb.toString()
}

fun generateTXTContent(items: List<HistoryItem>, content: List<String>): String {
    val sb = StringBuilder()
    sb.append("SkipFeed Data Export\n")
    sb.append("Generated: ${java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", java.util.Locale.getDefault()).format(java.util.Date())}\n\n")

    if (content.contains("queries")) {
        sb.append("SEARCH HISTORY:\n")
        sb.append("================\n")
        items.forEach { item ->
            val date = java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss", java.util.Locale.getDefault())
                .format(java.util.Date(item.timestampMillis))
            sb.append("Query: ${item.query}\n")
            sb.append("Platform: ${item.platform}\n")
            sb.append("Time: ${item.timestamp}\n")
            sb.append("Date: $date\n\n")
        }
    }

    if (content.contains("platforms")) {
        sb.append("PLATFORM USAGE:\n")
        sb.append("===============\n")
        val platformCounts = items.groupBy { it.platform }.mapValues { it.value.size }
        platformCounts.forEach { (platform, count) ->
            sb.append("$platform: $count searches\n")
        }
        sb.append("\n")
    }

    if (content.contains("statistics")) {
        sb.append("STATISTICS:\n")
        sb.append("===========\n")
        sb.append("Total Searches: ${items.size}\n")
        sb.append("Unique Queries: ${items.map { it.query }.distinct().size}\n")
        sb.append("Platforms Used: ${items.map { it.platform }.distinct().size}\n")
    }

    return sb.toString()
}

fun generateJSONContent(items: List<HistoryItem>, content: List<String>): String {
    val sb = StringBuilder()
    sb.append("{\n")
    sb.append("  \"export_info\": {\n")
    sb.append("    \"app\": \"SkipFeed\",\n")
    sb.append("    \"version\": \"1.0.0\",\n")
    sb.append("    \"generated\": \"${java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", java.util.Locale.getDefault()).format(java.util.Date())}\"\n")
    sb.append("  },\n")

    if (content.contains("queries")) {
        sb.append("  \"search_history\": [\n")
        items.forEachIndexed { index, item ->
            val date = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", java.util.Locale.getDefault())
                .format(java.util.Date(item.timestampMillis))
            sb.append("    {\n")
            sb.append("      \"query\": \"${item.query}\",\n")
            sb.append("      \"platform\": \"${item.platform}\",\n")
            sb.append("      \"timestamp\": \"${item.timestamp}\",\n")
            sb.append("      \"date\": \"$date\"\n")
            sb.append("    }")
            if (index < items.size - 1) sb.append(",")
            sb.append("\n")
        }
        sb.append("  ]")
        if (content.contains("platforms") || content.contains("statistics")) sb.append(",")
        sb.append("\n")
    }

    if (content.contains("platforms")) {
        sb.append("  \"platform_usage\": {\n")
        val platformCounts = items.groupBy { it.platform }.mapValues { it.value.size }
        platformCounts.entries.forEachIndexed { index, (platform, count) ->
            sb.append("    \"$platform\": $count")
            if (index < platformCounts.size - 1) sb.append(",")
            sb.append("\n")
        }
        sb.append("  }")
        if (content.contains("statistics")) sb.append(",")
        sb.append("\n")
    }

    if (content.contains("statistics")) {
        sb.append("  \"statistics\": {\n")
        sb.append("    \"total_searches\": ${items.size},\n")
        sb.append("    \"unique_queries\": ${items.map { it.query }.distinct().size},\n")
        sb.append("    \"platforms_used\": ${items.map { it.platform }.distinct().size}\n")
        sb.append("  }\n")
    }

    sb.append("}")
    return sb.toString()
}

fun shareExportedData(context: android.content.Context, content: String, format: String) {
    try {
        val fileName = "skipfeed_export_${System.currentTimeMillis()}.$format"
        val file = java.io.File(context.cacheDir, fileName)
        file.writeText(content)

        val uri = androidx.core.content.FileProvider.getUriForFile(
            context,
            "${context.packageName}.fileprovider",
            file
        )

        val shareIntent = Intent(Intent.ACTION_SEND).apply {
            type = when (format) {
                "csv" -> "text/csv"
                "json" -> "application/json"
                else -> "text/plain"
            }
            putExtra(Intent.EXTRA_STREAM, uri)
            putExtra(Intent.EXTRA_SUBJECT, "SkipFeed Data Export")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        context.startActivity(Intent.createChooser(shareIntent, "Share Export"))
    } catch (e: Exception) {
        // Handle error - could show a toast
        android.util.Log.e("SkipFeed", "Error sharing export: ${e.message}")
    }
}

// MARK: - Language Management Functions

fun getSystemLanguage(): String {
    return java.util.Locale.getDefault().language
}

fun applyLanguageChange(context: android.content.Context, languageCode: String) {
    // Save the language preference
    saveUserPreferences(context, "app_language", languageCode)

    // Apply locale change (requires activity restart for full effect)
    val locale = when (languageCode) {
        "English" -> java.util.Locale.ENGLISH
        "中文" -> java.util.Locale.CHINESE
        "Español" -> java.util.Locale("es")
        "Français" -> java.util.Locale.FRENCH
        "Deutsch" -> java.util.Locale.GERMAN
        "日本語" -> java.util.Locale.JAPANESE
        else -> java.util.Locale.ENGLISH
    }

    java.util.Locale.setDefault(locale)

    val config = context.resources.configuration
    config.setLocale(locale)

    // Restart the activity to apply language changes
    if (context is android.app.Activity) {
        val intent = context.intent
        context.finish()
        context.startActivity(intent)
    }
}

// MARK: - Data Retention Functions

fun applyDataRetentionPolicy(context: android.content.Context, period: String) {
    val historyItems = loadSearchHistory(context)
    val cutoffTime = when (period) {
        "7 Days" -> System.currentTimeMillis() - (7 * 24 * 60 * 60 * 1000L)
        "30 Days" -> System.currentTimeMillis() - (30 * 24 * 60 * 60 * 1000L)
        "3 Months" -> System.currentTimeMillis() - (90 * 24 * 60 * 60 * 1000L)
        "1 Year" -> System.currentTimeMillis() - (365 * 24 * 60 * 60 * 1000L)
        "Forever" -> 0L
        else -> System.currentTimeMillis() - (30 * 24 * 60 * 60 * 1000L)
    }

    if (cutoffTime > 0) {
        val filteredItems = historyItems.filter { it.timestampMillis >= cutoffTime }
        saveSearchHistory(context, filteredItems)
    }
}

fun saveSearchHistory(context: android.content.Context, items: List<HistoryItem>) {
    val sharedPrefs = context.getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE)
    val editor = sharedPrefs.edit()

    // Clear existing history
    editor.clear()

    // Save new filtered history
    items.forEachIndexed { index, item ->
        editor.putString("query_$index", item.query)
        editor.putString("platform_$index", item.platform)
        editor.putString("timestamp_$index", item.timestamp)
        editor.putLong("timestamp_millis_$index", item.timestampMillis)
        editor.putInt("icon_$index", item.iconRes)
    }

    editor.putInt("history_count", items.size)
    editor.apply()
}

// MARK: - Platform Ordering Functions

fun applyPlatformOrderingChange(context: android.content.Context, isAutomatic: Boolean) {
    // Save the preference
    saveUserPreferences(context, "platform_ordering_mode", if (isAutomatic) "automatic" else "manual")

    if (isAutomatic) {
        // Reorder platforms based on usage frequency
        reorderPlatformsByUsage(context)
    } else {
        // Reset to default order
        resetPlatformsToDefaultOrder(context)
    }
}

fun reorderPlatformsByUsage(context: android.content.Context) {
    val historyItems = loadSearchHistory(context)
    val platformCounts = historyItems.groupBy { it.platform }.mapValues { it.value.size }

    // Sort platforms by usage count (descending)
    val sortedPlatforms = platformCounts.toList().sortedByDescending { it.second }

    // Save the new order
    val sharedPrefs = context.getSharedPreferences("platform_order", android.content.Context.MODE_PRIVATE)
    val editor = sharedPrefs.edit()

    sortedPlatforms.forEachIndexed { index, (platform, _) ->
        editor.putString("platform_$index", platform)
    }
    editor.putInt("platform_count", sortedPlatforms.size)
    editor.apply()
}

fun resetPlatformsToDefaultOrder(context: android.content.Context) {
    val defaultOrder = listOf("Reddit", "YouTube", "X", "TikTok", "Instagram", "Facebook")

    val sharedPrefs = context.getSharedPreferences("platform_order", android.content.Context.MODE_PRIVATE)
    val editor = sharedPrefs.edit()

    defaultOrder.forEachIndexed { index, platform ->
        editor.putString("platform_$index", platform)
    }
    editor.putInt("platform_count", defaultOrder.size)
    editor.apply()
}

// MARK: - Internal WebView Dialog

@Composable
fun InternalWebViewDialog(
    title: String,
    content: String,
    onDismiss: () -> Unit
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Text(
                text = title,
                fontSize = 18.sp,
                fontWeight = FontWeight.SemiBold
            )
        },
        text = {
            LazyColumn(
                modifier = Modifier
                    .fillMaxWidth()
                    .heightIn(max = 400.dp)
            ) {
                item {
                    Text(
                        text = content,
                        fontSize = 14.sp,
                        lineHeight = 20.sp,
                        color = Color(0xFF1C1C1E)
                    )
                }
            }
        },
        confirmButton = {
            TextButton(onClick = onDismiss) {
                Text("Close", color = Color(0xFF007AFF))
            }
        }
    )
}
