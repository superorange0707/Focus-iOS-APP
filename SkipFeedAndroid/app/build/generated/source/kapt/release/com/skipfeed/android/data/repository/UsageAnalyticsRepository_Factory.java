package com.skipfeed.android.data.repository;

import com.skipfeed.android.data.database.UsageAnalyticsDao;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.QualifierMetadata;
import dagger.internal.ScopeMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;

@ScopeMetadata("javax.inject.Singleton")
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
public final class UsageAnalyticsRepository_Factory implements Factory<UsageAnalyticsRepository> {
  private final Provider<UsageAnalyticsDao> usageAnalyticsDaoProvider;

  public UsageAnalyticsRepository_Factory(Provider<UsageAnalyticsDao> usageAnalyticsDaoProvider) {
    this.usageAnalyticsDaoProvider = usageAnalyticsDaoProvider;
  }

  @Override
  public UsageAnalyticsRepository get() {
    return newInstance(usageAnalyticsDaoProvider.get());
  }

  public static UsageAnalyticsRepository_Factory create(
      Provider<UsageAnalyticsDao> usageAnalyticsDaoProvider) {
    return new UsageAnalyticsRepository_Factory(usageAnalyticsDaoProvider);
  }

  public static UsageAnalyticsRepository newInstance(UsageAnalyticsDao usageAnalyticsDao) {
    return new UsageAnalyticsRepository(usageAnalyticsDao);
  }
}
