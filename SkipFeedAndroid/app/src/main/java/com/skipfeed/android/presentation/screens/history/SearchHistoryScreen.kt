package com.skipfeed.android.presentation.screens.history

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.clickable
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.skipfeed.android.R
import com.skipfeed.android.data.model.Platform
import com.skipfeed.android.data.model.SearchHistoryItem
import com.skipfeed.android.presentation.components.getPlatformIcon
import java.text.SimpleDateFormat
import java.util.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SearchHistoryScreen(
    viewModel: SearchHistoryViewModel = hiltViewModel()
) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.White)
    ) {
        // Top App Bar
        TopAppBar(
            title = {
                Text(
                    text = stringResource(R.string.search_history),
                    fontWeight = FontWeight.Bold
                )
            },
            actions = {
                if (uiState.searchHistory.isNotEmpty()) {
                    if (uiState.isSelectionMode) {
                        // Selection mode actions
                        Row {
                            TextButton(onClick = viewModel::selectAllItems) {
                                Text("Select All", color = Color(0xFF007AFF))
                            }
                            IconButton(onClick = viewModel::deleteSelectedItems) {
                                Icon(
                                    Icons.Default.Delete,
                                    contentDescription = "Delete Selected",
                                    tint = if (uiState.selectedItems.isNotEmpty()) Color.Red else Color.Gray
                                )
                            }
                            IconButton(onClick = viewModel::toggleSelectionMode) {
                                Icon(
                                    Icons.Default.Close,
                                    contentDescription = "Cancel Selection"
                                )
                            }
                        }
                    } else {
                        // Normal mode actions
                        Row {
                            TextButton(onClick = viewModel::toggleSelectionMode) {
                                Text("Select", color = Color(0xFF007AFF))
                            }
                            IconButton(onClick = viewModel::clearHistory) {
                                Icon(
                                    Icons.Default.Delete,
                                    contentDescription = stringResource(R.string.clear_history)
                                )
                            }
                        }
                    }
                }
            },
            colors = TopAppBarDefaults.topAppBarColors(
                containerColor = Color.White,
                titleContentColor = Color.Black
            )
        )
        
        if (uiState.searchHistory.isEmpty()) {
            // Empty state
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Icon(
                        Icons.Default.History,
                        contentDescription = null,
                        modifier = Modifier.size(64.dp),
                        tint = Color.Gray
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    Text(
                        text = stringResource(R.string.no_search_history),
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Medium,
                        color = Color.Gray
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = stringResource(R.string.start_searching_message),
                        fontSize = 14.sp,
                        color = Color.Gray
                    )
                }
            }
        } else {
            // Search history list
            LazyColumn(
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(uiState.searchHistory) { historyItem ->
                    SearchHistoryCard(
                        historyItem = historyItem,
                        isSelectionMode = uiState.isSelectionMode,
                        isSelected = uiState.selectedItems.contains(historyItem.id),
                        onDeleteClick = { viewModel.deleteHistoryItem(historyItem) },
                        onSelectionToggle = { viewModel.toggleItemSelection(historyItem.id) }
                    )
                }
            }
        }
    }
}

@Composable
private fun SearchHistoryCard(
    historyItem: SearchHistoryItem,
    isSelectionMode: Boolean,
    isSelected: Boolean,
    onDeleteClick: () -> Unit,
    onSelectionToggle: () -> Unit,
    modifier: Modifier = Modifier
) {
    val platform = Platform.entries.find { it.name == historyItem.platform } ?: Platform.REDDIT
    val timeFormatter = SimpleDateFormat("MMM dd, yyyy 'at' HH:mm", Locale.getDefault())
    
    Card(
        modifier = modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .clickable {
                if (isSelectionMode) {
                    onSelectionToggle()
                }
            },
        colors = CardDefaults.cardColors(
            containerColor = if (isSelected) Color(0xFF007AFF).copy(alpha = 0.1f) else Color.White
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
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
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(RoundedCornerShape(8.dp))
                    .background(platform.color.copy(alpha = 0.1f)),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = getPlatformIcon(platform),
                    contentDescription = platform.displayName,
                    tint = platform.color,
                    modifier = Modifier.size(20.dp)
                )
            }
            
            Spacer(modifier = Modifier.width(12.dp))
            
            // Query and details
            Column(
                modifier = Modifier.weight(1f)
            ) {
                Text(
                    text = historyItem.query,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color.Black,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
                Spacer(modifier = Modifier.height(4.dp))
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = platform.displayName,
                        fontSize = 12.sp,
                        color = platform.color,
                        fontWeight = FontWeight.Medium
                    )
                    Text(
                        text = " • ${timeFormatter.format(Date(historyItem.timestamp))}",
                        fontSize = 12.sp,
                        color = Color.Gray
                    )
                }
            }

            // Delete button (only in normal mode)
            if (!isSelectionMode) {
                IconButton(
                    onClick = onDeleteClick,
                    modifier = Modifier.size(40.dp)
                ) {
                    Icon(
                        Icons.Default.Delete,
                        contentDescription = stringResource(R.string.delete_search),
                        tint = Color.Gray,
                        modifier = Modifier.size(20.dp)
                    )
                }
            }
        }
    }
}
