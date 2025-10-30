package com.skipfeed.android.data

import android.content.Context
import android.content.res.Configuration
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import java.util.Locale

class LocalizationManager private constructor() {
    companion object {
        @Volatile
        private var INSTANCE: LocalizationManager? = null

        fun getInstance(): LocalizationManager {
            return INSTANCE ?: synchronized(this) {
                INSTANCE ?: LocalizationManager().also { INSTANCE = it }
            }
        }
    }

    var currentLanguage by mutableStateOf("en")
        private set

    // Match iOS exactly - same languages and order
    private val supportedLanguages = linkedMapOf(
        "ar" to "العربية",
        "zh" to "中文",
        "de" to "Deutsch",
        "en" to "English",
        "es" to "Español",
        "fr" to "Français",
        "it" to "Italiano",
        "ja" to "日本語",
        "ko" to "한국어",
        "pt" to "Português",
        "ru" to "Русский"
    )
    
    fun initialize(context: Context) {
        val sharedPrefs = context.getSharedPreferences("user_preferences", Context.MODE_PRIVATE)
        val autoDetect = sharedPrefs.getBoolean("auto_detect_language", true)

        currentLanguage = if (autoDetect) {
            // Use system language if auto-detect is enabled
            val systemLang = getSystemLanguage()
            // Check if system language is supported, otherwise use English
            if (supportedLanguages.containsKey(systemLang)) systemLang else "en"
        } else {
            // Use saved language
            sharedPrefs.getString("app_language", "en") ?: "en"
        }

        applyLanguage(context, currentLanguage)
    }
    
    fun getSupportedLanguages(): List<Pair<String, String>> {
        // Create a fixed list to ensure exactly 11 languages
        val languageList = listOf(
            "en" to "English",
            "es" to "Español",
            "fr" to "Français",
            "de" to "Deutsch",
            "it" to "Italiano",
            "pt" to "Português",
            "ru" to "Русский",
            "ja" to "日本語",
            "ko" to "한국어",
            "zh" to "中文",
            "ar" to "العربية"
        )

        // Sort alphabetically by language name
        return languageList.sortedBy { it.second }
    }
    
    fun getLanguageName(code: String): String {
        return supportedLanguages[code] ?: "Unknown"
    }
    
    fun setLanguage(context: Context, languageCode: String) {
        if (supportedLanguages.containsKey(languageCode)) {
            currentLanguage = languageCode

            // Save preference
            val sharedPrefs = context.getSharedPreferences("user_preferences", Context.MODE_PRIVATE)
            sharedPrefs.edit().putString("app_language", languageCode).apply()

            // Apply language change
            applyLanguage(context, languageCode)

            // Restart activity to apply changes
            if (context is android.app.Activity) {
                val intent = context.intent
                context.finish()
                context.startActivity(intent)
                context.overridePendingTransition(0, 0)
            }
        }
    }
    
    fun getSystemLanguage(): String {
        return Locale.getDefault().language
    }
    
    private fun applyLanguage(context: Context, languageCode: String) {
        val locale = when (languageCode) {
            "en" -> Locale.ENGLISH
            "es" -> Locale("es")
            "fr" -> Locale.FRENCH
            "de" -> Locale.GERMAN
            "it" -> Locale.ITALIAN
            "pt" -> Locale("pt")
            "ru" -> Locale("ru")
            "ja" -> Locale.JAPANESE
            "ko" -> Locale("ko")
            "zh" -> Locale.CHINESE
            "ar" -> Locale("ar")
            else -> Locale.ENGLISH
        }

        Locale.setDefault(locale)
        val config = context.resources.configuration
        config.setLocale(locale)

        // Handle RTL for Arabic
        if (languageCode == "ar") {
            config.setLayoutDirection(locale)
        }

        context.resources.updateConfiguration(config, context.resources.displayMetrics)
    }

    fun isRightToLeft(): Boolean {
        return currentLanguage == "ar"
    }

    fun getCurrentLanguageDisplayName(): String {
        return supportedLanguages[currentLanguage] ?: "English"
    }
}
