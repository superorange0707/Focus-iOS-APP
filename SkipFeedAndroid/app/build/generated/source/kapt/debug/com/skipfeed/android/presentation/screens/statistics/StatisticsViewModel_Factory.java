package com.skipfeed.android.presentation.screens.statistics;

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

  public StatisticsViewModel_Factory(
      Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider) {
    this.usageAnalyticsRepositoryProvider = usageAnalyticsRepositoryProvider;
  }

  @Override
  public StatisticsViewModel get() {
    return newInstance(usageAnalyticsRepositoryProvider.get());
  }

  public static StatisticsViewModel_Factory create(
      Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider) {
    return new StatisticsViewModel_Factory(usageAnalyticsRepositoryProvider);
  }

  public static StatisticsViewModel newInstance(UsageAnalyticsRepository usageAnalyticsRepository) {
    return new StatisticsViewModel(usageAnalyticsRepository);
  }
}
