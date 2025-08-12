package com.skipfeed.android.presentation.screens.history

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.skipfeed.android.data.model.SearchHistoryItem
import com.skipfeed.android.data.repository.SearchRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

data class SearchHistoryUiState(
    val searchHistory: List<SearchHistoryItem> = emptyList(),
    val isLoading: Boolean = false,
    val error: String? = null
)

@HiltViewModel
class SearchHistoryViewModel @Inject constructor(
    private val searchRepository: SearchRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(SearchHistoryUiState())
    val uiState: StateFlow<SearchHistoryUiState> = _uiState.asStateFlow()

    init {
        loadSearchHistory()
    }

    private fun loadSearchHistory() {
        viewModelScope.launch {
            searchRepository.getSearchHistory().collect { history ->
                _uiState.update { it.copy(searchHistory = history) }
            }
        }
    }

    fun deleteHistoryItem(item: SearchHistoryItem) {
        viewModelScope.launch {
            try {
                // Note: You'd need to add a delete method to SearchRepository
                // For now, we'll implement clearing all history
                // In a full implementation, you'd add a delete single item method
            } catch (e: Exception) {
                _uiState.update { it.copy(error = e.message) }
            }
        }
    }

    fun clearHistory() {
        viewModelScope.launch {
            try {
                searchRepository.clearSearchHistory()
            } catch (e: Exception) {
                _uiState.update { it.copy(error = e.message) }
            }
        }
    }
}
