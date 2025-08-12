package com.skipfeed.android.presentation.screens.search

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.spring
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Clear
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.outlined.AccessTime
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.skipfeed.android.R
import com.skipfeed.android.data.model.Platform
import com.skipfeed.android.data.model.SearchMode
import com.skipfeed.android.presentation.components.PlatformSelector
import com.skipfeed.android.presentation.components.SearchModeToggle
import com.skipfeed.android.presentation.theme.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SearchScreen(
    viewModel: SearchViewModel = hiltViewModel()
) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
    val keyboardController = LocalSoftwareKeyboardController.current
    val focusManager = LocalFocusManager.current
    val context = LocalContext.current

    // Animation for search button scale
    val searchButtonScale by animateFloatAsState(
        targetValue = if (uiState.isSearching) 0.95f else 1.0f,
        animationSpec = spring(dampingRatio = 0.7f, stiffness = 300f),
        label = "searchButtonScale"
    )

    Box(
        modifier = Modifier
            .fillMaxSize()
            .skipFeedGradient()
            .clickable(
                indication = null,
                interactionSource = remember { androidx.compose.foundation.interaction.MutableInteractionSource() }
            ) {
                // Dismiss keyboard when tapping background
                keyboardController?.hide()
                focusManager.clearFocus()
            }
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 30.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(50.dp))

            // Header - Exact iOS match
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.padding(top = 10.dp)
            ) {
                Text(
                    text = "SkipFeed",
                    style = MaterialTheme.typography.displayMedium.copy(
                        fontWeight = FontWeight.Bold,
                        fontSize = 28.sp
                    ),
                    color = SkipFeedColors.FocusBlue
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = "Skip the feed, find what matters",
                    style = MaterialTheme.typography.labelMedium.copy(
                        fontWeight = FontWeight.Medium
                    ),
                    color = getSecondaryTextColor()
                )
            }

            Spacer(modifier = Modifier.height(28.dp))
            
            // Platform selector with dynamic ordering - exact iOS match
            PlatformSelector(
                selectedPlatform = uiState.selectedPlatform,
                platforms = uiState.platformOrder,
                onPlatformSelected = viewModel::selectPlatform,
                modifier = Modifier.padding(top = 2.dp)
            )

            Spacer(modifier = Modifier.height(28.dp))

            // Search section - exact iOS layout
            Column(
                modifier = Modifier.fillMaxWidth(),
                verticalArrangement = Arrangement.spacedBy(18.dp)
            ) {
                // Only show search input for non-TikTok platforms
                if (uiState.selectedPlatform != Platform.TIKTOK) {
                    // Search input with glass style - exact iOS match
                    SearchInputField(
                        searchQuery = uiState.searchQuery,
                        platform = uiState.selectedPlatform,
                        onQueryChange = viewModel::updateSearchQuery,
                        onSearch = {
                            keyboardController?.hide()
                            focusManager.clearFocus()
                            viewModel.performSearch(context)
                        }
                    )

                    // Search mode toggle under search bar - only for Reddit
                    if (uiState.selectedPlatform == Platform.REDDIT) {
                        SearchModeToggleView(
                            searchMode = uiState.searchMode,
                            onSearchModeChanged = viewModel::updateSearchMode,
                            modifier = Modifier.padding(top = (-6).dp) // Reduced spacing like iOS
                        )
                    }
                } else {
                    // For TikTok, show a simple message - exact iOS match
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 5.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            Icons.Default.Search,
                            contentDescription = null,
                            tint = SkipFeedColors.FocusBlue,
                            modifier = Modifier.size(12.sp.value.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            text = "Opens TikTok search page where you can input your query",
                            style = MaterialTheme.typography.labelSmall,
                            color = getSecondaryTextColor()
                        )
                        Spacer(modifier = Modifier.weight(1f))
                    }
                }

                // Glass style search button - exact iOS match
                Button(
                    onClick = {
                        keyboardController?.hide()
                        focusManager.clearFocus()
                        viewModel.performSearch(context)
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(55.dp)
                        .scale(searchButtonScale)
                        .shadow(
                            elevation = 10.dp,
                            shape = RoundedCornerShape(20.dp),
                            ambientColor = getShadowColor(isSelected = true),
                            spotColor = getShadowColor(isSelected = true)
                        ),
                    enabled = uiState.selectedPlatform == Platform.TIKTOK || uiState.searchQuery.isNotEmpty(),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color.Transparent,
                        contentColor = Color.White,
                        disabledContainerColor = Color.Transparent,
                        disabledContentColor = Color.White.copy(alpha = 0.6f)
                    ),
                    shape = RoundedCornerShape(20.dp),
                    contentPadding = PaddingValues(0.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(
                                brush = Brush.horizontalGradient(
                                    colors = listOf(
                                        SkipFeedColors.FocusBlue,
                                        SkipFeedColors.FocusBlue.copy(alpha = 0.8f)
                                    )
                                ),
                                shape = RoundedCornerShape(20.dp)
                            )
                            .clip(RoundedCornerShape(20.dp)),
                        contentAlignment = Alignment.Center
                    ) {
                        Row(
                            horizontalArrangement = Arrangement.spacedBy(12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            if (uiState.isSearching) {
                                CircularProgressIndicator(
                                    color = Color.White,
                                    modifier = Modifier.size(20.dp),
                                    strokeWidth = 2.dp
                                )
                                Text(
                                    text = "Searching...",
                                    style = MaterialTheme.typography.headlineSmall.copy(
                                        fontWeight = FontWeight.SemiBold
                                    ),
                                    color = Color.White
                                )
                            } else {
                                Icon(
                                    Icons.Default.Search,
                                    contentDescription = null,
                                    modifier = Modifier.size(20.dp)
                                )
                                Text(
                                    text = getSearchButtonText(uiState.selectedPlatform, context),
                                    style = MaterialTheme.typography.headlineSmall.copy(
                                        fontWeight = FontWeight.SemiBold
                                    ),
                                    color = Color.White
                                )
                            }
                        }
                    }
                }
            }

            // Recent searches section - exact iOS match
            if (uiState.recentQueries.isNotEmpty() &&
                uiState.searchQuery.isEmpty() &&
                uiState.selectedPlatform != Platform.TIKTOK) {

                Spacer(modifier = Modifier.height(28.dp))

                Column(
                    modifier = Modifier.fillMaxWidth(),
                    verticalArrangement = Arrangement.spacedBy(15.dp)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 5.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                Icons.Outlined.AccessTime,
                                contentDescription = null,
                                tint = SkipFeedColors.FocusBlue,
                                modifier = Modifier.size(12.dp)
                            )
                            Spacer(modifier = Modifier.width(4.dp))
                            Text(
                                text = "Recent Searches",
                                style = MaterialTheme.typography.labelMedium.copy(
                                    fontWeight = FontWeight.Medium
                                ),
                                color = getSecondaryTextColor()
                            )
                        }
                        TextButton(
                            onClick = viewModel::clearRecentQueries,
                            contentPadding = PaddingValues(0.dp)
                        ) {
                            Text(
                                text = "Clear",
                                style = MaterialTheme.typography.labelSmall,
                                color = getSecondaryTextColor()
                            )
                        }
                    }

                    LazyRow(
                        horizontalArrangement = Arrangement.spacedBy(10.dp),
                        contentPadding = PaddingValues(horizontal = 5.dp)
                    ) {
                        items(uiState.recentQueries.take(5)) { query ->
                            RecentSearchChip(
                                query = query,
                                onClick = {
                                    viewModel.updateSearchQuery(query)
                                    keyboardController?.hide()
                                    focusManager.clearFocus()
                                    viewModel.performSearch(context)
                                }
                            )
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.weight(1f))

            // Footer with app info - exact iOS match
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.padding(bottom = 30.dp)
            ) {
                Text(
                    text = "Skip the feed, find what matters",
                    style = MaterialTheme.typography.labelMedium,
                    color = SkipFeedColors.FocusBlue.copy(alpha = 0.7f)
                )
                Text(
                    text = "Direct search, zero distractions",
                    style = MaterialTheme.typography.labelSmall,
                    color = getTertiaryTextColor()
                )
            }
        }
    }
}

// Search Input Field with glass effect - exact iOS match
@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun SearchInputField(
    searchQuery: String,
    platform: Platform,
    onQueryChange: (String) -> Unit,
    onSearch: () -> Unit,
    modifier: Modifier = Modifier
) {
    OutlinedTextField(
        value = searchQuery,
        onValueChange = onQueryChange,
        modifier = modifier
            .fillMaxWidth()
            .glassMorphism(cornerRadius = 20.dp),
        placeholder = {
            Text(
                text = getPlaceholderText(platform),
                style = MaterialTheme.typography.bodyMedium,
                color = getSecondaryTextColor()
            )
        },
        leadingIcon = {
            Icon(
                Icons.Default.Search,
                contentDescription = null,
                tint = SkipFeedColors.FocusBlue.copy(alpha = 0.75f),
                modifier = Modifier.size(20.dp)
            )
        },
        trailingIcon = {
            if (searchQuery.isNotEmpty()) {
                IconButton(onClick = { onQueryChange("") }) {
                    Icon(
                        Icons.Default.Clear,
                        contentDescription = null,
                        tint = getSecondaryTextColor(),
                        modifier = Modifier.size(20.dp)
                    )
                }
            }
        },
        keyboardOptions = KeyboardOptions(imeAction = ImeAction.Search),
        keyboardActions = KeyboardActions(onSearch = { onSearch() }),
        singleLine = true,
        colors = OutlinedTextFieldDefaults.colors(
            focusedBorderColor = SkipFeedColors.FocusBlue.copy(alpha = 0.7f),
            unfocusedBorderColor = Color.Transparent,
            focusedContainerColor = Color.Transparent,
            unfocusedContainerColor = Color.Transparent,
            focusedTextColor = MaterialTheme.colorScheme.onSurface,
            unfocusedTextColor = MaterialTheme.colorScheme.onSurface
        ),
        textStyle = MaterialTheme.typography.bodyMedium
    )
}

// Search Mode Toggle View - exact iOS match
@Composable
private fun SearchModeToggleView(
    searchMode: SearchMode,
    onSearchModeChanged: (SearchMode) -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.Start
    ) {
        Row(
            modifier = Modifier
                .background(
                    color = getSurfaceVariantColor(),
                    shape = RoundedCornerShape(16.dp)
                )
                .padding(4.dp),
            horizontalArrangement = Arrangement.spacedBy(0.dp)
        ) {
            // Direct mode button
            Button(
                onClick = { onSearchModeChanged(SearchMode.DIRECT) },
                colors = ButtonDefaults.buttonColors(
                    containerColor = if (searchMode == SearchMode.DIRECT)
                        SkipFeedColors.FocusBlue else Color.Transparent,
                    contentColor = if (searchMode == SearchMode.DIRECT)
                        Color.White else MaterialTheme.colorScheme.onSurface
                ),
                shape = RoundedCornerShape(12.dp),
                contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
                modifier = Modifier.height(32.dp)
            ) {
                Text(
                    text = "Direct",
                    style = MaterialTheme.typography.labelMedium.copy(
                        fontWeight = FontWeight.Medium
                    )
                )
            }

            // In-App mode button
            Button(
                onClick = { onSearchModeChanged(SearchMode.IN_APP) },
                colors = ButtonDefaults.buttonColors(
                    containerColor = if (searchMode == SearchMode.IN_APP)
                        SkipFeedColors.FocusBlue else Color.Transparent,
                    contentColor = if (searchMode == SearchMode.IN_APP)
                        Color.White else MaterialTheme.colorScheme.onSurface
                ),
                shape = RoundedCornerShape(12.dp),
                contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
                modifier = Modifier.height(32.dp)
            ) {
                Text(
                    text = "In-App",
                    style = MaterialTheme.typography.labelMedium.copy(
                        fontWeight = FontWeight.Medium
                    )
                )
            }
        }
    }
}

// Recent Search Chip - exact iOS match
@Composable
private fun RecentSearchChip(
    query: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Button(
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(
            containerColor = Color.Transparent,
            contentColor = SkipFeedColors.FocusBlue
        ),
        shape = RoundedCornerShape(12.dp),
        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp),
        modifier = modifier
            .glassMorphism(cornerRadius = 12.dp, alpha = 0.9f)
    ) {
        Text(
            text = query,
            style = MaterialTheme.typography.labelMedium.copy(
                fontWeight = FontWeight.Medium
            ),
            color = SkipFeedColors.FocusBlue
        )
    }
}

// Helper functions
private fun getPlaceholderText(platform: Platform): String {
    return when (platform) {
        Platform.TIKTOK -> "Opens TikTok search page"
        else -> "Search ${platform.displayName}..."
    }
}

@Composable
private fun getSearchButtonText(platform: Platform, context: android.content.Context): String {
    return when (platform) {
        Platform.TIKTOK -> "Open TikTok Search"
        else -> {
            val isAppInstalled = platform.isAppInstalled(context)
            if (isAppInstalled) {
                "Open in ${platform.displayName}"
            } else {
                "Search on ${platform.displayName}"
            }
        }
    }
}
