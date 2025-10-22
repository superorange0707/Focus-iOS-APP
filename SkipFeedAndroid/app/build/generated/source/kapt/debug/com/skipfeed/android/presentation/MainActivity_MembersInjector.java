package com.skipfeed.android.presentation;

import com.skipfeed.android.data.repository.SearchRepository;
import com.skipfeed.android.data.repository.UsageAnalyticsRepository;
import dagger.MembersInjector;
import dagger.internal.DaggerGenerated;
import dagger.internal.InjectedFieldSignature;
import dagger.internal.QualifierMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;

@QualifierMetadata
@DaggerGenerated
@Generated(
    value = "dagger.internal.codegen.ComponentProcessor",
    comments = "https://dagger.dev"
)
@SuppressWarnings({
    "unchecked",
    "rawtypes",
    "KotlinInternal",
    "KotlinInternalInJava"
})
public final class MainActivity_MembersInjector implements MembersInjector<MainActivity> {
  private final Provider<SearchRepository> searchRepositoryProvider;

  private final Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider;

  public MainActivity_MembersInjector(Provider<SearchRepository> searchRepositoryProvider,
      Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider) {
    this.searchRepositoryProvider = searchRepositoryProvider;
    this.usageAnalyticsRepositoryProvider = usageAnalyticsRepositoryProvider;
  }

  public static MembersInjector<MainActivity> create(
      Provider<SearchRepository> searchRepositoryProvider,
      Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider) {
    return new MainActivity_MembersInjector(searchRepositoryProvider, usageAnalyticsRepositoryProvider);
  }

  @Override
  public void injectMembers(MainActivity instance) {
    injectSearchRepository(instance, searchRepositoryProvider.get());
    injectUsageAnalyticsRepository(instance, usageAnalyticsRepositoryProvider.get());
  }

  @InjectedFieldSignature("com.skipfeed.android.presentation.MainActivity.searchRepository")
  public static void injectSearchRepository(MainActivity instance,
      SearchRepository searchRepository) {
    instance.searchRepository = searchRepository;
  }

  @InjectedFieldSignature("com.skipfeed.android.presentation.MainActivity.usageAnalyticsRepository")
  public static void injectUsageAnalyticsRepository(MainActivity instance,
      UsageAnalyticsRepository usageAnalyticsRepository) {
    instance.usageAnalyticsRepository = usageAnalyticsRepository;
  }
}
