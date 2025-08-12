package com.skipfeed.android.presentation.theme

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/**
 * Glass morphism effect modifier that matches iOS glass design
 */
@Composable
fun Modifier.glassMorphism(
    cornerRadius: Dp = 20.dp,
    strokeWidth: Dp = 1.dp,
    alpha: Float = 0.85f
): Modifier {
    val isDark = isSystemInDarkTheme()
    
    val backgroundColor = if (isDark) {
        SkipFeedColors.DarkGlassBackground.copy(alpha = alpha)
    } else {
        SkipFeedColors.LightGlassBackground.copy(alpha = alpha)
    }
    
    val strokeColor = if (isDark) {
        SkipFeedColors.DarkGlassStroke
    } else {
        SkipFeedColors.LightGlassStroke
    }
    
    return this
        .clip(RoundedCornerShape(cornerRadius))
        .background(backgroundColor)
        .border(
            width = strokeWidth,
            color = strokeColor,
            shape = RoundedCornerShape(cornerRadius)
        )
}

/**
 * Card background modifier that matches iOS card design
 */
@Composable
fun Modifier.cardBackground(
    isSelected: Boolean = false,
    cornerRadius: Dp = 22.dp,
    alpha: Float = 0.6f
): Modifier {
    val isDark = isSystemInDarkTheme()
    
    val backgroundColor = if (isDark) {
        if (isSelected) {
            SkipFeedColors.DarkCardBackgroundSelected.copy(alpha = alpha)
        } else {
            SkipFeedColors.DarkCardBackground.copy(alpha = alpha)
        }
    } else {
        if (isSelected) {
            SkipFeedColors.LightCardBackgroundSelected.copy(alpha = alpha)
        } else {
            SkipFeedColors.LightCardBackground.copy(alpha = alpha)
        }
    }
    
    return this
        .clip(RoundedCornerShape(cornerRadius))
        .background(backgroundColor)
}

/**
 * Gradient background that matches iOS main screen gradient
 */
@Composable
fun Modifier.skipFeedGradient(): Modifier {
    val gradientBrush = Brush.verticalGradient(
        colors = listOf(
            SkipFeedColors.GradientTop,
            SkipFeedColors.GradientMiddle,
            SkipFeedColors.GradientBottom
        )
    )
    
    return this.background(gradientBrush)
}

/**
 * Platform-specific colors for platform cards
 */
object PlatformColors {
    val Reddit = SkipFeedColors.RedditOrange
    val YouTube = SkipFeedColors.YouTubeRed
    val X = SkipFeedColors.XBlue
    val TikTok = SkipFeedColors.TikTokBlack
    val Instagram = SkipFeedColors.InstagramPink
    val Facebook = SkipFeedColors.FacebookBlue
}

/**
 * Shadow colors that adapt to theme
 */
@Composable
fun getShadowColor(isSelected: Boolean = false): Color {
    val isDark = isSystemInDarkTheme()
    
    return if (isDark) {
        if (isSelected) {
            SkipFeedColors.FocusBlue.copy(alpha = 0.3f)
        } else {
            Color.Black.copy(alpha = 0.4f)
        }
    } else {
        if (isSelected) {
            SkipFeedColors.FocusBlue.copy(alpha = 0.2f)
        } else {
            Color.Black.copy(alpha = 0.1f)
        }
    }
}

/**
 * Text colors that match iOS secondary and tertiary text
 */
@Composable
fun getSecondaryTextColor(): Color {
    val isDark = isSystemInDarkTheme()
    return if (isDark) {
        SkipFeedColors.DarkSecondaryText
    } else {
        SkipFeedColors.LightSecondaryText
    }
}

@Composable
fun getTertiaryTextColor(): Color {
    val isDark = isSystemInDarkTheme()
    return if (isDark) {
        SkipFeedColors.DarkTertiaryText
    } else {
        SkipFeedColors.LightTertiaryText
    }
}

/**
 * Surface colors for cards and containers
 */
@Composable
fun getSurfaceColor(): Color {
    val isDark = isSystemInDarkTheme()
    return if (isDark) {
        SkipFeedColors.DarkSurface
    } else {
        SkipFeedColors.LightSurface
    }
}

@Composable
fun getSurfaceVariantColor(): Color {
    val isDark = isSystemInDarkTheme()
    return if (isDark) {
        SkipFeedColors.DarkSurfaceVariant
    } else {
        SkipFeedColors.LightSurfaceVariant
    }
}
