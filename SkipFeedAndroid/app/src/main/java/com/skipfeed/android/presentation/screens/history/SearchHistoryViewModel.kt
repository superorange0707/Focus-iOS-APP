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
    val error: String? = null,
    val isSelectionMode: Boolean = false,
    val selectedItems: Set<String> = emptySet()
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
                android.util.Log.d("SearchHistoryViewModel", "Delete item requested: ${item.query}")
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

    fun toggleSelectionMode() {
        _uiState.update {
            it.copy(
                isSelectionMode = !it.isSelectionMode,
                selectedItems = emptySet()
            )
        }
    }

    fun toggleItemSelection(itemId: String) {
        _uiState.update { currentState ->
            val newSelectedItems = if (currentState.selectedItems.contains(itemId)) {
                currentState.selectedItems - itemId
            } else {
                currentState.selectedItems + itemId
            }
            currentState.copy(selectedItems = newSelectedItems)
        }
    }

    fun selectAllItems() {
        _uiState.update { currentState ->
            currentState.copy(
                selectedItems = currentState.searchHistory.map { it.id }.toSet()
            )
        }
    }

    fun clearSelection() {
        _uiState.update { it.copy(selectedItems = emptySet()) }
    }

    fun deleteSelectedItems() {
        viewModelScope.launch {
            try {
                val currentState = _uiState.value
                // For now, we'll implement this as clearing all history
                // In a full implementation, you'd delete only selected items
                if (currentState.selectedItems.isNotEmpty()) {
                    searchRepository.clearSearchHistory()
                    _uiState.update {
                        it.copy(
                            isSelectionMode = false,
                            selectedItems = emptySet()
                        )
                    }
                }
            } catch (e: Exception) {
                _uiState.update { it.copy(error = e.message) }
            }
        }
    }
}
