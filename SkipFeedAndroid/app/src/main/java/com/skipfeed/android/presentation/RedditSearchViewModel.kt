package com.skipfeed.android.presentation

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.skipfeed.android.data.*
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class RedditSearchUiState(
    val posts: List<RedditPost> = emptyList(),
    val isLoading: Boolean = false,
    val isLoadingMore: Boolean = false,
    val error: String? = null,
    val hasMorePosts: Boolean = true,
    val selectedSort: RedditSort = RedditSort.RELEVANCE,
    val selectedTimeFilter: RedditTimeFilter = RedditTimeFilter.ALL,
    val showFilters: Boolean = false,
    val afterToken: String? = null,
    val currentQuery: String = ""
)

class RedditSearchViewModel : ViewModel() {
    private val redditApiService = RedditApiService()
    
    private val _uiState = MutableStateFlow(RedditSearchUiState())
    val uiState: StateFlow<RedditSearchUiState> = _uiState.asStateFlow()
    
    fun searchPosts(query: String) {
        if (query.isBlank()) return
        
        _uiState.value = _uiState.value.copy(
            isLoading = true,
            error = null,
            posts = emptyList(),
            afterToken = null,
            hasMorePosts = true,
            currentQuery = query
        )
        
        viewModelScope.launch {
            redditApiService.searchPosts(
                query = query,
                sort = _uiState.value.selectedSort,
                timeFilter = _uiState.value.selectedTimeFilter
            ).fold(
                onSuccess = { (posts, afterToken) ->
                    _uiState.value = _uiState.value.copy(
                        posts = posts,
                        isLoading = false,
                        error = null,
                        afterToken = afterToken,
                        hasMorePosts = afterToken != null
                    )
                },
                onFailure = { error ->
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        error = error.message ?: "Unknown error occurred"
                    )
                }
            )
        }
    }
    
    fun loadMorePosts() {
        val currentState = _uiState.value
        if (currentState.isLoadingMore || !currentState.hasMorePosts || currentState.afterToken == null) {
            return
        }
        
        _uiState.value = currentState.copy(isLoadingMore = true)
        
        viewModelScope.launch {
            redditApiService.searchPosts(
                query = currentState.currentQuery,
                sort = currentState.selectedSort,
                timeFilter = currentState.selectedTimeFilter,
                after = currentState.afterToken
            ).fold(
                onSuccess = { (newPosts, afterToken) ->
                    _uiState.value = _uiState.value.copy(
                        posts = _uiState.value.posts + newPosts,
                        isLoadingMore = false,
                        afterToken = afterToken,
                        hasMorePosts = afterToken != null
                    )
                },
                onFailure = { error ->
                    _uiState.value = _uiState.value.copy(
                        isLoadingMore = false,
                        error = error.message ?: "Failed to load more posts"
                    )
                }
            )
        }
    }
    
    fun updateSort(sort: RedditSort, query: String) {
        _uiState.value = _uiState.value.copy(selectedSort = sort)
        searchPosts(query)
    }
    
    fun updateTimeFilter(timeFilter: RedditTimeFilter, query: String) {
        _uiState.value = _uiState.value.copy(selectedTimeFilter = timeFilter)
        searchPosts(query)
    }
    
    fun toggleFilters() {
        _uiState.value = _uiState.value.copy(
            showFilters = !_uiState.value.showFilters
        )
    }
    
    fun clearError() {
        _uiState.value = _uiState.value.copy(error = null)
    }
}
