package com.skipfeed.android.presentation.theme;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u0000&\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\b\u001a\r\u0010\u0000\u001a\u00020\u0001H\u0007\u00a2\u0006\u0002\u0010\u0002\u001a\u0017\u0010\u0003\u001a\u00020\u00012\b\b\u0002\u0010\u0004\u001a\u00020\u0005H\u0007\u00a2\u0006\u0002\u0010\u0006\u001a\r\u0010\u0007\u001a\u00020\u0001H\u0007\u00a2\u0006\u0002\u0010\u0002\u001a\r\u0010\b\u001a\u00020\u0001H\u0007\u00a2\u0006\u0002\u0010\u0002\u001a\r\u0010\t\u001a\u00020\u0001H\u0007\u00a2\u0006\u0002\u0010\u0002\u001a4\u0010\n\u001a\u00020\u000b*\u00020\u000b2\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000fH\u0007\u00f8\u0001\u0000\u00a2\u0006\u0004\b\u0010\u0010\u0011\u001a4\u0010\u0012\u001a\u00020\u000b*\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u0013\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000fH\u0007\u00f8\u0001\u0000\u00a2\u0006\u0004\b\u0014\u0010\u0015\u001a\f\u0010\u0016\u001a\u00020\u000b*\u00020\u000bH\u0007\u0082\u0002\u0007\n\u0005\b\u00a1\u001e0\u0001\u00a8\u0006\u0017"}, d2 = {"getSecondaryTextColor", "Landroidx/compose/ui/graphics/Color;", "()J", "getShadowColor", "isSelected", "", "(Z)J", "getSurfaceColor", "getSurfaceVariantColor", "getTertiaryTextColor", "cardBackground", "Landroidx/compose/ui/Modifier;", "cornerRadius", "Landroidx/compose/ui/unit/Dp;", "alpha", "", "cardBackground-d8LSEHM", "(Landroidx/compose/ui/Modifier;ZFF)Landroidx/compose/ui/Modifier;", "glassMorphism", "strokeWidth", "glassMorphism-ghNngFA", "(Landroidx/compose/ui/Modifier;FFF)Landroidx/compose/ui/Modifier;", "skipFeedGradient", "app_debug"})
public final class GlassEffectsKt {
    
    /**
     * Gradient background that matches iOS main screen gradient
     */
    @androidx.compose.runtime.Composable()
    @org.jetbrains.annotations.NotNull()
    public static final androidx.compose.ui.Modifier skipFeedGradient(@org.jetbrains.annotations.NotNull()
    androidx.compose.ui.Modifier $this$skipFeedGradient) {
        return null;
    }
    
    /**
     * Shadow colors that adapt to theme
     */
    @androidx.compose.runtime.Composable()
    public static final long getShadowColor(boolean isSelected) {
        return 0L;
    }
    
    /**
     * Text colors that match iOS secondary and tertiary text
     */
    @androidx.compose.runtime.Composable()
    public static final long getSecondaryTextColor() {
        return 0L;
    }
    
    @androidx.compose.runtime.Composable()
    public static final long getTertiaryTextColor() {
        return 0L;
    }
    
    /**
     * Surface colors for cards and containers
     */
    @androidx.compose.runtime.Composable()
    public static final long getSurfaceColor() {
        return 0L;
    }
    
    @androidx.compose.runtime.Composable()
    public static final long getSurfaceVariantColor() {
        return 0L;
    }
}