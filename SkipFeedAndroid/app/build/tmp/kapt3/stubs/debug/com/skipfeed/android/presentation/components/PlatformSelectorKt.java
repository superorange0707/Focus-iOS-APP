package com.skipfeed.android.presentation.components;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u00004\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010 \n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a0\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00010\u00072\b\b\u0002\u0010\b\u001a\u00020\tH\u0003\u001a<\u0010\n\u001a\u00020\u00012\u0006\u0010\u000b\u001a\u00020\u00032\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00030\r2\u0012\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00010\u000f2\b\b\u0002\u0010\b\u001a\u00020\tH\u0007\u001a\u000e\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0002\u001a\u00020\u0003\u00a8\u0006\u0012"}, d2 = {"PlatformCard", "", "platform", "Lcom/skipfeed/android/data/model/Platform;", "isSelected", "", "onClick", "Lkotlin/Function0;", "modifier", "Landroidx/compose/ui/Modifier;", "PlatformSelector", "selectedPlatform", "platforms", "", "onPlatformSelected", "Lkotlin/Function1;", "getPlatformIcon", "Landroidx/compose/ui/graphics/vector/ImageVector;", "app_debug"})
public final class PlatformSelectorKt {
    
    @androidx.compose.runtime.Composable()
    public static final void PlatformSelector(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.Platform selectedPlatform, @org.jetbrains.annotations.NotNull()
    java.util.List<? extends com.skipfeed.android.data.model.Platform> platforms, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super com.skipfeed.android.data.model.Platform, kotlin.Unit> onPlatformSelected, @org.jetbrains.annotations.NotNull()
    androidx.compose.ui.Modifier modifier) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public static final androidx.compose.ui.graphics.vector.ImageVector getPlatformIcon(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.Platform platform) {
        return null;
    }
    
    @androidx.compose.runtime.Composable()
    private static final void PlatformCard(com.skipfeed.android.data.model.Platform platform, boolean isSelected, kotlin.jvm.functions.Function0<kotlin.Unit> onClick, androidx.compose.ui.Modifier modifier) {
    }
}