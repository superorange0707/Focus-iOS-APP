package com.skipfeed.android.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.skipfeed.android.data.model.SearchHistoryItem
import com.skipfeed.android.data.model.UsageAnalytics
import com.skipfeed.android.data.repository.SearchRepository
import com.skipfeed.android.data.repository.UsageAnalyticsRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class StatisticsViewModel @Inject constructor(
    private val usageAnalyticsRepository: UsageAnalyticsRepository,
    private val searchRepository: SearchRepository
) : ViewModel() {

    private val _usageAnalytics = MutableStateFlow(UsageAnalytics())
    val usageAnalytics: StateFlow<UsageAnalytics> = _usageAnalytics.asStateFlow()

    private val _searchHistory = MutableStateFlow<List<SearchHistoryItem>>(emptyList())
    val searchHistory: StateFlow<List<SearchHistoryItem>> = _searchHistory.asStateFlow()

    init {
        loadData()
    }

    private fun loadData() {
        viewModelScope.launch {
            // Load usage analytics
            usageAnalyticsRepository.getUsageAnalytics().collect { analytics ->
                _usageAnalytics.value = analytics
            }
        }

        viewModelScope.launch {
            // Load search history
            searchRepository.getSearchHistory().collect { history ->
                _searchHistory.value = history
            }
        }
    }
}
