package com.skipfeed.android.presentation.theme

import android.app.Activity
import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

// SkipFeed Brand Colors - Exact match to iOS
object SkipFeedColors {
    val FocusBlue = Color(0xFF007AFF) // iOS focusBlue: rgb(0, 122, 255)

    // Light Theme Colors
    val LightBackground = Color(0xFFFFFBFE)
    val LightSurface = Color(0xFFF8F9FA)
    val LightSurfaceVariant = Color(0xFFF1F3F4)
    val LightOnBackground = Color(0xFF1C1B1F)
    val LightOnSurface = Color(0xFF1C1B1F)
    val LightSecondaryText = Color(0xFF6C757D)
    val LightTertiaryText = Color(0xFFADB5BD)

    // Glass Effect Colors (Light Mode)
    val LightGlassBackground = Color(0xFAFCFF).copy(alpha = 0.85f) // Subtle blue tint
    val LightGlassStroke = Color(0xFFE6F0FF).copy(alpha = 0.5f)
    val LightCardBackground = Color(0xFFF7F9FF).copy(alpha = 0.6f)
    val LightCardBackgroundSelected = Color(0xFFF0F4FF).copy(alpha = 0.8f)

    // Dark Theme Colors
    val DarkBackground = Color(0xFF121212)
    val DarkSurface = Color(0xFF1E1E1E)
    val DarkSurfaceVariant = Color(0xFF2C2C2C)
    val DarkOnBackground = Color(0xFFE1E1E1)
    val DarkOnSurface = Color(0xFFE1E1E1)
    val DarkSecondaryText = Color(0xFFB0B0B0)
    val DarkTertiaryText = Color(0xFF808080)

    // Glass Effect Colors (Dark Mode)
    val DarkGlassBackground = Color(0xFF1E1E1E).copy(alpha = 0.9f)
    val DarkGlassStroke = Color(0xFF404040).copy(alpha = 0.4f)
    val DarkCardBackground = Color(0xFF2C2C2C).copy(alpha = 0.6f)
    val DarkCardBackgroundSelected = Color(0xFF383838).copy(alpha = 0.8f)

    // Platform Colors
    val RedditOrange = Color(0xFFFF4500)
    val YouTubeRed = Color(0xFFFF0000)
    val XBlue = Color(0xFF1DA1F2)
    val TikTokBlack = Color(0xFF000000)
    val InstagramPink = Color(0xFFE4405F)
    val FacebookBlue = Color(0xFF1877F2)

    // Gradient Colors
    val GradientTop = Color(0xFFE3F2FD)
    val GradientMiddle = Color(0xFFBBDEFB)
    val GradientBottom = Color(0xFF90CAF9)

    // Status Colors
    val Success = Color(0xFF4CAF50)
    val Warning = Color(0xFFFF9800)
    val Error = Color(0xFFF44336)
    val Info = Color(0xFF2196F3)
}

private val DarkColorScheme = darkColorScheme(
    primary = SkipFeedColors.FocusBlue,
    onPrimary = Color.White,
    secondary = SkipFeedColors.DarkSecondaryText,
    onSecondary = Color.White,
    tertiary = SkipFeedColors.DarkTertiaryText,
    onTertiary = Color.White,
    background = SkipFeedColors.DarkBackground,
    onBackground = SkipFeedColors.DarkOnBackground,
    surface = SkipFeedColors.DarkSurface,
    onSurface = SkipFeedColors.DarkOnSurface,
    surfaceVariant = SkipFeedColors.DarkSurfaceVariant,
    onSurfaceVariant = SkipFeedColors.DarkSecondaryText,
    outline = SkipFeedColors.DarkGlassStroke,
    outlineVariant = SkipFeedColors.DarkGlassStroke.copy(alpha = 0.3f),
    error = Color(0xFFF44336)
)

private val LightColorScheme = lightColorScheme(
    primary = SkipFeedColors.FocusBlue,
    onPrimary = Color.White,
    secondary = SkipFeedColors.LightSecondaryText,
    onSecondary = Color.White,
    tertiary = SkipFeedColors.LightTertiaryText,
    onTertiary = Color.White,
    background = SkipFeedColors.LightBackground,
    onBackground = SkipFeedColors.LightOnBackground,
    surface = SkipFeedColors.LightSurface,
    onSurface = SkipFeedColors.LightOnSurface,
    surfaceVariant = SkipFeedColors.LightSurfaceVariant,
    onSurfaceVariant = SkipFeedColors.LightSecondaryText,
    outline = SkipFeedColors.LightGlassStroke,
    outlineVariant = SkipFeedColors.LightGlassStroke.copy(alpha = 0.3f),
    error = Color(0xFFF44336)
)

@Composable
fun SkipFeedTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    // Dynamic color disabled to maintain exact iOS brand colors
    dynamicColor: Boolean = false,
    content: @Composable () -> Unit
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }

    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            // Use transparent status bar for gradient effect
            window.statusBarColor = Color.Transparent.toArgb()
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = !darkTheme
        }
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}
