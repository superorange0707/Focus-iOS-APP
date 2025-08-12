package com.skipfeed.android.data.model

data class UserPreferences(
    val preferredLanguage: String = "en",
    val autoDetectLanguage: Boolean = true,
    val platformOrder: List<Platform> = Platform.entries.toList(),
    val searchMode: SearchMode = SearchMode.DIRECT,
    val hasSeenOnboarding: Boolean = false
)

enum class SearchMode(val displayName: String) {
    DIRECT("Direct Search"),
    IN_APP("In-App Browsing");
    
    companion object {
        fun fromString(value: String): SearchMode {
            return entries.find { it.name == value } ?: DIRECT
        }
    }
}
