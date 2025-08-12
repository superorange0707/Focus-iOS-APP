package com.skipfeed.android.presentation.screens.search

import android.content.Context
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.skipfeed.android.data.model.Platform
import com.skipfeed.android.data.model.SearchMode
import com.skipfeed.android.data.repository.SearchRepository
import com.skipfeed.android.data.repository.UsageAnalyticsRepository
import com.skipfeed.android.data.repository.UserPreferencesRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

data class SearchUiState(
    val searchQuery: String = "",
    val selectedPlatform: Platform = Platform.REDDIT,
    val platformOrder: List<Platform> = Platform.entries.toList(),
    val searchMode: SearchMode = SearchMode.DIRECT,
    val recentQueries: List<String> = emptyList(),
    val isSearching: Boolean = false,
    val error: String? = null
)

@HiltViewModel
class SearchViewModel @Inject constructor(
    private val searchRepository: SearchRepository,
    private val userPreferencesRepository: UserPreferencesRepository,
    private val usageAnalyticsRepository: UsageAnalyticsRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(SearchUiState())
    val uiState: StateFlow<SearchUiState> = _uiState.asStateFlow()

    init {
        // Initialize with safe defaults first
        _uiState.update { currentState ->
            currentState.copy(
                platformOrder = Platform.entries.toList(),
                searchMode = SearchMode.DIRECT,
                selectedPlatform = Platform.REDDIT
            )
        }

        // Then observe user preferences in a try-catch to prevent crashes
        viewModelScope.launch {
            try {
                userPreferencesRepository.userPreferences.collect { preferences ->
                    _uiState.update { currentState ->
                        currentState.copy(
                            platformOrder = preferences.platformOrder,
                            searchMode = preferences.searchMode,
                            selectedPlatform = if (currentState.selectedPlatform in preferences.platformOrder) {
                                currentState.selectedPlatform
                            } else {
                                preferences.platformOrder.firstOrNull() ?: Platform.REDDIT
                            }
                        )
                    }

                    // Auto-switch to Direct mode for non-Reddit platforms
                    if (preferences.searchMode == SearchMode.IN_APP &&
                        _uiState.value.selectedPlatform != Platform.REDDIT) {
                        userPreferencesRepository.setSearchMode(SearchMode.DIRECT)
                    }
                }
            } catch (e: Exception) {
                // Log error but don't crash
                _uiState.update { it.copy(error = "Failed to load preferences: ${e.message}") }
            }
        }

        // Load recent queries with error handling
        viewModelScope.launch {
            try {
                loadRecentQueries()
            } catch (e: Exception) {
                // Log error but don't crash
                _uiState.update { it.copy(error = "Failed to load recent queries: ${e.message}") }
            }
        }
    }

    fun updateSearchQuery(query: String) {
        _uiState.update { it.copy(searchQuery = query) }
    }

    fun selectPlatform(platform: Platform) {
        _uiState.update { it.copy(selectedPlatform = platform) }
        
        // Auto-switch to Direct mode for non-Reddit platforms
        if (platform != Platform.REDDIT && _uiState.value.searchMode == SearchMode.IN_APP) {
            updateSearchMode(SearchMode.DIRECT)
        }
    }

    fun updateSearchMode(searchMode: SearchMode) {
        userPreferencesRepository.setSearchMode(searchMode)
    }

    fun performSearch(context: Context) {
        val currentState = _uiState.value
        
        // Special handling for TikTok - no search text required
        if (currentState.selectedPlatform == Platform.TIKTOK) {
            _uiState.update { it.copy(isSearching = true) }
            
            viewModelScope.launch {
                try {
                    usageAnalyticsRepository.recordSearch(currentState.selectedPlatform)

                    val success = searchRepository.performDirectSearch("", currentState.selectedPlatform)

                    _uiState.update { it.copy(isSearching = false) }

                    if (!success) {
                        _uiState.update { it.copy(error = "Failed to open ${currentState.selectedPlatform.displayName}") }
                    }
                } catch (e: Exception) {
                    _uiState.update { it.copy(isSearching = false, error = "Search failed: ${e.message}") }
                }
            }
            return
        }

        // For other platforms, require search text
        if (currentState.searchQuery.isEmpty()) return

        _uiState.update { it.copy(isSearching = true, error = null) }

        viewModelScope.launch {
            try {
                // Record search in analytics and history
                usageAnalyticsRepository.recordSearch(currentState.selectedPlatform)
                searchRepository.addToSearchHistory(currentState.searchQuery, currentState.selectedPlatform)

                when (currentState.searchMode) {
                    SearchMode.DIRECT -> {
                        val success = searchRepository.performDirectSearch(
                            currentState.searchQuery, 
                            currentState.selectedPlatform
                        )
                        
                        if (!success) {
                            _uiState.update { 
                                it.copy(
                                    isSearching = false,
                                    error = "Failed to open ${currentState.selectedPlatform.displayName}"
                                )
                            }
                        } else {
                            _uiState.update { it.copy(isSearching = false, searchQuery = "") }
                            loadRecentQueries() // Refresh recent queries
                        }
                    }
                    SearchMode.IN_APP -> {
                        // For Reddit, this would open the in-app Reddit search
                        // For now, fall back to direct search
                        val success = searchRepository.performDirectSearch(
                            currentState.searchQuery, 
                            currentState.selectedPlatform
                        )
                        
                        if (!success) {
                            _uiState.update { 
                                it.copy(
                                    isSearching = false,
                                    error = "Failed to open ${currentState.selectedPlatform.displayName}"
                                )
                            }
                        } else {
                            _uiState.update { it.copy(isSearching = false, searchQuery = "") }
                            loadRecentQueries() // Refresh recent queries
                        }
                    }
                }
            } catch (e: Exception) {
                _uiState.update { 
                    it.copy(
                        isSearching = false,
                        error = e.message ?: "An unknown error occurred"
                    )
                }
            }
        }
    }

    fun clearRecentQueries() {
        viewModelScope.launch {
            searchRepository.clearSearchHistory()
            loadRecentQueries()
        }
    }

    private fun loadRecentQueries() {
        viewModelScope.launch {
            try {
                val queries = searchRepository.getRecentQueries(5)
                _uiState.update { it.copy(recentQueries = queries) }
            } catch (e: Exception) {
                // Handle error silently for recent queries
            }
        }
    }

    fun clearError() {
        _uiState.update { it.copy(error = null) }
    }
}
