package com.skipfeed.android.presentation.screens.settings

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

data class SettingsUiState(
    val preferredLanguage: String = "en",
    val autoDetectLanguage: Boolean = true,
    val platformOrder: List<Platform> = Platform.entries.toList(),
    val searchMode: SearchMode = SearchMode.DIRECT,
    val hasSeenOnboarding: Boolean = false
)

@HiltViewModel
class SettingsViewModel @Inject constructor(
    private val userPreferencesRepository: UserPreferencesRepository,
    private val searchRepository: SearchRepository,
    private val usageAnalyticsRepository: UsageAnalyticsRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(SettingsUiState())
    val uiState: StateFlow<SettingsUiState> = _uiState.asStateFlow()

    init {
        loadSettings()
    }

    private fun loadSettings() {
        viewModelScope.launch {
            userPreferencesRepository.userPreferences.collect { preferences ->
                _uiState.update {
                    it.copy(
                        preferredLanguage = preferences.preferredLanguage,
                        autoDetectLanguage = preferences.autoDetectLanguage,
                        platformOrder = preferences.platformOrder,
                        searchMode = preferences.searchMode,
                        hasSeenOnboarding = preferences.hasSeenOnboarding
                    )
                }
            }
        }
    }

    fun toggleAutoDetectLanguage(enabled: Boolean) {
        viewModelScope.launch {
            val currentPrefs = userPreferencesRepository.userPreferences.first()
            userPreferencesRepository.updatePreferences(
                currentPrefs.copy(autoDetectLanguage = enabled)
            )
        }
    }

    fun updateSearchMode(searchMode: SearchMode) {
        userPreferencesRepository.setSearchMode(searchMode)
    }

    fun updatePreferredLanguage(language: String) {
        userPreferencesRepository.setPreferredLanguage(language)
    }

    fun updatePlatformOrder(platforms: List<Platform>) {
        userPreferencesRepository.setPlatformOrder(platforms)
    }

    fun resetData() {
        viewModelScope.launch {
            try {
                searchRepository.clearSearchHistory()
                usageAnalyticsRepository.clearAnalytics()
            } catch (e: Exception) {
                // Handle error
            }
        }
    }
}
