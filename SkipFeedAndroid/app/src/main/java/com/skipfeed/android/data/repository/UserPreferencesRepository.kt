package com.skipfeed.android.data.repository

import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.skipfeed.android.data.model.Platform
import com.skipfeed.android.data.model.SearchMode
import com.skipfeed.android.data.model.UserPreferences
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class UserPreferencesRepository @Inject constructor(
    private val context: Context
) {
    private val sharedPreferences: SharedPreferences = 
        context.getSharedPreferences("skipfeed_prefs", Context.MODE_PRIVATE)
    
    private val gson = Gson()
    
    private val _userPreferences = MutableStateFlow(loadPreferencesWithFallback())
    val userPreferences: Flow<UserPreferences> = _userPreferences.asStateFlow()

    private fun loadPreferencesWithFallback(): UserPreferences {
        return try {
            loadPreferences()
        } catch (e: Exception) {
            // Return default preferences if loading fails
            UserPreferences()
        }
    }

    private fun loadPreferences(): UserPreferences {
        val preferredLanguage = sharedPreferences.getString("preferred_language", "en") ?: "en"
        val autoDetectLanguage = sharedPreferences.getBoolean("auto_detect_language", true)
        val searchModeString = sharedPreferences.getString("search_mode", SearchMode.DIRECT.name) ?: SearchMode.DIRECT.name
        val hasSeenOnboarding = sharedPreferences.getBoolean("has_seen_onboarding", false)
        
        val platformOrderJson = sharedPreferences.getString("platform_order", null)
        val platformOrder = if (platformOrderJson != null) {
            try {
                val type = object : TypeToken<List<String>>() {}.type
                val platformNames: List<String> = gson.fromJson(platformOrderJson, type)
                platformNames.mapNotNull { name ->
                    Platform.entries.find { it.name == name }
                }
            } catch (e: Exception) {
                Platform.entries.toList()
            }
        } else {
            Platform.entries.toList()
        }
        
        return UserPreferences(
            preferredLanguage = preferredLanguage,
            autoDetectLanguage = autoDetectLanguage,
            platformOrder = platformOrder,
            searchMode = SearchMode.fromString(searchModeString),
            hasSeenOnboarding = hasSeenOnboarding
        )
    }
    
    fun updatePreferences(preferences: UserPreferences) {
        with(sharedPreferences.edit()) {
            putString("preferred_language", preferences.preferredLanguage)
            putBoolean("auto_detect_language", preferences.autoDetectLanguage)
            putString("search_mode", preferences.searchMode.name)
            putBoolean("has_seen_onboarding", preferences.hasSeenOnboarding)
            
            val platformOrderJson = gson.toJson(preferences.platformOrder.map { it.name })
            putString("platform_order", platformOrderJson)
            
            apply()
        }
        _userPreferences.value = preferences
    }
    
    fun setSearchMode(searchMode: SearchMode) {
        val currentPrefs = _userPreferences.value
        updatePreferences(currentPrefs.copy(searchMode = searchMode))
    }
    
    fun setPlatformOrder(platforms: List<Platform>) {
        val currentPrefs = _userPreferences.value
        updatePreferences(currentPrefs.copy(platformOrder = platforms))
    }
    
    fun setHasSeenOnboarding(hasSeenOnboarding: Boolean) {
        val currentPrefs = _userPreferences.value
        updatePreferences(currentPrefs.copy(hasSeenOnboarding = hasSeenOnboarding))
    }
    
    fun setPreferredLanguage(language: String) {
        val currentPrefs = _userPreferences.value
        updatePreferences(currentPrefs.copy(preferredLanguage = language))
    }
}
