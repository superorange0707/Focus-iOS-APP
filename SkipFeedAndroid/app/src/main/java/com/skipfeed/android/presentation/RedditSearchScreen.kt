package com.skipfeed.android.presentation

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import com.skipfeed.android.data.*
import com.skipfeed.android.presentation.components.RedditPostDetailDialog
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RedditSearchScreen(
    query: String,
    onDismiss: () -> Unit
) {
    val viewModel: RedditSearchViewModel = viewModel()
    val uiState by viewModel.uiState.collectAsState()
    val context = LocalContext.current
    var selectedPost by remember { mutableStateOf<RedditPost?>(null) }
    
    LaunchedEffect(query) {
        viewModel.searchPosts(query)
    }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Reddit") },
                navigationIcon = {
                    IconButton(onClick = onDismiss) {
                        Icon(Icons.Default.Close, contentDescription = "Close")
                    }
                },
                actions = {
                    IconButton(onClick = { viewModel.toggleFilters() }) {
                        Icon(Icons.Default.FilterList, contentDescription = "Filters")
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Color.White
                )
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .background(Color(0xFFF2F2F7))
        ) {
            // Filter bar
            if (uiState.showFilters) {
                FilterBar(
                    selectedSort = uiState.selectedSort,
                    selectedTimeFilter = uiState.selectedTimeFilter,
                    onSortChange = { viewModel.updateSort(it, query) },
                    onTimeFilterChange = { viewModel.updateTimeFilter(it, query) }
                )
            }
            
            // Content
            when {
                uiState.isLoading && uiState.posts.isEmpty() -> {
                    LoadingView()
                }
                uiState.error != null -> {
                    ErrorView(
                        error = uiState.error!!,
                        onRetry = { viewModel.searchPosts(query) }
                    )
                }
                uiState.posts.isEmpty() -> {
                    EmptyView(query = query)
                }
                else -> {
                    PostsList(
                        posts = uiState.posts,
                        isLoadingMore = uiState.isLoadingMore,
                        hasMorePosts = uiState.hasMorePosts,
                        onLoadMore = { viewModel.loadMorePosts() },
                        onPostClick = { post ->
                            // Show post detail dialog
                            selectedPost = post
                        }
                    )
                }
            }
        }
    }

    // Show post detail dialog
    selectedPost?.let { post ->
        RedditPostDetailDialog(
            post = post,
            onDismiss = { selectedPost = null }
        )
    }
}

@Composable
fun FilterBar(
    selectedSort: RedditSort,
    selectedTimeFilter: RedditTimeFilter,
    onSortChange: (RedditSort) -> Unit,
    onTimeFilterChange: (RedditTimeFilter) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        // Sort dropdown
        var sortExpanded by remember { mutableStateOf(false) }
        
        Box {
            Button(
                onClick = { sortExpanded = true },
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.White,
                    contentColor = Color(0xFF1C1C1E)
                ),
                shape = RoundedCornerShape(8.dp)
            ) {
                Text(selectedSort.displayName)
                Icon(Icons.Default.ArrowDropDown, contentDescription = null)
            }
            
            DropdownMenu(
                expanded = sortExpanded,
                onDismissRequest = { sortExpanded = false }
            ) {
                RedditSort.values().forEach { sort ->
                    DropdownMenuItem(
                        text = { Text(sort.displayName) },
                        onClick = {
                            onSortChange(sort)
                            sortExpanded = false
                        }
                    )
                }
            }
        }
        
        // Time filter dropdown
        var timeExpanded by remember { mutableStateOf(false) }
        
        Box {
            Button(
                onClick = { timeExpanded = true },
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.White,
                    contentColor = Color(0xFF1C1C1E)
                ),
                shape = RoundedCornerShape(8.dp)
            ) {
                Text(selectedTimeFilter.displayName)
                Icon(Icons.Default.ArrowDropDown, contentDescription = null)
            }
            
            DropdownMenu(
                expanded = timeExpanded,
                onDismissRequest = { timeExpanded = false }
            ) {
                RedditTimeFilter.values().forEach { filter ->
                    DropdownMenuItem(
                        text = { Text(filter.displayName) },
                        onClick = {
                            onTimeFilterChange(filter)
                            timeExpanded = false
                        }
                    )
                }
            }
        }
    }
}

@Composable
fun LoadingView() {
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            CircularProgressIndicator(color = Color(0xFF007AFF))
            Spacer(modifier = Modifier.height(16.dp))
            Text(
                text = "Loading Reddit posts...",
                color = Color(0xFF8E8E93)
            )
        }
    }
}

@Composable
fun ErrorView(error: String, onRetry: () -> Unit) {
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(
                imageVector = Icons.Default.Error,
                contentDescription = null,
                tint = Color(0xFFFF3B30),
                modifier = Modifier.size(48.dp)
            )
            Spacer(modifier = Modifier.height(16.dp))
            Text(
                text = "Error loading posts",
                fontSize = 18.sp,
                fontWeight = FontWeight.Medium
            )
            Text(
                text = error,
                color = Color(0xFF8E8E93),
                modifier = Modifier.padding(16.dp)
            )
            Button(
                onClick = onRetry,
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFF007AFF)
                )
            ) {
                Text("Retry")
            }
        }
    }
}

@Composable
fun EmptyView(query: String) {
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(
                imageVector = Icons.Default.Search,
                contentDescription = null,
                tint = Color(0xFF8E8E93),
                modifier = Modifier.size(48.dp)
            )
            Spacer(modifier = Modifier.height(16.dp))
            Text(
                text = "No Results",
                fontSize = 18.sp,
                fontWeight = FontWeight.Medium
            )
            Text(
                text = "No Reddit posts found for '$query'",
                color = Color(0xFF8E8E93),
                modifier = Modifier.padding(16.dp)
            )
        }
    }
}

@Composable
fun PostsList(
    posts: List<RedditPost>,
    isLoadingMore: Boolean,
    hasMorePosts: Boolean,
    onLoadMore: () -> Unit,
    onPostClick: (RedditPost) -> Unit
) {
    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        items(posts) { post ->
            RedditPostCard(
                post = post,
                onClick = { onPostClick(post) }
            )
        }

        if (hasMorePosts) {
            item {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    contentAlignment = Alignment.Center
                ) {
                    if (isLoadingMore) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            CircularProgressIndicator(
                                modifier = Modifier.size(16.dp),
                                color = Color(0xFF007AFF)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                text = "Loading more posts...",
                                color = Color(0xFF8E8E93),
                                fontSize = 14.sp
                            )
                        }
                    } else {
                        Button(
                            onClick = onLoadMore,
                            colors = ButtonDefaults.buttonColors(
                                containerColor = Color(0xFF007AFF)
                            )
                        ) {
                            Text("Load More")
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun RedditPostCard(
    post: RedditPost,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() },
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color.White
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            // Header
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "r/${post.subreddit}",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color(0xFF007AFF)
                )

                Spacer(modifier = Modifier.width(8.dp))

                Text(
                    text = "•",
                    color = Color(0xFF8E8E93)
                )

                Spacer(modifier = Modifier.width(8.dp))

                Text(
                    text = "u/${post.author}",
                    fontSize = 14.sp,
                    color = Color(0xFF8E8E93)
                )

                Spacer(modifier = Modifier.weight(1f))

                Text(
                    text = formatTime(post.created_utc),
                    fontSize = 12.sp,
                    color = Color(0xFF8E8E93)
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Title
            Text(
                text = post.title,
                fontSize = 16.sp,
                fontWeight = FontWeight.Medium,
                color = Color(0xFF1C1C1E),
                maxLines = 3,
                overflow = TextOverflow.Ellipsis
            )

            // Content preview
            if (!post.selftext.isNullOrEmpty()) {
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = post.selftext!!,
                    fontSize = 14.sp,
                    color = Color(0xFF8E8E93),
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )
            }

            // Preview image
            val imageUrl = post.previewImageUrl ?: post.thumbnailUrl
            if (imageUrl != null) {
                Spacer(modifier = Modifier.height(12.dp))
                AsyncImage(
                    model = imageUrl,
                    contentDescription = null,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(120.dp)
                        .clip(RoundedCornerShape(8.dp)),
                    contentScale = ContentScale.Crop
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Footer
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.KeyboardArrowUp,
                        contentDescription = null,
                        tint = Color(0xFFFF9500),
                        modifier = Modifier.size(16.dp)
                    )
                    Text(
                        text = post.score.toString(),
                        fontSize = 14.sp,
                        color = Color(0xFFFF9500)
                    )
                }

                Spacer(modifier = Modifier.width(16.dp))

                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.ChatBubbleOutline,
                        contentDescription = null,
                        tint = Color(0xFF8E8E93),
                        modifier = Modifier.size(16.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = post.num_comments.toString(),
                        fontSize = 14.sp,
                        color = Color(0xFF8E8E93)
                    )
                }

                Spacer(modifier = Modifier.weight(1f))

                if (post.is_video) {
                    Icon(
                        imageVector = Icons.Default.PlayCircleFilled,
                        contentDescription = "Video",
                        tint = Color(0xFF007AFF),
                        modifier = Modifier.size(20.dp)
                    )
                }
            }
        }
    }
}

private fun formatTime(createdUtc: Double): String {
    val now = System.currentTimeMillis() / 1000
    val diff = now - createdUtc.toLong()

    return when {
        diff < 60 -> "now"
        diff < 3600 -> "${diff / 60}m"
        diff < 86400 -> "${diff / 3600}h"
        else -> "${diff / 86400}d"
    }
}
