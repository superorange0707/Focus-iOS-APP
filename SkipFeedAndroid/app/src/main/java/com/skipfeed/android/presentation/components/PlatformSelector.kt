package com.skipfeed.android.presentation.components

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.spring
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.Language
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.skipfeed.android.R
import com.skipfeed.android.data.model.Platform
import com.skipfeed.android.presentation.theme.*

@Composable
fun PlatformSelector(
    selectedPlatform: Platform,
    platforms: List<Platform>,
    onPlatformSelected: (Platform) -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(15.dp)
    ) {
        // Header - exact iOS match
        Row(
            modifier = Modifier.padding(horizontal = 5.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                Icons.Outlined.Language,
                contentDescription = null,
                tint = getSecondaryTextColor(),
                modifier = Modifier.size(12.dp)
            )
            Spacer(modifier = Modifier.width(4.dp))
            Text(
                text = "Choose Platform",
                style = MaterialTheme.typography.headlineSmall.copy(
                    fontWeight = FontWeight.SemiBold
                ),
                color = MaterialTheme.colorScheme.onSurface
            )
        }

        // Platform cards - exact iOS layout
        LazyRow(
            horizontalArrangement = Arrangement.spacedBy(18.dp),
            contentPadding = PaddingValues(horizontal = 20.dp)
        ) {
            items(platforms) { platform ->
                PlatformCard(
                    platform = platform,
                    isSelected = platform == selectedPlatform,
                    onClick = { onPlatformSelected(platform) }
                )
            }
        }
    }
}

// Helper function to get platform icon
fun getPlatformIcon(platform: Platform): ImageVector {
    return when (platform) {
        Platform.REDDIT -> Icons.Default.Forum
        Platform.YOUTUBE -> Icons.Default.PlayArrow
        Platform.X -> Icons.Default.ClearAll
        Platform.TIKTOK -> Icons.Default.MusicNote
        Platform.INSTAGRAM -> Icons.Default.PhotoCamera
        Platform.FACEBOOK -> Icons.Default.Facebook
    }
}

@Composable
private fun PlatformCard(
    platform: Platform,
    isSelected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    // Animation for selection
    val scale by animateFloatAsState(
        targetValue = if (isSelected) 1.05f else 1.0f,
        animationSpec = spring(dampingRatio = 0.8f, stiffness = 400f),
        label = "platformCardScale"
    )

    Column(
        modifier = modifier
            .scale(scale)
            .width(90.dp)
            .height(100.dp)
            .cardBackground(
                isSelected = isSelected,
                cornerRadius = 22.dp
            )
            .clickable { onClick() }
            .shadow(
                elevation = if (isSelected) 12.dp else 3.dp,
                shape = RoundedCornerShape(22.dp),
                ambientColor = getShadowColor(isSelected),
                spotColor = getShadowColor(isSelected)
            ),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        // Platform icon with enhanced quality and shadows - exact iOS match
        Box(
            modifier = Modifier.size(
                width = 72.dp,
                height = 56.dp
            ),
            contentAlignment = Alignment.Center
        ) {
            when (platform) {
                Platform.REDDIT -> {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_reddit),
                        contentDescription = platform.displayName,
                        tint = Color.Unspecified, // Use original colors
                        modifier = Modifier.size(40.dp)
                    )
                }
                Platform.YOUTUBE -> {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_youtube),
                        contentDescription = platform.displayName,
                        tint = Color.Unspecified, // Use original colors
                        modifier = Modifier.size(56.dp) // YouTube gets larger scale like iOS
                    )
                }
                Platform.X -> {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_x),
                        contentDescription = platform.displayName,
                        tint = Color.Unspecified, // Use original colors
                        modifier = Modifier.size(40.dp)
                    )
                }
                Platform.TIKTOK -> {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_tiktok),
                        contentDescription = platform.displayName,
                        tint = Color.Unspecified, // Use original colors
                        modifier = Modifier.size(40.dp)
                    )
                }
                Platform.INSTAGRAM -> {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_instagram),
                        contentDescription = platform.displayName,
                        tint = Color.Unspecified, // Use original colors
                        modifier = Modifier.size(40.dp)
                    )
                }
                Platform.FACEBOOK -> {
                    Icon(
                        painter = painterResource(id = R.drawable.ic_facebook),
                        contentDescription = platform.displayName,
                        tint = Color.Unspecified, // Use original colors
                        modifier = Modifier.size(40.dp)
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(10.dp))

        // Platform name
        Text(
            text = platform.displayName,
            style = MaterialTheme.typography.labelMedium.copy(
                fontWeight = FontWeight.Medium
            ),
            color = if (isSelected) platform.color else MaterialTheme.colorScheme.onSurface,
            maxLines = 1
        )
    }
}


