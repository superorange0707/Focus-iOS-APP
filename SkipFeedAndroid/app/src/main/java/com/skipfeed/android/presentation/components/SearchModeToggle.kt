package com.skipfeed.android.presentation.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.skipfeed.android.R
import com.skipfeed.android.data.model.SearchMode

@Composable
fun SearchModeToggle(
    searchMode: SearchMode,
    onSearchModeChanged: (SearchMode) -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .clip(RoundedCornerShape(16.dp))
            .background(Color.White.copy(alpha = 0.8f))
            .border(
                width = 1.dp,
                color = Color.Gray.copy(alpha = 0.3f),
                shape = RoundedCornerShape(16.dp)
            )
            .padding(4.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        SearchModeItem(
            text = stringResource(R.string.direct),
            isSelected = searchMode == SearchMode.DIRECT,
            onClick = { onSearchModeChanged(SearchMode.DIRECT) },
            modifier = Modifier.weight(1f)
        )
        
        SearchModeItem(
            text = stringResource(R.string.in_app),
            isSelected = searchMode == SearchMode.IN_APP,
            onClick = { onSearchModeChanged(SearchMode.IN_APP) },
            modifier = Modifier.weight(1f)
        )
    }
}

@Composable
private fun SearchModeItem(
    text: String,
    isSelected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .clip(RoundedCornerShape(12.dp))
            .background(
                if (isSelected) Color(0xFF007AFF) else Color.Transparent
            )
            .clickable { onClick() }
            .padding(horizontal = 16.dp, vertical = 8.dp),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = text,
            fontSize = 12.sp,
            fontWeight = FontWeight.Medium,
            color = if (isSelected) Color.White else Color(0xFF6C757D)
        )
    }
}
