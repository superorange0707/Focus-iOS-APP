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
    
    // iOS-style tab bar - clean without extra lines
    Box(
        modifier = modifier
            .fillMaxWidth()
            .background(Color.White.copy(alpha = 0.95f))
            .padding(bottom = 34.dp) // Space for home indicator
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
    val timestamp = SimpleDateFormat("h:mm:ss a", Locale.getDefault()).format(Date())

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

        if (query.isNotEmpty() && platform.isNotEmpty()) {
            val iconRes = when (platform) {
                "Reddit" -> R.drawable.icon_reddit
                "YouTube" -> R.drawable.icon_youtube
                "X" -> R.drawable.icon_x
                "TikTok" -> R.drawable.icon_tiktok
                "Instagram" -> R.drawable.icon_instagram
                "Facebook" -> R.drawable.icon_facebook
                else -> R.drawable.icon_reddit
            }
            historyItems.add(HistoryItem(query, platform, timestamp, iconRes))
        }
    }

    // If no history, return sample data
    if (historyItems.isEmpty()) {
        return listOf(
            HistoryItem("Skip", "YouTube", "2:40:55 am", R.drawable.icon_youtube),
            HistoryItem("Skip", "Reddit", "1:42:46 am", R.drawable.icon_reddit),
            HistoryItem("Skipfeed", "Reddit", "12:35:47 am", R.drawable.icon_reddit)
        )
    }

    return historyItems
}

// Delete search history item
fun deleteSearchHistory(context: android.content.Context, item: HistoryItem) {
    val sharedPrefs = context.getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE)
    val allEntries = sharedPrefs.all

    // Find and delete the matching entry
    for ((key, _) in allEntries) {
        if (key.endsWith("_query")) {
            val baseKey = key.replace("_query", "")
            val query = sharedPrefs.getString("${baseKey}_query", "")
            val platform = sharedPrefs.getString("${baseKey}_platform", "")
            val timestamp = sharedPrefs.getString("${baseKey}_timestamp", "")

            if (query == item.query && platform == item.platform && timestamp == item.timestamp) {
                sharedPrefs.edit()
                    .remove("${baseKey}_query")
                    .remove("${baseKey}_platform")
                    .remove("${baseKey}_timestamp")
                    .apply()
                break
            }
        }
    }
}

// Clear all search history
fun clearAllHistory(context: android.content.Context) {
    val sharedPrefs = context.getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE)
    sharedPrefs.edit().clear().apply()
    Toast.makeText(context, "Search history cleared", Toast.LENGTH_SHORT).show()
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

                // Search mode toggle - only show for Reddit
                if (selectedPlatform == "Reddit") {
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
                }

                // Search button - exactly like iOS
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

        // Recent searches section - exactly like iOS
        if (recentSearches.isNotEmpty() && searchQuery.isEmpty() && selectedPlatform != "TikTok") {
            Spacer(modifier = Modifier.height(28.dp))

            Column(
                modifier = Modifier.fillMaxWidth(),
                verticalArrangement = Arrangement.spacedBy(15.dp)
            ) {
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
    var isSelectionMode by remember { mutableStateOf(false) }
    var selectedItems by remember { mutableStateOf(setOf<String>()) }
    val context = LocalContext.current
    var historyItems by remember { mutableStateOf(loadSearchHistory(context)) }

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

        // Calculate filtered items first
        val filteredItems = if (selectedFilter == "All") {
            historyItems
        } else {
            historyItems.filter { it.platform == selectedFilter }
        }.filter {
            if (searchQuery.isBlank()) true
            else it.query.contains(searchQuery, ignoreCase = true)
        }

        // Select and Clear All buttons - exactly like iOS
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            if (isSelectionMode) {
                Row {
                    TextButton(
                        onClick = {
                            // Select all items
                            selectedItems = filteredItems.map { "${it.query}_${it.platform}_${it.timestamp}" }.toSet()
                        }
                    ) {
                        Text(
                            text = "Select All",
                            color = Color(0xFF007AFF),
                            fontSize = 17.sp
                        )
                    }

                    TextButton(
                        onClick = {
                            // Delete selected items
                            selectedItems.forEach { itemKey ->
                                val parts = itemKey.split("_")
                                if (parts.size >= 3) {
                                    val query = parts[0]
                                    val platform = parts[1]
                                    val timestamp = parts[2]
                                    val item = HistoryItem(query, platform, timestamp, 0)
                                    deleteSearchHistory(context, item)
                                }
                            }
                            historyItems = loadSearchHistory(context)
                            selectedItems = setOf()
                            isSelectionMode = false
                        }
                    ) {
                        Text(
                            text = "Delete (${selectedItems.size})",
                            color = Color(0xFFFF3B30),
                            fontSize = 17.sp
                        )
                    }

                    TextButton(
                        onClick = {
                            isSelectionMode = false
                            selectedItems = setOf()
                        }
                    ) {
                        Text(
                            text = "Cancel",
                            color = Color(0xFF8E8E93),
                            fontSize = 17.sp
                        )
                    }
                }
            } else {
                TextButton(
                    onClick = {
                        isSelectionMode = true
                        selectedItems = setOf()
                    }
                ) {
                    Text(
                        text = "Select",
                        color = Color(0xFF007AFF),
                        fontSize = 17.sp
                    )
                }

                TextButton(
                    onClick = {
                        clearAllHistory(context)
                        historyItems = loadSearchHistory(context)
                    }
                ) {
                    Text(
                        text = "Clear All",
                        color = Color(0xFFFF3B30),
                        fontSize = 17.sp
                    )
                }
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

        // History items - real data
        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(1.dp)
        ) {
            items(filteredItems) { item ->
                val itemKey = "${item.query}_${item.platform}_${item.timestamp}"
                IOSHistoryItem(
                    item = item,
                    isSelectionMode = isSelectionMode,
                    isSelected = selectedItems.contains(itemKey),
                    onDelete = {
                        // Delete from history
                        deleteSearchHistory(context, item)
                        historyItems = loadSearchHistory(context)
                    },
                    onRestore = {
                        // Restore/repeat search with original mode
                        val originalMode = getSearchMode(context, item)
                        performSearch(context, item.platform, item.query, originalMode)
                    },
                    onSelectionToggle = {
                        selectedItems = if (selectedItems.contains(itemKey)) {
                            selectedItems - itemKey
                        } else {
                            selectedItems + itemKey
                        }
                    }
                )
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
fun IOSHistoryItem(
    item: HistoryItem,
    isSelectionMode: Boolean = false,
    isSelected: Boolean = false,
    onDelete: () -> Unit = {},
    onRestore: () -> Unit = {},
    onSelectionToggle: () -> Unit = {}
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable {
                if (isSelectionMode) {
                    onSelectionToggle()
                }
            },
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(
            containerColor = if (isSelected) Color(0xFF007AFF).copy(alpha = 0.1f) else Color.White
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Selection checkbox (only in selection mode)
            if (isSelectionMode) {
                Checkbox(
                    checked = isSelected,
                    onCheckedChange = { onSelectionToggle() },
                    colors = CheckboxDefaults.colors(
                        checkedColor = Color(0xFF007AFF)
                    )
                )
                Spacer(modifier = Modifier.width(8.dp))
            }

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

            // Action buttons - exactly like iOS (only in normal mode)
            if (!isSelectionMode) {
                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    IconButton(
                        onClick = onDelete
                    ) {
                        Icon(
                            imageVector = Icons.Default.Delete,
                            contentDescription = "Delete",
                            tint = Color(0xFFFF3B30),
                            modifier = Modifier.size(20.dp)
                        )
                    }

                    IconButton(
                        onClick = onRestore
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
