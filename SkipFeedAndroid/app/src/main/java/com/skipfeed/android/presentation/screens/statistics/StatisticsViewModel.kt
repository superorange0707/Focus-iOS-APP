package com.skipfeed.android.presentation.screens.statistics

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.skipfeed.android.data.model.UsageAnalytics
import com.skipfeed.android.data.repository.UsageAnalyticsRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

data class StatisticsUiState(
    val analytics: UsageAnalytics = UsageAnalytics(),
    val isLoading: Boolean = false,
    val error: String? = null
)

@HiltViewModel
class StatisticsViewModel @Inject constructor(
    private val usageAnalyticsRepository: UsageAnalyticsRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(StatisticsUiState())
    val uiState: StateFlow<StatisticsUiState> = _uiState.asStateFlow()

    init {
        loadStatistics()
    }

    private fun loadStatistics() {
        viewModelScope.launch {
            try {
                usageAnalyticsRepository.getUsageAnalytics().collect { analytics ->
                    _uiState.update { it.copy(analytics = analytics, error = null) }
                }
            } catch (e: Exception) {
                _uiState.update { it.copy(error = "Failed to load statistics: ${e.message}") }
            }
        }
    }

    fun resetStatistics() {
        viewModelScope.launch {
            try {
                usageAnalyticsRepository.resetAnalytics()
            } catch (e: Exception) {
                _uiState.update { it.copy(error = e.message) }
            }
        }
    }
}
