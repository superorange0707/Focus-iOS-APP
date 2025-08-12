package com.skipfeed.android.data.model

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.compose.ui.graphics.Color

enum class Platform(
    val displayName: String,
    val packageName: String,
    val searchUrl: String,
    val appScheme: String,
    val color: Color
) {
    REDDIT(
        displayName = "Reddit",
        packageName = "com.reddit.frontpage",
        searchUrl = "https://www.reddit.com/search/?q=",
        appScheme = "reddit://www.reddit.com/search/?q=",
        color = Color(0xFFFF4500)
    ),
    YOUTUBE(
        displayName = "YouTube",
        packageName = "com.google.android.youtube",
        searchUrl = "https://www.youtube.com/results?search_query=",
        appScheme = "youtube://www.youtube.com/results?search_query=",
        color = Color(0xFFFF0000)
    ),
    X(
        displayName = "X",
        packageName = "com.twitter.android",
        searchUrl = "https://x.com/search?q=",
        appScheme = "twitter://search?query=",
        color = Color(0xFF1DA1F2)
    ),
    TIKTOK(
        displayName = "TikTok",
        packageName = "com.ss.android.ugc.trill",
        searchUrl = "https://www.tiktok.com/search?q=",
        appScheme = "tiktok://search?q=",
        color = Color(0xFF000000)
    ),
    INSTAGRAM(
        displayName = "Instagram",
        packageName = "com.instagram.android",
        searchUrl = "https://www.instagram.com/explore/search/?q=",
        appScheme = "instagram://tag?name=",
        color = Color(0xFFE4405F)
    ),
    FACEBOOK(
        displayName = "Facebook",
        packageName = "com.facebook.katana",
        searchUrl = "https://www.facebook.com/search/top/?q=",
        appScheme = "fb://search/top/?q=",
        color = Color(0xFF1877F2)
    );

    fun isAppInstalled(context: Context): Boolean {
        return try {
            context.packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    fun createSearchIntent(query: String, context: Context): Intent? {
        return if (isAppInstalled(context)) {
            val encodedQuery = Uri.encode(query)
            val intentUri = when (this) {
                REDDIT -> "$appScheme$encodedQuery"
                YOUTUBE -> "$appScheme$encodedQuery"
                X -> "$appScheme$encodedQuery"
                TIKTOK -> "$appScheme$encodedQuery"
                INSTAGRAM -> {
                    if (query.startsWith("@")) {
                        val username = query.substring(1)
                        "instagram://user?username=${Uri.encode(username)}"
                    } else {
                        "$appScheme${Uri.encode(query)}"
                    }
                }
                FACEBOOK -> "$appScheme$encodedQuery"
            }
            
            try {
                Intent.parseUri(intentUri, Intent.URI_INTENT_SCHEME).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
            } catch (e: Exception) {
                createWebIntent(query)
            }
        } else {
            createWebIntent(query)
        }
    }

    fun createWebIntent(query: String): Intent {
        val encodedQuery = Uri.encode(query)
        val url = "$searchUrl$encodedQuery"
        return Intent(Intent.ACTION_VIEW, Uri.parse(url)).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
    }
}
