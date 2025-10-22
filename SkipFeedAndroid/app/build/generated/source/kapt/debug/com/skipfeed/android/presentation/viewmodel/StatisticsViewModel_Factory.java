package com.skipfeed.android.presentation.viewmodel;

import com.skipfeed.android.data.repository.SearchRepository;
import com.skipfeed.android.data.repository.UsageAnalyticsRepository;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.QualifierMetadata;
import dagger.internal.ScopeMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;

@ScopeMetadata
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
public final class StatisticsViewModel_Factory implements Factory<StatisticsViewModel> {
  private final Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider;

  private final Provider<SearchRepository> searchRepositoryProvider;

  public StatisticsViewModel_Factory(
      Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider,
      Provider<SearchRepository> searchRepositoryProvider) {
    this.usageAnalyticsRepositoryProvider = usageAnalyticsRepositoryProvider;
    this.searchRepositoryProvider = searchRepositoryProvider;
  }

  @Override
  public StatisticsViewModel get() {
    return newInstance(usageAnalyticsRepositoryProvider.get(), searchRepositoryProvider.get());
  }

  public static StatisticsViewModel_Factory create(
      Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider,
      Provider<SearchRepository> searchRepositoryProvider) {
    return new StatisticsViewModel_Factory(usageAnalyticsRepositoryProvider, searchRepositoryProvider);
  }

  public static StatisticsViewModel newInstance(UsageAnalyticsRepository usageAnalyticsRepository,
      SearchRepository searchRepository) {
    return new StatisticsViewModel(usageAnalyticsRepository, searchRepository);
  }
}
